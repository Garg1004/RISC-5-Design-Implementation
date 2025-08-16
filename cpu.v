`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2025 11:25:10
// Design Name: 
// Module Name: cpu
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


module cpu(
    input rst, clk,
    input [31:0] mem_rdata,
    output [31:0] mem_addr,
    output reg [31:0] cycle,
    output mem_rstrb
  );
  reg [31:0] regfile[0:31];//Register file with X0 to X31;
  reg [31:0] addr; //address bus
  reg [31:0] data_rs1, data_rs2; //temp regs for alu input
  reg [31:0] data; //data bus
  reg [2:0] state; //state register
  parameter RESET=0, FETCH=1, DECODE=2, EXECUTE=3, HLT=4, WAIT = 5; //Different states
  //********* Decoding of Instructions*******//
  wire [4:0] opcode = data[6:2];
  wire [4:0] rd = data[11:7];
  wire [2:0] funct3 = data[14:12];
  wire [6:0] funct7 = data[31:25];
  wire [31:0] I_data = {{21{data[31]}},data[30:20]}; //sign extended data

  // check whether opcode is for R type or I type  or system-type(ebreak, ecall etc)
  wire isRtype = (opcode == 5'b01100);
  wire isItype = (opcode == 5'b00100);
  wire isSystype = (opcode == 5'b11100);
  //  Design ALU using conditional operator
  wire [31:0] ADD = alu_in1 + alu_in2;
  wire [31:0] XOR = alu_in1 ^ alu_in2;
  wire [31:0] OR = alu_in1 | alu_in2;
  wire [31:0] AND = alu_in1 & alu_in2;

  // Note : for ADD and SUB, funct3 is same but funct7[5] is different
  wire [31:0] alu_result = (funct3==3'b000)? ADD: //ADD
       (funct3==3'b100)? XOR: //XOR
       (funct3==3'b110)? OR: //OR
       (funct3==3'b111)? AND: 0;//AND

  //source1 and source 2 data for ALU operation
  wire [31:0] alu_in1 = data_rs1; //source is always rs1 for both type
  wire [31:0] alu_in2 = (isRtype )? data_rs2 : I_data;
  wire [31:0] pcplus4 = addr + 4;

  //Generate memory read strobe signal and address
  assign mem_addr = addr;
  assign mem_rstrb = (state == FETCH)|(state==WAIT);


  initial
  begin
    state=0;
    addr = 0;
    regfile[0] = 0;//X0 reg is always 0
    cycle = 0;
  end

  //clock dependent operation

  always @(posedge clk)
  begin
    if(rst)
    begin
      addr <= 0;
      state <= RESET;
      data <= 32'h0;
    end
    else
    case(state)
      RESET: //If reset is pressed
      begin
        if(rst)
          state <= RESET;
        else
          state <= WAIT;
      end

      WAIT: state <= FETCH;

      FETCH: //Fetch data from progmem RAM
      begin
        data <= mem_rdata; //latch mem read data into reg
        state <= DECODE;
      end

      DECODE: //Decoding of different instruction and generate signal
      begin
        data_rs1 <= regfile[data[19:15]];
        data_rs2 <= regfile[data[24:20]];
        //state <= (isItype | isRtype | isBtype)? ALU: isSystype ? HLT:EXECUTE;
        state <= (isItype | isRtype )? EXECUTE:  HLT;
      end

      EXECUTE:
      begin
        addr <= pcplus4;
        state <= FETCH;
      end
      
    endcase
  end

  // ** Register file write back data **//
  wire write_reg_en = (isRtype | isItype) &   (state==EXECUTE);
  wire [31:0] write_reg_data = (isItype |isRtype) ? alu_result:0;

  always @(posedge clk)
  begin
    if (write_reg_en)
      if (rd != 0)//check whether dest reg is x0 or not, if not then write data
        regfile[rd] <= write_reg_data;
  end

  //*** clock cycle counter **//
  always @(posedge clk)
  begin
    if(rst)
      cycle <= 0;
    else
    begin
      if(state != HLT)
        cycle <= cycle + 1;
    end
  end


endmodule

