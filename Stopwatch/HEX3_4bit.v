module HEX3_4bit(
	input wire clk,
	input wire enable,
	input wire reset,
	output reg [3:0] r3
);

always @(posedge clk or posedge reset) begin
    
    if (reset)
		r3 <= 4'b0000;
    else if (enable) begin
		if (r3 == 4'b1111)
			r3 <= 4'b0000;
		else
			r3 <= r3 + 1;
    end
end

endmodule
