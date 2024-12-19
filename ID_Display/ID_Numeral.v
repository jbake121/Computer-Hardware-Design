module ID_Numeral(
	
	input [2:0] Position,
	output reg [3:0] Numeral
);

always @(*) begin
    case (Position)
    	3'b000:  Numeral = 4'b0001;
	3'b001:  Numeral = 4'b0011;
	3'b010:  Numeral = 4'b0100;
	3'b011:  Numeral = 4'b0110;
	3'b100:  Numeral = 4'b0011;
	3'b101:  Numeral = 4'b0111;
	3'b110:  Numeral = 4'b0010;
	3'b111:  Numeral = 4'b0011;
	default: Numeral = 4'bxxxx;
    endcase
end

endmodule
