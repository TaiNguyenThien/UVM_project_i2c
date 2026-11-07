class i2c_WR_reg extends uvm_reg;
  `uvm_object_utils(i2c_WR_reg)

  rand uvm_reg_field tx_fifo;

  function new(string name="i2c_WR_reg");
    super.new(name,8,UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    // Create object instance for each field
    tx_fifo = uvm_reg_field::type_id::create("tx_fifo");

    // Configure each field
    tx_fifo.configure(this,8,0,"WO",1'b1,8'h00,1,1,1);
  endfunction

endclass
