

module load_and_store_tb ;

reg clk1,clk2;
integer k;

pipelined_processor_5stage mips(clk1 , clk2);

initial begin 

    clk1=0; clk2=0;

    repeat(50) begin
   #5 clk1=0;   #5 clk1=1;
   #5 clk2=0;   #5 clk2=1;
    end
end

initial begin 
    for(k=0; k<=31; k=k+1)
      mips.Reg[k] = k;

      mips.Mem[0] = 32'h28010078;  // ADDI R1,R0,120
      mips.Mem[1] = 32'h0c631800; //  OR R3 R3 R3  dummy
      mips.Mem[2] = 32'h20220000; //  LW R2 ,0(R1)
      mips.Mem[3] = 32'h0c631800; // Or R3 R3 R3 dummy
      mips.Mem[4] = 32'h2842002d; // ADDI R2 R4 45
      mips.Mem[5] = 32'h0c631800; // Or R3 R3 R3 dummy
      mips.Mem[6] = 32'h24220001; // SW R2 , 1(R1)
      mips.Mem[7] = 32'hfc000000; // HLT

      mips.Mem[120] =85; // 85 arbitary value

      mips.PC =0;
      mips.HALTED=0;
      mips.Taken_Branch=0;

      $display("R1 =0%d", mips.Reg[1]);
      $display("R2 =0%d", mips.Reg[2]);
      $display("Mem[120] =%0d", mips.Mem[120]);
      $display("Mem[121] =%0d", mips.Mem[121]);

      #500 $display("Mem[120]: %4d \n Mem[121]: %4d", mips.Mem[120], mips.Mem[121]);

end

initial begin 
    $dumpfile ("mips.vcd");
    $dumpvars (0,load_and_store_tb);
    #600 $finish;
end 
endmodule