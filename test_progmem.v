`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2025 11:19:16
// Design Name: 
// Module Name: test_progmem
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


module test_progmem;
reg rst, clk;
    reg [31:0] addr;
    reg [31:0] data_in;//this should be same size of data_outto avoid dual port RAM generation during synthesis
    reg rd_strobe;
    reg [3:0] wr_strobe;
    wire [31:0] data_out;
//calling DUT
    progmem DUT(.rst(rst), .clk(clk),
    .data_in(data_in),
    .rd_strobe(rd_strobe),
    .wr_strobe(wr_strobe),
    .addr(addr),
    .data_out(data_out)
    );

    initial begin
        $dumpfile("test.vcd");
        $dumpvars;
        rst=1; clk=0;wr_strobe=0;data_in=0;addr=0;#50;
        rst=0;
        addr=0;rd_strobe=1;#20;
        addr=4;#20;
        addr=8; #20;
        $finish;
    end
always #5 clk=~clk;

initial begin
    $monitor("Addr=%d, dataout=%h", addr, data_out);
end
endmodule
