`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:40:05 11/08/2022 
// Design Name: 
// Module Name:    DisplaySync 
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
module DisplaySync(
	input[15:0]Hexs,
	input[1:0]Scan,
	input[3:0]Point,
	input[3:0]Les,
	output reg[3:0]Hex,
	output reg p,LE,
	output reg[3:0]AN
    );
	always@(*)
	begin
		case(Scan)
			2'b00:begin Hex <=Hexs[3:0]; AN <=4'b 1110; p<=Point[0]; LE <=Les[0]; end
			2'b01:begin Hex <=Hexs[7:4]; AN <=4'b 1101; p<=Point[1]; LE <=Les[1];  end
			2'b10:begin Hex <=Hexs[11:8];AN <=4'b 1011; p<=Point[2]; LE <=Les[2]; end
			2'b11:begin Hex <=Hexs[15:12];AN <=4'b 0111; p<=Point[3]; LE <=Les[3]; end
		endcase
	end
endmodule