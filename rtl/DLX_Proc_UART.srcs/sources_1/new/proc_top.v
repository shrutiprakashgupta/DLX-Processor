`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2021 12:47:55 PM
// Design Name: dlx_proc
// Module Name: top_module
// Project Name: DELUXE PROCESSOR
// Target Devices: BASYS 3 FPGA Board
// Tool Versions: Vivado 2020.1
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module proc_top(active_clk, rst, state, write, addr, data_in, pc_curr, data_out);
    
    input active_clk;
    input rst;
    
    input [2:0]state;
    input write;
    input [31:0]addr;
    input [31:0]data_in;
    
    output [31:0]data_out;
    output [31:0]pc_curr;
    
    reg [31:0] reg_file [31:0]; //32 registers of 32 bits
    integer i;
    
    wire [31:0] pc; //Program counter
    wire [31:0] instr;
    
    wire [4:0] rs1; //Source register 1
    wire [4:0] rs2; //Source register 2
    wire [15:0] imm; //Immediate operand
    wire [4:0] rd; //Destination register
    wire [5:0] opcode; //Operation code
    wire [25:0] val; //Immediate value for branching
    wire feed; //Dependency (Read after write)
    
    wire [31:0] imm_val;
    wire [31:0] val_ext;
    wire [31:0] result; 
    wire [4:0] dest;
    
    wire reg_2_mem;
    wire mem_2_reg;
    wire [31:0] mem_data; 
    
    wire we;
    wire [31:0]addr_mem;
    wire [31:0]data;
    wire we_reg;
    parameter sp = 4092;
    
    wire branch; //Used to detect branches and flush the pipeline 
    
    assign imm_val = (imm[15] == 1'b1)?{16'b1111_1111_1111_1111,imm}:{16'b0000_0000_0000_0000,imm};
    assign val_ext = (val[25] == 1'b1)?{6'b111111,val}:{6'b000000,val};
    
    assign we_reg = (dest == 0)?0:(!reg_2_mem); 

    assign we = (state == 3'b100)?reg_2_mem:write;
    assign addr_mem = (state == 3'b100)?result:addr;
    assign data = (state == 3'b100)?reg_file[dest]:data_in;
    assign data_out = mem_data;
     
    assign pc_curr = pc;
     
    always @(negedge active_clk) begin
        if(rst == 1'b1) begin
            for (i=0; i<30; i=i+1) begin
                reg_file[i] <= 0;
            end
            reg_file[30] <= sp;
            reg_file[31] <= 0;
        end
        else begin            
            if (we_reg == 1'b1) begin
                if (mem_2_reg == 1'b1) begin
                    reg_file[dest] <= mem_data;
                end
                else begin
                    reg_file[dest] <= result;
                end
            end
        end
    end
    
    instr_mem instr_rom (.active_clk(active_clk), .pc(pc), .instr(instr));
    if_decode decode (.active_clk(active_clk), .rst(rst), .branch(branch), .instr(instr), .rs1(rs1), .rs2(rs2), .imm(imm), .rd(rd), .opcode(opcode), .val(val), .feed(feed));
    execute exec (.active_clk(active_clk), .rst(rst), .branch(branch), .rs1_val(reg_file[rs1]), .rs2_val(reg_file[rs2]), .imm_val(imm_val), .rd_in(rd), .opcode(opcode), .val(val_ext), .feed(feed), .result(result), .rd(dest), .pc(pc), .reg_2_mem(reg_2_mem), .mem_2_reg(mem_2_reg));
    data_mem write_back (.active_clk(active_clk), .we(we), .addr(addr_mem), .data_in(data), .data_out(mem_data));
endmodule