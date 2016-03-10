module ControlUnit(OPcode, ALUOp, RFwe, DMwe, DMre, RegDst, ALUSrc, MemtoReg, Branch);

input [5:0] OPcode;

// Register File Control
output reg RFwe;

// Data Memory Control
output reg DMwe;
output reg DMre;

// ALU Control
output reg [1:0] ALUOp;	// R, I, or Branch

// Multiplexors
output reg RegDst; 		// rd (1) or rt (0) to write register input.
output reg ALUSrc; 		// inst[15:0] (1) or $rt (0) to second ALU input.
output reg MemtoReg; 	// dm output (1) or alu output (0) to write register data.
output reg Branch;      // branch (1), don't branch (0)

always @(OPcode)
	case(OPcode)
		0:		begin // R-Type
					RegDst <= 1; // set rd as write register
					ALUSrc <= 0; // use $rt value as second input to ALU
					MemtoReg <= 0; // use ALU output
					Branch <= 0; // don't branch
					RFwe <= 1; // enable register write
					DMwe <= 0; // not using DM
					DMre <= 0; // not using DM 
					ALUOp <= 2; // ALUOp for R-Type
				end
		35:	begin // lw
					RegDst <= 0; // set rt as write register
					ALUSrc <= 1; // use inst[15:0] as second input to ALU
					MemtoReg <= 1; // write dm output to register
					Branch <= 0; // don't branch
					RFwe <= 1; // enable registerwrite
					DMwe <= 0; // don't write to memory
					DMre <= 1; // read value from memory
					ALUOp <= 0; // ALUOp for lw/sw
				end
		43:	begin // sw
					ALUSrc <= 1; // use inst[15:0] as second input to ALU
					Branch <= 0; // don't branch
					RFwe <= 0; // enable registerwrite
					DMwe <= 1; // write value to memory
					DMre <= 0; // read value from memory
					ALUOp <= 0; // ALUOp for lw/sw
				end
		4:		begin // beq
					ALUSrc <= 0; // use $rt as second input to ALU
					Branch <= 1; // don't branch
					RFwe <= 0; // enable registerwrite
					DMwe <= 0; // write value to memory
					DMre <= 0; // read value from memory
					ALUOp <= 1; // ALUOp for lw/sw
				end
	endcase
endmodule