////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: P.20131013
//  \   \         Application: netgen
//  /   /         Filename: D_74LS138_Test_map.v
// /___/   /\     Timestamp: Tue Nov 01 15:06:26 2022
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -intstyle ise -s 1 -pcf D_74LS138_Test.pcf -sdf_anno true -sdf_path netgen/map -insert_glbl true -w -dir netgen/map -ofmt verilog -sim D_74LS138_Test_map.ncd D_74LS138_Test_map.v 
// Device	: 7k160tffg676-1 (PRODUCTION 1.10 2013-10-13)
// Input file	: D_74LS138_Test_map.ncd
// Output file	: E:\lab\5\D_74LS138_Test\netgen\map\D_74LS138_Test_map.v
// # of Modules	: 1
// Design Name	: D_74LS138_Test
// Xilinx        : E:\ISE\14.7\ISE_DS\ISE\
//             
// Purpose:    
//     This verilog netlist is a verification model and uses simulation 
//     primitives which may not represent the true implementation of the 
//     device, however the netlist is functionally correct and should not 
//     be modified. This file cannot be synthesized and should only be used 
//     with supported simulation tools.
//             
// Reference:  
//     Command Line Tools User Guide, Chapter 23 and Synthesis and Simulation Design Guide, Chapter 6
//             
////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns/1 ps

