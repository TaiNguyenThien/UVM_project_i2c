class i2c_CONTROL_reg extends uvm_reg;
  `uvm_object_utils(i2c_CONTROL_reg)

  uvm_reg_field      rsvd;
  rand uvm_reg_field rx_enable;
  rand uvm_reg_field tx_enable;
  rand uvm_reg_field repeat_start;
  rand uvm_reg_field abort;
  rand uvm_reg_field start;

  function new(string name="i2c_CONTROL_reg");
    super.new(name,8,UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    // Create object instance for each field
    rsvd       = uvm_reg_field::type_id::create("rsvd");
    rx_enable    = uvm_reg_field::type_id::create("rx_enable");
    tx_enable       = uvm_reg_field::type_id::create("tx_enable");
    repeat_start = uvm_reg_field::type_id::create("repeat_start");
    abort    = uvm_reg_field::type_id::create("abort");
    start    = uvm_reg_field::type_id::create("start");

    // Configure each field
    rsvd.configure(this,3,5,"RO",1'b0,3'b000,1,1,1);
    rx_enable.configure(this,1,4,"WO",1'b0,1'b0,1,1,1);
    tx_enable.configure(this,1,3,"WO",1'b0,1'b0,1,1,1);
    repeat_start.configure(this,1,2,"RW",1'b0,1'b0,1,1,1);
    abort.configure(this,1,1,"WO",1'b0,1'b0,1,1,1);
    start.configure(this,1,0,"WO",1'b0,1'b0,1,1,1);
  endfunction

endclass

