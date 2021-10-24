`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2021 12:47:55 PM
// Design Name: dlx_proc
// Module Name: if_decode
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

`define ADD 6'b10_0000
`define AND 6'b10_0100
`define OR 6'b10_0101
`define SEQ 6'b10_1000
`define SLE 6'b10_1100
`define SLL 6'b00_0100
`define SLT 6'b10_1010
`define SNE 6'b10_1001
`define SRA 6'b00_0111
`define SRL 6'b00_0110
`define SUB 6'b10_0010
`define XOR 6'b10_0110

`define ADDI 6'b00_1000
`define ANDI 6'b00_1100
`define BEQZ 6'b00_1001
`define BNEZ 6'b00_0101
`define J 6'b00_0010
`define JAL 6'b00_0011
`define JALR 6'b01_0011
`define JR 6'b01_0010
`define LHI 6'b00_1111
`define LW 6'b10_0011
`define ORI 6'b00_1101
`define SEQI 6'b01_1000
`define SLEI 6'b01_1100
`define SLLI 6'b01_0100
`define SLTI 6'b01_1010
`define SNEI 6'b01_1001
`define SRAI 6'b01_0111
`define SRLI 6'b01_0110
`define SUBI 6'b00_1010
`define SW 6'b10_1011
`define XORI 6'b00_1110

module if_decode(active_clk, rst, branch, instr, rs1, rs2, imm, rd, opcode, val, feed);
    
    input active_clk;
    input rst;
    input branch;
    input [31:0] instr;
    
    output reg [4:0] rs1;
    output reg [4:0] rs2;
    output reg [15:0] imm;
    output reg [4:0] rd;
    output reg [5:0] opcode;
    output reg [25:0] val;
    output reg feed;

    reg [4:0] rd_prev;
    wire [4:0] rd_prev_imm;
    
    assign rd_prev_imm = (branch == 1'b1)?5'b00000 : rd_prev;
    
    always @(posedge active_clk) begin
        if(rst == 1'b1) begin
            rs1 <= 0;
            rs2 <= 0;
            imm <= 0;
            rd <= 0;
            opcode <= 0;
            val <= 0;
            feed <= 0;
        end
        else begin
            rs1 <= instr[25:21];
            rs2 <= instr[20:16];
            imm <= instr[16:0];
            val <= instr[25:0];
            if(instr[31:26] == 6'b000000) begin
                opcode <= instr[5:0];
                rd <= instr[15:11];
            end
            else begin
                opcode <= instr[31:26];
                rd <= instr[20:16];
            end
            if((instr[31:26] == `J) | (instr[31:26] == `JAL)) begin
                feed <= 1'b0;
            end
            else begin
                if(instr[25:21] == rd_prev_imm)
                    feed <= 1'b1;
                else 
                    feed <= 1'b0;
            end
        end
    end
    
    always @(negedge active_clk) begin
        if(rst == 1'b1) begin
            rd_prev <= 0;
        end
        else begin 
            rd_prev <= rd;
        end
    end
    
endmodule