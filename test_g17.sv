//This is the test class which builds the sequence and environment (testbench)

class test_g17 extends uvm_test;
	
	`uvm_component_utils(test_g17)
	environment_g17 env;
	sequence_g17 seq;
	function new (string name ="test_g17", uvm_component parent =  null);
		super.new(name,parent);
		`uvm_info("test","Test Constructor Created", UVM_MEDIUM)
	endfunction: new
	
	function void build_phase( uvm_phase phase);
		super.build_phase(phase);
		env =  environment_g17::type_id::create("environment",this);
		seq = sequence_g17::type_id::create("seq");
		`uvm_info("test","Inside test build phase",UVM_MEDIUM)
	endfunction : build_phase
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		$display("Inside run_phase");
		phase.raise_objection(this);
		seq.start(env.Agent.sr);
		phase.drop_objection(this);
		`uvm_info("test","Inside test run phase",UVM_MEDIUM)
	endtask : run_phase

endclass : test_g17
