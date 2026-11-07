module testbench;

  import uvm_pkg::*;
  import apb_pkg::*;
  import i2c_pkg::*;
  import test_pkg::*;

 // reg sys_clk;
  logic  [7:0]  data_in;
  wire   [7:0]  data_out_top;

  wire tx_fifo_full_int;
  wire tx_fifo_empty_int;
  wire rx_fifo_full_int;
  wire rx_fifo_empty_int;
  wire nack_error_int;
  

  wire sda;
  wire scl;
  
  pullup(sda);

  /** Instantiate APB Interface */
  apb_if apb_vif();
  
  i2c_if i2c_vif (
  .scl (scl),
  .sda (sda)
);

  //instance DUT
 module_top u_dut (
    // Clock & Reset
    .sys_clk        (apb_vif.pclk),
    .sys_rst_n      (apb_vif.presetn),

    // APB Interface
    .psel           (apb_vif.psel),
    .penable        (apb_vif.penable),
    .pwrite         (apb_vif.pwrite),
    .paddr          (apb_vif.paddr),
    .pwdata         (apb_vif.pwdata),
    .prdata         (apb_vif.prdata),
    .pready         (apb_vif.pready),

    // Data path
    .data_in        (data_in),
    .data_out_top   (data_out_top),

    // Interrupts
  //  .tr_cmp_int         (tr_cmp_int),
    .tx_fifo_full_int  (tx_fifo_full_int),
    .tx_fifo_empty_int (tx_fifo_empty_int),
    .rx_fifo_full_int  (rx_fifo_full_int),
    .rx_fifo_empty_int (rx_fifo_empty_int),
    .nack_error_int    (nack_error_int),
 //   .abort_ack_int     (abort_ack_int),
 //   .arb_lost_int      (arb_lost_int),
 //   .timeout_int       (timeout_int),

    // I2C signals
    .sda            (sda),
    .scl            (scl)
);
  	
  initial begin
    apb_vif.presetn = 0;
    data_in = 8'hA5;
    #100ns apb_vif.presetn = 1;
  end

  // 50 MHz
  initial begin
    apb_vif.pclk = 0;
    forever begin 
      #10ns;
      apb_vif.pclk = ~apb_vif.pclk;
    end
  end
 
  /** Set the VIP interface on the environment */
  initial begin
    uvm_config_db#(virtual apb_if)::set(uvm_root::get(),"uvm_test_top","apb_vif",apb_vif);
    uvm_config_db#(virtual i2c_if)::set(uvm_root::get(),"uvm_test_top.env","i2c_vif",i2c_vif);


    /** Start the UVM test */
    run_test();
  end

endmodule
