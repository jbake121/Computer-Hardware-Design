module Calculator(
    input wire       CLOCK_50,      // 50 MHz system clock
    input wire [1:0] KEY,          // Reset button
    input wire       GPIO_0,      // UART receive data
    output wire      GPIO_1,      // UART transmit data
	output wire [9:0] LEDR,
    output wire [6:0] HEX0,          // HEX display for accumulator lower nibble
    output wire [6:0] HEX1,          // HEX display for accumulator upper nibble
    output wire [6:0] HEX5           // HEX display for last ASCII digit received
);

    // Internal signals
    wire        reset;
    wire [7:0]  rx_data;
    wire        rx_ready;
    reg  [7:0]  accumulator;
    reg  [3:0]  last_digit;
    reg         tx_start;
    wire        tx_busy;
    reg  [7:0]  tx_data;
	
	EdgeDetector edge_detector_inst (
		.clk(CLOCK_50),
		.in(KEY[1]),
		.pulse(key_detected)
	);
	
	UART_Receiver uart_receiver_inst (
		.clk(CLOCK_50),
		.reset(key_detected),
		.serial_in(GPIO_0),
		.data_out(rx_data),
		.data_valid(rx_ready)
	);
	
    // HEX Display Decoders
    HEX_Decoder hex0_inst (
        .hex_digit(accumulator[3:0]),
        .segments(HEX0)
    );

    HEX_Decoder hex1_inst (
        .hex_digit(accumulator[7:4]),
        .segments(HEX1)
    );

    HEX_Decoder hex5_inst (
        .hex_digit(last_digit),
        .segments(HEX5)
    );

    UART_Transmitter uart_transmitter_inst (
        .clk(CLOCK_50),
        .reset(key_detected),
        .data_in(tx_data),
        .start(tx_start),
        .busy(tx_busy),
        .serial_out(GPIO_1)
    );

    // ASCII checks and accumulator logic
    wire is_ascii_digit = (rx_data[7:4] == 4'h3); // ASCII '0'-'9' have upper nibble 3
    wire [3:0] digit_value = rx_data[3:0];

// Inside your main module (Calculator):

// State definitions for sending two hexadecimal characters plus a newline
localparam TX_CHAR_1 = 3'd0,
           TX_WAIT_1 = 3'd1,
           TX_CHAR_2 = 3'd2,
		   TX_WAIT_2 = 3'd3,
           TX_SPACE  = 3'd4,
		   TX_DONE	 = 3'd5;

reg [2:0] tx_state;
reg [7:0] high_char;
reg [7:0] low_char;
reg run;

function [7:0] nibble_to_ascii;
    input [3:0] nib;
    begin
        if (nib < 10)
            nibble_to_ascii = 8'h30 + nib;       // '0' to '9'
        else
            nibble_to_ascii = 8'h41 + (nib - 10); // 'A' to 'F'
    end
endfunction

always @(posedge CLOCK_50 or posedge key_detected) begin
	
    if (key_detected) begin
        accumulator <= 8'h00;
        last_digit <= 4'h0;
        tx_start <= 1'b0;
        tx_state <= TX_CHAR_1;
		run <= 1'b0;
    end else begin
        // Default no start
        tx_start <= 1'b0; 

        // Update accumulator and prepare for transmission when a new digit arrives
        if (rx_ready && is_ascii_digit) begin
            last_digit <= digit_value;
            accumulator <= accumulator + digit_value;

            // Prepare the two hex characters for accumulator
            high_char <= nibble_to_ascii(accumulator[7:4]);
            low_char <= nibble_to_ascii(accumulator[3:0]);

            run <= 1'b1;
			
        end else if (run) begin
            // If no new digit is being received, we still want to continue the TX state machine
            case (tx_state)
				TX_CHAR_1: begin
						tx_data <= high_char;
						tx_start <= 1'b1;
						tx_state <= TX_WAIT_1;
				end
					
                TX_WAIT_1: begin
					if (!tx_busy) begin
						tx_start <= 1'b1;
						tx_state <= TX_CHAR_2;
					end
                end

                TX_CHAR_2: begin
					if (!tx_busy) begin
						tx_data <= low_char; // For example, a space
						tx_start <= 1'b1;
						tx_state <= TX_WAIT_2;
					end
                end

                TX_WAIT_2: begin
					if (!tx_busy) begin
						tx_start <= 1'b1;
						tx_state <= TX_SPACE;
					end
                end
				
				TX_SPACE: begin
					if (!tx_busy) begin
						tx_data <= 8'h20;
						tx_start <= 1'b1;
						tx_state <= TX_DONE;
					end
				end
				
				TX_DONE: begin
					if (!tx_busy) begin
						tx_state <= TX_CHAR_1;
						run <= 0;
					end
				end
            endcase
        end
    end
end

endmodule