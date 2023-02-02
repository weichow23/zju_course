`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:13:36 11/08/2022 
// Design Name: 
// Module Name:    DispNumber 
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
module DispNumber(
	input[7:0]SW,
	input LE,
	input point,
	output[3:0] AN,
	output[7:0] SEGMENT
    );
	assign AN=~SW[7:4];
	MyMC14495 uut(
		.D(SW[3:0]),
		.LE(LE),
		.Point(point),
		.LED({SEGMENT[0],SEGMENT[1],SEGMENT[2],SEGMENT[3],SEGMENT[4],SEGMENT[5],SEGMENT[6]}),
		.p(SEGMENT[7])
	);

endmodule
