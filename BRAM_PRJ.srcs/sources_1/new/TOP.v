`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: C3e
// Engineer: Ghazi Abbassi
// 
// Create Date: 07/26/2016 05:48:29 PM
// Design Name: 
// Module Name: TOP
// Project Name: Ground detection module
// Target Devices: Zynq Board
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 

module TOP(
           input wire reset,
           input wire clk,
           input wire       data_available,
           
           input wire [63:0] data_in_left,
           input wire [63:0] data_in_right,
           /////////////////////////////////////////////////////////////////////////
           output wire       data_ack, 
           output wire [63:0] min_value_disparity_1_row,
           output wire        enable_axi_interface
//           output wire [15:0] min_value_disparity_2_row,
//           output wire [15:0] min_value_disparity_3_row

    );

    /////////////////////////////////////////////////////////////////////
    wire [31:0] sum_d0;
    wire [31:0] sum_d1;
    wire [31:0] sum_d2;
    wire [31:0] sum_d3;
    wire [31:0] sum_d4;
    wire [31:0] sum_d5;
    wire [31:0] sum_d6;
    wire [31:0] sum_d7;
    wire [31:0] min_value;  
    wire        row_finished; 
    wire        selection_finished;
    reg        selection_finished_reg;
    reg [15:0] min_value_disparity_1_w; 
    reg [15:0] min_value_disparity_2_w; 
    reg [15:0] min_value_disparity_3_w; 
    wire [7:0] min_value_disparity_1;
    wire [7:0] min_value_disparity_2;
    wire [7:0] min_value_disparity_3;
    reg         row_finished_r_last;
    reg         EDGE;
    
//////////////////////////////////////////////////////////////////////////////////
    reg [4:0]    mem_state;
    reg          data_available_reg;
    reg          data_ack_reg;
    reg [6:0]    data_in_adr; 
    reg          en_write; 
    reg [7:0]    rows_reg; 
    reg          en_fsm;
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
    ///////////////////////////////////////////////////////////////////////////////////
    always@(posedge clk or negedge reset) begin :fsm_get_data// this state machine stores the data into the right and left buffers it is related directly to MEM-READ_FILE_BRAM
         
                  if(~reset)begin
                                mem_state<= IDLE_STATE;
                                data_in_adr<=7'b0000_000;
                                en_write<=1'b0;
                                en_fsm<=1'b0;
                                rows_reg<=0;
                               end
                  else begin
                  
                      casex(mem_state)
              
                      
                          IDLE_CASE:begin //1
                                    mem_state<=(data_available == 1'b1 )?CYCLE1_STATE:IDLE_STATE;// the stqte mqchine stqrts running when the data is available
                                    
                                    
                                     end
                          CYCLE1_CASE:begin//2
                                    
                                    if     (data_in_adr ==80/*because we have 640 bytes divided by 8 bytes for each chunk of data */) begin    mem_state<=CYCLE3_STATE;data_in_adr<=8'b0000_000;en_write<=1'b0;en_fsm<=1'b1;end// when the state machine finishes buffering the data it starts the v-disparity image processing
                                    else if(rows_reg == 240/*because we have 240 rows*/)  begin    mem_state<= IDLE_STATE; data_in_adr<=8'b0000_000;end  // when the state machine ends writing all the rows it stops  
                                    else                      begin    mem_state<=CYCLE2_STATE;en_write<=1'b1;end         // continue writing
                                    data_ack_reg<=1'b0; 
                          end
                          CYCLE2_CASE:begin//4
                                   mem_state<=CYCLE1_STATE;  
                                   data_in_adr<=data_in_adr+8'b0000_001; // increment the address
                                   en_write<=1'b0;
                                   data_ack_reg<=1'b1;//acknowledge the  data           
                                      end
                          CYCLE3_CASE:begin//8
                                   if(~EDGE) mem_state<=CYCLE3_STATE;
                                   else begin mem_state<=CYCLE1_STATE;en_fsm<=1'b0/* command for the v-disparity compurtation state machine*/ ;rows_reg<=rows_reg+1;end // when processing the last row is finished start a new one
                                   en_fsm<=1'b0;
                                   
                               
                          end
                          CYCLE4_CASE:begin//16
                          
                          end
                                  
                          default:
                           mem_state<=IDLE_STATE;
                      endcase
                   end
    end 
///////////////////////////////////////////////////////////////////////////////////    
 always@(posedge clk)begin
        row_finished_r_last<=  row_finished;
        if({row_finished_r_last,row_finished}==2'b10)   begin
        
                       
                      EDGE<=1'b1;//detect the ending of processing of  the last row
        
//                    en_fsm<=1'b1;en_write=4'b0000;
        
        end 
        else begin
                      EDGE<=1'b0;
//                     en_fsm<=1'b0;en_write=4'b1111;

        end 

end    
/////////////////////////////////////////////////////////////////////////////////////////
/*Block for arranging the min values */  
always@(posedge clk)begin
selection_finished_reg <= selection_finished;
if(selection_finished_reg==1'b1)begin
min_value_disparity_1_w = {rows_reg,min_value_disparity_1};
min_value_disparity_2_w = {rows_reg,min_value_disparity_2};
min_value_disparity_3_w = {rows_reg,min_value_disparity_3};
end
end   
///////////////////////////////////////////////////////////////////////////////////////    wiring with the Processing module and the v_disparity computation module
DATA_PROCESS M1(
           .reset(reset),//input
           .clk(clk),//input
           .en_write(en_write),//input
           .data_in_adr(data_in_adr),//input
           
           .data_in_left(data_in_left),//input
           .data_in_right(data_in_right),//input
           
           .en_fsm(en_fsm),//input
           
           .sum_d0(sum_d0),//output-input
           .sum_d1(sum_d1),//output-input
           .sum_d2(sum_d2),//output-input
           .sum_d3(sum_d3),//output-input
           .sum_d4(sum_d4),//output-input
           .sum_d5(sum_d5),//output-input
           .sum_d6(sum_d6),//output-input
           .sum_d7(sum_d7),//output-input
           .min_value(min_value),//output-input
           .d_av(d_av),//output-input
           .row_finished(row_finished) //output-input 

);  
STORE_V_DISPARITY M2(

             .clk(clk),//input
             .reset_n(reset),//input
             .sum_d0(sum_d0),//input-output
             .sum_d1(sum_d1),//input-output
             .sum_d2(sum_d2),//input-output
             .sum_d3(sum_d3),//input-output
             .sum_d4(sum_d4),//input-output
             .sum_d5(sum_d5),//input-output
             .sum_d6(sum_d6),//input-output
             .sum_d7(sum_d7),//input-output
             .min_value(min_value),//input-output
             .d_av(d_av),//input-output
             .row_finished(row_finished),//input-output
             .min_value_disparity_1(min_value_disparity_1),//output
             .min_value_disparity_2(min_value_disparity_2),//output
             .min_value_disparity_3(min_value_disparity_3),
             .selection_finished(selection_finished)//output
);
assign  data_ack=data_ack_reg;
assign  min_value_disparity_1_row={{16{1'b0}},min_value_disparity_1_w,min_value_disparity_2_w,min_value_disparity_3_w};
assign  enable_axi_interface     = selection_finished_reg;
//assign  min_value_disparity_2_row=min_value_disparity_2_w;
//assign  min_value_disparity_3_row=min_value_disparity_3_w;
endmodule
