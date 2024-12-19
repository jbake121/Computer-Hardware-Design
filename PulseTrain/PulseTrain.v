module PulseTrain (
	
	input wire CLOCK_50,
	input wire [9:0] SW,
	output wire [1:0] LEDR

);

wire rollover;

StateRegister stateregister_inst (

	.clk(CLOCK_50),
	.reset(SW[0]),
	.trigger(SW[9]),
	.enable(enable),
	.pulses(SW[4:2]),
	.sets(SW[7:5]),
	.pulse(pulse)

);

Timer_250ms timer_250ms_inst (

	.clk(CLOCK_50),
	.reset(SW[0]),
	.count(count),
	.rollover(rollover)

);

assign enable = rollover;
assign LEDR = pulse;

endmodule
