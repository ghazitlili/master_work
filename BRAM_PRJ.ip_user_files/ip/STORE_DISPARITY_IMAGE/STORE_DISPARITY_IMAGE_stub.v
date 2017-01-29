// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.3 (lin64) Build 1368829 Mon Sep 28 20:06:39 MDT 2015
// Date        : Mon Jan 23 19:49:52 2017
// Host        : ghazi-Inspiron-N5010 running 64-bit Ubuntu 16.04 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/ghazi/Desktop/master_work/BRAM_PRJ/BRAM_PRJ.srcs/sources_1/ip/STORE_DISPARITY_IMAGE/STORE_DISPARITY_IMAGE_stub.v
// Design      : STORE_DISPARITY_IMAGE
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_3_0,Vivado 2015.3" *)
module STORE_DISPARITY_IMAGE(clka, wea, addra, dina, clkb, enb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[6:0],dina[31:0],clkb,enb,addrb[6:0],doutb[31:0]" */;
  input clka;
  input [0:0]wea;
  input [6:0]addra;
  input [31:0]dina;
  input clkb;
  input enb;
  input [6:0]addrb;
  output [31:0]doutb;
endmodule
