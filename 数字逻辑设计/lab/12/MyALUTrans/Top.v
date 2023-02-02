`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:18:53 12/06/2022 
// Design Name: 
// Module Name:    Top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module Top(
  input clk,
  input RST,
  input [15:0] SW,
  output [3:0] Aoutput,Boutput,Coutput,
  output LoadA,LoadB,LoadC
  );
  wire [31:0] clk_div;
  wire [3:0] A_IN, B_IN, C_IN;
  wire Load_A, Load_B, Load_C;
  wire [3:0] A, B, C;
  wire [3:0] I1, I0_A, I0_B, I0_C;
  wire Co;

  Load_Gen m0(.clk(clk), .clk_1ms(clk_div[2]), .btn_in(SW[2]),.Load_out(Load_A));
  Load_Gen m1(.clk(clk), .clk_1ms(clk_div[2]), .btn_in(SW[3]),.Load_out(Load_B));
  Load_Gen m2(.clk(clk), .clk_1ms(clk_div[2]), .btn_in(SW[4]),.Load_out(Load_C));
  clkdiv m3(.clk(clk), .rst(1'b0), .clkdiv(clk_div));

  AddSub4b m4(.A(A), .B(4'b0001), .Ctrl(SW[0]), .S(I0_A));
  AddSub4b m5(.A(B), .B(4'b0001), .Ctrl(SW[1]), .S(I0_B));

  //Mux2to14b m6( I1, I0_A, SW[15], A_IN);
  //Mux2to14b m7( I1, I0_B, SW[15], B_IN);
  //Mux2to14b m8( I1, I0_C, SW[15], C_IN);
  //Mux3to14b m9(.in1(A), .in2(B), .in3(C), .op(SW[8:7]), .out(I1));
  Mux4to1b4 m6(.s(SW[8:7]),.I0(A),.I1(B),.I2(C),.o(I1));
	
  MyRegister4b RegA( .clk(clk), .IN(A_IN), .Load(Load_A), .OUT(A));
  MyRegister4b RegB( .clk(clk), .IN(B_IN), .Load(Load_B), .OUT(B));
  MyRegister4b RegC( .clk(clk), .IN(C_IN), .Load(Load_C), .OUT(C));

  ALU m10( .A(A), .B(B), .S(SW[6:5]), .C(I0_C), .Co(Co));
   
  assign A_IN = (RST==1'b0)?I0_A:I1;
  assign B_IN = (RST==1'b0)?I0_B:I1;
  assign C_IN = (RST==1'b0)?I0_C:I1;  
  
  assign Aoutput=A;
  assign Boutput=B;
  assign Coutput=C;
  assign LoadA=Load_A;
  assign LoadB=Load_B;
  assign LoadC=Load_C;

endmodule
