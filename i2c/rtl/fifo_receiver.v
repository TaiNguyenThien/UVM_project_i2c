`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2025 12:56:33 AM
// Design Name: 
// Module Name: fifo_receiver
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


module fifo_receiver(
    input  wire         clk,          
    input  wire         rst_n,        
    input  wire [7:0]   data_in_rx,   
    input  wire         rx_enable,    
    output wire  [7:0]   data_out_rx,  
    output wire         full_rx,      
    output wire         empty_rx,   
    input wire         rx_done_tick  
 );
    parameter DEPTH = 4;              
    parameter ADDR_WIDTH = 2;        

    reg [7:0] fifo_mem [0:DEPTH-1];

    reg [ADDR_WIDTH-1:0] write_ptr_r;
	reg [ADDR_WIDTH-1:0] write_ptr_n;
	wire [ADDR_WIDTH-1:0] write_ptr_s;
	 
	reg [ADDR_WIDTH-1:0] read_ptr_r;
	reg [ADDR_WIDTH-1:0] read_ptr_n;
	wire [ADDR_WIDTH-1:0] read_ptr_s;
	 
	reg full_r;
	reg full_n;
	reg empty_r;
	reg empty_n;
	 
	wire [1:0] wr_op;
	 
 
	reg rx_en_pre;
	wire pulse_p;
	 
	integer i;
	 
	always @(posedge clk or negedge rst_n) begin
	  if (!rst_n) begin
	    rx_en_pre <= 1'b0; 
		end else begin
		rx_en_pre <= rx_enable;
		end
	   end
	 
	 assign pulse_p = !rx_en_pre && rx_enable; 

     always @(posedge clk or negedge rst_n) begin
       if (!rst_n) begin
	     for (i = 0; i < DEPTH; i = i + 1) begin
		   fifo_mem[i] <= 8'b0;
		 end
       end
       else if (rx_done_tick && !full_r) begin
          fifo_mem[write_ptr_r] <= data_in_rx; 
       end
      end
	 
	  assign data_out_rx = fifo_mem[read_ptr_r];
	 
 

      always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          read_ptr_r <= 0;
          write_ptr_r <= 0;
          empty_r <= 1;
          full_r <= 0;				
        end
        else begin
          read_ptr_r <= read_ptr_n;
		  write_ptr_r <= write_ptr_n;
		  empty_r <= empty_n;
		  full_r <= full_n;
        end
      end
	 
	  assign write_ptr_s = write_ptr_r + 1;
	  assign read_ptr_s = read_ptr_r + 1;
	  assign wr_op      = {rx_done_tick , pulse_p};
	 
	  always @( write_ptr_r, write_ptr_s, read_ptr_r, read_ptr_s, wr_op, empty_r, full_r) begin
	    read_ptr_n <= read_ptr_r;
		write_ptr_n <= write_ptr_r;
		empty_n <= empty_r;
		full_n <= full_r;
		case ( wr_op ) 
		  2'b00: begin
		  end
		  2'b01: if ( !empty_r) begin 
			read_ptr_n <= read_ptr_s;
			full_n <= 0;
			if ( read_ptr_s == write_ptr_r ) begin
			  empty_n <= 1;
			end
		  end
		  2'b10: if ( !full_r) begin 
			write_ptr_n <= write_ptr_s;
			empty_n <= 0;
			if ( write_ptr_s == read_ptr_r ) begin
			  full_n <= 1;
			end
		  end
		  default: begin
			read_ptr_n <= read_ptr_s;
			write_ptr_n <= write_ptr_s;
		  end
		    endcase
	  end
 
	  assign full_rx =  full_r; 
	  assign empty_rx = empty_r;
endmodule
