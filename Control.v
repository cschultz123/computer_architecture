module Control(op_code, alu_op, reg_write, mem_write, mem_read, reg_dst, alu_src, mem_to_reg, branch);

input [5:0] op_code;

// Register File Control
output reg reg_write;

// Data Memory Control
output reg mem_write;
output reg mem_read;

// ALU Control
output reg [1:0] alu_op;	// R, I, or Branch

// Multiplexors
output reg reg_dst; 		// rd (1) or rt (0) to write register input.
output reg alu_src; 		// inst[15:0] (1) or $rt (0) to second ALU input.
output reg mem_to_reg; 	// dm output (1) or alu output (0) to write register data.
output reg branch;      // branch (1), don't branch (0)

always @(op_code)
	case(op_code)
		0:		begin // R-Type
					reg_dst <= 1; // set rd as write register
					alu_src <= 0; // use $rt value as second input to ALU
					mem_to_reg <= 0; // use ALU output
					branch <= 0; // don't branch
					reg_write <= 1; // enable register write
					mem_write <= 0; // not using DM
					mem_read <= 0; // not using DM 
					alu_op <= 2; // ALUOp for R-Type
				end
		35:	begin // lw
					reg_dst <= 0; // set rt as write register
					alu_src <= 1; // use inst[15:0] as second input to ALU
					mem_to_reg <= 1; // write dm output to register
					branch <= 0; // don't branch
					reg_write <= 1; // enable registerwrite
					mem_write <= 0; // don't write to memory
					mem_read <= 1; // read value from memory
					alu_op <= 0; // ALUOp for lw/sw
				end
		43:	begin // sw
					alu_src <= 1; // use inst[15:0] as second input to ALU
					branch <= 0; // don't branch
					reg_write <= 0; // enable registerwrite
					mem_write <= 1; // write value to memory
					mem_read <= 0; // read value from memory
					alu_op <= 0; // ALUOp for lw/sw
				end
		4:		begin // beq
					alu_src <= 0; // use $rt as second input to ALU
					branch <= 1; // don't branch
					reg_write <= 0; // enable registerwrite
					mem_write <= 0; // write value to memory
					mem_read <= 0; // read value from memory
					alu_op <= 1; // ALUOp for lw/sw
				end
	endcase
endmodule