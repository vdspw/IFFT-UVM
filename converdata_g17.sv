// Converdata function is used for converting real value to fixedpoint and then to integer using Real to Integer.

class converdata_g17 extends uvm_component;

	`uvm_component_utils(converdata_g17)
	uvm_blocking_put_imp #(seqitem_g17, converdata_g17) crec; 
	uvm_analysis_port #(seqitem_g17) crev;
	
	function new(string name = "converdata_g17", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		crec = new("crec", this); 
		crev=new("crev", this);
	endfunction
	
	virtual task put(ref seqitem_g17 mi);
               	converdata(mi);
		crev.write(mi);
	endtask
	
	function converdata(seqitem_g17 mi);
		int x;
		int nfract = 15;
		real realtemp_a[128], imgtemp_a[128];
		int realtemp_b[128], imgtemp_b[128];

		for (x = 0; x < 128; x++) begin
			realtemp_a[x] = mi.timeout[x].re * (2 ** nfract);
			imgtemp_a[x] = mi.timeout[x].im * (2 ** nfract);
			realtemp_b[x] = $rtoi(realtemp_a[x]);
			imgtemp_b[x] = $rtoi(imgtemp_a[x]);
			mi.realfp[x] = realtemp_b[x];
			mi.imgfp[x] = imgtemp_b[x];
		end
		
		for (x=0;x<128;x++) begin
			//$display("mi.realfp[x] = %f , mi.imgfp[x] = %f", mi.realfp[x], mi.imgfp[x]);
		end
	endfunction : converdata
	
endclass : converdata_g17
