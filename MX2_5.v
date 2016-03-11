module MX2_5(sel, input_1, input_2, out);

	// control input
	input sel;

	// signal inputs
	input [4:0] input_1;
	input [4:0] input_2;

	// signal output
	output reg [4:0] out;

	always @(sel, input_1, input_2) begin
		case(sel)
			0: out <= input_1;
			1: out <= input_2;
		endcase
	end
endmodule