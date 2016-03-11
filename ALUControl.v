module ALUControl (alu_op, func, alu_ctrl);

input [1:0] alu_op;

input [5:0] func;

output reg [3:0] alu_ctrl;

always @(alu_op, func)

	if(alu_op==0)

		alu_ctrl<=2;

	else if(alu_op==1)

		alu_ctrl<=6;

	else

		case(func)

			32: alu_ctrl <= 2; //add

			34: alu_ctrl <= 6; //subtract

			36: alu_ctrl <= 0; //and

			37: alu_ctrl <= 1; //or

			39: alu_ctrl <= 12; //nor

			42: alu_ctrl <= 7; //slt

			default: alu_ctrl <= 15; //should not happen

		endcase
endmodule