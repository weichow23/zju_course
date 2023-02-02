`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:18:52 12/06/2022 
// Design Name: 
// Module Name:    MyRegister4b 
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
module MyRegister4b(
   input wire clk,
	input wire Load,
	input wire [3:0] IN,
	output wire [3:0] OUT
    );
	//reg [3:0] IN;
	reg [3:0] out_initial =  4'h0;
	assign OUT=out_initial;
	always @ (posedge clk) 
		begin
			if (Load) 
				out_initial <= IN;
		end
endmodule
