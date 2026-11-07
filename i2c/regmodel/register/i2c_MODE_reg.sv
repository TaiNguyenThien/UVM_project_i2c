class i2c_MODE_reg extends uvm_reg;
  `uvm_object_utils(i2c_MODE_reg)

  uvm_reg_field      rsvd;
  rand uvm_reg_field addr_mode;
  rand uvm_reg_field trx_mode;
  rand uvm_reg_field presc_high;

  function new(string name="i2c_MODE_reg");
    super.new(name,8,UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    // Create object instance for each field
    rsvd       = uvm_reg_field::type_id::create("rsvd");
    addr_mode = uvm_reg_field::type_id::create("addr_mode");
    trx_mode    = uvm_reg_field::type_id::create("trx_mode");
    presc_high    = uvm_reg_field::type_id::create("presc_high");

    // Configure each field
    rsvd.configure(this,3,5,"RO",1'b0,3'b000,1,1,1);
    addr_mode.configure(this,1,4,"RW",1'b0,1'b0,1,1,1);
    trx_mode.configure(this,1,3,"RW",1'b0,1'b0,1,1,1);
    presc_high.configure(this,3,0,"RW",1'b0,3'b000,1,1,1);
  endfunction

endclass

