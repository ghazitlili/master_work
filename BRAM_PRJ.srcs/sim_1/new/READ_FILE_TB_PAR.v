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


module READ_FILE_TB_PAR(

    );
                reg    clk;
                reg en_write;
                reg [9 : 0] data_in_adr;
                reg [7 : 0] data_in_left;
                reg [7 : 0] data_in_right;
                reg         en_read;
                reg [9 : 0] data_out_adr;
                wire [7 : 0] data_out_left;
                wire [7 : 0] data_out_right;    
                
    
READ_FILE_BRAM  READ_FILE_BRAM_INST(

            .clk(clk),
            .en_write(en_write),
            .data_in_adr(data_in_adr),
            .data_in_left(data_in_left),
            .data_in_right(data_in_right),
            .en_read(en_read),
            .data_out_adr(data_out_adr),
            .data_out_left(data_out_left),
            .data_out_right(data_out_right)  


);

always #5 clk=~clk;


initial begin
      
        data_out_adr=0;
        en_read=1'b0;
        en_write= 1'b0;
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
                          data_in_adr=row_right+(col_right-1)*240-1;  
                          data_in_left=red_left;
                          data_in_right=red_right;
                          en_write = 1;   
               end           
        $fclose(in_left);$fclose(in_right);en_write<=0;
end       

initial begin:READ_RIGHT_LEFT

     
            repeat (300) @ (posedge clk);          
            en_read=1;
            repeat (300) @ (posedge clk)
            data_out_adr=data_out_adr +1 ;
            
                      
end


endmodule
