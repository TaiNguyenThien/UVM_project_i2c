package test_pkg;
  import uvm_pkg::*;
  import apb_pkg::*;
  import env_pkg::*;
  import seq_pkg::*;
  import i2c_regmodel_pkg::*;

  `include "i2c_base_test.sv"
  `include "i2c_reg_scan_test.sv"
  `include "i2c_default_test.sv"
  `include "i2c_master_read_test.sv"
  `include "i2c_master_write_test.sv"
  `include "i2c_repeat_start_test.sv"
  `include "i2c_write_3byte_test.sv"
  `include "i2c_fifo_int_test.sv"
  `include "i2c_nack_error_test.sv"
  `include "i2c_master_write_addr10b_test.sv"
endpackage
