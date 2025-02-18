//This is the agent class which is used for connecting the various blocks 

class agent_g17 extends uvm_agent;

	`uvm_component_utils(agent_g17)
   
	driver_g17 d;
	sequencer_g17 sr;
	encoder_g17 e;
	ifft_g17 ifft;
	converdata_g17 c;
	   
	function new(string name = "agent_g17", uvm_component parent);
		super.new(name, parent);
	endfunction
		  
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("agent","-->Building Agent",UVM_MEDIUM)
		d = driver_g17::type_id::create("d",this);
		sr = sequencer_g17::type_id::create("sr",this);
		e = encoder_g17::type_id::create("e",this);
		ifft = ifft_g17::type_id::create("ifft",this);
		c = converdata_g17::type_id::create("c", this);
	endfunction
	  	  
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("agent","-->Connecting Agent",UVM_MEDIUM)
		d.seq_item_port.connect(sr.seq_item_export);  // Sequencer to Driver
		d.driver_put.connect(e.erec);                 //Driver to Encoder
		e.esend.connect(ifft.ifftrec);                //Encoder to IFFT Block
		ifft.ifftsend.connect(c.crec);                //IFFT Block to ConvertData
		c.crev.connect(d.fif.analysis_export);        //ConvertData to Driver
	endfunction: connect_phase
	  
endclass : agent_g17
  
