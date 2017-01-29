`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/28/2016 11:53:45 AM
// Design Name: 
// Module Name: INCREMENT
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


module INCREMENT(en,clock,in,out);

input en,clock;
input [9:0] in;

output reg [9:0] out;

always@(posedge clock)begin

        if(en) out<=in +1;
        
        else  out<=out;


end
endmodule
