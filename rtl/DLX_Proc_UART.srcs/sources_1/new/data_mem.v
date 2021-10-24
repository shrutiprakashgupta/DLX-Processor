`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2021 12:47:55 PM
// Design Name: dlx_proc
// Module Name: data_mem
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

module data_mem (active_clk, we, addr, data_in, data_out);
    input active_clk;
    input we;
    input [31:0] addr;
    input [31:0] data_in;
    output [31:0] data_out;
    
    parameter mem_size = 1<<10;
    reg  [31:0] data_memory [mem_size-1:0];
    integer i;

    assign data_out = data_memory[addr[11:2]];

    always @(negedge active_clk) begin
       if (we) begin
            data_memory[addr[11:2]] <= data_in;
       end
    end 
endmodule