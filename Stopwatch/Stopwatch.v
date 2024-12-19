module Stopwatch(
		input wire CLOCK_50,
		input wire [1:0] KEY,
		output wire [9:0] LEDR,
		output wire [6:0] HEX0,
		output wire [6:0] HEX1,
		output wire [6:0] HEX2,
		output wire [6:0] HEX3,
		output wire [6:0] HEX4,
		output wire [6:0] HEX5
);

	wire [6:0] seg;
	wire toggle_0;
	wire toggle_1;
	wire rollover;
	wire [3:0] r0, r1, r2, r3, r4, r5;
	
	Encoder_4bit encoder_0 (.in(r0), .seg(HEX0));
	Encoder_4bit encoder_1 (.in(r1), .seg(HEX1));
	Encoder_4bit encoder_2 (.in(r2), .seg(HEX2));
	Encoder_4bit encoder_3 (.in(r3), .seg(HEX3));
	Encoder_4bit encoder_4 (.in(r4), .seg(HEX4));
	Encoder_4bit encoder_5 (.in(r5), .seg(HEX5));
	
	HEX0_4bit hex0_4bit_inst (
			.clk(CLOCK_50),
			.enable(
					toggle_1
					&& rollover
			),
			.reset(toggle_0),
			.r0(r0)
	);
	
	HEX1_4bit hex1_4bit_inst (
			.clk(CLOCK_50),
			.enable (
					r0 == 4'b1001 
					&& rollover
			),
			.reset(toggle_0),
			.r1(r1)
	);
	
	HEX2_4bit hex2_4bit_inst (
			.clk(CLOCK_50),
			.enable(
					r1 == 4'b1001
					&& r0 == 4'b1001
					&& rollover
			),
			.reset(toggle_0),
			.r2(r2)
	);
	
	HEX3_4bit hex3_4bit_inst (
			.clk(CLOCK_50),
			.enable(
					r2 == 4'b1001
					&& r1 == 4'b1001
					&& r0 == 4'b1001
					&& rollover
			),
			.reset(toggle_0),
			.r3(r3)
	);
	
	HEX4_4bit hex4_4bit_inst (
			.clk(CLOCK_50),
			.enable(
					r3 == 4'b0101
					&& r2 == 4'b1001
					&& r1 == 4'b1001
					&& r0 == 4'b1001
					&& rollover
			),
			.reset(toggle_0),
			.r4(r4)
	);
	
	HEX5_4bit hex5_4bit_inst (
			.clk(CLOCK_50),
			.enable(
					r4 == 4'b1001
					&& r3 == 4'b0101
					&& r2 == 4'b1001
					&& r1 == 4'b1001
					&& r0 == 4'b1001
					&& rollover
			),
			.reset(toggle_0),
			.r5(r5)
	);
	
	Toggle toggle_0_inst (
			.clk(CLOCK_50),
			.key0_async(KEY[0]),
			.key1_async(1'b0),
			.toggle(toggle_0)
	);
	
	Toggle toggle_1_inst (
			.clk(CLOCK_50),
			.key0_async(1'b0),
			.key1_async(KEY[1]),
			.toggle(toggle_1)
	);
	
	Timer_10ms timer_10ms_inst (
			.clk(CLOCK_50),
			.reset(toggle_0),
			.count(count),
			.rollover(rollover)
	);

	assign LEDR[0] = ~toggle_0;
	assign LEDR[1] = ~toggle_1;
	assign LEDR[9:2] = 9'b0;

endmodule