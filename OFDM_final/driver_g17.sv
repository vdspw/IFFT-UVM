//This is the driver block

class driver_g17 extends uvm_driver #(seqitem_g17);  

	`uvm_component_utils(driver_g17)
	seqitem_g17 mes1;
	uvm_blocking_put_port #(seqitem_g17) driver_put;
	uvm_blocking_put_port #(seqitem_g17) fft_send;
	uvm_tlm_analysis_fifo #(seqitem_g17) fif;
	
	virtual interface_g17 vir_int;

	function new (string name = "driver_g17", uvm_component parent = null);
	    super.new(name, parent);
	    `uvm_info("Driver", "-->Driver Constructor Created", UVM_MEDIUM)
	endfunction : new

	function void build_phase(uvm_phase phase);
	    super.build_phase(phase);
	    driver_put = new("driver_put", this);
	    fif = new("fif", this);
	    fft_send = new("fft_send", this);
	    mes1 = new("mes1");
	    
	    if (!uvm_config_db#(virtual interface_g17)::get(this, "*", "virtual_interface", vir_int))
		`uvm_error("Driver", "Failed to get data!")
	endfunction: build_phase

	task run_phase(uvm_phase phase);
	    super.run_phase(phase);

	    forever begin
		    int i;
		    seq_item_port.get_next_item(mes1);
		    driver_put.put(mes1);
		    fft_send.put(mes1);
		    fif.get(mes1);

		    mes1.FirstData = 1; 
		    mes1.Pushin= 1;

		    for(i = 0; i < 128; i++) begin
		    	#5;
			mes1.DinR = mes1.realfp[i];
		    	if (i < 128)  begin
		    		vir_int.Data_In = mes1.DataIn;
				vir_int.Pushin = mes1.Pushin;
				vir_int.DinR <= mes1.DinR;
				vir_int.DinI <= 0;    
				vir_int.FirstData = mes1.FirstData;
		   	end  
			@ (posedge vir_int.Clk); 
			#1;
		    end
			mes1.FirstData = 0;
			mes1.Pushin = 0;
			vir_int.Pushin = mes1.Pushin;
			vir_int.FirstData = mes1.FirstData;
			#5000;
			seq_item_port.item_done();
	    end
	endtask
		   
endclass: driver_g17
