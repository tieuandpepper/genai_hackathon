# ASU Spec2Tapeout ICLAD 2025 Hackathon Problems

## Infrastrcutre setup


If you are participating in the SLM cateogory: 
The prerequisites are iVerilog and OpenROAD-flow-scripts that should be avialbale in your laptops.

If you are participating in the LLM category:
Solving these problems requires the docker image available here which you can pull in your GCP VM instance. 


## Problem Set

Your objective is to design tapeout-ready ASICs based on the given problem specifications in the yaml format described below. For each problem, you must develop an LLM agent script/tool that produces the following output files:

## Required Outputs

- Synthesizable RTL in SystemVerilog  
- Constraint files in SDC format  
- Tapeout-ready files, including:
  - DEF  
  - Gate-level Netlist  
  - GDSII  

## Guidelines

- Module signatures are provided for each problem. Your generated RTL must **strictly follow** these signatures to ensure compatibility with automated test frameworks.  
- Your LLM agent script/tool should **generalize to unseen/hidden problems**, which will be provided in a similar format.  
- Please provide solutions for **all** the questions, even if your script does not generalize to other testcases.  

## Hints

- You have access to **iVerilog**. Use it iteratively with your LLM to verify the functional correctness of your code.  
- You must generate your own **testbenches** to validate RTL functionality (use of LLMs allowed). We have our own testbenches that we will use to evalute your RTL.  
- Once your RTL is verified, use **OpenROAD-flow-scripts** to generate the tapeout-ready GDSII and other physical design files and reports.  
- You can use LLMs to learn how to work with ORFS and use the LLM to write a script to integrate your design into the existing ORFS framework.  
- The provided constraints or specification  of frequency are **relatively relaxed** and should be met without requiring multiple iterations of physical design.  

---

## Submission guidelines

Coming soon

## Evaluation setup

Coming soon


## Example: YAML Spect for Sequence Detector Design for `0011`



```yaml
seq_detector_0011:
  description: Detects a binary sequence "0011" in the input stream.
  tech_node: SkyWater 130HD
  clock_period: 1.1ns
  ports:
    - name: clk
      direction: input
      type: logic
      description: Clock input
    - name: reset
      direction: input
      type: logic
      description: Synchronous reset (active high)
    - name: data_in
      direction: input
      type: logic
      description: Serial data input
    - name: detected
      direction: output
      type: logic
      description: Asserted high for one cycle when '0011' is detected.
  module_signature: |
    module seq_detector_0011(
        input clk,
        input reset,
        input data_in,
        output reg detected
    );
  sequence_to_detect: '0011'
  sample_input: '0001100110110010'
  sample_output: '0000010001000000'

```


