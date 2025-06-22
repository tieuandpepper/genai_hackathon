import yaml
import subprocess
from vertexai.preview.generative_models import GenerativeModel
import vertexai
import time

# EXAMPLE or VISIBLE PROBLEM (example problem in the example_problem folder, visible problem in the problems/visible directory)
PROBLEM_TYPE_EXAMPLE = 1
PROBLEM_TYPE_VISIBLE = 2
PROBLEM_TYPE = PROBLEM_TYPE_EXAMPLE

MAX_ITER = 10

PDK_MAP = {
    "SkyWater 130HD": {
        "lib":  "OpenROAD-flow-scripts/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib",
        "lef":  "OpenROAD-flow-scripts/flow/platforms/sky130hd/lef/sky130_fd_sc_hd_merged.lef",
        "tlef": "OpenROAD-flow-scripts/flow/platforms/sky130hd/lef/sky130_fd_sc_hd.tlef"
    },
    "SkyWater 130HS": {
        "lib":  "OpenROAD-flow-scripts/flow/platforms/sky130hs/lib/sky130_fd_sc_hs__tt_025C_1v80.lib",
        "lef":  "OpenROAD-flow-scripts/flow/platforms/sky130hs/lef/sky130_fd_sc_hs_merged.lef",
        "tlef": "OpenROAD-flow-scripts/flow/platforms/sky130hs/lef/sky130_fd_sc_hs.tlef"
    },
    "Nangate45": {
        "lib":  "OpenROAD-flow-scripts/flow/platforms/nangate45/lib/NangateOpenCellLibrary_typical.lib",
        "lef":  "OpenROAD-flow-scripts/flow/platforms/nangate45/lef/NangateOpenCellLibrary.macro.lef",
        "tlef": "OpenROAD-flow-scripts/flow/platforms/nangate45/lef/NangateOpenCellLibrary.tech.lef"
    },
    "ASAP7": {
        "lib":  "OpenROAD-flow-scripts/flow/platforms/asap7/lib/CCS/asap7sc7p5t_SIMPLE_RVT_FF_ccs_211120.lib",
        "lef":  "OpenROAD-flow-scripts/flow/platforms/asap7/lef/asap7sc7p5t_DFFHV2X.lef",
        "tlef": None
    }
}

##############################################################
# HELPER FUNCTIONS
##############################################################

def write_file(filename, content):
    with open(filename, 'w') as f:
        f.write(content)

###################################
def run_iverilog(filenames):
    try:
        subprocess.run(["iverilog", *filenames], check=True, capture_output=True)
        return True, ""
    except subprocess.CalledProcessError as e:
        return False, e.stderr.decode()


##############################################################
# AGENT FUNCTIONS
##############################################################
def prompt_from_yaml(spec):
    name, content = list(spec.items())[0]
    description = content.get("description", "")
    ports = content.get("ports", [])
    module_sig = content.get("module_signature", "")
    parameters = content.get("parameters", {})

    port_lines = []
    for p in ports:
        port_lines.append(f"- {p['direction']} {p['type']} [{p['width'] if 'width' in p else ''}] {p['name']}: {p.get('description','')}\n")

    param_lines = [f"- {k}: {v}" for k, v in parameters.items()] if parameters else []

    prompt = """Please act as a professional digital hardware designer.

1.Module Name: {}

2.Description: 
{}
3.Ports:
{}
4.Parameters:
{}

5.Pseudocode Implementation:
Plan the pseudocode implementation of this design function

6.Module Signature:
{}

7.Verilog Implementation:
Convert the pseudocode into complete, synthesizable Verilog code for the Module Signature frame.

Important:
- Provide only the final Verilog code under section 7.
- Do not include additional explanations or comments outside the code block.

""".format(name, description, ''.join(port_lines), '\n'.join(param_lines), module_sig)

    write_file("current_design.txt", prompt)
    return name, content.get("clock_period", 1.0), content


###################################

def generate_sdc(top_module, clock_period):
    sdc = f"""current_design {top_module}

set clk_name  clk
set clk_port_name clk
set clk_period {round(clock_period - 0.1, 3)}
set clk_io_pct 0.2

set clk_port [get_ports $clk_port_name]

create_clock -name $clk_name -period $clk_period $clk_port

set non_clock_inputs [lsearch -inline -all -not -exact [all_inputs] $clk_port]

set_input_delay  [expr $clk_period * $clk_io_pct] -clock $clk_name $non_clock_inputs 
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [all_outputs]
"""
    write_file("constraint.sdc", sdc)

