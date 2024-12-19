module Accumulator (

	input clk, reset, enable,
	input [7:0] rx_data,
	output [7:0] tx_data
	
);

localparam TX_IDLE = 2'd0,
localparam TX_HIGH = 2'd1,
localparam TX_LOW  = 2'd2,
localparam TX_DONE = 2'd3;

reg [1:0] state, next_state;

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			