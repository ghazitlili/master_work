`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: c3e
// Engineer: qin
// 
// Create Date: 05/24/2016 11:20:50 AM
// Design Name: 
// Module Name: tb_bram
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


module tb_bram;
reg sclk;
reg [3:0]  write_enable;
reg [15:0] write_addr;
reg [7:0] write_data_left,write_data_right;
reg read_enable;
reg [15:0] read_addr;
wire [7:0] read_data_left,read_data_right;

BUFFER_ROW U0(
      //port A write
      .clka(sclk),            // input wire clka
      .wea(write_enable),     // input wire [0 : 0] wea
      .addra(write_addr),     // input wire [15 : 0] addra
      .dina(write_data_left),      // input wire [7 : 0] dina
    //port B read
      .clkb(sclk),            // input wire clkb
      .enb(read_enable),      // input wire enb
      .addrb(read_addr),      // input wire [15 : 0] addrb
      .doutb(read_data_left)       // output wire [7 : 0] doutb
    );
    
BUFFER_ROW U1(
          //port A write
          .clka(sclk),            // input wire clka
          .wea(write_enable),     // input wire [0 : 0] wea
          .addra(write_addr),     // input wire [15 : 0] addra
          .dina(write_data_right),      // input wire [7 : 0] dina
        //port B read
          .clkb(sclk),            // input wire clkb
          .enb(read_enable),      // input wire enb
          .addrb(read_addr),      // input wire [15 : 0] addrb
          .doutb(read_data_right)       // output wire [7 : 0] doutb
        );

    
integer i;
initial begin
  sclk = 0;
  write_enable=0;
  write_addr = 0;
  write_data_left=0;
  write_data_right=0;

  read_enable=0;
  read_addr=0;

  #200;
  write_enable=4'b1111;
  write_addr<=write_addr+1'b1;
  write_data_left<=write_data_left+8'd1;
  write_data_right<=write_data_right+8'd1;
  @(posedge sclk);
  for(i=0;i<100;i=i+1) begin
    @(posedge sclk);
    write_enable=~write_enable;
    if(write_enable) begin
        write_addr<=write_addr+1'b1;
        write_data_left<=write_data_left+8'd1;
        write_data_right<=write_data_right+8'd1;
    end
      @(posedge sclk);
    read_enable=~read_enable;
    if(read_enable) begin
        read_addr<=read_addr+1'b1;
        $display("read data is %d ",read_data_left);
    end
  end
  
end

always #10 sclk = ~sclk;
endmodule
