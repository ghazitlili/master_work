`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/28/2016 10:53:32 AM
// Design Name: 
// Module Name: Absolute_value
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


module Absolute_value_cost(en,clock,data_in_left,data_in_right,cost );

input clock,en;
input [7:0] data_in_left,data_in_right;

output reg [7:0] cost;

always@(posedge clock) begin

        if(en)begin
        
                cost<=(data_in_left<data_in_right)? (data_in_right-data_in_left):(data_in_left-data_in_right);
        
        
        end


end

        
endmodule
