`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2016 12:39:21 AM
// Design Name: 
// Module Name: READ_FILE_BRAM_TB
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


module READ_FILE_BRAM_TB(

    );
    reg sclk;
    reg write_enable;
    reg [15:0] write_addr;
    reg [7:0] write_data_left,write_data_right;
    reg read_enable;
    reg [15:0] read_addr;
    wire [7:0] read_data_left,read_data_right;  
                
    
READ_FILE_BRAM  U0(

            .clk(sclk),
            .en_write(write_enable),
            .data_in_adr(write_addr),
            .data_in_left(write_data_left),
            .data_in_right(write_data_right),
            .en_read(read_enable),
            .data_out_adr(read_addr),
            .data_out_left(read_data_left),
            .data_out_right(read_data_right)  


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
  write_enable=1;
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
    read_enable=~read_enable;
    if(read_enable) begin
        read_addr<=read_addr+1'b1;
        $display("read data is %d \t %d ",read_data_left,read_data_right);
    end
  end
  
end

always #10 sclk = ~sclk;


endmodule
