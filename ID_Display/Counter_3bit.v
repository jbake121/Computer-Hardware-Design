module Counter_3bit(
	input wire clk,
	input wire Enable,
	input wire Reset,
	output reg [2:0] Q
);

always @(posedge clk or posedge Reset) begin
    
    if (Reset)
      Q <= 3'b000;
    else if (Enable)
      Q <= Q + 1;
    end

endmodule
