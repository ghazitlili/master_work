`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2016 08:39:48 PM
// Design Name: 
// Module Name: M1_M2_tb
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


module M1_M2_tb(

    );
       
               
                reg reset;
                reg clk;
                reg [3:0] en_write;
                reg [9:0] data_in_adr;
                
                reg [63:0] data_in_left;
                reg [63:0] data_in_right;
                
                reg en_fsm;
                reg  row_finished_r_last;
                wire row_finished;
                reg    EDGE;               
    TOP UUT(.reset(reset),.clk(clk),.en_write(en_write),.data_in_adr(data_in_adr),.data_in_left(data_in_left),.data_in_right(data_in_right),.en_fsm(en_fsm),.row_finished_(row_finished));                
            
        initial begin:FSM
        integer i,j;
        integer in_left,row_left,col_left;
        integer in_right,row_right,col_right;
        reg [7:0] blue_left,red_left,green_left;
        reg [7:0] blue_right,red_right,green_right; 
                     clk=0;
                     reset=0;
                     in_left  = $fopen("/afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/matlab/image_rect_matlab/image_rect_matlab/output_left_64bits.txt","r");
                     in_right = $fopen("/afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/matlab/image_rect_matlab/image_rect_matlab/output_right_64bits.txt","r");
                     
                       en_fsm=0;  
                       #100
                       reset=1;       
             for(j=0;j<240;j=j+1)begin
             
                      $fscanf(in_left,"%x\n",data_in_left);
                      $fscanf(in_right,"%x\n",data_in_right);
                     data_in_adr  =9'b0;
                     en_write=4'b1111;
                     
                     for(i=0;i<79;i=i+1)begin
                       @(posedge clk);
                       $fscanf(in_left,"%x\n",data_in_left);
                       $fscanf(in_right,"%x\n",data_in_right);
                       data_in_adr=data_in_adr+9'b1;  
                     end
                     @(posedge clk);
                     en_write=4'b0000;
                     @(posedge clk);
                     en_fsm=1;
                     while(!EDGE)begin @(posedge clk);en_fsm=0;end
                     @(posedge clk); en_fsm=0;
             end
          
        end 
        
 always@(posedge clk)begin
         row_finished_r_last<=  row_finished;
         if({row_finished_r_last,row_finished}==2'b10)   begin
         
                        
                       EDGE<=1'b1;
         
//                    en_fsm<=1'b1;en_write=4'b0000;
         
         end 
         else begin
                       EDGE<=1'b0;
//                     en_fsm<=1'b0;en_write=4'b1111;

         end 
 
 end       
        
        always #5 clk=~clk;   
endmodule
