class i2c_monitor extends uvm_monitor;
  `uvm_component_utils(i2c_monitor)
 /* Analysis port send trans to scoreboard*/
  uvm_analysis_port #(i2c_transaction) item_observed_port;
  virtual i2c_if vif;
  function new(string name="i2c_monitor", uvm_component parent);
    super.new(name,parent);
    item_observed_port = new("item_observed_port",this);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      if (!uvm_config_db#(virtual i2c_if)::get(this, "", "vif", vif))
      `uvm_fatal("I2C_MON", "Cannot get i2c_if")
  endfunction: build_phase

  virtual task run_phase(uvm_phase phase);
  i2c_transaction tr;
  byte byte_data;
  bit  ack;

  forever begin
    @(negedge vif.sda iff (vif.scl == 1));

    tr = i2c_transaction::type_id::create("tr");
    tr.data.delete();

    // Address + R/W
    byte_data = 0;
    for (int i = 7; i >= 0; i--) begin
      @(posedge vif.scl);
      byte_data[i] = vif.sda;
    end
    tr.slave_addr = byte_data[7:1];
    tr.rw         = byte_data[0];

    // ACK
    @(posedge vif.scl);
    ack = ~vif.sda;
    tr.addr_ack = ack;

    // Data bytes
    while (1) begin
      byte_data = 0;
      for (int i = 7; i >= 0; i--) begin
        @(posedge vif.scl);
        byte_data[i] = vif.sda;
      end

      tr.data.push_back(byte_data);

      @(posedge vif.scl);
      ack = ~vif.sda;
      tr.data_ack.push_back(ack);

      if (!ack) break;
      if (vif.scl && vif.sda) break;
    end

    item_observed_port.write(tr);
  end
endtask


endclass: i2c_monitor

