`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2016 11:36:44 AM
// Design Name: 
// Module Name: MIN
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


module MIN(in_0,in_1,out);


input  [31:0]    in_0;
input  [31:0]    in_1;
output [31:0]    out;

assign out=(in_0[23:0]<in_1[23:0])?in_0:in_1;

 
 
endmodule
