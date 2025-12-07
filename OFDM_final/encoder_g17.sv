//This is the encoder block 

class encoder_g17 extends uvm_component;
	`uvm_component_utils(encoder_g17)
	
	seqitem_g17 enc;
	uvm_blocking_put_port #(seqitem_g17) esend;
    	uvm_blocking_put_imp #(seqitem_g17, encoder_g17) erec; 
    	
	function new(string name="encoder_g17", uvm_component parent = null);
		super.new(name, parent);
	endfunction;

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		erec=new("erec", this);
		esend=new("esend",this);
		enc=new("enc");
	endfunction
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
	endtask:run_phase
	
	real amp[0:3] = '{0.0,0.333,0.666,1.0};

	virtual task put(ref seqitem_g17 enc1);
		$display("Encoding Stage Begins ------");
		$display("Data Input: %0h", enc1.DataIn);
		encoding(enc1);
		esend.put(enc1);
		for(int i=0;i<128;i++) begin
			//$display("encoder out = %f", enc1.complexout[i].re);
		end
	endtask
	
	virtual function void encoding(seqitem_g17 enc1);
		bit [47:0] data = enc1.DataIn;
		int fbin = 4;
		int x,y,z;
		
		typedef struct{
		real re; 
		real im;
		}complexvalue;
		
		complexvalue complex[128];
		
		foreach(complex[x]) begin
		   complex[x].re = 0;
		   complex[x].im = 0;
		end
			
		for (fbin=4; fbin<52; fbin+=2) begin
			int idx = data[1:0];
			real xx = amp[idx];
			data = data>>2;
			complex[fbin].re = xx;
			complex[128-fbin].re = xx;
		end
		
		complex[55].re=1.0;
		complex[128-55].re=1.0;
		
		for (y=0;y<128; y++) begin
			enc1.complexout[y].re = complex[y].re;
			enc1.complexout[y].im = complex[y].im;
		end
		
	endfunction
		
endclass : encoder_g17
