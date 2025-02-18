// This is the environment block where we are connecting the different blocks of the OFDM 

class environment_g17 extends uvm_env;
	
	`uvm_component_utils(environment_g17)
	agent_g17 Agent;
	scoreboard_g17 ScoreB;
	monitor_dut_g17 MOut;
	monitor_g17 MIn;
	fft_g17 fftref;
	decoder_g17 dec;

	function new (string name = "environment_g17", uvm_component parent = null);
		super.new( name,parent);
	endfunction :  new

	function void build_phase (uvm_phase phase);
	  	super.build_phase(phase);
		`uvm_info("Environment","-------> Environment Building " , UVM_MEDIUM);
		Agent = agent_g17::type_id::create("Agent",this);
		MOut = monitor_dut_g17::type_id::create("MOut", this);
		MIn = monitor_g17::type_id::create("MIn", this);
		ScoreB = scoreboard_g17::type_id::create ("ScoreB", this);
		fftref = fft_g17::type_id::create("fftref",this);
		dec = decoder_g17::type_id::create("dec", this);
		uvm_top.print_topology();
	endfunction: build_phase

	function void connect_phase (uvm_phase phase);
		`uvm_info("Message from Env","-------> Environment Connecting" , UVM_MEDIUM);
		
		//MIn.moni.connect(ScoreB.scorebrd_rec);
		Agent.d.fft_send.connect(fftref.fft_rec);
		fftref.ffts.connect(dec.drec);
		dec.dsend.connect(ScoreB.score.analysis_export);
		MOut.mono.connect(ScoreB.score.analysis_export);
	endfunction : connect_phase
	
endclass : environment_g17
