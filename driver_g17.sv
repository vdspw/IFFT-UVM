//This is the driver block
/* Functions of this block :
1. get the transaction from sequencer.
2. launch encoder -> IFFT -> covert data chain.
3. launch FFT refenrece model chain.
4. wait for coverted fixed point samples -> drive these onto the DYT */

class driver_g17 extends uvm_driver #(seqitem_g17);  

	`uvm_component_utils(driver_g17)
	seqitem_g17 mes1;
	uvm_blocking_put_port #(seqitem_g17) driver_put; // sends transaction to encoder
	uvm_blocking_put_port #(seqitem_g17) fft_send; // sends transaction to referecne FFT path
	uvm_tlm_analysis_fifo #(seqitem_g17) fif; // recives back the processed transaction from convert data.
	
	virtual interface_g17 vir_int; // instance of the interface.

	function new (string name = "driver_g17", uvm_component parent = null);
	    super.new(name, parent);
	    `uvm_info("Driver", "-->Driver Constructor Created", UVM_MEDIUM)
	endfunction : new

	function void build_phase(uvm_phase phase);  
	    super.build_phase(phase);
		driver_put = new("driver_put", this); // creating the port 
		fif = new("fif", this);  // creating the FIFO
		fft_send = new("fft_send", this); // creating the port
		mes1 = new("mes1"); // transaction object
	    // getting the virtual interface from the top module
	    if (!uvm_config_db#(virtual interface_g17)::get(this, "*", "virtual_interface", vir_int))
		`uvm_error("Driver", "Failed to get data!")
	endfunction: build_phase

	task run_phase(uvm_phase phase);
	    super.run_phase(phase);

	    forever begin
		    int i;
			seq_item_port.get_next_item(mes1); // driver recives one randomized transaction 
			driver_put.put(mes1); // send the transaction to encoder 
			fft_send.put(mes1); // send the transaction to FFT referecne model
			fif.get(mes1); // wait till the covertdata retruns the fixed point samples

		    mes1.FirstData = 1; // marks start of the frame
		    mes1.Pushin= 1; // marks the valid input

			for(i = 0; i < 128; i++) begin  // for each time domain samples
		    	#5;
				mes1.DinR = mes1.realfp[i]; // take fiexedpoint sample and drive to Din R
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
