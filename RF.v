module RF(clk, read_reg_1, read_reg_2, write_reg, write_data, reg_write, read_data_1, read_data_2);
	// control inputs
	input clk;
	input reg_write;
	 
	// register inputs
	input [4:0] read_reg_1;
	input [4:0] read_reg_2;
	input [4:0] write_reg;
	 
	// ALU or DM data input
	input [31:0] write_data;
	 
	// Register value outputs
	output reg [31:0] read_data_1;
	output reg [31:0] read_data_2;

	// registry mem
	reg [31:0] registry [0:31]; // 32 registers each 32 bits long
	 
	always @(posedge clk) begin
		if (reg_write)
			registry[write_reg] <= write_data;
	end
	
	always @(read_reg_1) begin
		read_data_1 <= registry[read_reg_1];
	end
	always @(read_reg_2) begin
		read_data_2 <= registry[read_reg_2];
	end
endmodule