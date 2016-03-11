module IM(clk, addr, inst);
	// control input	
	input clk;
	
	// data input
	input [31:0] addr;
	
	// output
	output reg [31:0] inst;
	
	// memory
	reg [31:0] im_mem [127:0];
	
	// initialize memory
	initial begin
		$readmemh("im_seed.txt", im_mem);
	end
	
	always @(posedge clk) begin
		inst <= im_mem[addr[31:2]];
	end
	
endmodule