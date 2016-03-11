module IM2(clk, addr, inst);
	// control input	
	input clk;
	
	// data input
	input [31:0] addr;
	
	// output
	output reg [31:0] inst;
	
	// memory
	reg [31:0] inst_mem [127:0];
	
	// initialize memory
	initial begin
		$readmemh("dm_seed.txt", inst_mem, 0, 10);
	end
	
	always @(posedge clk) begin
		inst <= inst_mem[addr[31:2]];
	end
	
endmodule