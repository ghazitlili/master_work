`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/28/2016 11:13:27 AM
// Design Name: 
// Module Name: SUMMATION
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


module SUMMATION(en,clock,cost,SUM);
        input en,clock;
        input [7:0] cost;
        output [31:0] SUM;
     
reg [31:0]   SUM;
always@(posedge clock)begin

      if(en)  
                 SUM<=SUM + cost;
      
      else
                 SUM<=SUM;
           
end
        
endmodule
