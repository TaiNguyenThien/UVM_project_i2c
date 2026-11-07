`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2025 06:52:26 AM
// Design Name: 
// Module Name: apb_lmmi_bridge
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


module apb_lmmi_bridge(
    input  wire sys_clk,        
    input  wire sys_rst_n,      
    input  wire psel,     
    input  wire penable,    
    input  wire pwrite,     
    input  wire [11:0] paddr, 
    input  wire [7:0] rdata,  
    input  wire [7:0] pwdata,  
    output  wire [7:0] prdata,
    
    output wire  pready,
    output wire [7:0] wdata,
   // output wire  pslverr,
   // input  wire error,    
    
    output wire wr_en,
    output wire rd_en,  
    output wire [11:0] addr   
    );
    
assign wr_en  = psel && penable && pwrite;
assign rd_en  = psel && penable && !pwrite; 
assign pready = psel && penable;

assign addr  = paddr;
assign wdata = pwdata;
assign prdata       = rdata;

endmodule