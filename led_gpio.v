`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2025 11:46:36
// Design Name: 
// Module Name: led_gpio
// Project Name: 
// Target Devices: 
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


module led_gpio(
    input [31:0] addr,
    input rst, clk,
    input [31:0] data_in,
    input rd_strobe,
    input [3:0] wr_strobe,
    output reg [31:0] data_out,
    output [7:0] leds
);
reg [31:0] led_data_reg;
always @(posedge clk)
begin
if(rst)
   led_data_reg<=0;
   else if(rd_strobe)
   data_out<=led_data_reg;
   else if(wr_strobe)
   led_data_reg<=data_in;
   end
   assign leds=led_data_reg[7:0];
endmodule
