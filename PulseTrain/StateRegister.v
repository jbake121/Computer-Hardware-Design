module StateRegister(

	input wire trigger, reset, clk, enable,
	input wire [2:0] pulses,
	input wire [2:0] sets,
	output reg pulse

);

localparam pulse_high = 3'b000;
localparam pulse_low  = 3'b001;
localparam low_2      = 3'b010;
localparam low_3      = 3'b011;
localparam rst        = 3'b100;


reg [2:0] state, next_state;
reg [3:0] pulse_count;
reg [2:0] set_count;

always @(posedge clk or posedge reset) begin
	if (reset) begin
	    state 	<= rst;
	end
	else if (enable) begin
	    state <= next_state;
	end
end

always @(posedge clk or posedge reset) begin
	if (reset) begin
	    pulse_count <= 0;
	    set_count 	<= 0;
	end
	else if (enable) begin
	    case (state)
		pulse_low: begin
		    pulse_count <= pulse_count + 1;
		end

		low_3: begin
		    pulse_count <= 4'b0;
		    set_count <= set_count + 1;
		end

		rst: begin
		    pulse_count <= 0;
		    set_count	<= 0;
		end
		
		default: begin

		end
	    endcase
	end
end

always @(*) begin
	case (state)
	    pulse_high: begin
		pulse = 1;
	    end
	    pulse_low, low_2, low_3: begin
		pulse = 0;
	    end
	    default: begin
		pulse = 0;
	    end
	endcase
end

always @(*) begin
	next_state = state;
	
	if (reset) begin
	    next_state = rst;
	end
	else if (enable) begin
	    case (state)
	        rst: begin
		    if (trigger) begin
		        next_state = pulse_high;
		    end
		    else begin
		        next_state = rst;
		    end
	        end

	        pulse_high: begin
		    if (reset) begin
		        next_state = rst;
		    end
		    else begin
		        next_state = pulse_low;
		    end
	        end

	        pulse_low: begin
		    if (pulse_count == pulses) begin
		        next_state = low_2;
	            end
		    else if (reset) begin
		        next_state = rst;
		    end
		    else begin
		        next_state = pulse_high;
		    end
	        end

	        low_2: begin
		    if (!reset) begin
		        next_state = low_3;
		    end
		    else begin
		        next_state = rst;
		    end
	        end

	        low_3: begin
		    if (set_count == sets) begin
		        next_state = rst;
		    end
		    else if (reset) begin
		        next_state = rst;
		    end
		    else begin
		        next_state = pulse_high;
		    end
	        end
	    
	        default: next_state = rst;
	
	    endcase
	end
end

endmodule
