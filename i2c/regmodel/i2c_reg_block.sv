class i2c_reg_block extends uvm_reg_block;
  `uvm_object_utils(i2c_reg_block)

  rand i2c_WR_reg  WR;
  rand i2c_RD_reg  RD;
  rand i2c_ADDRL_reg ADDRL;
  rand i2c_ADDRH_reg ADDRH;
  rand i2c_CONTROL_reg  CONTROL;
  rand i2c_BYTECNT_reg  BYTECNT;
  rand i2c_MODE_reg  MODE;
  rand i2c_PRESC_reg  PRESC;
  rand i2c_INTSTA_reg  INTSTA; 
  rand i2c_INTEN_reg  INTEN; 
  uvm_reg_map apb_map;

  function new(string name="i2c_reg_block");
    super.new(name,UVM_NO_COVERAGE);
  endfunction

  virtual function void build();
    WR = i2c_WR_reg::type_id::create("WR");
    WR.configure(this);
    WR.build();

    RD = i2c_RD_reg::type_id::create("RD");
    RD.configure(this);
    RD.build();
       
    ADDRL = i2c_ADDRL_reg::type_id::create("ADDRL");
    ADDRL.configure(this);
    ADDRL.build();
    
    ADDRH = i2c_ADDRH_reg::type_id::create("ADDRH");
    ADDRH.configure(this);
    ADDRH.build();
   
    CONTROL = i2c_CONTROL_reg::type_id::create("CONTROL");
    CONTROL.configure(this);
    CONTROL.build();
    
    BYTECNT = i2c_BYTECNT_reg::type_id::create("BYTECNT");
    BYTECNT.configure(this);
    BYTECNT.build();
   
    MODE = i2c_MODE_reg::type_id::create("MODE");
    MODE.configure(this);
    MODE.build();

    PRESC = i2c_PRESC_reg::type_id::create("PRESC");
    PRESC.configure(this);
    PRESC.build();

    INTSTA = i2c_INTSTA_reg::type_id::create("INTSTA");
    INTSTA.configure(this);
    INTSTA.build();    

    INTEN = i2c_INTEN_reg::type_id::create("INTEN");
    INTEN.configure(this);
    INTEN.build();
    
    apb_map = create_map("apb_map",'h0,4,UVM_LITTLE_ENDIAN);

    apb_map.add_reg(WR,12'h00, "WO");
    apb_map.add_reg(RD,12'h04, "RO");
    apb_map.add_reg(ADDRL,12'h08, "RW");
    apb_map.add_reg(ADDRH,12'h0C, "RW");
    apb_map.add_reg(CONTROL,12'h10, "WO");
    apb_map.add_reg(BYTECNT,12'h14, "RW");
    apb_map.add_reg(MODE,12'h18, "RW");
    apb_map.add_reg(PRESC,12'h1C, "RW"); 
    apb_map.add_reg(INTSTA,12'h20, "RW");
    apb_map.add_reg(INTEN,12'h24, "RW");
    
    lock_model();
  endfunction

endclass

