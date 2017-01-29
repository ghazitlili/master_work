`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/01/2016 11:01:00 AM
// Design Name: 
// Module Name: M1_M2_tb_select_points
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


module M1_M2_tb_select_points(

    );
           
            
             reg reset;
             reg clk;
             reg [3:0] en_write;
             reg [9:0] data_in_adr;
             
             reg [63:0] data_in_left;
             reg [63:0] data_in_right;
             
             reg en_fsm;
             wire row_finished;
             reg    EDGE; 
             wire [7:0]     min_value_disparity_1;
             wire [7:0]     min_value_disparity_2;
             wire [7:0]     min_value_disparity_3;             
 TOP UUT(.reset(reset),.clk(clk),.en_write(en_write),.data_in_adr(data_in_adr),.data_in_left(data_in_left),.data_in_right(data_in_right),.en_fsm(en_fsm),.row_finished_(row_finished),
          .min_value_disparity_1(min_value_disparity_1),.min_value_disparity_2(min_value_disparity_2),.min_value_disparity_3(min_value_disparity_3));                
         
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
          end
       

      
     
     always #5 clk=~clk;   
endmodule
