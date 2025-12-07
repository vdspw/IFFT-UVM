//This is the sequence_item block which contains the input and output variables

class seqitem_g17 extends uvm_sequence_item;

	`uvm_object_utils(seqitem_g17)
	 bit Clk;
	 bit Reset;
	 bit Pushin;
	 bit FirstData;
	 reg signed [16:0] DinR;
	 reg signed [16:0] DinI;
	 rand bit [47:0] DataIn;
	 
	 // Outputs
	 bit PushOut;
	 reg [47:0] DataOut;
	 logic  [47:0] DataOut1;
	 real temp[128];
	 reg signed [16:0]  realfp[128];
	 reg signed [16:0]  imgfp[128];
	 
	typedef struct  {
		real re; 
		real im;
		} complex_num;
											    
		complex_num complexout[128],timeout[128];
		   
	function new (string name = "seqitem_g17");    
		super.new(name);
	endfunction: new

endclass : seqitem_g17



