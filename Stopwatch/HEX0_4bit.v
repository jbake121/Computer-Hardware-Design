module HEX0_7bit(
	input wire clk,
	input wire enable,
	input wire reset,
	output reg [6:0] r0
);

always @(posedge clk or posedge reset) begin
    
    if (reset)
		r0<= 7'b0000000;
    else if (enable) begin
		if (r0 == 7'b1111111)
			r0 <= 7'b0000000;
		else
			r0 <= r0 + 1;
    end
end

endmodule
