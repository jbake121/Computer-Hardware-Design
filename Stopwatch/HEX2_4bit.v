module HEX2_4bit(
	input wire clk,
	input wire enable,
	input wire reset,
	output reg [3:0] r2
);

always @(posedge clk or posedge reset) begin
    
    if (reset)
		r2 <= 4'b0000;
    else if (enable) begin
		if (r2 == 4'b1111)
			r2 <= 4'b0000;
		else
			r2 <= r2 + 1;
    end
end

endmodule
