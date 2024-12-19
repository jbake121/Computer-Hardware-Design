module UART_Transmitter (
    input  wire       clk,
    input  wire       reset,
    input  wire [7:0] data_in,
    input  wire       start,
    output reg        busy,
    output wire       serial_out
);

localparam integer DIVISOR = 434;

reg [15:0] baud_counter;
reg [9:0]  tx_shift;
reg [3:0]  bit_counter;
reg        tx_reg;

assign serial_out = tx_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        tx_reg <= 1'b1; // idle line high
        busy <= 1'b0;
        baud_counter <= 0;
        bit_counter <= 0;
    end else begin
		
        if (!busy) begin
            // Idle state, wait for start
            if (start) begin
                // Load frame: {stop bit, data_in, start bit}
                // Stop bit = 1 at MSB, start bit = 0 at LSB
                tx_shift <= {1'b1, data_in[7:0], 1'b0};
                busy <= 1'b1;
                bit_counter <= 0;
                baud_counter <= 0;
                tx_reg <= 1'b0; // Immediately output start bit
            end
        end else begin
            // Busy transmitting
            if (baud_counter < (DIVISOR - 1)) begin
                baud_counter <= baud_counter + 1;
            end else begin
                baud_counter <= 0;
                bit_counter <= bit_counter + 1;
                tx_shift <= tx_shift >> 1;  // Shift right by one
                tx_reg <= tx_shift[1];      // After shift, next bit is now at position 1
                
                if (bit_counter == 9) begin
                    // All 10 bits (start+8 data+stop) sent
                    busy <= 1'b0;
                    tx_reg <= 1'b1; // Return line to idle high
                end
            end
        end
    end
end
endmodule
