class i2c_PRESC_reg extends uvm_reg;
  `uvm_object_utils(i2c_PRESC_reg)

  rand uvm_reg_field presc;

  function new(string name="i2c_PRESC_reg");
    super.new(name,8,UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    // Create object instance for each field
    presc = uvm_reg_field::type_id::create("presc");

    // Configure each field
    presc.configure(this,8,0,"RW",1'b0,8'h0,1,1,1);
  endfunction

endclass
