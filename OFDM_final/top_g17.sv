//This is the top module
//By Group 17 - Nischal Dinesh (017268771), Gayatri Rane (017163575), Vishnudeep Pandurangarao (017269330) 

import uvm_pkg::*;
	`include "package_g17.sv" //Calling all the other modules is done in package_g17.sv
import g17_pkg::*;
import uvm_pkg::*;
`include "interface_g17.sv"
	
	module top_g17();
		bit Clk, Reset;
		interface_g17 vir_int(Clk, Reset);

	initial begin
		Clk=0;
		Reset=1;
		#15;
		Reset = 0;
                repeat(600000000) begin
		        #5;
		        Clk = ~Clk;
                end
	end

   	initial begin
	  uvm_config_db #(virtual interface_g17)::set(null,"*","virtual_interface",vir_int);
	  run_test("test_g17");
	end
	
	ofdmdec dut1(
	      .Clk(Clk), 
		.Reset(Reset), 
		.Pushin(vir_int.Pushin), 
		.FirstData(vir_int.FirstData), 
		.DinR(vir_int.DinR), 
		.DinI(vir_int.DinI), 
		.PushOut(vir_int.PushOut), 
		.DataOut(vir_int.DataOut)
	    );
endmodule
