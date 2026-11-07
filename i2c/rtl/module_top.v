`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/24/2025 11:29:16 AM
// Design Name: 
// Module Name: module_top
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


module module_top(
    input  wire sys_clk,
    input  wire sys_rst_n,
    
    input  wire psel,
    input  wire penable,
    input  wire pwrite,
    input  wire [11:0] paddr,
    input  wire [7:0] pwdata,
    input  wire [7:0] data_in,
    output  wire [7:0] data_out_top,
    
    output wire [7:0] prdata,
    output wire pready,
    
 //   output wire tr_cmp_int,
    output wire tx_fifo_full_int,
    output wire tx_fifo_empty_int,
    output wire rx_fifo_full_int,
    output wire rx_fifo_empty_int,
    output wire nack_error_int,
 //   output wire abort_ack_int,
 //   output wire arb_lost_int,
 //   output wire timeout_int,
    
    output wire sda,
	output wire scl

    );
    
    wire wr_en;
    wire rd_en;
    wire [11:0] addr;
    wire [7:0] wdata;
    wire [7:0] rdata;
    wire ready;
    
    wire [7:0] data_in_tx;
    wire [7:0] data_out_rx;
//    wire tr_cmp;
    wire tx_fifo_full, tx_fifo_empty, rx_fifo_full, rx_fifo_empty;
    wire nack_error;

    wire tx_enable, rx_enable, repeated_start, start;
    wire [6:0] addrl;
    wire [2:0] addrh;
    wire [7:0] byte_cnt;
  //  wire [1:0] speed_mode;
    wire addr_mode, trx_mode;
    wire [2:0] clk_presc_high;
    wire [7:0] clk_presc_low;
    
    wire [7:0] data_out_tx;
    wire [7:0] data_in_rx;
    wire tx_done_tick, rx_done_tick;
    
    wire [7:0] slave_data_wire;
    
    apb_lmmi_bridge u_apb_lmmi_bridge (
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .psel(psel),
        .penable(penable),
        .pwrite(pwrite),
        .paddr(paddr),
        .pwdata(pwdata),
        .prdata(prdata),
        .pready(pready),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .addr(addr),
        .wdata(wdata),
        .rdata(rdata)
    );
    
    register_file u_register_file (
        .clk(sys_clk),
        .rst_n(sys_rst_n),

        .wrdata(wdata),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .addr(addr),
        .pready(pready),
        
     //   .tr_cmp(tr_cmp),
        .tx_fifo_full(tx_fifo_full),
        .tx_fifo_empty(tx_fifo_empty),
        .rx_fifo_full(rx_fifo_full),
        .rx_fifo_empty(rx_fifo_empty),
        .nack_error(nack_error),
     //   .abort_ack(abort_ack),
    //    .arb_lost(arb_lost),
    //    .timeout(timeout),

        .data_out_rx(data_out_rx),
        .rdata(rdata),
        .data_in_tx(data_in_tx),

    //    .tr_cmp_int(tr_cmp_int),
        .tx_fifo_full_int(tx_fifo_full_int),
        .tx_fifo_empty_int(tx_fifo_empty_int),
        .rx_fifo_full_int(rx_fifo_full_int),
        .rx_fifo_empty_int(rx_fifo_empty_int),
        .nack_error_int(nack_error_int),
   //     .abort_ack_int(abort_ack_int),
    //    .arb_lost_int(arb_lost_int),
   //     .timeout_int(timeout_int),

        .rx_enable(rx_enable),
        .tx_enable(tx_enable),
        .repeated_start(repeated_start),
    //    .reset(reset),
    //    .abort(abort),
        .start(start),

        .addrl(addrl),
        .addrh(addrh),
        
    //    .speed_mode(speed_mode),
        .addr_mode(addr_mode),
        .trx_mode(trx_mode),
        .byte_cnt(byte_cnt),
        .clk_presc_high(clk_presc_high),
        .clk_presc_low(clk_presc_low)
    );
    
    fifo_trans u_fifo_trans (
        .clk(sys_clk),
        .rst_n(sys_rst_n),
        .data_in_tx(data_in_tx),
        .tx_enable(tx_enable),
        .data_out_tx(data_out_tx),
        .full_tx(tx_fifo_full),
        .empty_tx(tx_fifo_empty),
        .tx_done_tick(tx_done_tick)
    );
    
    fifo_receiver u_fifo_receiver (
        .clk(sys_clk),
        .rst_n(sys_rst_n),
        .data_in_rx(data_in_rx),
        .rx_enable(rx_enable),
        .data_out_rx(data_out_rx),
        .full_rx(rx_fifo_full),
        .empty_rx(rx_fifo_empty),
        .rx_done_tick(rx_done_tick)
    );
    

    i2c_master u_i2c_master (
        .clk(sys_clk),
        .rst_n(sys_rst_n),

        .start(start),
    //    .abort(abort),
        .repeated_start(repeated_start),
    //    .reset(reset),

        .addrl(addrl),
        .addrh(addrh),

        .data_out_tx(data_out_tx),
    //    .speed_mode(speed_mode),
        .addr_mode(addr_mode),
        .trx_mode(trx_mode),
        .clk_presc_high(clk_presc_high),
        .clk_presc_low(clk_presc_low),
        .byte_cnt(byte_cnt),

    //    .tr_cmp(tr_cmp),
        .nack_error(nack_error),
   //     .abort_ack(abort_ack),
   //     .arb_lost(arb_lost),
    //    .timeout(timeout),

        .data_in_rx(data_in_rx),
        .tx_done_tick(tx_done_tick),
        .rx_done_tick(rx_done_tick),

        .i2c_scl(scl),
        .i2c_sda(sda)
    );
    
    i2c_slave #(.SLAVE_ADDR(7'h55)) u_i2c_slave (
        .clk(sys_clk),
        .rst_n(sys_rst_n),
        .scl(scl),
        .sda(sda),
        .data_out(slave_data_wire),
        .repeated_start(repeated_start),
        .byte_cnt(byte_cnt),
        .addr_mode(addr_mode),
        .data_in(data_in)  

    );
    
    assign data_out_top = slave_data_wire;
endmodule
