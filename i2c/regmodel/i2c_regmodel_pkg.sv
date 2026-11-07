package i2c_regmodel_pkg;

  import uvm_pkg::*;
  import apb_pkg::*;
  import i2c_register_pkg::*;

  `include "i2c_reg2apb_adapter.sv";
  `include "i2c_reg_block.sv";

endpackage
