`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/23/2016 11:59:54 PM
// Design Name: 
// Module Name: READ_FILE_BRAM
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
//////////////////////////////////////////////////////////////////////////////////This module gives an interface to the Bram blocks (right and left buffers )memory 


module READ_FILE_BRAM(

            
  
            input   clk,
            input           en_write,
            input  [6 : 0]  data_in_adr,
            input  [63 : 0] data_in_left,
            input  [63 : 0] data_in_right,
            input           en_read,
            
            input  [6 : 0]  data_out_adr_left,
            input  [6 : 0]  data_out_adr_right,
            
            output [63 : 0] data_out_left,
            output [63 : 0] data_out_right    
   ); 

BUFFER_ROW BUFFER_LEFT(
      //port A write
      .clka(clk),            // input wire clka
      .wea(en_write),     // input wire [0 : 0] wea
      .addra(data_in_adr),     // input wire [15 : 0] addra
      .dina(data_in_left),      // input wire [7 : 0] dina
    //port B read
      .clkb(clk),            // input wire clkb
      .enb(en_read),      // input wire enb
      .addrb(data_out_adr_left),      // input wire [15 : 0] addrb
      .doutb(data_out_left)       // output wire [7 : 0] doutb
    );
    
BUFFER_ROW BUFFER_RIGHT(
          //port A write
          .clka(clk),            // input wire clka
          .wea(en_write),     // input wire [0 : 0] wea
          .addra(data_in_adr),     // input wire [15 : 0] addra
          .dina(data_in_right),      // input wire [7 : 0] dina
        //port B read
          .clkb(clk),            // input wire clkb
          .enb(en_read),      // input wire enb
          .addrb(data_out_adr_right),      // input wire [15 : 0] addrb
          .doutb(data_out_right)       // output wire [7 : 0] doutb
        );   
    
endmodule
