// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.2 (lin64) Build 1266856 Fri Jun 26 16:35:25 MDT 2015
// Date        : Fri Jun 24 00:18:25 2016
// Host        : wks24.c3e.cs.tu-bs.de running 64-bit CentOS Linux release 7.2.1511 (Core)
// Command     : write_verilog -force -mode synth_stub
//               /afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/references/VERILOG/tutorial/tutorial/project_1/BRAM_PRJ/BRAM_PRJ.srcs/sources_1/ip/BUFFER_ROW_RIGHT_1/BUFFER_ROW_RIGHT_stub.v
// Design      : BUFFER_ROW_RIGHT
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_2,Vivado 2015.2" *)
module BUFFER_ROW_RIGHT(clka, wea, addra, dina, clkb, enb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[9:0],dina[7:0],clkb,enb,addrb[9:0],doutb[7:0]" */;
  input clka;
  input [0:0]wea;
  input [9:0]addra;
  input [7:0]dina;
  input clkb;
  input enb;
  input [9:0]addrb;
  output [7:0]doutb;
endmodule
