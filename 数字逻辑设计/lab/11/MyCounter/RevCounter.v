`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:47:20 11/29/2022 
// Design Name: 
// Module Name:    RevCounter 
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
module RevCounter(clk, s, cnt, Rc);
	input wire clk, s;
	output reg [15:0] cnt;
	output wire Rc;
	assign Rc = (~s & (~|cnt)) | (s & (&cnt));
	initial begin
		cnt = 0;
	end
	always@(posedge clk) begin
		if (s) 
			  cnt <= cnt + 1;
		 else
			  cnt <= cnt - 1;
	end
endmodule