module D_74LS138_Test (
SW, LED
);
  input [5 : 0] SW;
  output [7 : 0] LED;
  wire SW_1_IBUF_96;
  wire SW_2_IBUF_97;
  wire SW_3_IBUF_98;
  wire SW_4_IBUF_99;
  wire SW_5_IBUF_100;
  wire LED_0_OBUF_101;
  wire LED_1_OBUF_102;
  wire LED_2_OBUF_103;
  wire LED_3_OBUF_104;
  wire LED_4_OBUF_105;
  wire LED_5_OBUF_106;
  wire LED_6_OBUF_107;
  wire LED_7_OBUF_108;
  wire SW_0_IBUF_109;
  wire \XLXI_1/XLXN_50 ;
  wire \XLXI_1/XLXN_6 ;
  wire \XLXI_1/XLXN_12 ;
  wire \XLXI_1/XLXN_14 ;
  wire \XLXI_1/XLXN_17 ;
  wire \ProtoComp0.INTERMDISABLE_GND.0 ;
  wire \SW<3>/ProtoComp0.INTERMDISABLE_GND.0 ;
  wire \SW<4>/ProtoComp0.INTERMDISABLE_GND.0 ;
  wire \SW<1>/ProtoComp0.INTERMDISABLE_GND.0 ;
  wire \SW<5>/ProtoComp0.INTERMDISABLE_GND.0 ;
  wire \SW<0>/ProtoComp0.INTERMDISABLE_GND.0 ;
  initial $sdf_annotate("netgen/map/d_74ls138_test_map.sdf");
  X_IPAD #(
    .LOC ( "IOB_X0Y154" ))
  \SW<2>  (
    .PAD(SW[2])
  );
  X_ZERO #(
    .LOC ( "IOB_X0Y154" ))
  \ProtoComp0.INTERMDISABLE_GND.1  (
    .O(\ProtoComp0.INTERMDISABLE_GND.0 )
  );
  X_IBUF_INTERMDISABLE_TPWRGT #(
    .LOC ( "IOB_X0Y154" ))
  SW_2_IBUF (
    .IBUFDISABLE(1'b0),
    .INTERMDISABLE(\ProtoComp0.INTERMDISABLE_GND.0 ),
    .O(SW_2_IBUF_97),
    .I(SW[2]),
    .TPWRGT(1'b1)
  );
  X_IPAD #(
    .LOC ( "IOB_X0Y139" ))
  \SW<3>  (
    .PAD(SW[3])
  );
  X_ZERO #(
    .LOC ( "IOB_X0Y139" ))
  \ProtoComp0.INTERMDISABLE_GND.2  (
    .O(\SW<3>/ProtoComp0.INTERMDISABLE_GND.0 )
  );
  X_IBUF_INTERMDISABLE_TPWRGT #(
    .LOC ( "IOB_X0Y139" ))
  SW_3_IBUF (
    .IBUFDISABLE(1'b0),
    .INTERMDISABLE(\SW<3>/ProtoComp0.INTERMDISABLE_GND.0 ),
    .O(SW_3_IBUF_98),
    .I(SW[3]),
    .TPWRGT(1'b1)
  );
  X_IPAD #(
    .LOC ( "IOB_X0Y141" ))
  \SW<4>  (
    .PAD(SW[4])
  );
  X_ZERO #(
    .LOC ( "IOB_X0Y141" ))
  \ProtoComp0.INTERMDISABLE_GND.3  (
    .O(\SW<4>/ProtoComp0.INTERMDISABLE_GND.0 )
  );
  X_IBUF_INTERMDISABLE_TPWRGT #(
    .LOC ( "IOB_X0Y141" ))
  SW_4_IBUF (
    .IBUFDISABLE(1'b0),
    .INTERMDISABLE(\SW<4>/ProtoComp0.INTERMDISABLE_GND.0 ),
    .O(SW_4_IBUF_99),
    .I(SW[4]),
    .TPWRGT(1'b1)
  );
  X_IPAD #(
    .LOC ( "IOB_X0Y156" ))
  \SW<1>  (
    .PAD(SW[1])
  );
  X_ZERO #(
    .LOC ( "IOB_X0Y156" ))
  \ProtoComp0.INTERMDISABLE_GND  (
    .O(\SW<1>/ProtoComp0.INTERMDISABLE_GND.0 )
  );
  X_IBUF_INTERMDISABLE_TPWRGT #(
    .LOC ( "IOB_X0Y156" ))
  SW_1_IBUF (
    .IBUFDISABLE(1'b0),
    .INTERMDISABLE(\SW<1>/ProtoComp0.INTERMDISABLE_GND.0 ),
    .O(SW_1_IBUF_96),
    .I(SW[1]),
    .TPWRGT(1'b1)
  );
  X_OPAD #(
    .LOC ( "IOB_X0Y143" ))
  \LED<0>  (
    .PAD(LED[0])
  );
  X_OBUF #(
    .LOC ( "IOB_X0Y143" ))
  LED_0_OBUF (
    .I(LED_0_OBUF_101),
    .O(LED[0])
  );
  X_IPAD #(
    .LOC ( "IOB_X0Y142" ))
  \SW<5>  (
    .PAD(SW[5])
  );
  X_ZERO #(
    .LOC ( "IOB_X0Y142" ))
  \ProtoComp0.INTERMDISABLE_GND.4  (
    .O(\SW<5>/ProtoComp0.INTERMDISABLE_GND.0 )
  );
  X_IBUF_INTERMDISABLE_TPWRGT #(
    .LOC ( "IOB_X0Y142" ))
  SW_5_IBUF (
    .IBUFDISABLE(1'b0),
    .INTERMDISABLE(\SW<5>/ProtoComp0.INTERMDISABLE_GND.0 ),
    .O(SW_5_IBUF_100),
    .I(SW[5]),
    .TPWRGT(1'b1)
  );
  X_OPAD #(
    .LOC ( "IOB_X0Y137" ))
  \LED<6>  (
    .PAD(LED[6])
  );
  X_OBUF #(
    .LOC ( "IOB_X0Y137" ))
  LED_6_OBUF (
    .I(LED_6_OBUF_107),
    .O(LED[6])
  );
  X_OPAD #(
    .LOC ( "IOB_X0Y144" ))
  \LED<1>  (
    .PAD(LED[1])
  );
  X_OBUF #(
    .LOC ( "IOB_X0Y144" ))
  LED_1_OBUF (
    .I(LED_1_OBUF_102),
    .O(LED[1])
  );
  X_OPAD #(
    .LOC ( "IOB_X0Y140" ))
  \LED<3>  (
    .PAD(LED[3])
  );
  X_OBUF #(
    .LOC ( "IOB_X0Y140" ))
  LED_3_OBUF (
    .I(LED_3_OBUF_104),
    .O(LED[3])
  );
  X_OPAD #(
    .LOC ( "IOB_X0Y146" ))
  \LED<4>  (
    .PAD(LED[4])
  );
  X_OBUF #(
    .LOC ( "IOB_X0Y146" ))
  LED_4_OBUF (
    .I(LED_4_OBUF_105),
    .O(LED[4])
  );
  X_OPAD #(
    .LOC ( "IOB_X0Y138" ))
  \LED<5>  (
    .PAD(LED[5])
  );
  X_OBUF #(
    .LOC ( "IOB_X0Y138" ))
  LED_5_OBUF (
    .I(LED_5_OBUF_106),
    .O(LED[5])
  );
  X_OPAD #(
    .LOC ( "IOB_X0Y145" ))
  \LED<2>  (
    .PAD(LED[2])
  );
  X_OBUF #(
    .LOC ( "IOB_X0Y145" ))
  LED_2_OBUF (
    .I(LED_2_OBUF_103),
    .O(LED[2])
  );
  X_LUT6 #(
    .LOC ( "SLICE_X12Y142" ),
    .INIT ( 64'hFF00FFFFFFFFFFFF ))
  \XLXI_1/XLXI_7  (
    .ADR0(1'b1),
    .ADR1(1'b1),
    .ADR2(1'b1),
    .ADR3(SW_3_IBUF_98),
    .ADR4(\XLXI_1/XLXN_50 ),
    .ADR5(\XLXI_1/XLXN_6 ),
    .O(LED_7_OBUF_108)
  );
  X_LUT6 #(
    .LOC ( "SLICE_X12Y142" ),
    .INIT ( 64'h000000000000FFFF ))
  \XLXI_1/XLXI_1  (
    .ADR0(1'b1),
    .ADR1(1'b1),
    .ADR2(1'b1),
    .ADR3(1'b1),
    .ADR4(SW_4_IBUF_99),
    .ADR5(SW_5_IBUF_100),
    .O(\XLXI_1/XLXN_6 )
  );
  X_LUT6 #(
    .LOC ( "SLICE_X12Y142" ),
    .INIT ( 64'hFF00FFFFFFFFFFFF ))
  \XLXI_1/XLXI_9  (
    .ADR0(1'b1),
    .ADR1(1'b1),
    .ADR2(1'b1),
    .ADR3(SW_3_IBUF_98),
    .ADR4(\XLXI_1/XLXN_50 ),
    .ADR5(\XLXI_1/XLXN_14 ),
    .O(LED_5_OBUF_106)
  );
  X_LUT6 #(
    .LOC ( "SLICE_X12Y142" ),
    .INIT ( 64'h00000000FFFF0000 ))
  \XLXI_1/XLXI_3  (
    .ADR0(1'b1),
    .ADR1(1'b1),
    .ADR2(1'b1),
    .ADR3(1'b1),
    .ADR4(SW_4_IBUF_99),
    .ADR5(SW_5_IBUF_100),
    .O(\XLXI_1/XLXN_14 )
  );
  X_OPAD #(
    .LOC ( "IOB_X0Y136" ))
  \LED<7>  (
    .PAD(LED[7])
  );
  X_OBUF #(
    .LOC ( "IOB_X0Y136" ))
  LED_7_OBUF (
    .I(LED_7_OBUF_108),
    .O(LED[7])
  );
  X_LUT6 #(
    .LOC ( "SLICE_X12Y143" ),
    .INIT ( 64'hFF00FFFFFFFFFFFF ))
  \XLXI_1/XLXI_10  (
    .ADR0(1'b1),
    .ADR1(1'b1),
    .ADR2(1'b1),
    .ADR3(SW_3_IBUF_98),
    .ADR4(\XLXI_1/XLXN_50 ),
    .ADR5(\XLXI_1/XLXN_17 ),
    .O(LED_4_OBUF_105)
  );
  X_LUT6 #(
    .LOC ( "SLICE_X12Y143" ),
    .INIT ( 64'hFFFF000000000000 ))
  \XLXI_1/XLXI_4  (
    .ADR0(1'b1),
    .ADR1(1'b1),
    .ADR2(1'b1),
    .ADR3(1'b1),
    .ADR4(SW_4_IBUF_99),
    .ADR5(SW_5_IBUF_100),
    .O(\XLXI_1/XLXN_17 )
  );
  X_LUT6 #(
    .LOC ( "SLICE_X11Y143" ),
    .INIT ( 64'h00FFFFFFFFFFFFFF ))
  \XLXI_1/XLXI_13  (
    .ADR0(1'b1),
    .ADR1(1'b1),
    .ADR2(1'b1),
    .ADR3(SW_3_IBUF_98),
    .ADR4(\XLXI_1/XLXN_50 ),
    .ADR5(\XLXI_1/XLXN_14 ),
    .O(LED_1_OBUF_102)
  );
  X_LUT6 #(
    .LOC ( "SLICE_X13Y143" ),
    .INIT ( 64'h00FFFFFFFFFFFFFF ))
  \XLXI_1/XLXI_14  (
    .ADR0(1'b1),
    .ADR1(1'b1),
    .ADR2(1'b1),
    .ADR3(SW_3_IBUF_98),
    .ADR4(\XLXI_1/XLXN_50 ),
    .ADR5(\XLXI_1/XLXN_17 ),
    .O(LED_0_OBUF_101)
  );
  X_LUT6 #(
    .LOC ( "SLICE_X13Y143" ),
    .INIT ( 64'h00FFFFFFFFFFFFFF ))
  \XLXI_1/XLXI_12  (
    .ADR0(1'b1),
    .ADR1(1'b1),
    .ADR2(1'b1),
    .ADR3(SW_3_IBUF_98),
    .ADR4(\XLXI_1/XLXN_50 ),
    .ADR5(\XLXI_1/XLXN_12 ),
    .O(LED_2_OBUF_103)
  );
  X_LUT6 #(
    .LOC ( "SLICE_X1Y153" ),
    .INIT ( 64'h000000FF00000000 ))
  \XLXI_1/XLXI_16  (
    .ADR0(1'b1),
    .ADR1(1'b1),
    .ADR2(1'b1),
    .ADR3(SW_0_IBUF_109),
    .ADR4(SW_1_IBUF_96),
    .ADR5(SW_2_IBUF_97),
    .O(\XLXI_1/XLXN_50 )
  );
  X_LUT6 #(
    .LOC ( "SLICE_X13Y142" ),
    .INIT ( 64'h00FFFFFFFFFFFFFF ))
  \XLXI_1/XLXI_11  (
    .ADR0(1'b1),
    .ADR1(1'b1),
    .ADR2(1'b1),
    .ADR3(SW_3_IBUF_98),
    .ADR4(\XLXI_1/XLXN_50 ),
    .ADR5(\XLXI_1/XLXN_6 ),
    .O(LED_3_OBUF_104)
  );
  X_LUT6 #(
    .LOC ( "SLICE_X13Y142" ),
    .INIT ( 64'hFF00FFFFFFFFFFFF ))
  \XLXI_1/XLXI_8  (
    .ADR0(1'b1),
    .ADR1(1'b1),
    .ADR2(1'b1),
    .ADR3(SW_3_IBUF_98),
    .ADR4(\XLXI_1/XLXN_50 ),
    .ADR5(\XLXI_1/XLXN_12 ),
    .O(LED_6_OBUF_107)
  );
  X_LUT6 #(
    .LOC ( "SLICE_X13Y142" ),
    .INIT ( 64'h0000FFFF00000000 ))
  \XLXI_1/XLXI_2  (
    .ADR0(1'b1),
    .ADR1(1'b1),
    .ADR2(1'b1),
    .ADR3(1'b1),
    .ADR4(SW_4_IBUF_99),
    .ADR5(SW_5_IBUF_100),
    .O(\XLXI_1/XLXN_12 )
  );
  X_IPAD #(
    .LOC ( "IOB_X0Y153" ))
  \SW<0>  (
    .PAD(SW[0])
  );
  X_ZERO #(
    .LOC ( "IOB_X0Y153" ))
  \ProtoComp0.INTERMDISABLE_GND.5  (
    .O(\SW<0>/ProtoComp0.INTERMDISABLE_GND.0 )
  );
  X_IBUF_INTERMDISABLE_TPWRGT #(
    .LOC ( "IOB_X0Y153" ))
  SW_0_IBUF (
    .IBUFDISABLE(1'b0),
    .INTERMDISABLE(\SW<0>/ProtoComp0.INTERMDISABLE_GND.0 ),
    .O(SW_0_IBUF_109),
    .I(SW[0]),
    .TPWRGT(1'b1)
  );
endmodule


`ifndef GLBL
`define GLBL

`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;

    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule

`endif

