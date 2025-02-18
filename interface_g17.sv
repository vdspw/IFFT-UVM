// This is the interface block Which contains the variables 

interface interface_g17(input Clk, input Reset);

	logic Pushin;
	logic FirstData;
	logic signed [16:0] DinR;
	logic signed [16:0] DinI;
	logic PushOut;
	logic [47:0] DataOut;
	logic [47:0] Data_In;
  
endinterface
