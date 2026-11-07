
`ifndef GUARD_UART_PKG__SV
`define GUARD_UART_PKG__SV
package i2c_pkg;
  import uvm_pkg::*;
  `include "i2c_define.sv"
  `include "i2c_transaction.sv"
//  `include "i2c_configuration.sv"
//  `include "i2c_sequencer.sv"
//  `include "i2c_driver.sv"
  `include "i2c_monitor.sv"
  `include "i2c_agent.sv"

  // Include your file

endpackage: i2c_pkg
  

`endif

