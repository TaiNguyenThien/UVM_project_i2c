`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2025 11:46:13 PM
// Design Name: 
// Module Name: i2c_master
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


module i2c_master (
    input  wire        clk,
    input  wire        rst_n,

    input  wire        start,
//    input  wire        abort,
    input  wire        repeated_start,
//    input  wire        reset,
    
    input  wire [6:0]  addrl,
    input  wire [2:0]  addrh,
    
    input  wire [7:0]  data_out_tx,
    
//    input  wire [1:0]  speed_mode,
    input  wire        addr_mode,
    input  wire        trx_mode,         
    input  wire [2:0]  clk_presc_high,
    input  wire [7:0]  clk_presc_low,
    input  wire  [7:0] byte_cnt,

//   output reg         tr_cmp,           
    output reg         nack_error,
//    output reg         abort_ack,
//    output reg         arb_lost,
//    output reg         timeout,
    
    output reg  [7:0]  data_in_rx,
    output reg tx_done_tick,
    output reg rx_done_tick,

    output wire        i2c_scl,
    inout  wire        i2c_sda
);

    wire [10:0] clk_divider = {clk_presc_high, clk_presc_low};
    reg  [10:0] clk_cnt;
    reg         scl_clk;
    reg [1:0]ack_phase;
    reg [7:0] byte_count;
    reg addr_10b;
    
    

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_cnt <= 0;
            scl_clk <= 1'b1;
        end else begin
            if (clk_cnt >= clk_divider) begin
                clk_cnt <= 0;
                scl_clk <= ~scl_clk;
            end else begin
                clk_cnt <= clk_cnt + 1'b1;
            end
        end
    end
   
    assign i2c_scl = scl_clk;
    
    localparam IDLE          = 4'd0;
    localparam START         = 4'd1;
    localparam SEND_ADDR_H   = 4'd2;   
    localparam SEND_ADDR_L   = 4'd3;   
    localparam SEND_ADDR_7B  = 4'd4;
    localparam WACK_ADDR     = 4'd5;  
    localparam SEND_DATA     = 4'd6;
    localparam WACK_DATA     = 4'd7; 
    localparam READ_DATA     = 4'd8;
    localparam STOP          = 4'd9;
 //   localparam ABORT         = 4'd10;
    localparam ACK_DATA      = 4'd10;
    

    reg [3:0] state, next_state;
    wire [9:0] slave_addr = {addrh, addrl};
    reg [3:0] bit_cnt;
    reg [7:0] shift_reg;
    reg       sda_oe;
    wire      sda_in;
    reg released_sda;
    reg       checker;

    assign sda_in = i2c_sda;      
    assign i2c_sda = sda_oe ? 1'b0 : 1'bz;
    
    reg scl_clk_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            scl_clk_d <= 1'b1;
        else
            scl_clk_d <= scl_clk;
    end

    wire scl_rise = scl_clk && ~scl_clk_d;
    wire scl_fall = ~scl_clk && scl_clk_d;
 

    always @( posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            next_state <= IDLE; 
            sda_oe <= 1'b0;
            bit_cnt <= 4'd7;
     //       tr_cmp <= 1'b0;
            nack_error <= 1'b0;
     //       arb_lost <= 1'b0;
     //       abort_ack   <= 1'b0;
     //       timeout     <= 1'b0;
            released_sda <= 1'b0;
            ack_phase <= 2'b0;   
            byte_count <= 8'b0;  
            addr_10b  <= 1'b0;       
        end else begin
            state <= next_state;
     //       abort_ack <= 1'b0;
            rx_done_tick <=1'b0;
            tx_done_tick <=1'b0;
         
        case (state)
            IDLE: begin
                sda_oe <= 1'b0;
                bit_cnt <= 4'd7;
                nack_error <= 1'b0;
        //        arb_lost <= 1'b0;
                if (start) begin
        //          tr_cmp <= 1'b0;
                  next_state <= START;
                  byte_count <= byte_cnt; 
                end
        //        else if (abort)
        //          next_state <= ABORT;
            end
            
            START: begin
                if (scl_clk) begin
                    sda_oe <= 1'b1;  
                    bit_cnt <= 4'd7;  
                    next_state <= (addr_mode) ? SEND_ADDR_H : SEND_ADDR_7B;
                    rx_done_tick <=1'b0;
                    tx_done_tick <=1'b0;
                end
            end
                
            SEND_ADDR_H: begin        
                if (bit_cnt == 4'd7)
                    shift_reg <= {5'b11110, slave_addr[9:8], trx_mode};
                if (scl_fall) begin
                    sda_oe <= ~shift_reg[bit_cnt];  // sda_oe = 0 --> sda = 1
                    //if (shift_reg[bit_cnt] && ~sda_in)
                    //    arb_lost <= 1'b1;
                end else if (scl_rise) begin
                    if (bit_cnt == 0) begin
                      next_state <= WACK_ADDR;  
                      bit_cnt <= 4'd7; 
                      addr_10b  <= 1'b1;  
                    end else
                      bit_cnt <= bit_cnt - 1;
                end
            end

            SEND_ADDR_L: begin
                if (bit_cnt == 4'd7)
                shift_reg <= slave_addr[7:0];
                if (scl_fall) begin
                    sda_oe <= ~shift_reg[bit_cnt];
                   // if (shift_reg[bit_cnt] && ~sda_in)
                   //     arb_lost <= 1'b1;
                end else if (scl_rise) begin
                    if (bit_cnt == 0) begin
                      next_state <= WACK_ADDR;
                      bit_cnt <= 4'd7;
                    end else
                      bit_cnt <= bit_cnt - 1;
                end
            end

           SEND_ADDR_7B: begin
                if (bit_cnt == 4'd7)
                    shift_reg <= {slave_addr[6:0], trx_mode};
                if (scl_fall) begin
                    sda_oe <= ~shift_reg[bit_cnt];
                   // if (~shift_reg[bit_cnt] && sda_in)
                   //     arb_lost <= 1'b1;
                end else if (scl_rise) begin
                    if (bit_cnt == 0) begin
                      next_state <= WACK_ADDR;
                      bit_cnt <= 4'd7;
                    end else
                      bit_cnt <= bit_cnt - 1;
                end
            end
            
            WACK_ADDR: begin
                if (!released_sda && scl_fall) begin 
                    sda_oe <= 1'b0; // release SDA for ACK
                    released_sda <= 1'b1;
                end
                else if (released_sda && scl_rise) begin
                    if (sda_in == 1'b1) begin
                        nack_error <= 1'b1;
          //              next_state <= STOP;
                    end
                    else begin
                        bit_cnt <= 4'd7;
                        if (addr_mode && addr_10b)
                        begin
                            next_state <= SEND_ADDR_L;
                            checker <= 1'b1;
                            addr_10b  <= 1'b0;
                            bit_cnt <= 4'd7;
                        end                           
                        else if (trx_mode)
                                 next_state <= READ_DATA;
                             else begin 
                                 next_state <= SEND_DATA; 
                                        
                                 end            
                   end
                   released_sda <= 1'b0;
                 end              
            end

            SEND_DATA: begin
                if (scl_fall ) begin
                    sda_oe <= ~data_out_tx[bit_cnt];                    
                    //if ((data_in_tx[bit_cnt]) && ~sda_in)
                    //    arb_lost <= 1'b1;
                end else if (scl_rise ) begin
                    if (bit_cnt == 0) begin
                        next_state <= WACK_DATA;
                        tx_done_tick <= 1;
                        bit_cnt <= 4'd7;
                    end else
                        bit_cnt <= bit_cnt - 1;
                end
            end
            
            WACK_DATA: begin
                if (!released_sda && scl_fall) begin 
                    sda_oe <= 1'b0; // release SDA for ACK
                    released_sda <= 1'b1;
                end
                else if (released_sda && scl_rise) begin
                    if (sda_in == 1'b1) begin
                        nack_error <= 1'b1;
                        next_state <= STOP;
                    end    
                    if ( byte_count >1 ) begin
                        byte_count <= byte_count - 1;
                        next_state <= SEND_DATA;  
                        bit_cnt <= 4'd7;                     
                    end 
                    else begin                       
                        if (repeated_start) begin
                            next_state <= START; 
                            
                            end
                        else
                            next_state <= STOP;
                    end
               
                    bit_cnt <= 4'd7;
                    released_sda <= 1'b0;
                end
            end
            READ_DATA: begin
                    if (scl_rise) begin
                        data_in_rx[bit_cnt] <= sda_in;
                        if (bit_cnt == 0) begin
                            rx_done_tick <= 1;
                            next_state <= ACK_DATA;
                        end
                        else
                            bit_cnt <= bit_cnt - 1;
                    end
            end
            
            ACK_DATA: begin
                    case(ack_phase)
                    2'b00 :if (scl_fall) begin
                          sda_oe <= 1'b1; //  SDA =0 (ACK);
                          ack_phase <= 2'b01;
                    end
                    2'b01: if (scl_fall) begin
                           sda_oe <= 1'b0;
                           ack_phase <= 2'b10;
                    end
                    2'b10: if (scl_rise) begin
                            if ( byte_count >1 ) begin
                              byte_count <= byte_count - 1;
                              next_state <= READ_DATA; 
                              bit_cnt <= 4'd7;                      
                             end 
                             else begin
                             if (repeated_start) begin
                             next_state <= START; 
                             checker <= 1'b1;
                             end
                             else
                             next_state <= STOP;
                           end
                           bit_cnt <= 4'd7;
                           ack_phase <= 2'b00;
                    end  
                    endcase
            end
            
            STOP: begin
                    if (scl_fall) begin
                        sda_oe <= 1'b0;  // master gui NACK 
    //                    tr_cmp <= 1'b1;
                        next_state <= IDLE;
                    end
            end
    /*        
            ABORT: begin
                    sda_oe <= 1'b0;    
                    abort_ack <= 1'b1;
            end
     */
        endcase
    end
end

endmodule


