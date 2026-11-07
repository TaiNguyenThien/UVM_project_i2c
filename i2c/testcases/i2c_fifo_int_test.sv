class i2c_fifo_int_test extends i2c_base_test;
  `uvm_component_utils(i2c_fifo_int_test)

  function new(string name="i2c_fifo_int_test", uvm_component parent);
    super.new(name,parent);
  endfunction: new

  virtual task run_phase(uvm_phase phase); 
    bit[31:0] rdata;
    uvm_status_e status;

    phase.raise_objection(this);
    
    regmodel.INTEN.write(status, 8'h04); // tx_fifo_empty_en
    repeat(2) @(posedge apb_vif.pclk);


    // ===============================
    // Clear EMPTY interrupt (W1C)
    // ===============================
    regmodel.INTSTA.write(status, 8'h04);
    repeat(2) @(posedge apb_vif.pclk);



    // Disable interrupt
    regmodel.INTEN.write(status, 8'h00);

    // ===============================
    // I2C config
    // ===============================
    regmodel.ADDRL.write(status, 8'h55);
    regmodel.PRESC.write(status, 8'd4);

    // ===============================
    // Push 4 bytes into TX FIFO
    // ===============================
    repeat (4) begin
      regmodel.WR.write(status, $random);

      regmodel.CONTROL.write(status, 8'h10); // tx_enable
      repeat(2) @(posedge apb_vif.pclk);
      regmodel.CONTROL.write(status, 8'h00);
      repeat(2) @(posedge apb_vif.pclk);
    end

    // ===============================
    // Enable TX FIFO FULL interrupt
    // ===============================
    regmodel.INTEN.write(status, 8'h08); // tx_fifo_full_en
    repeat(2) @(posedge apb_vif.pclk);



    // ===============================
    // Clear FULL interrupt (W1C)
    // ===============================
    regmodel.INTSTA.write(status, 8'h08);
    repeat(10) @(posedge apb_vif.pclk);

      
    phase.drop_objection(this);
  endtask

endclass
