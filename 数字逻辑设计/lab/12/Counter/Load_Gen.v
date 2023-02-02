`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:08:29 12/06/2022 
// Design Name: 
// Module Name:    Load_Gen 
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
module Load_Gen(
    input wire clk,
    input wire clk_1ms,
    input wire btn_in,
    output reg Load_out
    );	 
	 initial Load_out = 0;
	 reg old_btn=1'b0;
	 //pbdebounce p0(clk_1ms, btn_in, btn_out);//���治��Ҫ������
	 always@(posedge clk) begin
		if ((old_btn == 1'b0) && (btn_in == 1'b1))	//btn����������
			Load_out <= 1'b1;
		else
			Load_out <= 1'b0;
	 end
	 always@(posedge clk) begin		//������һ������btn��״̬
		old_btn <= btn_in;
	 end
endmodule
