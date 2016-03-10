module RF_ALU(
	// RF inputs
	clk, read_reg_1, read_reg_2, write_reg, write_data, reg_write, 
	// ALU mux input
	alu_input_sel, immediate_input, 
	// ALU input
	alu_op, 
	// ALU output
	alu_out, zero);
	
	// control input
	input clk;
	
	// RF control input
	input reg_write;
	
	// RF input
	input [4:0] read_reg_1;
	input [4:0] read_reg_2;
	input [4:0] write_reg;
	input [31:0] write_data;
	
	// ALU mux
	input alu_input_sel;
	input [31:0] immediate_input;
	
	// ALU input
	input [3:0] alu_op;
	
	// ALU output
	output [31:0] alu_out;
	output zero;
	
	// RF to ALU connections
	wire [31:0] alu_input_1;
	wire [31:0] reg_data_2;
	wire [31:0] alu_input_2;
	
	RF reg_file(
		// inputs
		.clk(clk),
		.read_reg_1(read_reg_1),
		.read_reg_2(read_reg_2),
		.write_reg(write_reg),
		.write_data(write_data),
		.reg_write(reg_write),
		// outputs
		.read_data_1(alu_input_1),
		.read_data_2(reg_data_2));
	
	MX2 alu_input_mux(
		// inputs
		.sel(alu_input_sel), 
		.input_1(reg_data_2), 
		.input_2(immediate_input),
		// outputs
		.out(alu_input_2));
	
	ALU alu(
		// inputs
		.alu_op(alu_op), 
		.input_1(alu_input_1), 
		.input_2(alu_input_2),
		// outputs
		.alu_out(alu_out), 
		.zero(zero));
		
endmodule
	
	