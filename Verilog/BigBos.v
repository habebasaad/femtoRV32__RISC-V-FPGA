`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2025 11:39:02 AM
// Design Name: 
// Module Name: BigBos
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


//module BigBoss( input clk, rst );
    module BigBoss ( input clk, ssdclk, rst, input [1:0]ledSel, input [3:0]ssdSel, output reg [15:0] led, output  [3:0] Anode, output [6:0] LED_out );
// load always in nbitRegmod  
    wire [31:0]PCin, PCout, inst, writeData, data1, data2, imm_out, shift_out, adder_shiftout, adder_4out, ALUmux_out, ALU_out, read_mem, ju_out, beforePC;
    wire branch, MemRead, MemWrite, ALUSrc, RegWrite, cout_useless, zFlag,sFlag, cFlag, vFlag,branchOut, jal, jalr, cont;
    wire [1:0] ALUOp,MemToreg ; 
    wire [3:0]ALU_sel;  
    wire [4:0] shamt; 
    reg [12:0]ssd;
    assign shamt = ALUmux_out[4:0];   /// need to checked 
    
   // assign PCin = (branch && ZFlag) ? adder_shiftout : adder_4out; // check
    nbitRegmod # (.n(32)) ops1( clk, cont, rst, PCin, PCout );
    InstMem ops2 (PCout[7:2], inst); 
    
    controlUnit ops3( inst[6:2], branch, MemRead, MemToreg, ALUOp, MemWrite, ALUSrc, RegWrite, jal, jalr, cont);
    regReset #(32) ops4( clk, rst, RegWrite, writeData,inst[19:15], inst[24:20], inst[11:7], data1, data2);
    immgen ops5 ( inst, imm_out);
    
    ALUControlU ops6( ALUOp, inst[14:12], inst[30], ALU_sel);
    nbitshift #(32) ops7(imm_out, shift_out);
    rca #(32) ops8(PCout, shift_out, 0, adder_shiftout, cout_useless);
    assign adder_4out = PCout+4;
    branchUnit opp( branch, zFlag, sFlag, cFlag, vFlag, inst[14:12], branchOut);
    nbitmux #(32) ops11( adder_4out, adder_shiftout, branchOut | jal, beforePC);
    nbitmux #(32) dod (beforePC, ALU_out, jalr, PCin);
    
    nbitmux #(32) ops9( data2, imm_out, ALUSrc, ALUmux_out);
    ALU0Flag ops10(data1, ALUmux_out,shamt,ALU_out, cFlag, zFlag, vFlag, sFlag, ALU_sel);
    DataMem ops12( clk,  MemRead,  MemWrite, ALU_out[7:0], data2,inst[14:12], read_mem); 
    nbitmux #(32) olalo (imm_out, 4, jal | jalr, ju_out );
    mux4to1 ops13( ALU_out, read_mem, imm_out, ju_out + PCout, MemToreg, writeData);
    // led 
     always @ (*) begin 
     case (ledSel)
        2'b00: led = inst [15:0];
        2'b01: led = inst [31:16];
        2'b10: led = {1'b0, ALUOp, branch, MemRead, MemToreg, MemWrite, ALUSrc, RegWrite, ALU_sel, zFlag, branchOut }; // check 
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
