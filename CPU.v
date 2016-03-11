module CPU(
	//CPU inputs
	clk, rst,
	//PC waveform output
	wv_pc_next,
	//IM waveform output
	wv_inst,
	//RF waveform output
	wv_write_reg, wv_reg_write_data, wv_reg_write, wv_read_data_1, wv_read_data_2,
	//ALU waveform output
	wv_alu_in2, wv_alu_out, wv_zero,
	//DM waveform output
	wv_mem_read, wv_mem_write, wv_dm_read_data,
	// reg dst mux
	wv_reg_dst,
	// alu input mux
	wv_alu_src,
	// mem to reg mux
	wv_mem_to_reg,
	// branch
	wv_branch);
	
	// inputs
	input clk;
	input rst;

	// PC
	
	wire [31:0] pc_next;
	wire [31:0] pc_out;
	
	PC pc(
		.rst(rst), 
		.clk(clk), 
		.pc_in(pc_next), 
		.pc_out(pc_out));
		
	// IM
	
	wire [31:0] inst; // instruction from IM
		
	IM instruction_memory(
		.addr(pc_next), 
		.clk(clk), 
		.inst(inst));
		
	// Control
		
	wire reg_dst; // mux selector rs2 or rd to RF write data
	wire reg_write; // RF write flag
	wire branch; // Branch flag
	wire mem_read; // DM read flag
	wire mem_write; // DM write flag
	wire mem_to_reg; // mux selector to DM to RF
	wire [1:0] alu_op; // ALUControl input
	wire alu_src; // mux selector RF2 or immediate
	
	Control control_unit(
		// inputs
		.op_code(inst[31:26]),	
		// outputs
		.alu_op(alu_op), 
		.reg_write(reg_write), 
		.mem_write(mem_write), 
		.mem_read(mem_read), 
		.reg_dst(reg_dst), 
		.alu_src(alu_src), 
		.mem_to_reg(mem_to_reg), 
		.branch(branch));
		
	// RF Write Mux
		
	wire [4:0] write_reg;
	
	MX2_5 reg_dst_mux(
		.sel(reg_dst), 
		.input_1(inst[20:16]), 
		.input_2(inst[15:11]), 
		.out(write_reg));
		
	// RF
	
	wire [31:0] read_data_1;
	wire [31:0] read_data_2;
	wire [31:0] reg_write_data; // input from ALU or DM
		
	RF register_file(
		.clk(clk), 
		.read_reg_1(inst[25:21]), 
		.read_reg_2(inst[20:16]), 
		.write_reg(write_reg), 
		.write_data(reg_write_data), 
		.reg_write(reg_write), 
		.read_data_1(read_data_1), 
		.read_data_2(read_data_2));
		
	wire [3:0] alu_ctrl; // ALU input
		
	ALUControl alu_control(
		.alu_op(alu_op), 
		.func(inst[5:0]), 
		.alu_ctrl(alu_ctrl));
		
	// sign extender for immediate
	
	wire [31:0] se_immediate;
	
	SE immediate_sign_extender(
		.in(inst[15:0]), 
		.out(se_immediate));
		
	// ALU input mux
	
	wire [31:0] alu_input_2;
	
	MX2_32 alu_input_mux(
		.sel(alu_src), 
		.input_1(read_data_2), 
		.input_2(se_immediate), 
		.out(alu_input_2));
		
	// ALU
	
	wire [31:0] alu_out;
	wire zero;
	
	ALU alu(
		.alu_ctrl(alu_ctrl), 
		.input_1(read_data_1), 
		.input_2(alu_input_2), 
		.alu_out(alu_out), 
		.zero(zero));
		
	// DM
	
	wire [31:0] dm_read_data;
	
	DM data_memory(
		.clk(clk), 
		.mem_read(mem_read), 
		.mem_write(mem_write), 
		.addr(alu_out), 
		.write_data(read_data_2), 
		.read_data(dm_read_data));
		
	// mem to reg mux
	
	MX2_32 mem_to_reg_mux(
		.sel(mem_to_reg), 
		.input_1(alu_out), 
		.input_2(dm_read_data), 
		.out(reg_write_data));
		
	// new pc from branch
	
	wire [31:0] branch_pc;
	
	BPC branch_pc_address(
		.pcin(pc_out), 
		.addr(se_immediate), 
		.pcout(branch_pc));
		
	// branch pc mux
	
	wire use_branch;
	assign use_branch = branch & zero ? 1:0;
	
	MX2_32 branch_mux(
		.sel(use_branch), 
		.input_1(pc_out), 
		.input_2(branch_pc), 
		.out(pc_next));
		
	// Outputs for waveform
	//PC
	output reg [31:0] wv_pc_next;
	//IM
	output reg [31:0] wv_inst;
	//RF
	output reg [31:0] wv_reg_write_data, wv_read_data_1, wv_read_data_2;
	output reg [4:0] wv_write_reg;
	output reg wv_reg_write;
	//ALU
	output reg [31:0] wv_alu_in2, wv_alu_out; 
	output reg wv_zero;
	//DM
	output reg wv_mem_read, wv_mem_write; 
	output reg [31:0] wv_dm_read_data;
	//Mux
	output reg wv_reg_dst, wv_alu_src, wv_mem_to_reg;
	//Branch
	output reg wv_branch;
	
	always @(posedge clk) begin
		wv_pc_next <= pc_next;
		wv_inst <= inst;
		wv_reg_write <= reg_write;
		wv_reg_write_data <= reg_write_data;
		wv_read_data_1 <= read_data_1;
		wv_read_data_2 <= read_data_2;
		wv_alu_in2 <= alu_input_2;
		wv_alu_out <= alu_out;
		wv_zero <= zero;
		wv_mem_read <= mem_read;
		wv_mem_write <= mem_write;
		wv_dm_read_data <= dm_read_data;
		wv_reg_dst <= reg_dst;
		wv_alu_src <= alu_src;
		wv_mem_to_reg <= mem_to_reg;
		wv_branch <= branch;
		wv_write_reg <= write_reg;
	end
	
	
endmodule
		
	
	