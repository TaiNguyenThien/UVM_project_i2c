class i2c_ADDRH_reg extends uvm_reg;
  `uvm_object_utils(i2c_ADDRH_reg)
  uvm_reg_field      rsvd;
  rand uvm_reg_field addrh;

  function new(string name="i2c_ADDRH_reg");
    super.new(name,8,UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    // Create object instance for each field
    rsvd       = uvm_reg_field::type_id::create("rsvd");
    addrh = uvm_reg_field::type_id::create("addrh");

    // Coinfigure each field
    rsvd.configure(this,5,3,"RO",1'b0,5'h00,1,1,1);
    addrh.configure(this,3,0,"RW",1'b0,3'b000,1,1,1);
  endfunction

endclass
