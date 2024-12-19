module Timer_10ms(
	
	input wire clk,
	output reg [22:0] count_ms,
	output reg rollover

);

initial begin
	count_ms = 0;
	rollover = 0;
end

	parameter target = 5000000;

	always @(posedge clk) begin

			if (count_ms == target - 1) begin   
				count_ms <= 23'b0;
				rollover <= 1'b1;
			end
			else begin
				count_ms <= count_ms + 1;
				rollover <= 1'b0;
			end
	end

endmodule
