//This is the monitor in class which is at the sending stage

class monitor_g17 extends uvm_monitor;

	`uvm_component_utils(monitor_g17)
	virtual interface_g17 vif;
	seqitem_g17 mes;
	//uvm_analysis_port #(seqitem_g17) moni ;

	function new (string name = "monitor_g17" , uvm_component parent = null);
	super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase); 
		//moni = new("moni", this);
		if(!uvm_config_db#(virtual interface_g17)::get(this, "*", "virtual_interface", vif))
		  `uvm_error("monitor","virtual int failed")
		`uvm_info("Monitor", "Inside Monitor Build Phase", UVM_MEDIUM)
		 mes = seqitem_g17::type_id::create("seqitem_g17", this);
	endfunction :  build_phase


	virtual task run_phase(uvm_phase phase);
		 super.run_phase(phase);
		 `uvm_info("Monitor","Inside Monitor Run Phase", UVM_NONE);
		    
		forever begin
		  	@(posedge vif.Clk);   
			  if(vif.Pushin == 1)
			      begin
				#20;
				mes.FirstData = vif.FirstData;
				mes.DinI = vif.DinI;
				mes.DinR = vif.DinR;
				//$display("Data Real %0d firstdata %0d", mes.DinR , mes.FirstData);
				//moni.write(mes); 
			      end
		end
	endtask: run_phase

endclass:  monitor_g17 
