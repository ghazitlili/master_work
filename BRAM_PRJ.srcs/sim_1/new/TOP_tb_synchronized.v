`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2016 04:08:17 PM
// Design Name: 
// Module Name: TOP_tb_synchronized
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


module TOP_tb_synchronized(

    );
                   
     reg reset;
     reg clk;
     reg data_available;
     reg [63:0] data_in_left;
     reg [63:0] data_in_right;
     wire data_ack; 
     wire [63:0] min_value_disparity_1;
     wire        enable_axi_interface;
//     wire [15:0] min_value_disparity_2;
//     wire [15:0] min_value_disparity_3;     
TOP UUT(.reset(reset),.clk(clk),.data_available(data_available),.data_in_left(data_in_left),.data_in_right(data_in_right),.data_ack(data_ack),
       .min_value_disparity_1_row(min_value_disparity_1),.enable_axi_interface(enable_axi_interface));//,.min_value_disparity_2_row(min_value_disparity_2),.min_value_disparity_3_row(min_value_disparity_3));                
integer i,j;
integer in_left,row_left,col_left;
integer in_right,row_right,col_right;
reg [7:0] blue_left,red_left,green_left;
reg [7:0] blue_right,red_right,green_right; 

 
initial begin:FSM

          clk=0;
          reset=0;
          data_available=1'b0;
          in_left  = $fopen("/home/ghazi/Downloads/master_work/matlab/image_rect_matlab/image_rect_matlab/output_left_64bits.txt","r");
          in_right = $fopen("/home/ghazi/Downloads/master_work/matlab/image_rect_matlab/image_rect_matlab/output_right_64bits.txt","r");
            
          #100
          reset=1;   
forever begin
            
                  i=$fscanf(in_left,"%x\n",data_in_left);
                  j=$fscanf(in_right,"%x\n",data_in_right); 
                  @(posedge clk);
                  data_available=1'b1;
                  wait(data_ack)
                  @(posedge clk); 
end
end 
always #5 clk=~clk;
endmodule
