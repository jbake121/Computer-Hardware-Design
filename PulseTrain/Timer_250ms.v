module Timer_250ms(
	
	input wire clk,
	output reg [25:0] count,
	output reg rollover

);

parameter target = 50000000;

always @(posedge clk) begin

	if (count == target - 1) begin
	        
		count <= 26'b0;
		rollover <= 1'b1;
	    
	end
	else begin

		count <= count + 1;
		rollover <= 1'b0;
	    
	end
end

endmodule
