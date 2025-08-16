`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2025 11:28:16
// Design Name: 
// Module Name: testbench
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


module top_test;
  reg rst, clk;
  wire [31:0] cycle;
  integer i;
  //instantiate DUT
  top dut (rst, clk, cycle);
  initial
  begin
    $dumpfile("test.vcd");
    $dumpvars;
    rst=1;
    clk=0;
    #50;
    rst=0;
    #700;

    //Print register content
    $display("*** Printing register content ***");
    for(i=0; i<7; i=i+1)
      $display("X[%0d] = %0d ",i,$signed(dut.cpu0.regfile[i]));
    $display("Clock cycle=%0d", cycle);

    $finish;
  end
  /*
  initial begin
  $monitor("Time=%0d, X[0]=%0d, X[1]=%0d, X[2]=%0d, X[3]=%0d, X[4]=%0d,  X[5]=%0d, Cycle=%0d",$time, dut.cpu0.regfile[0],dut.cpu0.regfile[1],dut.cpu0.regfile[2],dut.cpu0.regfile[3],dut.cpu0.regfile[4],dut.cpu0.regfile[5], cycle);
  end
  */
  always #5 clk=~clk; //clock generator
endmodule

