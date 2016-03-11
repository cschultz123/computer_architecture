module BPC(pcin, addr, pcout);
	input [31:0] pcin;
	input [31:0] addr;
	output reg [31:0] pcout;
	
	always @(pcin) begin
		pcout <= (addr << 2) + pcin;
	end
endmodule