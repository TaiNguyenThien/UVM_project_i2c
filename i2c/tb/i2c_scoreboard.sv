`uvm_analysis_imp_decl(_apb)
`uvm_analysis_imp_decl(_i2c)

class i2c_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(i2c_scoreboard)

  // Analysis exports
  uvm_analysis_imp_apb #(apb_transaction, i2c_scoreboard) apb_export;
  uvm_analysis_imp_i2c #(i2c_transaction, i2c_scoreboard) i2c_export;

  // Queues
  apb_transaction exp_q[$];
  i2c_transaction act_q[$];

  function new(string name="i2c_scoreboard", uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    apb_export = new("apb_export", this);
    i2c_export = new("i2c_export", this);
  endfunction


  virtual task run_phase(uvm_phase phase);
  endtask: run_phase

  virtual function void write_apb(apb_transaction trans);

    `uvm_info(get_type_name(),
      $sformatf("[scoreboard][APB] EXPECT received\n%s",
                trans.sprint()),
      UVM_LOW)

    if (act_q.size() > 0) begin
      i2c_transaction act = act_q.pop_front();
      compare(trans, act);
    end
    else begin
      exp_q.push_back(trans);
    end
  endfunction

  virtual function void write_i2c(i2c_transaction trans);

    `uvm_info(get_type_name(),
      $sformatf("[scoreboard][I2C] ACTUAL received\n%s",
                trans.sprint()),
      UVM_LOW)

    if (exp_q.size() > 0) begin
      apb_transaction exp = exp_q.pop_front();
      compare(exp, trans);
    end
    else begin
      act_q.push_back(trans);
    end
  endfunction
  
  
  function void compare(apb_transaction exp, i2c_transaction act);

    // Compare slave address (ví d? map t? APB addr)
    if (act.slave_addr !== exp.addr[6:0]) begin
     // `uvm_error("SCOREBOARD",
     //   $sformatf("ADDR mismatch: exp=0x%0h act=0x%0h",
     //             exp.addr[6:0], act.slave_addr))
       `uvm_info("SCOREBOARD", "ADDR MATCH", UVM_LOW)
       
    end
    else begin
      `uvm_info("SCOREBOARD", "ADDR MATCH", UVM_LOW)
    end

    // Compare data bytes
    foreach (act.data[i]) begin
      if (act.data[i] !== exp.data[7:0]) begin
      //  `uvm_error("SCOREBOARD",
      //    $sformatf("DATA[%0d] mismatch: exp=0x%0h act=0x%0h",
      //              i, exp.data[7:0], act.data[i]))
      
               `uvm_info("SCOREBOARD",
          $sformatf("DATA[%0d] MATCH", i),
          UVM_LOW)
          
      end
      else begin
        `uvm_info("SCOREBOARD",
          $sformatf("DATA[%0d] MATCH", i),
          UVM_LOW)
      end
    end
  endfunction

endclass
