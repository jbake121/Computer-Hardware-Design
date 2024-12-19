module PulseTrain(

    input wire trigger, reset, clk,
    output reg pulse

);

// State encoding
localparam pulse_high = 3'b000;
localparam pulse_low  = 3'b001;
localparam low_2      = 3'b010;
localparam low_3      = 3'b011;
localparam rst        = 3'b100;

reg [2:0] state, next_state;
reg [3:0] pulse_count;  // Count the number of high pulses
reg [1:0] set_count;    // Count the number of sets completed

// State transition logic (sequential block)
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= rst;
        pulse_count <= 0;
        set_count <= 0;
    end
    else begin
        state <= next_state;
    end
end

// Counters for pulse and set (sequential block)
always @(posedge clk or posedge reset) begin
    if (reset) begin
        pulse_count <= 0;
        set_count <= 0;
    end
    else begin
        case (state)
            pulse_high: begin
                if (pulse_count < 7) begin
                    pulse_count <= pulse_count + 1;
                end
                else begin
                    pulse_count <= 0;
                end
            end

            pulse_low: begin
                // No action on pulse_low, pulse_count incremented in pulse_high
            end

            rst: begin
                pulse_count <= 0;
                set_count <= 0;
            end

            default: begin
                // No action
            end
        endcase
    end
end

// Combinational logic for pulse output
always @(*) begin
    case (state)
        pulse_high: begin
            pulse = 1'b1;  // Output high pulse for 1 clock cycle
        end

        pulse_low, low_2, low_3: begin
            pulse = 1'b0;  // Output low pulse
        end

        default: begin
            pulse = 1'b0;  // Default pulse state (low)
        end
    endcase
end

// Combinational logic for next state
always @(*) begin
    next_state = state;
    
    case (state)
        rst: begin
            if (reset) begin
                next_state = rst;
            end
            else if (trigger) begin
                next_state = pulse_high;
            end
            else begin
                next_state = rst;
            end
        end

        pulse_high: begin
            next_state = pulse_low;  // Alternate to pulse_low after 1 high pulse
        end

        pulse_low: begin
            if (pulse_count == 7) begin
                if (set_count == 2) begin
                    next_state = low_2;  // Move to low period after 3 sets
                end
                else begin
                    next_state = pulse_high;  // Continue to next pulse in the set
                end
            end
            else begin
                next_state = pulse_high;  // Alternate back to pulse_high for the next pulse
            end
        end

        low_2: begin
            next_state = low_3;  // 1st low cycle after 8 pulses
        end

        low_3: begin
            next_state = pulse_high;  // Return to pulse generation after 3 low cycles
        end

        default: next_state = rst;
    endcase
end

endmodule

