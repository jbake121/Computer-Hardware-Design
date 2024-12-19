module Timer_1s(
	
	input wire clk,
	input wire Reset,
	output reg [25:0] count,
	output reg Rollover

);

parameter target = 50000000;

always @(posedge clk or posedge Reset) begin

	if (Reset) begin
		
	    count <= 26'b0;
	    Rollover <= 1'b0;
	
	end
	else begin
	    if (count == target - 1) begin
	        
		count <= 26'b0;
		Rollover <= 1'b1;
	    
	    end
	    else begin

		count <= count + 1;
		Rollover <= 1'b0;
	    
	    end
	end
    end

endmodule
