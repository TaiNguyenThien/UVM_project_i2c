class i2c_environment extends uvm_env;
  `uvm_component_utils(i2c_environment)

  virtual apb_if  apb_vif;
  apb_agent       apb_agt;
  i2c_agent        i2c_agt;
  i2c_scoreboard   sb;
  virtual i2c_if   i2c_vif;

  i2c_reg_block        regmodel;
  i2c_reg2apb_adapter  apb_adapter;

  // Predictor class creation
  uvm_reg_predictor #(apb_transaction) apb_predictor;

  function new(string name="i2c_environment", uvm_component parent);
    super.new(name,parent);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_if)::get(this,"","apb_vif",apb_vif))
      `uvm_fatal(get_type_name(),$sformatf("Failed to get apb_vif from uvm_config_db"))
      
    if(!uvm_config_db#(virtual i2c_if)::get(this,"","i2c_vif",i2c_vif))
      `uvm_fatal(get_type_name(),"Failed to get i2c_vif") 
      
    apb_agt = apb_agent::type_id::create("apb_agt",this);
    i2c_agt = i2c_agent::type_id::create("i2c_agt",this);
    sb = i2c_scoreboard::type_id::create("sb", this);
    
    uvm_config_db#(virtual apb_if)::set(this,"apb_agt","apb_if",apb_vif);
    uvm_config_db#(virtual i2c_if)::set(this,"i2c_agt","vif",i2c_vif);
    
    uvm_config_db#(uvm_active_passive_enum)::set(
    this,"i2c_agt","is_active",UVM_PASSIVE
    );
    
    apb_adapter = i2c_reg2apb_adapter::type_id::create("apb_adapter");
    regmodel = i2c_reg_block::type_id::create("regmodel",this);
    regmodel.build();

    apb_predictor = uvm_reg_predictor#(apb_transaction)::type_id::create("apb_predictor",this);

  endfunction: build_phase
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(regmodel.get_parent() == null)
      regmodel.apb_map.set_sequencer(apb_agt.sequencer, apb_adapter);
    
    // Predictor connection
    apb_predictor.map = regmodel.apb_map;
    apb_predictor.adapter = apb_adapter;
    apb_agt.monitor.item_observed_port.connect(apb_predictor.bus_in);
    
    // Connect monitor to scoreboard
    apb_agt.monitor.item_observed_port.connect(sb.apb_export);
    i2c_agt.monitor.item_observed_port.connect(sb.i2c_export);
  endfunction: connect_phase

endclass
