module UART_Receiver(
    input clk,
	input reset,
    input serial_in,
    output reg [7:0] data_out,
    output reg data_valid
);

    localparam integer SAMPLE_RATE = 434;

    reg [15:0] sample_counter = 0;
    reg [3:0] bit_counter = 0;
    reg [9:0] shift_reg = 10'b1111111111;
    reg receiving = 0;
	reg serial_in_prev;

    always @(posedge clk or posedge reset) begin
		if (reset) begin
			data_valid <= 0;
			sample_counter <= 0;
			bit_counter <= 0;
			shift_reg <= 10'b1111111111;
			receiving <= 0;
			serial_in_prev <= 1;
		end
		else begin
			data_valid <= 0;
			serial_in_prev <= serial_in;
		
			if (!receiving) begin
				if (serial_in == 0 && serial_in_prev == 1) begin
					receiving <= 1;
					sample_counter <= SAMPLE_RATE / 2;
					bit_counter <= 0;
				end
			end 
			else begin
				if (sample_counter == SAMPLE_RATE - 1) begin
					sample_counter <= 0;
					shift_reg <= {serial_in, shift_reg[9:1]};
					bit_counter <= bit_counter + 1;
					if (bit_counter == 9) begin
						receiving <= 0;
						data_out <= shift_reg[9:2];
						data_valid <= 1;
					end
				end 
				else begin
                sample_counter <= sample_counter + 1;
				end
			end
		end
	end
	
endmodule