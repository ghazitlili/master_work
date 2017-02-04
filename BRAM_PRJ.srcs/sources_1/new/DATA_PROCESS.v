`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/28/2016 02:59:17 PM
// Design Name: 
// Module Name: TOP
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


module DATA_PROCESS(
           input wire reset,
           input wire clk,
           input wire       en_write,
           input wire [6:0] data_in_adr,
           
           input wire [63:0] data_in_left,
           input wire [63:0] data_in_right,
           
           input wire       en_fsm,
           
           output wire [31:0] sum_d0,
           output wire [31:0] sum_d1,
           output wire [31:0] sum_d2,
           output wire [31:0] sum_d3,
           output wire [31:0] sum_d4,
           output wire [31:0] sum_d5,
           output wire [31:0] sum_d6,
           output wire [31:0] sum_d7,
           output wire [31:0] min_value,
           output wire        d_av,
           output wire        row_finished       

    );
    
wire en_read;

wire [9:0] data_out_adr_left;
wire [9:0] data_out_adr_right;

wire [63:0] data_out_left;
wire [63:0] data_out_right;  
    
    READ_FILE_BRAM MEM(
    
                .clk(clk),
                .en_write(en_write),
                .data_in_adr(data_in_adr),
                .data_in_left(data_in_left),
                .data_in_right(data_in_right),
                .en_read(en_read),
                
                .data_out_adr_left(data_out_adr_left),
                .data_out_adr_right(data_out_adr_right),
                
                .data_out_left(data_out_left),
                .data_out_right(data_out_right)    
    
    );
    
    statem     FSM(
                //input declaration
                .clock(clk),
    
                .reset_n(reset),
                
                .en_fsm(en_fsm),
    
                .data_left(data_out_left),
    
                .data_right(data_out_right),
    
                 //output declaration
                .sum_d0(sum_d0),
                 .sum_d1(sum_d1),
                  .sum_d2(sum_d2),
                   .sum_d3(sum_d3),
                .sum_d4(sum_d4),
                    .sum_d5(sum_d5),
                     .sum_d6(sum_d6),
                      .sum_d7(sum_d7),                   
    
                .read_en(en_read),
    
                .addr_left(data_out_adr_left),
                .addr_right(data_out_adr_right),
                
     
                .row_finished(row_finished),
                
                .min_value(min_value),
                .d_av(d_av)

    
    
    
    );

endmodule
