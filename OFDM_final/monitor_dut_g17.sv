//This is the monitor out block where the data is sent to scoreboard 

class monitor_dut_g17 extends uvm_monitor;

	`uvm_component_utils(monitor_dut_g17)

	virtual interface_g17 vir_int;
	seqitem_g17 out;
	uvm_analysis_port #(seqitem_g17) mono ;

	function new (string name = "monitor_dut_g17" , uvm_component parent = null);
	    super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
	    super.build_phase(phase);
	    mono = new("mono", this);
	    if(!uvm_config_db#(virtual interface_g17)::get(this, "*", "virtual_interface", vir_int))
	    `uvm_error("monitor","virtual interface failed")
	    out = seqitem_g17::type_id::create("seqitem_g17", this);
	    `uvm_info("monitor", "inside Monitor_out Build Phase ", UVM_MEDIUM)
	endfunction :  build_phase

	virtual task run_phase(uvm_phase phase);
	    super.run_phase(phase);
	    `uvm_info("monitor_dut_g17","Inside Monitor_out Run Phase", UVM_NONE);
	    forever begin
	  	@(posedge vir_int.Clk);   
		    if(vir_int.PushOut == 1)begin
			out.PushOut = vir_int.PushOut;
			out.DataOut = vir_int.DataOut;
			$display("PushOut %0d   <-------->   DataOut %0h", out.PushOut ,out.DataOut);
			mono.write(out); 
		    end
	    end
	endtask : run_phase

endclass:  monitor_dut_g17
