`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2016 03:07:01 PM
// Design Name: 
// Module Name: STORE_V_DISPARITY
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


module STORE_V_DISPARITY(

                    input wire            clk,
                    input wire            reset_n,
                    input wire [31:0]     sum_d0,
                    input wire [31:0]     sum_d1,
                    input wire [31:0]     sum_d2,
                    input wire [31:0]     sum_d3,
                    input wire [31:0]     sum_d4,
                    input wire [31:0]     sum_d5,
                    input wire [31:0]     sum_d6,
                    input wire [31:0]     sum_d7,
                    input wire [31:0]     min_value,
                    input wire            d_av,
                    input  wire           row_finished,
                    ///////////////////////////////////////
                    output wire [7:0]     min_value_disparity_1,
                    output wire [7:0]     min_value_disparity_2,
                    output wire [7:0]     min_value_disparity_3,
                    output wire           selection_finished
                     ); 



reg          [7:0]   address_in;
//reg                write_enable;
reg                  read_enable;
reg          [31:0]  data_in;
reg          [7:0]   address_out;
reg                  en_fsm;
reg                  en_fsm_m2;
wire         [31:0]  data_out;
reg          [31:0]  data_received [7:0];//data received from disparity state machine
reg          [3:0]   cnt;
reg                  d_av_last;
reg                  write_en_r;
reg          [23:0]  cmp_tmp_h;  
reg          [23:0]  cmp_tmp_l;    
reg          [31:0]  array_min_values [2:0]; 
reg                  selection_finished_reg;
//////////////////////////////////////////////////////////////////////////
reg [4:0]    mem_state;
reg [31:0]   min_value_r;
//PARAMETERS
parameter [4:0]            //machine states
          IDLE_STATE       =5'b00001,
          CYCLE1_STATE     =5'b00010,
          CYCLE2_STATE     =5'b00100,
          CYCLE3_STATE     =5'b01000,
          CYCLE4_STATE     =5'b10000;
parameter [4:0]            //cases
          IDLE_CASE       =5'bxxxx1,
          CYCLE1_CASE     =5'bxxx1x,
          CYCLE2_CASE     =5'bxx1xx,
          CYCLE3_CASE     =5'bx1xxx,
          CYCLE4_CASE     =5'b1xxxx;
////////////////////////////////////////////////////////////////////////////////
integer log;
//////////////////////////////////////////////////////////////////////////////         
always@(posedge clk or negedge reset_n) begin :fsm_memorize_disparities //this part responsible for storing the vßdisparity values to bram.
     
              if(~reset_n)begin
                            mem_state<= IDLE_STATE;
                           end
              else begin
              
                  casex(mem_state)
          
                  
                      IDLE_CASE:begin //1
                          mem_state<=(en_fsm==1'b1)?CYCLE1_STATE:IDLE_STATE;            //en_fsm only in this module.          
                          cnt<=0;  
                          en_fsm_m2<=1'b0;
                                 end
                      CYCLE1_CASE:begin//2// start writing to the memory write_enable=1 see block below,
                          mem_state<=CYCLE2_STATE;
  
                      end
                      CYCLE2_CASE:begin//4
                                  mem_state<=CYCLE3_STATE;
                                          
                                  end
                      CYCLE3_CASE:begin//8

                           if     (address_in==128)  begin mem_state<=IDLE_STATE;  en_fsm_m2<=1'b1;   end// if all disparities are stored start selecting the min values by asserting en_fsm_m2
                           else   if(cnt==7)         begin mem_state<=CYCLE4_STATE; end // when the disparities is written go and wait for the next disparities to be ready
                           else                      begin mem_state<=CYCLE1_STATE; end    // else keep writing
                           cnt<=cnt+1;
                      end
                      CYCLE4_CASE:begin//16 // wait for the disparities to be ready
                              mem_state<=(en_fsm==1'b0)?CYCLE4_STATE:CYCLE1_STATE;
                              cnt<=0;
                              end
                      default:
                       mem_state<=IDLE_STATE;
                  endcase
               end
end   
                  
//////////////////////////////////////////////////////////////////////////    
// this block receives the disparity value in parrallel and store them into one array it starts the finite state machine also
always@(posedge clk)begin
             d_av_last<=d_av;
            if({d_av_last,d_av}==2'b10 )begin   //disparity available
                        en_fsm<=1'b1;// start storage   
                        data_received[0]<=sum_d0;
                        data_received[1]<=sum_d1;
                        data_received[2]<=sum_d2;
                        data_received[3]<=sum_d3;
                        data_received[4]<=sum_d4;
                        data_received[5]<=sum_d5;
                        data_received[6]<=sum_d6;
                        data_received[7]<=sum_d7;
            end
            else //if(mem_state==CYCLE1_STATE)begin
            
                  en_fsm<=1'b0;
            


end
//////////////////////////////////////////////////////////////////////////////
/// this block controls writing and increments the address for the state machine fsm_memorize_disparities
always@(posedge clk)begin

            min_value_r<= min_value;
            if(write_en_r)begin
            
                     address_in<=  address_in+8'b0000_0001;
                     write_en_r<=1 'b0;
            end
            else if (mem_state==IDLE_STATE)begin
                    address_in<=8'b0000_0000;
            
            end
            else if(mem_state==CYCLE1_STATE)begin
                     write_en_r<=1'b1;
            
            end
            
end
//////////////////////////////////////////////////////////////////////////////////////////////
// block memory for storing the disparities
STORE_DISPARITY_IMAGE  STORE_V_DISPARITY(
      //port A write
      .clka(clk),            // input wire clka
      .wea(write_en_r),     // input wire [0 : 0] wea
      .addra(address_in),     // input wire [15 : 0] addra
      .dina(data_received[cnt]),      // input wire [7 : 0] dina
    //port B read
      .clkb(clk),            // input wire clkb
      .enb(read_enable),      // input wire enb
      .addrb(address_out),      // input wire [15 : 0] addrb
      .doutb(data_out)       // output wire [7 : 0] doutb
);
////////////////////////////////////////////////////////////////////////////////////////////
//---FSM to select min values

reg [4:0]    mem_state_m2;
//PARAMETERS
parameter [4:0]            //machine states
          IDLE_STATE_m2       =5'b00001,
          CYCLE1_STATE_m2     =5'b00010,
          CYCLE2_STATE_m2     =5'b00100,
          CYCLE3_STATE_m2     =5'b01000,
          CYCLE4_STATE_m2     =5'b10000;
parameter [4:0]            //cases
          IDLE_CASE_m2       =5'bxxxx1,
          CYCLE1_CASE_m2     =5'bxxx1x,
          CYCLE2_CASE_m2     =5'bxx1xx,
          CYCLE3_CASE_m2     =5'bx1xxx,
          CYCLE4_CASE_m2     =5'b1xxxx;
/////////////////////////////////////////////////////////////////////////////////////////
       
          
always@(posedge clk or negedge reset_n) begin :fsm_select_min_values
              //log=$fopen("/afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/matlab/image_rect_matlab/image_rect_matlab/disparity_values.txt","a");  
              if(~reset_n)begin
                            mem_state_m2<= IDLE_STATE_m2;
                            array_min_values[0]<= 32'b0; 
                            array_min_values[1]<= 32'b0;
                            array_min_values[2]<= 32'b0;  
                            read_enable<=1'b0; 

                           end
              else begin
              
                  casex(mem_state_m2)
          
                  
                      IDLE_CASE_m2:begin //1
                                   mem_state_m2<=(en_fsm_m2==1'b1)?CYCLE1_STATE_m2: IDLE_STATE_m2; 
                                   address_out<=8'b0;
                                   cmp_tmp_h<=min_value[23:0]+100;// he threshold  of selecting the disparity is 100 
//                                   cmp_tmp_l<=min_value[23:0]-1000;
//                                   en_fsm_m2<=1'b0;
                                   read_enable<=1'b0;
                                    selection_finished_reg = 1'b0;
                                 end
                      CYCLE1_CASE_m2:begin//2// Start reading from the buffer 
                                    mem_state_m2<=CYCLE2_STATE_m2;    
                                    read_enable<=1'b1;

                      end
                      CYCLE2_CASE_m2:begin//4
                                    mem_state_m2<=CYCLE3_STATE_m2; 
                                          
                                  end
                      CYCLE3_CASE_m2:begin//8
                                  
//                                  mem_state_m2<=(address_out == 127 )?IDLE_STATE_m2:CYCLE1_STATE_m2;
                                  if(address_out == 127 )begin
                                                mem_state_m2<=IDLE_STATE_m2;
                                                selection_finished_reg = 1'b1;
                                                
                                  end
                                  else begin
                                                mem_state_m2<=CYCLE1_STATE_m2;
                                  end
                                 if(data_out[23:0]<=cmp_tmp_h && data_out[23:0] != 32'b0)begin// shift the min value into the the storing register if it is in the required range
                                           array_min_values[0]<= data_out; 
                                           array_min_values[1]<= array_min_values[0];
                                           array_min_values[2]<= array_min_values[1];  
 
                                  end
//                                  if(address_out == 127)begin // this instruction writes the min values to a file
//                                    $fwrite(log,"%d\n%d\n%d\n",array_min_values[0][31:24],array_min_values[1][31:24],array_min_values[2][31:24]);
//                                  end
                                  address_out<=address_out+1;
                                   

                      end
                      CYCLE4_CASE_m2:begin//16
                      
                      
                      end
   
                      default:
                       mem_state_m2<=IDLE_STATE_m2;
                  endcase
               end
end   
                  
////////////////////////////////////////////////////////////////////////// 
// this module gives at last the disparities corresponding to the min values. It is the x coordinate of the min point
assign min_value_disparity_1=array_min_values[0][31:24];
assign min_value_disparity_2=array_min_values[1][31:24];
assign min_value_disparity_3=array_min_values[2][31:24];
assign selection_finished   =selection_finished_reg;
endmodule
