`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:29:14 11/29/2022 
// Design Name: 
// Module Name:    clk_1s 
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
module clk_1s(
	input wire clk,
	output reg clk_1s
   );
	reg [31:0] cnt;
	initial begin
		cnt = 0;
		clk_1s = 0;
	end
	always @ ( posedge clk ) begin
		if ( cnt < 50_000_000 ) cnt <= cnt + 1;
		else begin
			cnt <= 0;
			clk_1s <= ~clk_1s;
		end
	end
endmodule
