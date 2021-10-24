`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Shruti Prakash Gupta
// 
// Create Date: 05/21/2021 01:09:43 AM
// Design Name: 
// Module Name: uart_top
// Project Name: DLX_Proc_UART
// Target Devices: Basys 3
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module uart_top(clk, rx, tx, state, index);

    input clk;
    input rx;
    output tx;
    
    parameter data_count = (1<<12);
    output reg [11:0]index;
    
    parameter Init = 3'b000;
    parameter Ready = 3'b001; 
    parameter Read = 3'b010;
    parameter Done = 3'b011;
    parameter Process = 3'b100;
    parameter Write = 3'b101;
    
    wire [7:0]data_rx;  //Value read by the receiver
    wire ack_rx;        //Acknowledgment signal for data read 

    reg rst;            //Input to the processor block
    output reg [2:0]state;     //State of the top fsm
    reg write;          //Input to the processor block
    wire [31:0]addr;    //Address to the memory location
    reg [7:0]data_in0;  //Input to the memory block
    reg [7:0]data_in1;
    reg [7:0]data_in2;
    reg [7:0]data_in3;
    wire [31:0]pc;      //Output from the processor block - when bit 12 is 1, execution over
    wire [31:0]data_out;//Output from the processor block

    reg [7:0]data_tx;   //Data input to the transmitter
    reg ack_tx;         //Enable signal for transmitter
    wire sent;          //Acknowledgment signal from transmitter
    
    reg clk_by_2 = 0;
    wire active_clk;
    always @(posedge clk) begin
        clk_by_2 <= ~clk_by_2;
    end
    
    assign active_clk = (state == Process)?clk_by_2 : clk;
    assign addr = {20'b0000_0000_0000_0000_0000,index[11:2],2'b00};
//    assign addr = {20'b0000_0000_0000_0000_0000,7'b0000000,index[4:2],2'b00};
    
    always @(posedge clk) begin
        case(state) 
            Init: begin
                if(!rx) begin
                    state <= Ready;
                end
                else begin
                    state <= Init;
                end
                rst <= 1;
                write <= 0;
                data_in0 <= 0;
                data_in1 <= 0;
                data_in2 <= 0;
                data_in3 <= 0;
                ack_tx <= 0;
                data_tx <= 0;
                index <= 0;
            end
            Ready: begin
                if(ack_rx) begin
                    state <= Read;
                end
                else begin
                    state <= Ready;
                end
                rst <= 1;
                write <= 0;
                data_in0 <= 0;
                data_in1 <= 0;
                data_in2 <= 0;
                data_in3 <= 0;
                ack_tx <= 0;
                data_tx <= 0;
                index <= 0;
            end
            Read: begin
                if(ack_rx) begin
                    if(index == (data_count-1)) begin
                        state <= Done;
                        write <= 1;
                        data_in3 <= data_rx;                   
                        index <= 0;
                    end
                    else begin
                        state <= Read;
                        case(index[1:0])
                            2'b00: begin
                                write <= 0;
                                data_in0 <= data_rx;
                            end 
                            2'b01: begin
                                write <= 0;
                                data_in1 <= data_rx;
                            end
                            2'b10: begin
                                write <= 0;
                                data_in2 <= data_rx;
                            end
                            2'b11: begin
                                write <= 1;
                                data_in3 <= data_rx;
                            end
                        endcase
                        index <= index + 1;
                    end
                end
                else begin
                    state <= Read;
                    rst <= 1;
                    write <= 0;
                    data_tx <= 0;
                    ack_tx <= 0;
                end
            end
            Done: begin
                if(index < 1) begin
                    state <= Done;
                    index <= index + 1;
                end
                else begin
                    state <= Process;
                    index <= 0;
                end
               write <= 0;
               rst <= 1;
               data_tx <= 0;
               ack_tx <= 0;
            end
            Process: begin
                write <= 0;
                if(pc[12] == 1'b1) begin
                    state <= Write;
                    rst <= 1;
                    index <= 1;
                    data_tx <= data_out[7:0];
                    ack_tx <= 1;
                end 
                else begin
                    state <= Process;
                    rst <= 0;
                    index <= 0;
                    data_tx <= 0;
                    ack_tx <= 0;
                end
            end
            Write: begin
                rst <= 1;
                if(!sent) begin
                    state <= Write;
                    ack_tx <= 0;
                end
                else begin
                    if(index == 0) begin
                    //if(index == data_count) begin
                        state <= Read;
                        ack_tx <= 0;
                        data_tx <= 0;
                        index <= 0;
                    end
                    else begin
                        index <= index + 1;
                        case(index[1:0]) 
                            2'b00: data_tx <= data_out[7:0];
                            2'b01: data_tx <= data_out[15:8];
                            2'b10: data_tx <= data_out[23:16];
                            2'b11: data_tx <= data_out[31:24];
                        endcase
                        state <= Write;
                        ack_tx <= 1;
                    end
                end
            end
            default: begin
                state <= Init;
                index <= 0;
                data_tx <= 0;
                rst <= 1;
                ack_tx <= 0;
                write <= 0;
                data_in0 <= 0;
                data_in1 <= 0;
                data_in2 <= 0;
                data_in3 <= 0;
            end
        endcase
    end
        
    receiver rx_uut (.active_clk(active_clk), .rx(rx), .data_out(data_rx), .ack(ack_rx));
    proc_top proc_uut (.active_clk(active_clk), .rst(rst), .state(state), .write(write), .addr(addr), .data_in({data_in3,data_in2,data_in1,data_in0}), .pc_curr(pc), .data_out(data_out));
    transmitter tx_uut (.active_clk(active_clk), .tx(tx), .data_in(data_tx), .ack(ack_tx), .sent(sent));
endmodule