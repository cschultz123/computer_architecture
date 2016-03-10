module ALU (alu_op, input_1, input_2, alu_out, zero);
	input [3:0] alu_op;
	input [31:0] input_1,input_2;
	output reg [31:0] alu_out;
	output zero;
	assign zero = (alu_out==0); //Zero is true if alu_out is 0; goes anywhere
	always @(alu_op, input_1, input_2) //reevaluate if these change
		case (alu_op)
			0: alu_out <= input_1 & input_2;
			1: alu_out <= input_1 | input_2;
			2: alu_out <= input_1 + input_2;
			6: alu_out <= input_1 - input_2;
			7: alu_out <= input_1 < input_2 ? 1:0;
			12: alu_out <= ~(input_1 | input_2);
			default: alu_out <= 0; //default to 0, should not happen;
	endcase
endmodule