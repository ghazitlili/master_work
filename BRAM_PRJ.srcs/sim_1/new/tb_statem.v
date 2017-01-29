`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/28/2016 12:09:52 PM
// Design Name: 
// Module Name: tb_statem
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


module tb_statem(

    );
    
//input declaration
    reg clock;
    
    reg reset_n;
    
    reg [7:0] data_left;
    
    reg [7:0] data_right;
    
    //output declaration
    wire  [31:0]  sum;
    
    wire read_en;
    
    wire [9:0] addr;
    
    wire row_finished;
    
/// 

statem  U0(.clock(clock),.reset_n(reset_n),.data_left(data_left),.data_right(data_right),.sum(sum),.read_en(read_en),.addr(addr),.row_finished(row_finished));

initial begin
        clock=0;
        reset_n=0;
        #40
        reset_n=1;
        data_left=8'b1111_1111;
        data_right=8'b0000_1111;
        #90
        data_left=8'b1100_1111;
        data_right=8'b0000_1001;
        #90
        data_left=8'b1100_1111;
        data_right=8'b0000_1001;
                
        

end
always #10 clock=~clock;
   
endmodule
