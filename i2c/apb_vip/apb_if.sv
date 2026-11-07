
`ifndef GUARD_APB_IF__SV
`define GUARD_APB_IF__SV

interface apb_if();

  logic                        pclk;  
  logic                        presetn;  
  logic [11:0]                 paddr;  
  logic                        pwrite; 
  logic [`APB_PSEL_WIDTH-1:0]  psel;   
  logic                        penable;
  logic [7:0]  pwdata; 
  logic                        pready; 
  logic [7:0]  prdata; 
  logic                        pslverr = 1'b0;

endinterface

`endif


