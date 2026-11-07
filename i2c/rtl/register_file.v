`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2025 09:12:26 AM
// Design Name: 
// Module Name: register_file
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


module register_file(
    input wire clk, rst_n,
    input wire [7:0] wrdata,
    input wire wr_en, rd_en,    
    input wire [11:0] addr,
    input wire pready,
    
 //   input wire tr_cmp,
    input wire tx_fifo_full, 
    input wire tx_fifo_empty,
    input wire rx_fifo_full,
    input wire rx_fifo_empty,
    input wire nack_error, 
 //   input wire abort_ack,
 //   input wire arb_lost,
 //   input wire timeout,
    
    input wire [7:0] data_out_rx,
	
    output reg [7:0] rdata,
//   output reg lmmi_rdata_valid,
    output reg [7:0] data_in_tx,
   	
 //  	output wire tr_cmp_int,	
   	output wire tx_fifo_full_int,
   	output wire tx_fifo_empty_int,
   	output wire rx_fifo_full_int,
   	output wire rx_fifo_empty_int,
   	output wire nack_error_int,
//   	output wire abort_ack_int,
//   	output wire arb_lost_int,
//   	output wire timeout_int,
	
    output reg rx_enable,
	output reg tx_enable,
	output reg repeated_start,
//	output reg reset,
//	output reg abort,
	output reg start,
	
    output reg [6:0] addrl,
	output reg [2:0] addrh,
	
//	output reg [1:0] speed_mode,
	output reg addr_mode,
	output reg trx_mode,
	output reg [7:0] byte_cnt,
	output reg [2:0] clk_presc_high,
	output reg [7:0] clk_presc_low
	
    );
    
    localparam wr_data       = 12'h00;
	localparam rd_data       = 12'h04;
	localparam target_addrl  = 12'h08;
	localparam target_addrh  = 12'h0C;
	localparam control       = 12'h10;
	localparam byte_cnt_reg  = 12'h14;
	localparam mode          = 12'h18;
	localparam clk_prescl    = 12'h1C;
	localparam int_status    = 12'h20;
	localparam int_enable    = 12'h24;
	localparam ff_status     = 12'h28;
//	localparam scl_timeout   = 4'hb;
	
    reg nack_en;         
    reg tx_fifo_full_en;   
    reg tx_fifo_empty_en;  
    reg rx_fifo_full_en;   
    reg rx_fifo_empty_en;  
/*	
	reg nack_error_en;   
    reg abort_ack_en;    
    reg arb_lost_en;     
    reg timeout_en;   
  */  
    reg  [4:0] int_st;
	wire [4:0] int_set = {nack_error, tx_fifo_full, tx_fifo_empty, rx_fifo_full, rx_fifo_empty};
	wire [4:0] int_clr;
	
 	
	assign control_sel       = ( addr == control )        & wr_en;
	assign wr_data_sel       = ( addr == wr_data )        & wr_en;
	assign target_addrl_sel  = ( addr == target_addrl )   & wr_en;
	assign target_addrh_sel  = ( addr == target_addrh )   & wr_en;
	assign mode_sel          = ( addr == mode )           & wr_en;
	assign presc_low_sel     = ( addr == clk_prescl )     & wr_en;
	assign int_enable_sel   = (  addr == int_enable )    & wr_en;
	assign int_status_sel   = (  addr == int_status )    & wr_en;
	assign byte_cnt_sel      = ( addr == byte_cnt_reg )   & wr_en;
	// Write control
	 always@(posedge clk or negedge rst_n) begin
	   if(!rst_n) begin
	     rx_enable      <= 1'b0;
	     tx_enable      <= 1'b0;
	     repeated_start <= 1'b0;
	//     reset          <= 1'b0;
	//     abort          <= 1'b0;
	     start          <= 1'b0;
	   end
	   else if(control_sel) begin       
	     rx_enable      <= wrdata[5];
	     tx_enable      <= wrdata[4];
	     repeated_start <= wrdata[3];
	 //    reset          <= wrdata[2];
	 //    abort          <= wrdata[1];
	     start          <= wrdata[0];
	   end
	 end
	 // write data
	 always @(posedge clk or negedge rst_n) begin
	   if (!rst_n) begin
	     data_in_tx <= 8'b0;
	   end
	   else if (wr_data_sel) begin
	     data_in_tx <= wrdata [7:0];
	   end
	 end
    // write addr
     always @(posedge clk or negedge rst_n) begin
       if (!rst_n) begin
         addrl <= 7'h00;
       end
       else if (target_addrl_sel) begin
         addrl <= wrdata[6:0];
       end
     end
     
     always @(posedge clk or negedge rst_n) begin
       if (!rst_n) begin
         addrh <= 3'b0;
       end
       else if (target_addrh_sel) begin
         addrh <= wrdata[2:0];
       end
     end
    // write mode 
     always @(posedge clk or negedge rst_n) begin
       if (!rst_n) begin
         addr_mode     <= 1'b0;
         trx_mode      <= 1'b0;
         clk_presc_high <= 3'b000;
       end
       else if (mode_sel) begin
         addr_mode     <= wrdata[4];
         trx_mode      <= wrdata[3];
         clk_presc_high <= wrdata[2:0];
       end
     end
    // write presc 
     always @(posedge clk or negedge rst_n) begin
       if (!rst_n) begin
         clk_presc_low <= 8'h00;
       end
       else if (presc_low_sel) begin
         clk_presc_low <= wrdata;
       end
     end
	  // write int1
	 always @(posedge clk or negedge rst_n) begin
       if (!rst_n) begin
         nack_en        <= 1'b0;
         tx_fifo_full_en  <= 1'b0;
         tx_fifo_empty_en <= 1'b0;
         rx_fifo_full_en  <= 1'b0;
         rx_fifo_empty_en <= 1'b0;
       end 
       else if (int_enable_sel) begin
         nack_en        <= wrdata[4];  
         tx_fifo_full_en  <= wrdata[3];  
         tx_fifo_empty_en <= wrdata[2];  
         rx_fifo_full_en  <= wrdata[1];  
         rx_fifo_empty_en <= wrdata[0];  
       end
     end

     // interrupt1 (W1C)
//	assign int1_set = {tr_cmp, full_tx, empty_tx, full_rx, empty_rx};
	
	assign int_clr = wrdata[4:0] & {5{int_status_sel}};

	always @(posedge clk or negedge rst_n) begin
      if (!rst_n)
        int_st <= 5'b0;
      else
        int_st <= (int_st | int_set) & ~int_clr;
    end
    
    assign nack_error_int = int_st[4] && nack_en ; 
    assign tx_fifo_full_int = int_st[3] && tx_fifo_full_en ; 
    assign tx_fifo_empty_int = int_st[2] && tx_fifo_empty_en ; 
    assign rx_fifo_full_int = int_st[1] && rx_fifo_full_en ; 
    assign rx_fifo_empty_int = int_st[0] && rx_fifo_empty_en ;
    
    
    // write byte_cnt
    always @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
        byte_cnt <= 8'h00;
      end
      else if (byte_cnt_sel) begin
        byte_cnt <= wrdata;
      end
    end
   
   // read  
   always @(*) begin
     if ( rd_en & pready) begin
       case (addr)
	 rd_data       : rdata = data_out_rx;
         target_addrl  : rdata = addrl;
         target_addrh  : rdata = {5'h0, addrh};
         byte_cnt_reg  : rdata = byte_cnt;
         mode          : rdata = { 3'b0, addr_mode, trx_mode, clk_presc_high};
	 clk_prescl    : rdata = clk_presc_low;
         int_status   :  rdata = {3'b0,nack_error_int, tx_fifo_full_int, tx_fifo_empty_int, rx_fifo_full_int, rx_fifo_empty_int};
         int_enable   : rdata = {3'b0, nack_en, tx_fifo_full_en, tx_fifo_empty_en, rx_fifo_full_en, rx_fifo_empty_en};
    //     int2_enable   : rdata = {4'h0, nack_error_en, abort_ack_en, arb_lost_en, timeout_en};
         ff_status     : rdata = {4'h0, tx_fifo_full, tx_fifo_empty, rx_fifo_full, rx_fifo_empty};
		 default       : rdata = 8'h0;
       endcase
     end else begin
       rdata = 8'h0;
     end
   end
   


endmodule
