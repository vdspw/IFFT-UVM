//This is the scoreboard class which checks if the code is running correctly and if not throws error. 

class scoreboard_g17 extends uvm_scoreboard;
	`uvm_component_utils(scoreboard_g17)
	uvm_tlm_analysis_fifo #(seqitem_g17) score;

	function new (string name = "scoreboard_g17", uvm_component par);
		super.new(name,par);
	endfunction: new

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);  
		score = new("score", this);
		`uvm_info("score"," Inside Scoreboard Build Phase " , UVM_MEDIUM);
	  
	endfunction: build_phase

	task run_phase(uvm_phase phase);
		seqitem_g17 dec1;
		seqitem_g17 out;
		forever begin
			score.get(dec1);
			score.get(out);
			if (dec1.DataOut1 != out.DataOut) begin
				`uvm_error("MISMATCH", $sformatf("Expected: %h, Actual: %h", dec1.DataOut1, out.DataOut));
			end
			else begin
				`uvm_info("SUCCESS", $sformatf("Expected: %h, Actual: %h", dec1.DataOut1, out.DataOut), UVM_MEDIUM);
			end
		end
	endtask

endclass : scoreboard_g17
