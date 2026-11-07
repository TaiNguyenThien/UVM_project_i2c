class i2c_RD_reg extends uvm_reg;
  `uvm_object_utils(i2c_RD_reg)

  rand uvm_reg_field rx_fifo;

  function new(string name="i2c_RD_reg");
    super.new(name,8,UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    // Create object instance for each field
    rx_fifo = uvm_reg_field::type_id::create("rx_fifo");

    // Configure each field
    rx_fifo.configure(this,8,0,"RO",1'b1,8'h00,1,1,1);
  endfunction

endclass
