# DLX-Processor
This repository contains a simulator and RTL implementation of [DLX-Processor](https://www.csee.umbc.edu/courses/undergraduate/411/spring96/dlx.html). The simulator is written in Python and gives the Register file and Memory dump of the processor at every step of execution. RTL is written in Verilog and the implementation is pipelined. It is further executed on [Basys3 FPGA board](https://reference.digilentinc.com/_media/basys3:basys3_rm.pdf). Additionally UART transmitter and receiver modules are connected so that the input (data memory values) can be written and read over the serial port from the computer.
# Workflow
A program is written using the DLX processor instructions. <br/>
<img src="https://github.com/shrutipgupta/DLX-Processor/blob/main/asm_to_machine/asm_code.png" width="500" height="300"> <br/>
It is then converted into machine code with [asm_to_machine.py](https://github.com/shrutipgupta/DLX-Processor/blob/main/asm_to_machine/asm_to_machine.py). <br/>
<img src="https://github.com/shrutipgupta/DLX-Processor/blob/main/asm_to_machine/asm_to_machine.png" width="500" height="300"> <br/>
The formatted instruction file is generated for being included in RTL. <br/>
<img src="https://github.com/shrutipgupta/DLX-Processor/blob/main/asm_to_machine/machine_code.png" width="500" height="300"> <br/>
It is simulated to get the output. <br/>
<img src="https://github.com/shrutipgupta/DLX-Processor/blob/main/simulator/sim.png" width="1000" height="500"> <br/>
RTL is synthesized and implemented on Basys3 board <br/>
<img src="https://github.com/shrutipgupta/DLX-Processor/blob/main/rtl/reports/board.jpeg" width="500" height="400"> <br/>
Input to the data memory is written over UART and received output is displayed <br/>
<img src="https://github.com/shrutipgupta/DLX-Processor/blob/main/rtl/testbench/fact_output.png" width="500" height="300"> <br/>
Note: 120 in hex is 0x78 which is ascii value for ‘x’
# asm_to_machine 
The [assembly instructions](https://github.com/shrutipgupta/DLX-Processor/tree/main/asm_to_machine) are validated for syntax (used labels are defined, aliases are initialized and I-, J-, and R-type instructions have the required attributes), converted into machine code and formatted to be included in the RTL. As the instruction memory is implemented as ROM, thus machine instructions need to be included before synthesis.
# dlx_sim
The [simulator](https://github.com/shrutipgupta/DLX-Processor/blob/main/simulator/dlx_sim.py) steps through the instructions and updates the register file and memory. However, the implementation is non-pipelined and thus does not mimic the RTL. It thus generates the desired result, which is further used to verify the RTL design.
It is tested with the programs ranging from simple R-type instructions to those including jumps and recursion. 
# uart_interface
The [uart modules](https://github.com/shrutipgupta/DLX-Processor/tree/main/rtl/interface) designed in the [Basys3-gpio](https://github.com/shrutipgupta/Basys3-gpio) project are used as a wrapper for the dlx processor. It works on 115200 baud rate with a clock (used for synchronization with the processor) at a speed of 100MHz. It remains active in all other stages of the FSM except the Process step, and performs data read-write directly to the data_mem RAM. The inputs from UART and the processor are multiplexed and thus either of them can write or read from the memory at a time. 
The data memory is (2^10) x 32 bit large and thus manual input is not feasible. A text file can be used to give the input while the rest of the values are initialized to zero. 
<img src="https://github.com/shrutipgupta/DLX-Processor/blob/main/rtl/interface/data_in.png" width="500" height="200">
<img src="https://github.com/shrutipgupta/DLX-Processor/blob/main/rtl/interface/data_mem.png" width="500" height="200"> <br/>
The output after processing is read over UART. <br/>
<img src="https://github.com/shrutipgupta/DLX-Processor/blob/main/rtl/interface/data_out.png" width="500" height="300">
# rtl - Top FSM
![Top FSM](https://github.com/shrutipgupta/DLX-Processor/blob/main/rtl/reports/top_fsm.png)
![Top FSM Schematic](https://github.com/shrutipgupta/DLX-Processor/blob/main/rtl/reports/schematic_top.png)
# rtl - DLX Processor
The DLX-processor is implemented as a three stage pipeline with stages
Instruction fetch and decode
Execute and PC compute
Write back
Note:
Write Back - To eliminate the chances of read-write collision, write is performed at negative clock edge while read value is sampled at positive clock.
Data forwarding - As data compute and write back are happening in different stages, data from execute stage output is directly used in case of register value updation and use in two consecutive instructions. 
PC updation - As jump instructions are supported, PC is updated as per the compute in the execute stage. In cases when prediction (of incrementing PC by 4, by default) fails, the pipeline is flushed. 
Pipeline flush - As PC is being computed in the second stage (i.e. execute stage), when a pipeline flush is detected, the incorrect instruction is already decoded. Thus, a NOP (R0 = R0 AND R0) is used instead. This prevents any of the register values to be affected.
J-type instruction restriction - The very first instruction i.e. instruction memory location 0, should not be a jump type instruction. As the jump is being detected in the second stage, it may cause problems. This can be eliminated by adding a NOP in such cases.
LW and SW - Load and store instructions take one clock cycle to be completed and thus a register or memory being updated with them should not be read immediately in the next instruction. 
![DLX Proc Schematic](https://github.com/shrutipgupta/DLX-Processor/blob/main/rtl/reports/proc_schematic.png)
# Test bench
The design is verified for programs ranging from simple R-type instructions to Jump and recursion cases. The testbenches and corresponding outputs are included [here](https://github.com/shrutipgupta/DLX-Processor/tree/main/rtl/testbench).
# Report
Utilization report
![Utilization](https://github.com/shrutipgupta/DLX-Processor/blob/main/rtl/reports/utilization.png)
Timing report
![Timing](https://github.com/shrutipgupta/DLX-Processor/blob/main/rtl/reports/timing.png)
Note: The timing report generated shows violations as false paths are coming into picture. As two different clocks are being used for the DLX-processor stage, whenever the faster clock is enabled, the reset condition remains disabled. Thus, actual processing occurs only with the slower clock (with time period 20ns, i.e. 10ns difference between rising and falling edge, thus the slack of around 7ns is met) and design works properly on the board.  
