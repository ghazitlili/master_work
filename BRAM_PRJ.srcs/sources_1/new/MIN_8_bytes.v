`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2016 11:44:42 AM
// Design Name: 
// Module Name: MIN_8_bytes
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MIN_8_bytes(clk,in_0,in_1,in_2,in_3,in_4,in_5,in_6,in_7,out_

    );
input   wire  clk;   
input   wire [31:0] in_0,in_1,in_2,in_3,in_4,in_5,in_6,in_7;
output  wire [31:0] out_;

reg  [31:0]  tmp,tmp_old; 
wire [31:0] out_0,out_1,out_2,out_3,out_4,out_5,out;
MIN  C_0(.in_0(in_0),.in_1(in_1),.out(out_0));
MIN  C_1(.in_0(in_2),.in_1(in_3),.out(out_1));
MIN  C_2(.in_0(in_4),.in_1(in_5),.out(out_2));
MIN  C_3(.in_0(in_6),.in_1(in_7),.out(out_3));
//////////////////////////////
MIN  C_4(.in_0(out_0),.in_1(out_1),.out(out_4));
MIN  C_5(.in_0(out_2),.in_1(out_3),.out(out_5));
/////////////////////////////
MIN  C_6(.in_0(out_4),.in_1(out_5),.out(out_));
//////////////////////////////

endmodule
