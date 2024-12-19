module HEX5_4bit(
	input wire clk,
	input wire enable,
	input wire reset,
	output reg [3:0] r5
);

always @(posedge clk or posedge reset) begin
    
    if (reset)
		r5 <= 4'b0000;
    else if (enable) begin
		if (r5 == 4'b0110)
			r5 <= 4'b0000;
		else
			r5 <= r5 + 1;
    end
end

endmodule
