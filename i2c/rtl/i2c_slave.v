`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2025 05:18:36 AM
// Design Name: 
// Module Name: i2c_slave
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


module i2c_slave #(
    parameter SLAVE_ADDR  = 7'h55,
    parameter SLAVE_ADDR_10B = 10'b0111010101 // addr_h = 3'b001 (1) , addr_l = 7'b1010101 (55)
)(
    input  wire clk,     
    input  wire rst_n,

    input  wire scl,    
    inout  wire sda,

    output reg  [7:0] data_out,
    input  wire repeated_start,
    input  wire [7:0] byte_cnt,
    input  wire addr_mode,   
    input  wire [7:0] data_in     
);
    reg sda_oe;
    wire sda_in;
    assign sda_in = sda;
    assign sda = sda_oe ? 1'b0 : 1'bz;

    // phát hien START / STOP
    reg sda_d, scl_d;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sda_d <= 1;
            scl_d <= 1;
        end else begin
            sda_d <= sda_in;
            scl_d <= scl;
        end
    end
    wire scl_rise  = ~scl_d && scl;
    wire scl_fall  = scl_d && ~scl;
    wire start_detected = sda_d && ~sda_in && scl;
    wire stop_detected  = ~sda_d && sda_in && scl;
    reg released_sda;
    

  
    localparam    S_IDLE     = 4'd0;
    localparam    S_ADDR     = 4'd1;
    localparam    S_ADDR_H   = 4'd2;
    localparam    S_ADDR_L   = 4'd3;
    localparam    S_ACK_ADDR = 4'd4;
    localparam    S_RX       = 4'd5;
    localparam    S_ACK_DATA = 4'd6;
    localparam    S_TX       = 4'd7;
    localparam    S_WACK     = 4'd8;
    localparam    S_WACK_DATA= 4'd9;
    

    reg [3:0] state, next_state;
    reg ack_phase;
    reg [3:0] bit_cnt;
    reg [7:0] shift_reg;
    reg       rw_bit; // 0=write, 1=read
    reg       repeated;
    reg [7:0] byte_count;
    reg addr_10b;
    reg[9:0] addr_10bit;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_IDLE;
            next_state  <= S_IDLE;
            bit_cnt <= 4'd7;
            sda_oe <= 1'b0;
            data_out <= 8'd0;
            ack_phase <= 1'b0;
            repeated <= 1'b0;
            released_sda <= 1'b0;
            byte_count <= 8'b0; 
            addr_10b <= 0;
            addr_10bit<= 10'd0; 
        end else begin
            state <= next_state;
            
            case (state)
                S_IDLE: begin
 //                   data_valid <= 0;
 //                   sda_oe <= 0;
                    if (start_detected || repeated) begin
                        next_state <= (addr_mode) ? S_ADDR_H : S_ADDR;
          //              checker <= 1'b0;
                        bit_cnt <= 4'd7;  
                        byte_count <= byte_cnt;      
                    end
                end
                
                S_ADDR_H: begin
                     if (scl_rise) begin
                        shift_reg[bit_cnt] <= sda_in;
                        if (bit_cnt == 0) begin
                            rw_bit <= sda_in;
                            addr_10bit[9:8] <= shift_reg[2:1];
                            addr_10b <= 1'b1;                             
                            next_state <= S_ACK_ADDR;                               
                        end else
                            bit_cnt <= bit_cnt - 1;
                     end
                end
 
                S_ADDR_L: begin
                     if (scl_rise) begin
                        shift_reg[bit_cnt] <= sda_in;
                        if (bit_cnt == 0) begin
                            addr_10bit[7:0] = {shift_reg[7:1], sda_in};
                            if (addr_10bit == SLAVE_ADDR_10B)                            
                                next_state <= S_ACK_ADDR;  
                            else begin
                                next_state <= S_IDLE; 
                            end                             
                        end else
                            bit_cnt <= bit_cnt - 1;
                     end
                end                
                

                S_ADDR: begin
                    if (scl_rise) begin
                        shift_reg[bit_cnt] <= sda_in;
                        if (bit_cnt == 0) begin
                            rw_bit <= sda_in;
                            if (shift_reg[7:1] == SLAVE_ADDR)
                                next_state <= S_ACK_ADDR;
                            else begin
                                next_state <= S_IDLE; 
                                
                            end
                        end else
                            bit_cnt <= bit_cnt - 1;
                     end
                end
                
                S_ACK_ADDR: begin
                    
                    case(ack_phase)
                    1'b0 :if (scl_fall) begin
                          sda_oe <= 1'b1; //  SDA =0 (ACK);
                          ack_phase <= 1'b1;
                    end
                    1'b1: if ( scl_fall) begin
                              if (addr_10b) begin
                                  sda_oe <= 1'b0;
                                  addr_10b <= 1'b0;
                                  bit_cnt <= 4'd7;
                                  next_state <= S_ADDR_L;
                                  ack_phase <= 1'b0;
                              end
                              else begin                       
                                  if ( rw_bit ) begin
                                     sda_oe <= ~data_in[7];
                                     bit_cnt <= 4'd6;
                                     ack_phase <= 1'b0;  
                                     next_state <=  S_TX;  
                                  end
                                  else begin
                                     sda_oe <= 1'b0;
                                     next_state <= (rw_bit) ? S_TX : S_RX; 
                                     bit_cnt <= 4'd7;
                                     ack_phase <= 1'b0;
                                  end
                                     
                              end                                 
                    end           
                    endcase         
                end    

                S_RX: begin
                    if(scl_rise) begin
                        shift_reg[bit_cnt] <= sda_in;
                        if (bit_cnt == 0) begin
                            data_out <= {shift_reg[7:1], sda_in};               
                            next_state <= S_ACK_DATA;
                        end else
                            bit_cnt <= bit_cnt - 1;
                    end
                end
           // ack_d nhan byte tiep theo
                S_ACK_DATA: begin
                    case(ack_phase)
                    1'b0 :if (scl_fall) begin
                          sda_oe <= 1'b1; //  SDA =0 (ACK);
                          ack_phase <= 1'b1;
                    end
                    1'b1: if ( scl_fall) begin
                          sda_oe <= 1'b0;
                          
                          if ( byte_count >1 ) begin
                              byte_count <= byte_count - 1;
                              next_state <= S_RX; 
                              bit_cnt <= 4'd7;                      
                          end 
                          else begin 
                              if (repeated_start) begin
                                  next_state <= S_IDLE;
                                  repeated <= 1'b1;
                              end
                              else begin
                                  next_state <= S_WACK;
                              end
                          end 
                          bit_cnt <= 4'd7;
                          ack_phase <= 1'b0;
                    end 
                    endcase
                end

                S_TX: begin
                    if (scl_fall) begin
                        sda_oe <= ~data_in[bit_cnt];
                        if (bit_cnt == 0) begin
                            next_state <= S_WACK_DATA;
                            
                        end
                        else
                            bit_cnt <= bit_cnt - 1;
                    end
                end 
                
                S_WACK_DATA: begin
                if (!released_sda && scl_fall) begin 
                    sda_oe <= 1'b0; // release SDA for ACK
                    released_sda <= 1'b1;
                end
                else if (released_sda && scl_rise) begin
                    
                    if ( byte_count >1 ) begin
                        byte_count <= byte_count - 1;
                        next_state <= S_TX;  
                        bit_cnt <= 4'd7;                     
                    end 
                    else begin   
                    if (repeated_start) begin
                        next_state <= S_IDLE;
                   //     checker <= 1'b1;
                        end
                    else 
                          next_state <= S_WACK;
                    end 
                    bit_cnt <= 4'd7;
                    released_sda <= 1'b0;
                end
            end
                
                S_WACK: begin
                    if (!released_sda && scl_fall) begin 
                        sda_oe <= 1'b0; // release SDA for ACK
                        released_sda <= 1'b1;
                    end
                    else if (released_sda && scl_rise)begin 
                        if (sda_in == 1'b1) // NACK
                            next_state <= S_IDLE;
                        else begin
                            bit_cnt <= 4'd7;
                            next_state <= (rw_bit) ? S_TX : S_RX;
                         //   state <= S_TX;
                        end
                        released_sda <= 1'b0;
                    end
                end
            endcase

            if (stop_detected)
                next_state <= S_IDLE;
        end
    end

endmodule



