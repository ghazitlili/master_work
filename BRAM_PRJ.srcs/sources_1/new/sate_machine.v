`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TU Braunschweig
// Engineer: Ghazi Abbassi
// 
// Create Date: 05/23/2016 08:25:27 PM
// Design Name: 
// Module Name: Main state machine for v-disparity computation 
// Project Name: 
// Target Devices: Zynq 
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
`define IMAGE_WIDTH   79  // the image width define how many chunks of data we need to process (640 byte / 8 bytes == 80) minus one is for computational convenience
`define MAX_DISPARITY 17  // we compute 8 disparities at once so the max value for the counter is (128/ 8== 16 ) plus one is for computational convenience



module statem(clock,reset_n,en_fsm,data_left,data_right,

                sum_d0,sum_d1,sum_d2,sum_d3,sum_d4,sum_d5,sum_d6,sum_d7,
                
                
                read_en,addr_left,addr_right,row_finished,
                
                min_value,d_av);

//////////////////////////////////////used for loging//////////////////77
integer log;



///////////////////////////////////////////////////////////////////////
//input declaration
input wire clock;

input wire reset_n;

input wire en_fsm;

input wire [63:0] data_left;

input wire [63:0] data_right;

//output declaration
output wire  [31:0]  sum_d0;
output wire  [31:0]  sum_d1;
output wire  [31:0]  sum_d2;
output wire  [31:0]  sum_d3;
output wire  [31:0]  sum_d4;
output wire  [31:0]  sum_d5;
output wire  [31:0]  sum_d6;
output wire  [31:0]  sum_d7;
output wire  [31:0]  min_value;
output wire read_en;

output wire [9:0] addr_left;

output wire [9:0] addr_right;
 
output row_finished;
output wire d_av;
// SIGNAL DECLARATION
reg    row_finished_r;


//reg [31:0]  sum;
wire [31:0]  min_value_new;
reg  [31:0]  min_value_r;
//reg  [31:0]  min_value_r_old;
//INNER VARIABLES

reg  [7:0]   disparity;
reg  [23:0]  SUM_HIGH;    reg  [7:0]  cnt_d0;//these counters are used to increment the v-disparity values index
reg  [23:0]  SUM_LOW;
reg  [23:0]  SUM_HIGH_1;  reg  [7:0]  cnt_d1;
reg  [23:0]  SUM_LOW_1;
reg  [23:0]  SUM_HIGH_2;  reg  [7:0]  cnt_d2;
reg  [23:0]  SUM_LOW_2;
reg  [23:0]  SUM_HIGH_3;  reg  [7:0]  cnt_d3;
reg  [23:0]  SUM_LOW_3;
reg  [23:0]  SUM_HIGH_4;  reg  [7:0]  cnt_d4;
reg  [23:0]  SUM_LOW_4;
reg  [23:0]  SUM_HIGH_5;  reg  [7:0]  cnt_d5;
reg  [23:0]  SUM_LOW_5;
reg  [23:0]  SUM_HIGH_6;  reg  [7:0]  cnt_d6;
reg  [23:0]  SUM_LOW_6;
reg  [23:0]  SUM_HIGH_7;  reg  [7:0]  cnt_d7;
reg  [23:0]  SUM_LOW_7;

reg          read_en_r;


reg  [9:0]   addr_r_left;
reg  [9:0]   addr_r_right;


reg [8:0]    mem_state;
///////////////////////////////////////////////////////////////////////////////777
reg [31:0]    difference_d0;
reg [31:0]    difference_d1;
reg [31:0]    difference_d2;
reg [31:0]    difference_d3;
reg [31:0]    difference_d4;
reg [31:0]    difference_d5;
reg [31:0]    difference_d6;
reg [31:0]    difference_d7;

//PARAMETERS
parameter [8:0]            //machine states
          IDLE_STATE       =9'b00000_0001,
          CYCLE1_STATE     =9'b00000_0010,
          CYCLE2_STATE     =9'b00000_0100,
          CYCLE3_STATE     =9'b00000_1000,
          CYCLE4_STATE     =9'b00001_0000,
 	      CYCLE5_STATE     =9'b00010_0000,
 	      CYCLE6_STATE     =9'b00100_0000,
 	      CYCLE7_STATE     =9'b01000_0000,
 	      CYCLE8_STATE     =9'b10000_0000;
parameter [8:0]            //cases
          IDLE_CASE       =9'bxxxxx_xxx1,
          CYCLE1_CASE     =9'bxxxxx_xx1x,
          CYCLE2_CASE     =9'bxxxxx_x1xx,
          CYCLE3_CASE     =9'bxxxxx_1xxx,
          CYCLE4_CASE     =9'bxxxx1_xxxx,
          CYCLE5_CASE     =9'bxxx1x_xxxx,
          CYCLE6_CASE     =9'bxx1xx_xxxx,
          CYCLE7_CASE     =9'bx1xxx_xxxx,
          CYCLE8_CASE     =9'b1xxxx_xxxx;
        
        
        
  integer i=0;       
 /////////////////////////////////////-----registers for keeping read values from the memory---///////////////////
 

 wire [7:0]     w0_,w1_,w2_,w3_,w4_,w5_,w6_,w7_;
         assign w0_=data_left[7:0];
         assign w1_=data_left[15:8];
         assign w2_=data_left[23:16];
         assign w3_=data_left[31:24];
         assign w4_=data_left[39:32];
         assign w5_=data_left[47:40];
         assign w6_=data_left[55:48];
         assign w7_=data_left[63:56];

 wire [7:0]      x0_,x1_,x2_,x3_,x4_,x5_,x6_,x7_; 
          assign x0_=data_right[7:0];
          assign x1_=data_right[15:8];
          assign x2_=data_right[23:16];
          assign x3_=data_right[31:24]; 
          assign x4_=data_right[39:32];
          assign x5_=data_right[47:40];
          assign x6_=data_right[55:48];
          assign x7_=data_right[63:56];  
 


 
 reg [7:0]     d0_,d1_,d2_,d3_,d4_,d5_,d6_,d7_;      //small values starting from disparity_0, disparity_8, disparity_16 ....·
 reg [7:0]     d0_1,d1_1,d2_1,d3_1,d4_1,d5_1,d6_1,d7_1;//small values disparity_1
 reg [7:0]     d0_2,d1_2,d2_2,d3_2,d4_2,d5_2,d6_2,d7_2;//small values disparity_2
 reg [7:0]     d0_3,d1_3,d2_3,d3_3,d4_3,d5_3,d6_3,d7_3;//small values disparity_3
 
  reg [7:0]     d0_4,d1_4,d2_4,d3_4,d4_4,d5_4,d6_4,d7_4; //small values disparity_4
  reg [7:0]     d0_5,d1_5,d2_5,d3_5,d4_5,d5_5,d6_5,d7_5;//small values disparity_5
  reg [7:0]     d0_6,d1_6,d2_6,d3_6,d4_6,d5_6,d6_6,d7_6;//small values disparity_6
  reg [7:0]     d0_7,d1_7,d2_7,d3_7,d4_7,d5_7,d6_7,d7_7;//small values disparity_7
  
 /*********************************************************************************/
 
 
 
 
 reg [7:0]     d0,d1,d2,d3,d4,d5,d6,d7;//high  values  starting from disparity_0, disparity_8, disparity_16 ....·
 reg [7:0]     d01,d11,d21,d31,d41,d51,d61,d71;//high  values  disparity_1
 reg [7:0]     d02,d12,d22,d32,d42,d52,d62,d72;//high  values  disparity_2
 reg [7:0]     d03,d13,d23,d33,d43,d53,d63,d73;//high  values  disparity_3
 
  reg [7:0]     d04,d14,d24,d34,d44,d54,d64,d74;      //high values disparity_4
  reg [7:0]     d05,d15,d25,d35,d45,d55,d65,d75;//high values disparity_5
  reg [7:0]     d06,d16,d26,d36,d46,d56,d66,d76;//high values disparity_6
  reg [7:0]     d07,d17,d27,d37,d47,d57,d67,d77;//high values disparity_7
  
/*************************************************************************************/
 
MIN_8_bytes MIN(.clk(clock),.in_0(sum_d0),.in_1(sum_d1),.in_2(sum_d2),.in_3(sum_d3),.in_4(sum_d4),.in_5(sum_d5),.in_6(sum_d6),.in_7(sum_d7),.out_(min_value_new));

/************************************************************************************/

always@(posedge clock or negedge reset_n) begin :fsm //this state machine computes the v-disparity image it computes 8 disparities every time


 //log=$fopen("/afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/matlab/image_rect_matlab/image_rect_matlab/log.txt","a");   

    if(~reset_n)
        mem_state<= IDLE_STATE;
        
    else begin
    
        casex(mem_state)

        
            IDLE_CASE:begin //1
                    mem_state<= (en_fsm)?CYCLE2_STATE:IDLE_STATE; // the state machine starts if enabled
                    disparity      <=7'b0;
                    addr_r_left    <=0;
                    addr_r_right   <=0;            
                    SUM_HIGH         <=0;
                    SUM_LOW          <=0; 
                    difference_d0       <=32'hff_ff_ff_ff; 
                    difference_d1       <=32'hff_ff_ff_ff;
                    difference_d2       <=32'hff_ff_ff_ff; 
                    difference_d3       <=32'hff_ff_ff_ff;  
                    difference_d4       <=32'hff_ff_ff_ff; 
                    difference_d5       <=32'hff_ff_ff_ff;
                    difference_d6       <=32'hff_ff_ff_ff; 
                    difference_d7       <=32'hff_ff_ff_ff;  
                    ///////////////////////////////////////////////////////////
                    SUM_HIGH         <=0;////////these values serve to store the sums of disparties 
                    SUM_LOW          <=0;                         
                    SUM_HIGH_1       <=0;
                    SUM_LOW_1        <=0; 
                    SUM_HIGH_2       <=0;
                    SUM_LOW_2        <=0; 
                    SUM_HIGH_3       <=0;
                    SUM_LOW_3        <=0;               
                    SUM_HIGH_4       <=0;
                    SUM_LOW_4        <=0; 
                    SUM_HIGH_5       <=0;
                    SUM_LOW_5        <=0; 
                    SUM_HIGH_6       <=0;
                    SUM_LOW_6        <=0;
                    SUM_HIGH_7       <=0;
                    SUM_LOW_7        <=0; 
                    
                    cnt_d0           <=0;// disparity counter
                    cnt_d1           <=1;
                    cnt_d2           <=2;
                    cnt_d3           <=3;
                    cnt_d4           <=4;
                    cnt_d5           <=5;
                    cnt_d6           <=6;
                    cnt_d7           <=7;
                    min_value_r<=32'hff_ff_ff_ff; //initialize the min value
//                    min_value_r_old<=32'hff_ff_ff_ff;                          
            end
            CYCLE1_CASE: begin//2 // thhis state is not active but it can be included if so uncomment the read enable and comment it in the next state
	            mem_state<= CYCLE2_STATE;
//                    read_en_r<=1'b1;
//                    difference_d0       <=0; 
//                    difference_d1       <=0;
//                    difference_d2       <=0; 
//                    difference_d3       <=0; 
//                      read_en_r<=1'b1;//enable reading
     
            end  
	    CYCLE2_CASE: begin//4 // start reading from the buffers and selecting the max and min values
                          mem_state<= CYCLE3_STATE;  
                          read_en_r<=1'b1;//enable reading
                          /////////////////////////////    compute low values for disparity 7
                          d1_7<=(w0_<x1_)?(w0_):(x1_);
                          d2_7<=(w1_<x2_)?(w1_):(x2_);
                          d3_7<=(w2_<x3_)?(w2_):(x3_);
                          d4_7<=(w3_<x4_)?(w3_):(x4_);
                          d5_7<=(w4_<x5_)?(w4_):(x5_);
                          d6_7<=(w5_<x6_)?(w5_):(x6_);
                          d7_7<=(w6_<x7_)?(w6_):(x7_);
                          //////////////////////////////// compute high values for disparity 7
                          d17<=(w0_<x1_)?(x1_):(w0_);
                          d27<=(w1_<x2_)?(x2_):(w1_);
                          d37<=(w2_<x3_)?(x3_):(w2_);
                          d47<=(w3_<x4_)?(x4_):(w3_);
                          d57<=(w4_<x5_)?(x5_):(w4_);
                          d67<=(w5_<x6_)?(x6_):(w5_);
                          d77<=(w6_<x7_)?(x7_):(w6_);                                     
                          /////////////////////////////    compute low values for disparity 6
                          d2_6<=(w0_<x2_)?(w0_):(x2_);
                          d3_6<=(w1_<x3_)?(w1_):(x3_);
                          d4_6<=(w2_<x4_)?(w2_):(x4_);
                          d5_6<=(w3_<x5_)?(w3_):(x5_);
                          d6_6<=(w4_<x6_)?(w4_):(x6_);
                          d7_6<=(w5_<x7_)?(w5_):(x7_);
                          //////////////////////////////// compute high values for disparity 6
                          d26<=(w0_<x2_)?(x2_):(w0_);
                          d36<=(w1_<x3_)?(x3_):(w1_);
                          d46<=(w2_<x4_)?(x4_):(w2_);
                          d56<=(w3_<x5_)?(x5_):(w3_);
                          d66<=(w4_<x6_)?(x6_):(w4_);
                          d76<=(w5_<x7_)?(x7_):(w5_);                                     
                          /////////////////////////////    compute low values for disparity 5
                          d3_5<=(w0_<x3_)?(w0_):(x3_);
                          d4_5<=(w1_<x4_)?(w1_):(x4_);
                          d5_5<=(w2_<x5_)?(w2_):(x5_);
                          d6_5<=(w3_<x6_)?(w3_):(x6_);
                          d7_5<=(w4_<x7_)?(w4_):(x7_);
                          //////////////////////////////// compute high values for disparity 5
                          d35<=(w0_<x3_)?(x3_):(w0_);
                          d45<=(w1_<x4_)?(x4_):(w1_);
                          d55<=(w2_<x5_)?(x5_):(w2_);
                          d65<=(w3_<x6_)?(x6_):(w3_);
                          d75<=(w4_<x7_)?(x7_):(w4_);                                     
                          /////////////////////////////    compute low values for disparity 4
                          d4_4<=(w0_<x4_)?(w0_):(x4_);
                          d5_4<=(w1_<x5_)?(w1_):(x5_);
                          d6_4<=(w2_<x6_)?(w2_):(x6_);
                          d7_4<=(w3_<x7_)?(w3_):(x7_);
                          //////////////////////////////// compute high values for disparity 4
                          d44<=(w0_<x4_)?(x4_):(w0_);
                          d54<=(w1_<x5_)?(x5_):(w1_);
                          d64<=(w2_<x6_)?(x6_):(w2_);
                          d74<=(w3_<x7_)?(x7_):(w3_);                                     
                          /////////////////////////////    compute low values for disparity 3
                          d5_3<=(w0_<x5_)?(w0_):(x5_);
                          d6_3<=(w1_<x6_)?(w1_):(x6_);
                          d7_3<=(w2_<x7_)?(w2_):(x7_);
                          //////////////////////////////// compute high values for disparity 3
                          d53<=(w0_<x5_)?(x5_):(w0_);
                          d63<=(w1_<x6_)?(x6_):(w1_);
                          d73<=(w2_<x7_)?(x7_):(w2_);                                     
                          /////////////////////////////    compute low values for disparity 2
                          d6_2<=(w0_<x6_)?(w0_):(x6_);
                          d7_2<=(w1_<x7_)?(w1_):(x7_);
                          //////////////////////////////// compute high values for disparity 2
                          d62<=(w0_<x6_)?(x6_):(w0_);
                          d72<=(w1_<x7_)?(x7_):(w1_);                                     
                          /////////////////////////////    compute low values for disparity 1
                          d7_1<=(w0_<x7_)?(w0_):(x7_);
                          //////////////////////////////// compute high values for disparity 1
                          d71<=(w0_<x7_)?(x7_):(w0_);                                     

                                             
                                             
                                              
                                             if(addr_r_right == 0) begin
                                              /////////////////////////////////////////// purge all registers new restart
                                                d0_<=0; d1_<=0; d2_<=0; d3_<=0;d4_<=0; d5_<=0; d6_<=0; d7_<=0;//small values disparity_0
                                                d0_1<=0;d1_1<=0;d2_1<=0;d3_1<=0;d4_1<=0;d5_1<=0;d6_1<=0;d7_1<=0;//small values disparity_1
                                                d0_2<=0;d1_2<=0;d2_2<=0;d3_2<=0;d4_2<=0;d5_2<=0;d6_2<=0;d7_2<=0;//small values disparity_2
                                                d0_3<=0;d1_3<=0;d2_3<=0;d3_3<=0; d4_3<=0;d5_3<=0;d6_3<=0;d7_3<=0;//small values disparity_3
                                                
                                                d0_4<=0; d1_4<=0; d2_4<=0; d3_4<=0;d4_4<=0; d5_4<=0; d6_4<=0; d7_4<=0;//small values disparity_4
                                                d0_5<=0;d1_5<=0;d2_5<=0;d3_5<=0;d4_5<=0;d5_5<=0;d6_5<=0;d7_5<=0;//small values disparity_5
                                                d0_6<=0;d1_6<=0;d2_6<=0;d3_6<=0;d4_6<=0;d5_6<=0;d6_6<=0;d7_6<=0;//small values disparity_6
                                                d0_7<=0;d1_7<=0;d2_7<=0;d3_7<=0; d4_7<=0;d5_7<=0;d6_7<=0;d7_7<=0;//small values disparity_7
                                                  
                                                /***********************************************************************************************/
                                                d0 <=0; d1<=0; d2<=0; d3<=0; d4<=0; d5<=0; d6<=0; d7<=0;//small values disparity_0
                                                d01<=0;d11<=0;d21<=0;d31<=0;d41<=0;d51<=0;d61<=0; d71<=0;//small values disparity_1
                                                d02<=0;d12<=0;d22<=0;d32<=0;d42<=0;d52<=0;d62<=0; d72<=0;//small values disparity_2
                                                d03<=0;d13<=0;d23<=0;d33<=0; d43<=0;d53<=0;d63<=0;d73<=0;//small values disparity_3
                                                
                                                d04<=0; d14<=0; d24<=0; d34<=0;d44<=0; d54<=0; d64<=0; d74<=0;//small values disparity_4
                                                d05<=0;d15<=0;d25<=0;d35<=0;d45<=0;d55<=0;d65<=0;d75<=0;//small values disparity_5
                                                d06<=0;d16<=0;d26<=0;d36<=0;d46<=0;d56<=0;d66<=0;d76<=0;//small values disparity_6
                                                d07<=0;d17<=0;d27<=0;d37<=0; d47<=0;d57<=0;d67<=0;d77<=0;//small values disparity_7
                                                              
                                             
                                             
                                             end                    




       			 end
            CYCLE3_CASE: begin//8
//                        //////////////////////////////////////////// disparity 0
                         // the following operations serve to sum the high values and the low values in parallel 
                        //////////////////////////////////////////// disparity 0
                        mem_state<=CYCLE4_STATE; 
                        //////////////////////////////////////////  disparity 1
                        SUM_LOW_1 <=SUM_LOW_1+d7_1;                                                      
                        SUM_HIGH_1<=SUM_HIGH_1+d71;
                        //////////////////////////////////////////  disparity 2
                        SUM_LOW_2 <=SUM_LOW_2+d6_2+d7_2;                                                      
                        SUM_HIGH_2<=SUM_HIGH_2+d62+d72;
                        //////////////////////////////////////////  disparity 3
                        SUM_LOW_3 <=SUM_LOW_3+d5_3+d6_3+d7_3;                                                      
                        SUM_HIGH_3<=SUM_HIGH_3+d53+d63+d73;
                        //////////////////////////////////////////  disparity 4
                        SUM_LOW_4 <=SUM_LOW_4+d4_4+d5_4+d6_4+d7_4;                                                      
                        SUM_HIGH_4<=SUM_HIGH_4+d44+d54+d64+d74;                        
                          //////////////////////////////////////////  disparity 5
                        SUM_LOW_5 <=SUM_LOW_5+d3_5+d4_5+d5_5+d6_5+d7_5;                                                  
                        SUM_HIGH_5<=SUM_HIGH_5+d35+d45+d55+d65+d75;                      
                          //////////////////////////////////////////  disparity 6
                        SUM_LOW_6 <=SUM_LOW_6+d2_6+d3_6+d4_6+d5_6+d6_6+d7_6;                                                      
                        SUM_HIGH_6<=SUM_HIGH_6+d26+d36+d46+d56+d66+d76;                      
                          //////////////////////////////////////////  disparity 7
                        SUM_LOW_7 <=SUM_LOW_7+d1_7+d2_7+d3_7+d4_7+d5_7+d6_7+d7_7;                                                      
                        SUM_HIGH_7<=SUM_HIGH_7+d17+d27+d37+d47+d57+d67+d77;                       

                        ////////////////////////////////////////// increment the left address                             
                        addr_r_left<=addr_r_left+1;
                        
			
                    

            end
            CYCLE4_CASE: begin//16 // this cycle is inserted to wait for the data to be ready from the block ram 
			                          mem_state  <=  CYCLE5_STATE;
//			                          addr_r_left<=addr_r_left+1;
//			                          addr_r_right<=addr_r_right+1;

                         end
             
             
            CYCLE5_CASE: begin//32
            
                        mem_state  <=  CYCLE6_STATE;
                        ////////////////////////////     compute low values for disparity 0
                        d0_<=(w0_<x0_)?(w0_):(x0_);
                        d1_<=(w1_<x1_)?(w1_):(x1_);
                        d2_<=(w2_<x2_)?(w2_):(x2_);
                        d3_<=(w3_<x3_)?(w3_):(x3_);
                        d4_<=(w4_<x4_)?(w4_):(x4_);
                        d5_<=(w5_<x5_)?(w5_):(x5_);
                        d6_<=(w6_<x6_)?(w6_):(x6_);
                        d7_<=(w7_<x7_)?(w7_):(x7_);
                        /////////////////////////////    compute high values for disparity 0
                        d0<=(w0_<x0_)?(x0_):(w0_);
                        d1<=(w1_<x1_)?(x1_):(w1_);
                        d2<=(w2_<x2_)?(x2_):(w2_);
                        d3<=(w3_<x3_)?(x3_):(w3_);
                        d4<=(w4_<x4_)?(x4_):(w4_);
                        d5<=(w5_<x5_)?(x5_):(w5_);
                        d6<=(w6_<x6_)?(x6_):(w6_);
                        d7<=(w7_<x7_)?(x7_):(w7_);
                        /////////////////////////////    compute low values for disparity 1
                        d0_1<=(w1_<x0_)?(w1_):(x0_);
                        d1_1<=(w2_<x1_)?(w2_):(x1_);
                        d2_1<=(w3_<x2_)?(w3_):(x2_);
                        d3_1<=(w4_<x3_)?(w4_):(x3_);
                        d4_1<=(w5_<x4_)?(w5_):(x4_);
                        d5_1<=(w6_<x5_)?(w6_):(x5_);
                        d6_1<=(w7_<x6_)?(w7_):(x6_);
                        //////////////////////////////// compute high values for disparity 1
                        d01<=(w1_<x0_)?(x0_):(w1_);
                        d11<=(w2_<x1_)?(x1_):(w2_);
                        d21<=(w3_<x2_)?(x2_):(w3_);
                        d31<=(w4_<x3_)?(x3_):(w4_);
                        d41<=(w5_<x4_)?(x4_):(w5_);
                        d51<=(w6_<x5_)?(x5_):(w6_);
                        d61<=(w7_<x6_)?(x6_):(w7_);
                        //////////////////////////////   compute low values for disparity 2
                        d0_2<=(w2_<x0_)?(w2_):(x0_);
                        d1_2<=(w3_<x1_)?(w3_):(x1_);
                        d2_2<=(w4_<x2_)?(w4_):(x2_);
                        d3_2<=(w5_<x3_)?(w5_):(x3_);
                        d4_2<=(w6_<x4_)?(w6_):(x4_);
                        d5_2<=(w7_<x5_)?(w7_):(x5_);
                        //////////////////////////////   compute high values for disparity 2
                        d02<=(w2_<x0_)?(x0_):(w2_);
                        d12<=(w3_<x1_)?(x1_):(w3_);
                        d22<=(w4_<x2_)?(x2_):(w4_);
                        d32<=(w5_<x3_)?(x3_):(w5_);
                        d42<=(w6_<x4_)?(x4_):(w6_);
                        d52<=(w7_<x5_)?(x5_):(w7_);
                        //////////////////////////////   compute low values for disparity 3              
                        d0_3<=(w3_<x0_)?(w3_):(x0_);
                        d1_3<=(w4_<x1_)?(w4_):(x1_);
                        d2_3<=(w5_<x2_)?(w5_):(x2_);
                        d3_3<=(w6_<x3_)?(w6_):(x3_);
                        d4_3<=(w7_<x4_)?(w7_):(x4_);
                        //////////////////////////////   compute high values for disparity 3              
                        d03<=(w3_<x0_)?(x0_):(w3_);
                        d13<=(w4_<x1_)?(x1_):(w4_);
                        d23<=(w5_<x2_)?(x2_):(w5_);
                        d33<=(w6_<x3_)?(x3_):(w6_);
                        d43<=(w7_<x4_)?(x4_):(w7_);  
                        //////////////////////////////   compute low values for disparity 4   
                        d0_4<=(w4_<x0_)?(w4_):(x0_);
                        d1_4<=(w5_<x1_)?(w5_):(x1_);
                        d2_4<=(w6_<x2_)?(w6_):(x2_);
                        d3_4<=(w7_<x3_)?(w7_):(x3_);
                        //////////////////////////////   compute high values for disparity 4
                        d04<=(w4_<x0_)?(x0_):(w4_);
                        d14<=(w5_<x1_)?(x1_):(w5_);
                        d24<=(w6_<x2_)?(x2_):(w6_);
                        d34<=(w7_<x3_)?(x3_):(w7_);
                        //////////////////////////////   compute low values for disparity 5   
                        d0_5<=(w5_<x0_)?(w5_):(x0_);
                        d1_5<=(w6_<x1_)?(w6_):(x1_);
                        d2_5<=(w7_<x2_)?(w7_):(x2_);
                        //////////////////////////////   compute high values for disparity 5
                        d05<=(w5_<x0_)?(x0_):(w5_);
                        d15<=(w6_<x1_)?(x1_):(w6_);
                        d25<=(w7_<x2_)?(x2_):(w7_);
                        //////////////////////////////   compute low values for disparity 6   
                        d0_6<=(w6_<x0_)?(w6_):(x0_);
                        d1_6<=(w7_<x1_)?(w7_):(x1_);
                        //////////////////////////////   compute high values for disparity 6
                        d06<=(w6_<x0_)?(x0_):(w6_);
                        d16<=(w7_<x1_)?(x1_):(w7_);
                        //////////////////////////////   compute low values for disparity 7   
                        d0_7<=(w7_<x0_)?(w7_):(x0_);
                        //////////////////////////////   compute high values for disparity 7
                        d07<=(w7_<x0_)?(x0_):(w7_);
                        
                                         
                           
                              
            
            end       
           
            CYCLE6_CASE: begin//64
                   	      mem_state   <= (addr_r_left == `IMAGE_WIDTH+1)?CYCLE7_STATE:CYCLE2_STATE;// if the end of buffer is reached compute the difference else kepp summing
                          //////////////////////////////////////////// disparity 0
                         // the following operations serve to sum the high values and the low values in parallel 
                         //////////////////////////////////////////// disparity 0
                         SUM_LOW <=SUM_LOW+d0_+d1_+d2_+d3_+d4_+d5_+d6_+d7_;
                         SUM_HIGH<=SUM_HIGH+d0+d1+d2+d3+d4+d5+d6+d7;
                         //////////////////////////////////////////  disparity 1
                         SUM_LOW_1 <=SUM_LOW_1+d0_1+d1_1+d2_1+d3_1+d4_1+d5_1+d6_1;                                                      
                         SUM_HIGH_1<=SUM_HIGH_1+d01+d11+d21+d31+d41+d51+d61;
                         //////////////////////////////////////////  disparity 2
                         SUM_LOW_2 <=SUM_LOW_2+d0_2+d1_2+d2_2+d3_2+d4_2+d5_2;                                                      
                         SUM_HIGH_2<=SUM_HIGH_2+d02+d12+d22+d32+d42+d52;
                         //////////////////////////////////////////  disparity 3
                         SUM_LOW_3 <=SUM_LOW_3+d0_3+d1_3+d2_3+d3_3+d4_3;                                                      
                         SUM_HIGH_3<=SUM_HIGH_3+d03+d13+d23+d33+d43; 
                         //////////////////////////////////////////////disparity 4
                         SUM_LOW_4 <=SUM_LOW_4+d0_4+d1_4+d2_4+d3_4;                                                      
                         SUM_HIGH_4<=SUM_HIGH_4+d04+d14+d24+d34; 
                         //////////////////////////////////////////////disparity 5
                         SUM_LOW_5 <=SUM_LOW_5+d0_5+d1_5+d2_5;                                                      
                         SUM_HIGH_5<=SUM_HIGH_5+d05+d15+d25; 
                         //////////////////////////////////////////////disparity 6
                         SUM_LOW_6 <=SUM_LOW_6+d0_6+d1_6;                                                      
                         SUM_HIGH_6<=SUM_HIGH_6+d06+d16; 
                         //////////////////////////////////////////////disparity 7
                         SUM_LOW_7 <=SUM_LOW_7+d0_7;                                                      
                         SUM_HIGH_7<=SUM_HIGH_7+d07;                            
                         ////////////////////////////////////////// increment the right address                       
                         addr_r_right<=addr_r_right+1;
                         ////////////////////////////////////////////////////////////////////// 
                         row_finished_r=( addr_r_left == `IMAGE_WIDTH+1 & !row_finished )? 1'b1:1'b0;
                     
            end
            CYCLE7_CASE: begin//128
                        mem_state<=CYCLE8_STATE;
                        
                        difference_d0<={cnt_d0,SUM_HIGH   -SUM_LOW}; // the form of the difference is as folloying {disparity values x coordinate, corresponding cost}
                        difference_d1<={cnt_d1,SUM_HIGH_1 - SUM_LOW_1};
                        difference_d2<={cnt_d2,SUM_HIGH_2 - SUM_LOW_2};
                        difference_d3<={cnt_d3,SUM_HIGH_3 - SUM_LOW_3};
                        difference_d4<={cnt_d4,SUM_HIGH_4 - SUM_LOW_4};
                        difference_d5<={cnt_d5,SUM_HIGH_5 - SUM_LOW_5};
                        difference_d6<={cnt_d6,SUM_HIGH_6 - SUM_LOW_6};
                        difference_d7<={cnt_d7,SUM_HIGH_7 - SUM_LOW_7};
                        ////////////////////////////////////////////////////////////////////////////////////
                        
                       
                       /* min_value_r   <=(min_value_tmp<min_value_old)?min_value_tmp:min_value_old;*/
                        ////////////////////////////////////////////////////////////////////////////////////uncomment the following instructions to write the v-disparity value.
//                        if(disparity !=`MAX_DISPARITY-1)begin
//                            $fwrite(log,"%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d\n",SUM_HIGH-SUM_LOW,SUM_HIGH_1 - SUM_LOW_1,SUM_HIGH_2 - SUM_LOW_2,SUM_HIGH_3 - SUM_LOW_3,SUM_HIGH_4 - SUM_LOW_4,SUM_HIGH_5 - SUM_LOW_5,SUM_HIGH_6 - SUM_LOW_6,SUM_HIGH_7 - SUM_LOW_7);
//                        end
                        disparity<=disparity +1 ;
            end
            CYCLE8_CASE : begin//256 // purge all the sums and start reading from the new disparity
                        mem_state   <= (disparity == `MAX_DISPARITY)?IDLE_STATE:CYCLE2_STATE;
                        read_en_r<=1'b0;
                        addr_r_right<=0;// reinitialize to start the new computations
                        addr_r_left<=disparity; // shift to read starting from the new disparity 
                        //////////////////////////////////////////// disparity 0
                        SUM_LOW <=0;
                        SUM_HIGH<=0;
                        //////////////////////////////////////////  disparity 1
                        SUM_LOW_1 <=0;                                                      
                        SUM_HIGH_1<=0;
                        //////////////////////////////////////////  disparity 2
                        SUM_LOW_2 <=0;                                                      
                        SUM_HIGH_2<=0;
                        //////////////////////////////////////////  disparity 3
                        SUM_LOW_3 <=0;                                                      
                        SUM_HIGH_3<=0; 
                        //////////////////////////////////////////// disparity 4
                        SUM_LOW_4<=0;
                        SUM_HIGH_4<=0;
                        //////////////////////////////////////////  disparity 5
                        SUM_LOW_5 <=0;                                                      
                        SUM_HIGH_5<=0;
                        //////////////////////////////////////////  disparity 6
                        SUM_LOW_6 <=0;                                                      
                        SUM_HIGH_6<=0;
                        //////////////////////////////////////////  disparity 7
                        SUM_LOW_7 <=0;                                                      
                        SUM_HIGH_7<=0; 
                        ///////////////////////////////////////////////////////////////////////////////
                        min_value_r    <=(min_value_new[23:0]<min_value_r[23:0])?min_value_new:min_value_r;
//                        min_value_r_old<=(min_value_new[23:0]<min_value_r_old[23:0])?min_value_new:min_value_r_old;
                        //////////////////////////////////////////////////////////////////////////////     
                        cnt_d0 <=cnt_d0 + 8;
                        cnt_d1 <=cnt_d1 + 8;
                        cnt_d2 <=cnt_d2 + 8;
                        cnt_d3 <=cnt_d3 + 8;
                        cnt_d4 <=cnt_d4 + 8;
                        cnt_d5 <=cnt_d5 + 8;
                        cnt_d6 <=cnt_d6 + 8;
                        cnt_d7 <=cnt_d7 + 8;

            end
          default:
                      mem_state   <= IDLE_STATE;
         endcase
     end
end

//always@(posedge clock) begin
//             if(en_fsm)begin
//                       i=i+1;
//                       if(row_finished)begin
                       
//                            $display("total number of clocks seen is %d ",i); 
//                       end
//                       end


//end
assign row_finished=(disparity == `MAX_DISPARITY-1)?1'b1:1'b0;
assign addr_left=addr_r_left;
assign addr_right=addr_r_right;
assign read_en=read_en_r;
assign sum_d0=difference_d0;
assign sum_d1=difference_d1;
assign sum_d2=difference_d2;
assign sum_d3=difference_d3;
assign sum_d4=difference_d4;
assign sum_d5=difference_d5;
assign sum_d6=difference_d6;
assign sum_d7=difference_d7;
assign min_value=min_value_r;
assign d_av=row_finished_r;
endmodule