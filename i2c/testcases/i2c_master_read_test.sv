class i2c_master_read_test extends i2c_base_test;
  `uvm_component_utils(i2c_master_read_test)

  function new(string name="i2c_master_read_test", uvm_component parent);
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
    regmodel.MODE.write(status, 8'h08);
    repeat(2) @(posedge apb_vif.pclk);

    // ---------------- PRESCALER ----------------
    regmodel.PRESC.write(status, 8'd4);
    repeat(5) @(posedge apb_vif.pclk);

    // ---------------- START ----------------
    regmodel.CONTROL.write(status, 8'h11); // start=1, tx_enable=1
    repeat(2) @(posedge apb_vif.pclk);

    regmodel.CONTROL.write(status, 8'h00); // tx_enable=0

    // ---------------- WAIT I2C DONE ----------------
    repeat(180) @(posedge apb_vif.pclk);

    // ---------------- CHECK RESULT ----------------
    regmodel.RD.read(status, rdata);

    if (rdata == 32'hA5)
      `uvm_info("I2C_WRITE", "PASSED Write", UVM_LOW)
    else
      `uvm_error("I2C_WRITE", $sformatf("FAILED Write: read=0x%0h", rdata))
    repeat(50) @(posedge apb_vif.pclk);
      
    phase.drop_objection(this);
  endtask

endclass
