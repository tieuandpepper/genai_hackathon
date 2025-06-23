"""Agent definition that generates a testbench."""

import constants
from vertexai.preview.generative_models import GenerativeModel
import vertexai
import subprocess
import os, re
import tempfile

# from openai import OpenAI

GEMINI = "GEMINI"
# OPENAI = "OPENAI"
MODEL = GEMINI


MODULE_COUNT = 31
# helper function

if MODEL == GEMINI:
    # query gemini
    vertexai.init(project="iclad-hack25stan-3721", location="us-central1")
    model = GenerativeModel("gemini-2.0-flash-001")
# else:
    # token = os.getenv("OPENAI_API_KEY")
    # model = OpenAI(api_key=token)


def query_model(query):
    if MODEL == GEMINI:
        return model.generate_content(query).text
    else:
        return model.chat.completions.create(
            model='gpt-4o',
            messages=[
                    {
                        "role": "user",
                        "content": query,
                    }
            ]
        ).choices[0].message.content

# generate testbench from specs and verilog code
def generate_tb(specs, verilog_code):
    prompt = f"""
Generate a testbench based on this description:
{specs}
and this Verilog implmentation:
{verilog_code}

The testbench should be enclosed in a code block (start with ``` and end with ```).
"""
    count = 0
    while count < 10:
        output = query_model(prompt)
        # find all the strings that start with ``` and end with ``` for final_output string
        matches = re.findall(r'```verilog(.*?)```', output, flags=re.DOTALL)
        if matches:
            # get the last match
            testbench = matches[-1].strip("\n")
            return testbench
        else:
            matches = re.findall(r'```(.*?)```', output, flags=re.DOTALL)
            # prompt += "Remember to include the code block.\n"
            if matches:
            # get the last match
                testbench = matches[-1].strip("\n")
                return testbench
            count+=1
    return ""


def run_tb(verilog_testbench, verilog_module):
    with tempfile.TemporaryDirectory() as temp_dir:
        module_path = os.path.join(temp_dir, "temp_module.v")
        tb_path = os.path.join(temp_dir, "temp_tb.v")
        output_path = os.path.join(temp_dir, "temp_test")

        # Write module and testbench to files
        with open(module_path, "w") as f:
            f.write(verilog_module)
        with open(tb_path, "w") as f:
            f.write(verilog_testbench)

        # Compile Verilog files
        compile = subprocess.run(["iverilog", "-o", output_path, module_path, tb_path],
                                stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

        if compile.returncode != 0:
            print("Error:\n", compile.stderr)
        else:
            # Run simulation
            run = subprocess.run(["vvp", output_path],
                                stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
            if run.returncode != 0:
                print("Simulation Error:\n", run.stderr)
                return 0
            else:
                print("Simulation Output:\n", run.stdout)
                return 1
        return 0

# TODO: Implement this.
def generate_testbench(file_name_to_content: dict[str, str]) -> str:
    # del file_name_to_content
    # for key,value in file_name_to_content.items():
    #     print(key)
    spec_file_name = "specification.md"
    mutant_file_start = "mutant_"
    testbench_file_name = "tb.v"
    testbench = "Giving up is not an option, but a reality."
    specs = file_name_to_content[spec_file_name]
    mutant_idx = 0
    # Go through 31 modules
    for mutant_idx in range(0, MODULE_COUNT):
        verilog_module = file_name_to_content[mutant_file_start + str(mutant_idx) + ".v"]
        temp_testbench = generate_tb(specs,verilog_module)
        # print(temp_testbench)
        passed_tb = 0
        failed_tb = 0
        for i in range(0,MODULE_COUNT):
            test_module = file_name_to_content[mutant_file_start + str(i) + ".v"]
            result = run_tb(temp_testbench,test_module)
            if result == 1:
                print(f"mutant_{i} passed generated testbench for {mutant_idx}")
            
            failed_tb -= result
            passed_tb += result
        
        print(f"testbench for mutant_{mutant_idx} passed {passed_tb} test modules.")
        if passed_tb == MODULE_COUNT - 1:
            testbench = temp_testbench
            break
        if failed_tb > 1:
            continue


    # return constants.DUMMY_TESTBENCH
    return testbench


# print(query_model("How openROAD is used without Verilog"))