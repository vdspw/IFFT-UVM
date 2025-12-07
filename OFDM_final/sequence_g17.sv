//This is sequencer class 

class sequence_g17 extends uvm_sequence#(seqitem_g17);

  `uvm_object_utils(sequence_g17)
  seqitem_g17 msg;
   
  function new(string name = "sequence_g17");
    super.new(name);
    `uvm_info("Sequence","Sequence Constructor Created", UVM_MEDIUM);
  endfunction
  
  virtual task body();
	msg = seqitem_g17::type_id::create("msg");
	
	repeat(60000) begin
		start_item(msg);
		msg.randomize();
		$display("----> DataIn = %0h" ,msg.DataIn);
		finish_item(msg);
	end
    #13000; //Time delay to adjust the clocks to allow all data to come out
	`uvm_info("sequence","Sequence Running Successfully", UVM_MEDIUM);
  endtask

endclass :  sequence_g17
