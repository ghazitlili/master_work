`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/25/2016 01:30:59 PM
// Design Name: 
// Module Name: TB_
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


module TB_(

    );
                    reg    clk;
                    reg en_write_left;
                    reg en_write_right;
                    reg [9 : 0] data_in_adr_left;
                    reg [9 : 0] data_in_adr_right;
                    reg [7 : 0] data_in_left;
                    reg [7 : 0] data_in_right;
                    reg en_read_left;
                    reg en_read_right;
                    reg [9 : 0] data_out_adr_left;
                    reg [9 : 0] data_out_adr_right;
                    wire [7 : 0] data_out_left;
                    wire [7 : 0] data_out_right;    
                    
        
    READ_FILE_BRAM  U0(
    
                .clk(clk),
                .en_write_left(en_write_left),
                .en_write_right(en_write_right),
                .data_in_adr_left(data_in_adr_left),
                .data_in_adr_right(data_in_adr_right),
                .data_in_left(data_in_left),
                .data_in_right(data_in_right),
                .en_read_left(en_read_left),
                .en_read_right(en_read_right),
                .data_out_adr_left(data_out_adr_left),
                .data_out_adr_right(data_out_adr_right),
                .data_out_left(data_out_left),
                .data_out_right(data_out_right)  
    
    
    );
    
    always #5 clk=~clk;
    
    
    initial begin
          
            data_out_adr_left=0;
            data_out_adr_right=0;
            en_read_left=1'b0;
            en_read_right=1'b0;
            en_write_left = 1'b0;
            en_write_right = 1'b0;
            clk=1'b1;
    
    end
    
    
    
    initial begin : LEFT_IMAGE       
    // read data from file into a buffer left side
            integer in_left,row_left,col_left; integer in_right,row_right,col_right;       
            integer statusI_left; integer statusI_right;
            reg [7:0] blue_left,red_left,green_left;
            reg [7:0] blue_right,red_right,green_right;                 
            in_left  = $fopen("/afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/matlab/image_rect_matlab/image_rect_matlab/test_left.txt","r");
            in_right  = $fopen("/afs/c3e.cs.tu-bs.de/home/gabbassi/Desktop/ghazi_abbassi/matlab/image_rect_matlab/image_rect_matlab/test_right.txt","r");
            repeat (10) @ (posedge clk);
                  while (!$feof(in_left)) begin
                             @ (posedge clk);
                              statusI_left = $fscanf(in_left,"%d, %d = (%d, %d, %d)\n",row_left,col_left,red_left[7:0],green_left[7:0],blue_left[7:0]);
                              statusI_right = $fscanf(in_right,"%d, %d = (%d, %d, %d)\n",row_right,col_right,red_right[7:0],green_right[7:0],blue_right[7:0]);
                              data_in_adr_left=row_left+(col_left-1)*240-1;
                              data_in_adr_right=row_right+(col_right-1)*240-1;  
                              data_in_left=red_left;
                              data_in_right=red_right;
                              en_write_left = 1;
                              en_write_right = 1;   
                   end           
            $fclose(in_left);$fclose(in_right);
    end       
  
    
    initial begin:READ_RIGHT_LEFT
    
         
               repeat (30) @ (negedge clk);          
               while(1)begin
                  @ (posedge clk)begin
                                en_read_right <= 1; 
                                en_read_left <= 1; 
                                data_out_adr_right<=data_out_adr_right +1 ;
                                data_out_adr_left<=data_out_adr_left +1 ;   
                  end
                        
                end
              
    end
   

endmodule
