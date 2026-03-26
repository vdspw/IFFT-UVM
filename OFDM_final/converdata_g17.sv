// Converdata function is used for converting real value to fixedpoint and then to integer using Real to Integer.

class converdata_g17 extends uvm_component;  // class converter and ake it into uvm_component

	`uvm_component_utils(converdata_g17) // uvm factory registration 
	uvm_blocking_put_imp #(seqitem_g17, converdata_g17) crec;  // put_imp port to reciven tha data
	uvm_analysis_port #(seqitem_g17) crev; // analysis port to broadcast the data to more components in this case driver
	
	function new(string name = "converdata_g17", uvm_component parent = null); //constructor
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase); // build phase
		super.build_phase(phase);
		crec = new("crec", this);  // ports reciving 
		crev=new("crev", this);  // ports broadcasting
	endfunction
	
	virtual task put(ref seqitem_g17 mi);  // put method 
		converdata(mi); //calling the convert function 
		crev.write(mi); // write method as its an analysis port
	endtask
	
	function converdata(seqitem_g17 mi); // the input is the seqitem mi
		int x; // to run the loop 
		int nfract = 15; // defines tehformat Q1.15 (max value 32768) 
		real realtemp_a[128], imgtemp_a[128]; // to stroe the real numbers 
		int realtemp_b[128], imgtemp_b[128];  // to stare the converted integer values

		for (x = 0; x < 128; x++) begin
			realtemp_a[x] = mi.timeout[x].re * (2 ** nfract); // ifft data multiplied by 32767
			imgtemp_a[x] = mi.timeout[x].im * (2 ** nfract);  // ifft data multiplied by 32767
			realtemp_b[x] = $rtoi(realtemp_a[x]);  // conversion from real to integer 
			imgtemp_b[x] = $rtoi(imgtemp_a[x]);   // conversion from real to integer
			mi.realfp[x] = realtemp_b[x];  // put it in the seq_item (mi) -- real
			mi.imgfp[x] = imgtemp_b[x];   // put it in the seq_item(mi) -- imaginary
		end
		
		for (x=0;x<128;x++) begin
			//$display("mi.realfp[x] = %f , mi.imgfp[x] = %f", mi.realfp[x], mi.imgfp[x]);
		end
	endfunction : converdata
	
endclass : converdata_g17
