`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:28:40 11/08/2022 
// Design Name: 
// Module Name:    DisNum 
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
module DisNum(
	input wire clk,
	input wire RST,
	input wire[15:0]HEXS,
	input wire[3:0]points,
	input wire[3:0]LES,
	output wire[3:0]AN,
	output wire point,
	output wire[6:0] LED
    );
	wire[31:0] div;
	clkdiv a0(clk,RST,div);
	wire[3:0]DD;
	wire PPoint;
	wire LLE;
	DisplaySync b0(.Hexs(HEXS[15:0]),.Scan(div[18:17]),.Point(points[3:0]),.Les(LES[3:0]),.Hex(DD[3:0]),.p(PPoint),.LE(LLE),.AN(AN[3:0]));
	MyMC14495 c0(.D(DD[3:0]),.LE(LLE),.Point(PPoint),.LED({LED[0],LED[1],LED[2],LED[3],LED[4],LED[5],LED[6]}),.p(point));
endmodule
