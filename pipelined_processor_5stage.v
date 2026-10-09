

module pipelined_processor_5stage(input clk1,input clk2 ,output wire [31:0] pc_out,output wire [31:0] alu_out);

//input clk1,clk2;

reg [31:0] IF_ID_IR,PC,IF_ID_NPC;
reg [31:0] ID_EX_IR,ID_EX_A,ID_EX_B,ID_EX_IMM,ID_EX_NPC;
reg [1:0] ID_EX_type,EX_MEM_type,MEM_WB_type;
reg [31:0] EX_MEM_B,EX_MEM_ALUout,EX_MEM_IR;
reg EX_MEM_cond;
reg [31:0] MEM_WB_ALUout,MEM_WB_LMD,MEM_WB_IR;

reg [31:0] Reg [0:31]; // Register Banks
reg [31:0] Mem [0:1023];

parameter ADD =6'b000000, SUB=6'b000001, AND=6'b000010,OR=6'b000011,
          SLT =6'b000100, MUL=6'b000101,LW=6'b001000,SW=6'b001001,
          ADDI=6'b001010, SUBI=6'b001011,SLTI=6'b001100,BNEQZ=6'b001101,
          BEQZ=6'b001110, HLT=6'b111111;

parameter RR_ALU=3'b000, RM_ALU=3'b001, LOAD=3'b010,STORE=3'b011,Branch=3'b100,HALT=3'b101;

reg HALTED;
reg Taken_Branch;

assign pc_out = PC;
assign alu_out = EX_MEM_ALUout;

// IF Stage
always @(posedge clk1) begin 
    if(HALTED == 0) begin
        if((EX_MEM_IR[31:26]==BEQZ && EX_MEM_cond==1) || (EX_MEM_IR[31:26]==BNEQZ && EX_MEM_cond==0)) begin 
            IF_ID_IR <= #2 Mem[EX_MEM_ALUout];
            IF_ID_NPC <= #2 EX_MEM_ALUout + 1;
            PC <= #2 EX_MEM_ALUout + 1;
            Taken_Branch <= 1'b1;
        end else begin
            PC <= PC + 1;
            IF_ID_IR <= Mem[PC];
            IF_ID_NPC <= PC + 1;

        end
     end
end
     
//ID Stage
always @(posedge clk2) begin 
    if(HALTED == 0) begin 
        if(IF_ID_IR[25:21] == 5'b00000) ID_EX_A <= 0;
        else ID_EX_A <= #2 Reg[IF_ID_IR[25:21]];

        if(IF_ID_IR[20:16] == 5'b00000) ID_EX_B <= 0;
        else ID_EX_B <= #2 Reg[IF_ID_IR[20:16]];
    end

    ID_EX_NPC <= #2 IF_ID_NPC;
    ID_EX_IR <= #2 IF_ID_IR;
    ID_EX_IMM <= #2 {{16{IF_ID_IR[15]}}, {IF_ID_IR[15:0]}}; 


    case(IF_ID_IR[31:26]) 
    ADD,SUB,AND,OR,SLT,MUL : ID_EX_type <= #2 RR_ALU;
    ADDI,SUBI,SLTI : ID_EX_type <= #2 RM_ALU;
    LW : ID_EX_type <= #2 LOAD;
    SW : ID_EX_type <= #2 STORE;
    BEQZ,BNEQZ : ID_EX_type <= #2 Branch;
    HLT : ID_EX_type <= #2 HALT;
    default : ID_EX_type <= #2 HALT;
    endcase
end

// EX Stage
always @(posedge clk1) begin 
    if(HALTED == 0) begin 
      EX_MEM_type <= #2 ID_EX_type;
      EX_MEM_IR <= #2 ID_EX_IR;
     // Taken_Branch <= #2 1'b0;

      case(ID_EX_type) 
      RR_ALU : begin 
        case(ID_EX_IR[31:26]) 
        ADD : EX_MEM_ALUout <= #2 ID_EX_A + ID_EX_B;
        SUB : EX_MEM_ALUout <= #2 ID_EX_A - ID_EX_B;
        AND : EX_MEM_ALUout <= #2 ID_EX_A & ID_EX_B;
        OR : EX_MEM_ALUout <= #2 ID_EX_A | ID_EX_B;
        SLT : EX_MEM_ALUout <= #2 ID_EX_A < ID_EX_B;
        MUL : EX_MEM_ALUout <= #2 ID_EX_A * ID_EX_B;
        default : EX_MEM_ALUout <= #2 32'hxxxxxxxx;
        endcase
      end

      RM_ALU : begin 
        case(ID_EX_IR[31:26])
        ADDI : EX_MEM_ALUout <= #2 ID_EX_A + ID_EX_IMM ;
        SUBI : EX_MEM_ALUout <= #2 ID_EX_A - ID_EX_IMM ;
        SLTI : EX_MEM_ALUout <= #2 ID_EX_A < ID_EX_IMM ;
        default : EX_MEM_ALUout <= #2 32'hxxxxxxxx;
        endcase
      end

      LOAD,STORE : begin 
        EX_MEM_ALUout <= #2 ID_EX_A + ID_EX_IMM;
        EX_MEM_B <= ID_EX_B;
      end

      Branch : begin 
        EX_MEM_ALUout <= #2 ID_EX_NPC + ID_EX_IMM;
        EX_MEM_cond <= #2(ID_EX_A == 0);
      end
      endcase
    end
end

// MEM Stage

always @(posedge clk2) begin 
    if(HALTED == 0) begin 
        MEM_WB_IR <= #2 EX_MEM_IR;
        MEM_WB_type <= #2 EX_MEM_type;

        case(EX_MEM_type) 
         RR_ALU,RM_ALU : MEM_WB_ALUout <= #2 EX_MEM_ALUout;
         LOAD : MEM_WB_LMD <= #2 Mem[EX_MEM_ALUout];
         STORE : if(Taken_Branch == 0)
                 Mem[EX_MEM_ALUout] <= #2 EX_MEM_B;
        endcase
    end
end

// WB Stage

always @(posedge clk1) begin 
    if(Taken_Branch == 0) begin 
      case(MEM_WB_type) 
      RR_ALU : Reg[MEM_WB_IR[15:11]] <= #2 MEM_WB_ALUout;
      RM_ALU : Reg[MEM_WB_IR[20:16]] <= #2 MEM_WB_ALUout;
      LOAD : Reg[MEM_WB_ALUout[20:16]] <= #2 MEM_WB_LMD;
      HALT : HALTED <= #2 1'b1;
      endcase
    end
end


endmodule
