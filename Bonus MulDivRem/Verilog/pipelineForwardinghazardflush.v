`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2025 02:33:49 PM
// Design Name: 
// Module Name: pipeline
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

 module pipelineForwardingHazardFlush ( input clk, ssdclk, rst, input [1:0]ledSel, input [3:0]ssdSel, output reg [15:0] led, output  [3:0] Anode, output [6:0] LED_out );
// load always in nbitRegmod  
    wire [31:0]PCin, PCout, inst, writeData, data1, data2, imm_out, shift_out, adder_shiftout, adder_4out, ALUmux_out, ALU_out, read_mem, ju_out, beforePC, newmux, ALUforwardA, ALUforwardB;
    wire branch, MemRead, MemWrite, ALUSrc, RegWrite, cout_useless, zFlag,sFlag, cFlag, vFlag,branchOut, jal, jalr, cont, stall, PCSrc;
    wire [1:0] ALUOp,MemToreg, forwardA, forwardB; 
    wire [3:0]ALU_sel;  
    wire [4:0] shamt; 
    reg [12:0]ssd;
    assign shamt = ALUmux_out[4:0]; 
    assign PCSrc = branchOut || EX_MEM_Ctrl[1] ||EX_MEM_Ctrl[0];
    wire flush = PCSrc;


    nbitRegmod # (.n(32)) pc( clk, cont || (!stall), rst, PCin, PCout );
    
    InstMem ops2 (PCout[7:2], inst); 
    
         // IF_ID 
    wire [31:0] IF_ID_PC, IF_ID_Inst;
    nbitRegmod #(64) IF_ID (clk, !stall || !PCSrc ,rst, {PCout, (PCSrc)? 32'h00000033: inst}, {IF_ID_PC,IF_ID_Inst} );
    
    hazard hazz ( IF_ID_Inst[19:15], IF_ID_Inst[24:20], ID_EX_Rd,  ID_EX_Ctrl[10], stall);
    
    controlUnit ops3( IF_ID_Inst[6:2], branch, MemRead, MemToreg, ALUOp, MemWrite, ALUSrc, RegWrite, jal, jalr, cont);
    regReset #(32) ops4( clk, rst, MEM_WB_Ctrl[0], writeData,IF_ID_Inst[19:15], IF_ID_Inst[24:20], MEM_WB_Rd, data1, data2);
    immgen ops5 ( IF_ID_Inst, imm_out);
    nbitmux #(32) ss(imm_out, 4, jal | jalr, newmux);
    wire[31:0] newadd1 = newmux + IF_ID_PC;
    
    reg PCSrc_prev;
    always @(posedge clk) begin
        if (rst) PCSrc_prev <= 0;
        else PCSrc_prev <= PCSrc;
    end 
    wire effective_flush = PCSrc || PCSrc_prev;
    
    //ID_EX_PC
      // Rs1 and Rs2 are needed later for the forwarding unit
    wire [11:0] ctrlIn = (stall || effective_flush)? 12'd0: {branch, MemRead, MemToreg, ALUOp, MemWrite, ALUSrc, RegWrite, jal, jalr, cont};
    wire [3:0] func4 = { IF_ID_Inst[30],IF_ID_Inst[14:12] };
    wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, ID_EX_ADDER1;
    wire [11:0] ID_EX_Ctrl;
    wire [3:0] ID_EX_Func;
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
    nbitRegmod #(191) ID_EX (clk,1'b1, rst, {ctrlIn, IF_ID_PC,data1, data2,imm_out, func4, IF_ID_Inst[19:15], IF_ID_Inst[24:20], IF_ID_Inst[11:7],newadd1 },
     {ID_EX_Ctrl,ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2, ID_EX_Imm, ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd, ID_EX_ADDER1} );
    
    
    ALUControlU ops6( ID_EX_Ctrl[7:6], ID_EX_Func[2:0], ID_EX_Func[3], ALU_sel);
    nbitshift #(32) ops7(ID_EX_Imm, shift_out);
    rca #(32) ops8(ID_EX_PC, shift_out, 0, adder_shiftout, cout_useless); // adder sum
    assign adder_4out = PCout+4;

    forwarding forii (  ID_EX_Rs1, ID_EX_Rs2, EX_MEM_Rd, MEM_WB_Rd, EX_MEM_Ctrl[2], MEM_WB_Ctrl[0] , forwardA, forwardB);

    mux4to1 forwA (ID_EX_RegR1, writeData, EX_MEM_ALU_out, 0, forwardA, ALUforwardA);
    mux4to1 forwB (ID_EX_RegR2, writeData, EX_MEM_ALU_out, 0, forwardB, ALUforwardB);
     nbitmux #(32) ops9( ALUforwardB, ID_EX_Imm, ID_EX_Ctrl[4], ALUmux_out); 
    ALU0Flag ops10( ALUforwardA, ALUmux_out, ALUmux_out[4:0], ALU_out, cFlag, zFlag, vFlag, sFlag, ALU_sel );//CZVS

    
    // EX_mem
    wire [7:0] ctrl2In = (PCSrc)?8'd0: {ID_EX_Ctrl[11:8], ID_EX_Ctrl[5], ID_EX_Ctrl[3],ID_EX_Ctrl[2:1]}; //2,0  //9,8,3 //5,4,2
    wire [31:0] EX_MEM_BranchAddOut, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_ADDER1, EX_MEM_Imm;
      
    wire [3:0] branchin = {zFlag, sFlag, cFlag, vFlag};
    wire [7:0] EX_MEM_Ctrl;
    wire [4:0] EX_MEM_Rd;
    wire [3:0] EX_MEM_branchout;  //4 flags
    wire [2:0] EX_MEM_func3;
    nbitRegmod #(180) EX_MEM (clk,1'b1, rst, {ctrl2In, adder_shiftout, branchin, ALU_out, ALUforwardB, ID_EX_Rd, ID_EX_Func[2:0], ID_EX_ADDER1, ID_EX_Imm},
    {EX_MEM_Ctrl, EX_MEM_BranchAddOut, EX_MEM_branchout, EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd, EX_MEM_func3, EX_MEM_ADDER1, EX_MEM_Imm} );
   
    branchUnit opp( EX_MEM_Ctrl[7], EX_MEM_branchout[3], EX_MEM_branchout[2], EX_MEM_branchout[1], EX_MEM_branchout[0], EX_MEM_func3, branchOut);
     
    nbitmux #(32) ops11( adder_4out, EX_MEM_BranchAddOut, branchOut | EX_MEM_Ctrl[1] , beforePC);
    nbitmux #(32) opspp( beforePC, EX_MEM_ALU_out, EX_MEM_Ctrl[0] , PCin);
    
    DataMem ops12( clk,  EX_MEM_Ctrl[6],  EX_MEM_Ctrl[3], EX_MEM_ALU_out[7:0], EX_MEM_RegR2, EX_MEM_func3, read_mem); 
     
    // Mem_WB
    wire [2:0] ctrl3In = {EX_MEM_Ctrl[5:4], EX_MEM_Ctrl[2]}; //memtorig, regwrite
    wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_ADDER1,MEM_WB_Imm;
    wire [2:0] MEM_WB_Ctrl;
    wire [4:0] MEM_WB_Rd;
    nbitRegmod #(136) MEM_WB (clk,1'b1, rst, {ctrl3In, read_mem, EX_MEM_ALU_out, EX_MEM_Rd, EX_MEM_ADDER1,EX_MEM_Imm}, 
    {MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_ALU_out, MEM_WB_Rd, MEM_WB_ADDER1, MEM_WB_Imm} );
    
 
    mux4to1 ops13( MEM_WB_ALU_out, MEM_WB_Mem_out, MEM_WB_Imm, MEM_WB_ADDER1, MEM_WB_Ctrl[2:1], writeData);
     // pipeline
    
       // led 
     always @ (*) begin 
     case (ledSel)
        2'b00: led = inst [15:0];
        2'b01: led = inst [31:16];
        2'b10: led = {2'b00, ALUOp, branch, MemRead, MemToreg, MemWrite, ALUSrc, RegWrite, ALU_sel, zFlag, branchOut }; // check 
        default: led = 0;
     endcase 
     end 
 
    always @ (*) begin 
     case (ssdSel) 
     4'b0000: ssd = PCout[12:0];
     4'b0001: ssd = adder_4out[12:0];
     4'b0010: ssd = adder_shiftout [12:0];
     4'b0011: ssd = PCin[12:0];
     4'b0100: ssd = data1[12:0];
     4'b0101: ssd = data2[12:0];
     4'b0110: ssd = writeData[12:0];
     4'b0111: ssd = imm_out[12:0];
     4'b1000: ssd = shift_out[12:0];
     4'b1001: ssd = ALUmux_out[12:0];
     4'b1010: ssd = ALU_out[12:0];
     4'b1011: ssd = read_mem[12:0];
     default: ssd = 0;
     
     endcase 
     end 
  BCD oppa (ssdclk, ssd, Anode, LED_out);  
  
endmodule