###################################

def refine_with_gemini(prompt, model, top_module):
    design_file = f"iclad_{top_module}.v"
    for _ in range(MAX_ITER):
        response = model.generate_content(prompt).text
        write_file(design_file, response)
        success, err = run_iverilog([design_file])
        if success:
            print("\n✅ Verilog syntax is correct.")
            return response
        prompt = f"The following Verilog has syntax errors:\n{err}\nPlease fix them:\n{response}"
    return None

###################################

def run_openroad_flow(top_module, design_file):
    tech_node = yaml.safe_load(open("spec.yaml"))[top_module].get("tech_node")
    pdk = PDK_MAP.get(tech_node)
    if not pdk:
        print(f"Unsupported tech_node: {tech_node}")
        return

    tlef_cmd = f"read_lef {pdk['tlef']}\n" if pdk['tlef'] else ""
    tcl_script = f"""
read_verilog {design_file}
{tlef_cmd}read_lef {pdk['lef']}
read_liberty {pdk['lib']}
read_sdc constraint.sdc

synth_design -top {top_module}
write_verilog {top_module}_synth.v

initialize_floorplan -utilization 0.4 -aspect_ratio 1.0 -core_space 2
place_io
place_design
write_def {top_module}_placed.def

route_design
write_def {top_module}_routed.def

report_wns > {top_module}_wns.rpt
report_tns > {top_module}_tns.rpt
report_power > {top_module}_power.rpt

write_db {top_module}.odb
"""
    write_file("run_openroad.tcl", tcl_script)
    print("\n🚀 Launching OpenROAD...")
    subprocess.run(["openroad", "run_openroad.tcl"])



###################################

def verify_functionality(content, top_module, model):
    tb_file = f"{top_module}_tb.v"
    design_file = f"iclad_{top_module}.v"

    sample_input = content.get("sample_input")
    sample_output = content.get("sample_output")
    sample_usage = content.get("sample_usage")

    if not (sample_input and sample_output) and not sample_usage:
        return False

    for i in range(MAX_ITER):
        if sample_input and sample_output:
            testbench_prompt = f"Write a Verilog testbench for module {top_module} that applies the input stream {sample_input} to data_in and checks against expected output {sample_output}, printing whether the result is correct. Include parameter values if the design has parameters."
        else:
            testbench_prompt = f"Using the following sample usage, write a Verilog testbench for module {top_module}. The testbench should apply the inputs and check if outputs match expected results, printing pass/fail:\n{sample_usage}"

        tb_code = model.generate_content(testbench_prompt).text
        write_file(tb_file, tb_code)
        success, err = run_iverilog([design_file, tb_file])
        if success:
            sim = subprocess.run(["vvp", "a.out"], capture_output=True)
            output = sim.stdout.decode()
            if "PASS" in output.upper():
                print("\n✅ Functionality test passed.")
                user_input = input("Proceed to OpenROAD synthesis and place-and-route? (Y/N): ").strip().lower()
                if user_input == 'y':
                    run_openroad_flow(top_module, design_file)
                return True
            else:
                design_fix_prompt = f"The testbench produced incorrect results. Output:\n{output}\nExpected: {sample_output or '[see sample_usage]'}\nPlease fix the design:\n" + open(design_file).read()
                refine_with_gemini(design_fix_prompt, model, top_module)
        else:
            tb_prompt_fix = f"The testbench had syntax errors:\n{err}\nPlease fix:\n{tb_code}"
            model.generate_content(tb_prompt_fix)
    return False

##############################################################
# MAIN FUNCTION
##############################################################

def run_agent(model,spec):
    top_module, clock_period, content = prompt_from_yaml(spec)
    generate_sdc(top_module, float(clock_period))

    print("\n🔧 Generating Verilog with Gemini...")
    design_prompt = open("current_design.txt").read() + "\nPlease implement the full Verilog module."
    refine_with_gemini(design_prompt, model, top_module)

    print("\n🧪 Running functionality test...")
    verify_functionality(content, top_module, model)


def main():
    vertexai.init(project="iclad-hack25stan-3721", location="us-central1")
    model = GenerativeModel("gemini-2.0-flash-001")

    spec = yaml.safe_load(open("spec.yaml"))
    
    run_agent(model,spec)
    

if __name__ == "__main__":
    main()
