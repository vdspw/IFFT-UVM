//This is the encoder block 

class encoder_g17 extends uvm_component; // creating the class and declaring it as uvm_component 
	`uvm_component_utils(encoder_g17)    // factory registration to use UVM features
	
	seqitem_g17 enc;
	uvm_blocking_put_port #(seqitem_g17) esend;  // put port to send the transactions to downstream IFFT block 
	uvm_blocking_put_imp #(seqitem_g17, encoder_g17) erec;  // put implementation port to recive the transaction from driver.
    	
	function new(string name="encoder_g17", uvm_component parent = null); // constructor for the encoder class
		super.new(name, parent);
	endfunction;

	function void build_phase(uvm_phase phase);  // BUILD PHASE
		super.build_phase(phase);
		erec=new("erec", this); // building the ports
		esend=new("esend",this); // building the ports
		enc=new("enc");  // building this component of seq_item 
	endfunction
	
	task run_phase(uvm_phase phase);  // RUN PHASE
		super.run_phase(phase);
	endtask:run_phase
	
	real amp[0:3] = '{0.0,0.333,0.666,1.0}; // 4 amplitude levels 

	virtual task put(ref seqitem_g17 enc1);  // operate as sson as u recive something from the enc1 
		$display("Encoding Stage Begins ------");
		$display("Data Input: %0h", enc1.DataIn);
		encoding(enc1); // encoding function 
		esend.put(enc1);  // sending to the IFFT block 
		for(int i=0;i<128;i++) begin
			//$display("encoder out = %f", enc1.complexout[i].re);
		end
	endtask
	
	virtual function void encoding(seqitem_g17 enc1);
		bit [47:0] data = enc1.DataIn; // making a local copy of the data 48 bits
		int fbin = 4; // start the bin no. from 4 as 0,1,2,3, are reserved 
		int x,y,z;  // to run the loops
		
		typedef struct{  // usng struct to respresent the complex numbers 
		real re; // real prt
		real im; // imaginary part
		}complexvalue;
		
		complexvalue complex[128]; // array or buffer of 128 size
		
		foreach(complex[x]) begin // initializing all the elements to zero 
		   complex[x].re = 0;
		   complex[x].im = 0;
		end
			
		for (fbin=4; fbin<52; fbin+=2) begin
			int idx = data[1:0]; // extracting the lower 2 bits -- which will be either 00, 01,10 ,11
			real xx = amp[idx]; // the ampiltude index puts the bits 00, 01 ,10 ,11 in the xx variable
			data = data>>2; // shift right to get rid of the used data.
			complex[fbin].re = xx; // place the amplitude level on the bins
			complex[128-fbin].re = xx; // place the amplitude level on the bins -- symmetry 
		end
		
		complex[55].re=1.0; // reserved (PILOT) signals always 1
		complex[128-55].re=1.0; // symmetry is followed and its always 1 
		
		for (y=0;y<128; y++) begin
			enc1.complexout[y].re = complex[y].re;  // return the real part 
			enc1.complexout[y].im = complex[y].im;   // return the imaginary part
		end
		// the results returned here are stroed in the encoder object enc1 which flows down stream through TLM ports
	endfunction
		
endclass : encoder_g17
