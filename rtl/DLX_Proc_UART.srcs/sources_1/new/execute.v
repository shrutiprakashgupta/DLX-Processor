`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2021 12:47:55 PM
// Design Name: dlx_proc
// Module Name: execute
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

module execute(active_clk, rst, branch, rs1_val, rs2_val, imm_val, rd_in, opcode, val, feed, result, rd, pc, reg_2_mem, mem_2_reg);
    
    input active_clk;
    input rst;
    output reg branch;
    input [31:0] rs1_val;
    input [31:0] rs2_val;
    input [31:0] imm_val;
    input [4:0] rd_in;
    input [5:0] opcode; 
    input [31:0] val;
    input feed;
    
    output reg [31:0] result;
    output reg [4:0] rd;
    output reg [31:0] pc;
    output reg reg_2_mem;
    output reg mem_2_reg;
    wire [31:0] rs1_val_new;
    reg [1:0] feed_en; //Feed signal is not defined for first two instructions 
    
    wire flush; //Pipeline is flushed once the prediction is wrong
    
    assign rs1_val_new = (feed_en < 2'b11)?rs1_val:(feed == 1'b1)?result:rs1_val;
    assign flush = rst | branch;    
        
    always @(posedge active_clk) begin
        if(rst == 1'b1) begin
            result <= 0;
            rd <= 0;
            reg_2_mem <= 0;
            mem_2_reg <= 0;
            pc <= 0;
            branch <= 0;
         end
         else begin
         if(branch == 1'b1) begin
            result <= 0;
            rd <= 0;
            reg_2_mem <= 0;
            mem_2_reg <= 0;
            pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
            branch <= 0;
         end
         else begin
            case(opcode)
                `ADD : begin
                        result <= rs1_val_new + rs2_val;
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `AND : begin
                        result <= rs1_val_new & rs2_val;
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `OR : begin
                        result <= rs1_val_new | rs2_val;
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                      end
                `SEQ : begin
                        result <= (rs1_val_new == rs2_val)?1'b1:1'b0;
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `SLE : begin
                        result <= ($signed(rs1_val_new) <= $signed(rs2_val))?1'b1:1'b0;
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `SLL : begin
                        result <= rs1_val_new << rs2_val[3:0];
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `SLT : begin
                        result <= ($signed(rs1_val_new) < $signed(rs2_val))?1'b1:1'b0;
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `SNE : begin
                        result <= (rs1_val_new == rs2_val)?1'b0:1'b1;
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `SRA : begin
                        result <= $signed(rs1_val_new) >>> rs2_val[3:0];
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `SRL : begin
                        result <= rs1_val_new >> rs2_val[3:0];
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `SUB : begin
                        result <= rs1_val_new - rs2_val;
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `XOR : begin
                        result <= rs1_val_new ^ rs2_val;
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `ADDI : begin
                        result <= rs1_val_new + imm_val;
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `ANDI : begin
                        result <= rs1_val_new & imm_val;
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `BEQZ : begin
                        result <= 32'b0000_0000_0000_0000_0000_0000_0000_0000;
                        if(rs1_val_new == 0) begin
                            pc <= pc -4 + imm_val;
                            branch <= 1;
                        end
                        else begin
                            pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                            branch <= 0;
                        end
                        rd <= 0;
                      end
                `BNEZ : begin
                        result <= 32'b0000_0000_0000_0000_0000_0000_0000_0000;
                        if(rs1_val_new != 0) begin
                            pc <= pc -4 + imm_val;
                            branch <= 1;
                        end
                        else begin
                            pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                            branch <= 0;
                        end
                        rd <= 0;
                       end
                `J : begin
                        result <= 0;
                        pc <= (pc -4) + $signed(val);
                        rd <= 0;
                        branch <= 1;
                       end
                `JAL : begin
                        pc <= (pc - 4) + $signed(val);
                        result <= pc;
                        rd <= 5'b11111;
                        branch <= 1;
                      end
                `JALR : begin
                        pc <= rs1_val_new;
                        result <= pc;
                        rd <= 5'b11111;
                        branch <= 1;
                       end
                `JR : begin
                        pc <= rs1_val_new;
                        result <= 0;
                        rd <= 0;
                        branch <= 1;
                       end
                `LHI : begin
                        result <= imm_val << 16;
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `LW : begin
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        result <= rs1_val_new + imm_val;
                        rd <= rd_in;  
                        branch <= 0;  
                       end
                `ORI : begin
                        result <= rs1_val_new | imm_val;
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `SEQI : begin
                        result <= (rs1_val_new == imm_val)?32'b1:32'b0;
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `SLEI : begin
                        result <= ($signed(rs1_val_new) <= $signed(imm_val))?32'b1:32'b0;
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `SLLI : begin
                        result <= rs1_val_new <<< imm_val[3:0];
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `SLTI : begin
                        result <= ($signed(rs1_val_new) < $signed(imm_val))?32'b1:32'b0;
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `SNEI : begin
                        result <= (rs1_val_new != imm_val)?32'b1:32'b0;
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `SRAI : begin
                        result <= $signed(rs1_val_new) >>> imm_val[3:0];
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `SRLI : begin
                        result <= rs1_val_new >> imm_val[3:0];
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `SUBI : begin
                        result <= rs1_val_new - imm_val;
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `SW : begin
                        result <= rs1_val_new + imm_val;
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                `XORI : begin
                        result <= rs1_val_new ^ imm_val;
                        pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                        rd <= rd_in;
                        branch <= 0;
                       end
                default : begin
                          result <= 0;
                          pc <= pc + 32'b0000_0000_0000_0000_0000_0000_0000_0100;
                          rd <= 0;
                          branch <= 0;
                          end
                endcase
                if (opcode == `SW) begin
                    reg_2_mem <= 1'b1;
                end
                else begin
                    reg_2_mem <= 1'b0;
                end
                if (opcode == `LW) begin
                    mem_2_reg <= 1'b1;
                end
                else begin
                    mem_2_reg <= 1'b0;
                end
            end
          end
        end 
        
        always @(posedge active_clk) begin
            if(rst == 1'b1) begin
                feed_en <= 2'b00;
            end
            else begin
                if(feed_en < 2'b11) begin
                    feed_en <= feed_en + 1;
                end
            end
        end
endmodule