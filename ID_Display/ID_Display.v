module ID_Display(

	input wire CLOCK_50,
	input wire [9:0] SW,
	output wire [3:0] LEDR

);

wire [3:0] Numeral;
wire [2:0] Q;
wire Rollover;

ID_Numeral id_numeral_inst (
	
	.Numeral(Numeral), 
	.Position(Q)

);

Counter_3bit counter_3bit_inst (

	.clk(CLOCK_50),
	.Enable(Enable),
	.Reset(SW[0]),
	.Q(Q)

);

Timer_1s timer_1s_inst (

	.clk(CLOCK_50),
	.Reset(SW[0]),
	.count(count),
	.Rollover(Rollover)

);

assign Enable = Rollover;
assign LEDR = Numeral;

endmodule
