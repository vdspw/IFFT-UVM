//This is package file which consists of all the call for blocks in the order of execution

package g17_pkg;

	import uvm_pkg::*;
		
		`include "seqitem_g17.sv"
		`include "sequence_g17.sv"
		`include "sequencer_g17.sv"
		`include "driver_g17.sv"
		`include "encoder_g17.sv"
		`include "ifft_g17.sv"
		`include "converdata_g17.sv"
		`include "monitor_g17.sv"
		`include "monitor_dut_g17.sv"
		`include "agent_g17.sv"
		`include "fft_g17.sv"
		`include "decoder_g17.sv"
		`include "scoreboard_g17.sv"
		`include "environment_g17.sv"
		`include "test_g17.sv"

endpackage : g17_pkg
