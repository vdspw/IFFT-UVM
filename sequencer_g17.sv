//This is the sequencer class 

class sequencer_g17 extends uvm_sequencer # (seqitem_g17);

	`uvm_component_utils(sequencer_g17)

	function new (string name = "sequencer_g17", uvm_component par = null);
		super.new(name, par);
		`uvm_info("Sequencer","Sequencer Constructor Created", UVM_MEDIUM) 
	endfunction : new

endclass :sequencer_g17
