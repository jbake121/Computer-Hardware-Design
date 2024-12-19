module HEX1_4bit(
	input wire clk,
	input wire enable,
	input wire reset,
	output reg [3:0] r1
);

always @(posedge clk or posedge reset) begin
    
    if (reset)
		r1 <= 4'b0000;
    else if (enable) begin
		if (r1 == 4'b1001)
			r1 <= 4'b0000;
		else
			r1 <= r1 + 1;
    end
end

endmodule
