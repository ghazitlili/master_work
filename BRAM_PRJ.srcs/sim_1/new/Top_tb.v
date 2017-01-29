`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/29/2016 04:18:14 PM
// Design Name: 
// Module Name: Top_tb
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


module Top_tb(

    );
    
    
              
               reg reset;
               reg clk;
               reg [3:0] en_write;
               reg [9:0] data_in_adr;
               
               reg [63:0] data_in_left;
               reg [63:0] data_in_right;
               
               reg en_fsm;
               
               wire [31:0] sum_d0;
               wire [31:0] sum_d1;
               wire [31:0] sum_d2;
               wire [31:0] sum_d3;
               wire [31:0] sum_d4;
               wire [31:0] sum_d5;
               wire [31:0] sum_d6;
               wire [31:0] sum_d7;
               wire [31:0] min_value;
                              
   DATA_PROCESS UUT(.reset(reset),.clk(clk),.en_write(en_write),.data_in_adr(data_in_adr),.data_in_left(data_in_left),.data_in_right(data_in_right),.en_fsm(en_fsm),
   
   
            .sum_d0(sum_d0),.sum_d1(sum_d1),.sum_d2(sum_d2),.sum_d3(sum_d3),.sum_d4(sum_d4),.sum_d5(sum_d5),.sum_d6(sum_d6),.sum_d7(sum_d7),.min_value(min_value));                
           
       initial begin:FSM
       integer i;
       integer in_left,row_left,col_left;
       integer in_right,row_right,col_right;
       reg [7:0] blue_left,red_left,green_left;
       reg [7:0] blue_right,red_right,green_right; 
                    clk=0;
                    reset=0;
//                    data_in_left =64'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
//                    data_in_right=64'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111;
                    in_left  = $fopen("/afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/matlab/image_rect_matlab/image_rect_matlab/output_left_64bits.txt","r");
                    in_right = $fopen("/afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/matlab/image_rect_matlab/image_rect_matlab/output_right_64bits.txt","r");
                     $fscanf(in_left,"%x\n",data_in_left);
                     $fscanf(in_right,"%x\n",data_in_right);
                    data_in_adr  =9'b0;
                    en_fsm=0;
                    #100
                    reset=1;
                    en_write=4'b1111;
                    
                    for(i=0;i<79;i=i+1)begin
                      @(posedge clk);
                      $fscanf(in_left,"%x\n",data_in_left);
                      $fscanf(in_right,"%x\n",data_in_right);
//                      data_in_left=data_in_left+1;
//                      data_in_right=data_in_right-1;
//                      data_in_adr=row_right+(col_right-1)*240-1;
                      data_in_adr=data_in_adr+9'b1;  
                    end
                    @(posedge clk);
                    en_write=0;
                    #20
                    en_fsm=1;
                    
          
                    
       end 
       
       always #5 clk=~clk;   
       
 
endmodule
