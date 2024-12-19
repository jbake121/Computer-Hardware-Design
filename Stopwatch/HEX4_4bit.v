module HEX4_4bit(
	input wire clk,
	input wire enable,
	input wire reset,
	output reg [3:0] r4
);

always @(posedge clk or posedge reset) begin
    
    if (reset)
		r4 <= 4'b0000;
    else if (enable) begin
		if (r4 == 4'b1001)
			r4 <= 4'b0000;
		else
			r4 <= r4 + 1;
    end
end

endmodule
