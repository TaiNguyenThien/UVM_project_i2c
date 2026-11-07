class i2c_INTEN_reg extends uvm_reg;
  `uvm_object_utils(i2c_INTEN_reg)

  uvm_reg_field      rsvd;
  rand uvm_reg_field nack_en;
  rand uvm_reg_field tx_fifo_full_en;
  rand uvm_reg_field tx_fifo_empty_en;
  rand uvm_reg_field rx_fifo_full_en;
  rand uvm_reg_field rx_fifo_empty_en;
  
  function new(string name="i2c_INTEN_reg");
    super.new(name,8,UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    // Create object instance for each field
    rsvd               = uvm_reg_field::type_id::create("rsvd");
    nack_en   = uvm_reg_field::type_id::create("nack_en");
    tx_fifo_full_en   = uvm_reg_field::type_id::create("tx_fifo_full_en");
    tx_fifo_empty_en  = uvm_reg_field::type_id::create("tx_fifo_empty_en");
    rx_fifo_full_en   = uvm_reg_field::type_id::create("rx_fifo_full_en");
    rx_fifo_empty_en  = uvm_reg_field::type_id::create("rx_fifo_empty_en");
    
    // Configure each field
    rsvd.configure(this,3,5,"RO",1'b0,3'b000,1,1,1);
    nack_en.configure(this,1,4,"RW",1'b0,1'b0,1,1,1);
    tx_fifo_full_en.configure(this,1,3,"RW",1'b0,1'b0,1,1,1);
    tx_fifo_empty_en.configure(this,1,2,"RW",1'b0,1'b0,1,1,1);
    rx_fifo_full_en.configure(this,1,1,"RW",1'b0,1'b0,1,1,1);
    rx_fifo_empty_en.configure(this,1,0,"RW",1'b0,1'b0,1,1,1);
  endfunction

endclass
