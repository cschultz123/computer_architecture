module DM(clk, mem_read, mem_write, addr, write_data, read_data);
	// control input	
	input clk;
	input mem_read;
	input mem_write;
	
	// data input
	input [31:0] addr;
	input [31:0] write_data;
	
	// output
	output reg [31:0] read_data;
	
	// memory
	reg [31:0] dm_mem [127:0];
	
	// initialize memory
	initial begin
		$readmemh("dm_seed.txt", dm_mem);
	end
	
	always @(posedge clk) begin
		// read data if read flag is set
		if (mem_read)
			read_data <= dm_mem[addr[31:2]];
		// write data if write flag is set
		else if (mem_write)
			dm_mem[addr[31:2]] <= write_data;
	end
	
endmodule