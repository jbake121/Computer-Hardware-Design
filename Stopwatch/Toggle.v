module Toggle(
		input wire clk, key0_async, key1_async,
		output reg toggle
);

	wire key0_sync, key0_edge;
	reg sync0_1, sync0_2, key0_sync_d;
	wire key1_sync, key1_edge;
	reg sync1_1, sync1_2, key1_sync_d;
	
	always @(posedge clk) begin
		sync0_1 <= key0_async;
		sync0_2 <= sync0_1;
		key0_sync_d <= key0_sync;
	end
	
	always @(posedge clk) begin
		sync1_1 <= key1_async;
		sync1_2 <= sync1_1;
		key1_sync_d <= key1_sync;
	end
	
	always @(posedge clk) begin
		if (key0_edge || key1_edge) begin
			toggle <= ~toggle;
		end
	end
	
	assign key0_sync = sync0_2;
	assign key0_edge = (~key0_sync_d && key0_sync);
	assign key1_sync = sync1_2;
	assign key1_edge = (~key1_sync_d && key1_sync);
	
endmodule