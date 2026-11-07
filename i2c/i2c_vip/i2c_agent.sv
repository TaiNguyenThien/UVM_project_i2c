class i2c_agent extends uvm_agent;
  `uvm_component_utils(i2c_agent)

  virtual i2c_if vif;
  i2c_monitor monitor;

  function new(string name="i2c_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get virtual interface
    if (!uvm_config_db#(virtual i2c_if)::get(this,"","vif", vif))
      `uvm_fatal(get_type_name(), "Failed to get i2c_if")

    // Always PASSIVE
    is_active = UVM_PASSIVE;

    monitor = i2c_monitor::type_id::create("monitor", this);

    // Pass vif to monitor
    uvm_config_db#(virtual i2c_if)::set(this,"monitor","vif", vif);
  endfunction

endclass : i2c_agent
