package i2c_register_pkg;

  import uvm_pkg::*;
  
  `include "i2c_WR_reg.sv"
  `include "i2c_RD_reg.sv"    
  `include "i2c_ADDRL_reg.sv" 
  `include "i2c_ADDRH_reg.sv"   
  `include "i2c_CONTROL_reg.sv"    
  `include "i2c_BYTECNT_reg.sv"    
  `include "i2c_MODE_reg.sv"    
  `include "i2c_PRESC_reg.sv"  
  `include "i2c_INTSTA_reg.sv" 
  `include "i2c_INTEN_reg.sv" 
endpackage
