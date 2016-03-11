module PC(rst, clk, pc_in, pc_out);
	input clk, rst;
	input [31:0] pc_in;
	output reg [31:0] pc_out;
	
	always @(posedge clk) begin
		if (rst==1) pc_out <= 0;
		else pc_out <= pc_in + 4; // change to pc = pc + 32'd1 if memory is word addressed
	end
endmodule