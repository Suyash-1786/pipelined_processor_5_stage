
module pipelined_processor_top(
input wire clk1,clk2,
output wire [31:0] pc_out,
output wire [31:0] alu_out
);

pipelined_processor_5stage cpu(.clk1(clk1), .clk2(clk2), .pc_out(pc_out), .alu_out(alu_out));

endmodule
