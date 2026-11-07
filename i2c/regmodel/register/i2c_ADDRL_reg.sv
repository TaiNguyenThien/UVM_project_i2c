class i2c_ADDRL_reg extends uvm_reg;
  `uvm_object_utils(i2c_ADDRL_reg)
  uvm_reg_field      rsvd;
  rand uvm_reg_field addrl;

  function new(string name="i2c_ADDRL_reg");
    super.new(name,8,UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    // Create object instance for each field
    rsvd       = uvm_reg_field::type_id::create("rsvd");
    addrl = uvm_reg_field::type_id::create("addrl");

    // Coinfigure each field
    rsvd.configure(this,1,7,"RO",1'b0,1'b0,1,1,1);
    addrl.configure(this,7,0,"RW",1'b0,7'h00,1,1,1);
  endfunction

endclass
