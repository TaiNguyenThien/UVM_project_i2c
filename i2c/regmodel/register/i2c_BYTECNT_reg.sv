class i2c_BYTECNT_reg extends uvm_reg;
  `uvm_object_utils(i2c_BYTECNT_reg)

  rand uvm_reg_field byte_cnt;

  function new(string name="i2c_BYTECNT_reg");
    super.new(name,8,UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    // Create object instance for each field
    byte_cnt = uvm_reg_field::type_id::create("byte_cnt");

    // Configure each field
    byte_cnt.configure(this,8,0,"RW",1'b0,8'h00,1,1,1);
  endfunction

endclass
