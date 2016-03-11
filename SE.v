module SE(in, out);
	
	// input signal
	input [15:0] in;
	
	// output signal
	output reg[31:0] out;
	
	always @(in) begin
		out <= {{16{in[15]}},in[15:0]};
	end
endmodule