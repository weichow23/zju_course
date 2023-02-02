`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:36:05 11/15/2022 
// Design Name: 
// Module Name:    adder_4bit 
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
module  adder_4bit(FA, FB, Cin, Sum, Cout);
    parameter SIZE = 4;
    input [SIZE-1:0] FA, FB;
    output [SIZE-1:0] Sum;
    input Cin;
    output Cout;
    wire [SIZE:0] Temp;
    assign Temp=FA+FB+Cin;
    assign Cout=Temp[SIZE];
    assign Sum=Temp[SIZE-1:0];
endmodule


 
