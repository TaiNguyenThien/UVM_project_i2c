class i2c_INTSTA_reg extends uvm_reg;
  `uvm_object_utils(i2c_INTSTA_reg)

  uvm_reg_field      rsvd;
  rand uvm_reg_field nack_int;
  rand uvm_reg_field tx_fifo_full_int;
  rand uvm_reg_field tx_fifo_empty_int;
  rand uvm_reg_field rx_fifo_full_int;
  rand uvm_reg_field rx_fifo_empty_int;
  
  function new(string name="i2c_INTSTA_reg");
    super.new(name,8,UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    // Create object instance for each field
    rsvd               = uvm_reg_field::type_id::create("rsvd");
    nack_int   = uvm_reg_field::type_id::create("nack_int");
    tx_fifo_full_int   = uvm_reg_field::type_id::create("tx_fifo_full_int");
    tx_fifo_empty_int  = uvm_reg_field::type_id::create("tx_fifo_empty_int");
    rx_fifo_full_int   = uvm_reg_field::type_id::create("rx_fifo_full_int");
    rx_fifo_empty_int  = uvm_reg_field::type_id::create("rx_fifo_empty_int");
    
    // Configure each field
    rsvd.configure(this,3,5,"RO",1'b0,3'b000,1,1,1);
    nack_int.configure(this,1,4,"W1C",1'b0,1'b0,1,1,1);
    tx_fifo_full_int.configure(this,1,3,"W1C",1'b0,1'b0,1,1,1);
    tx_fifo_empty_int.configure(this,1,2,"W1C",1'b0,1'b0,1,1,1);
    rx_fifo_full_int.configure(this,1,1,"W1C",1'b0,1'b0,1,1,1);
    rx_fifo_empty_int.configure(this,1,0,"W1C",1'b0,1'b0,1,1,1);
  endfunction

endclass
