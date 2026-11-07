class i2c_transaction extends uvm_sequence_item;

  bit [6:0] slave_addr;
  bit       rw;

  bit       addr_ack;
  bit [7:0] data[$];
  bit       data_ack[$];

  `uvm_object_utils(i2c_transaction)

  function new(string name = "i2c_transaction");
    super.new(name);
  endfunction

endclass