class i2c_repeat_start_test extends i2c_base_test;
  `uvm_component_utils(i2c_repeat_start_test)

  function new(string name="i2c_repeat_start_test", uvm_component parent);
    super.new(name,parent);
  endfunction: new

  virtual task run_phase(uvm_phase phase); 
    bit[31:0] rdata;
    uvm_status_e status;

    phase.raise_objection(this);

    regmodel.WR.write(status, 8'h3C);      // data_in
    repeat(2) @(posedge apb_vif.pclk);

    // ---------------- ADDR ----------------
    regmodel.ADDRL.write(status, 8'h55);
    repeat(2) @(posedge apb_vif.pclk);

    // ---------------- CONTROL: tx_enable ----------------
    regmodel.CONTROL.write(status, 8'h10); // tx_enable=1
    repeat(2) @(posedge apb_vif.pclk);

    // ---------------- MODE ----------------
    regmodel.MODE.write(status, 8'h00); // write
    repeat(2) @(posedge apb_vif.pclk);

    // ---------------- PRESCALER ----------------
    regmodel.PRESC.write(status, 8'd4);
    repeat(5) @(posedge apb_vif.pclk);

    // ---------------- START ----------------
    regmodel.CONTROL.write(status, 8'h19); // start=1, tx_enable=1 , repeat_start=1
    repeat(2) @(posedge apb_vif.pclk);

    regmodel.CONTROL.write(status, 8'h09); // tx_enable=0

    // ---------------- WAIT I2C DONE ----------------
    repeat(150) @(posedge apb_vif.pclk);
    // ---------------- MODE ----------------
    regmodel.MODE.write(status, 8'h08); // read
    repeat(2) @(posedge apb_vif.pclk);

    repeat(200) @(posedge apb_vif.pclk);
    
    regmodel.CONTROL.write(status, 8'h00); // tx_enable=0, repeat_start=0
    
    repeat(30) @(posedge apb_vif.pclk);
    
      
    phase.drop_objection(this);
  endtask

endclass
