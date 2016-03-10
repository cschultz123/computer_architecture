module IM(addr, clk, inst);
	input [31:0] addr;
	input clk;
	output reg [31:0] inst;
	reg [31:0] mem [255:0];
	
	initial begin
		$readmemh("im_seed.txt", mem);
	end
	
	always @(posedge clk) begin
		inst = mem[addr[31:2]];
	end
endmodule