`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2025 11:02:41 AM
// Design Name: 
// Module Name: InstMem
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

//testing sb, lb, lh, lhu, lbu, lw, sw, sh
module InstMem (input [5:0] addr, output [31:0] data_out); 
// it's actual value is reg [31:0] mem [0:63];
reg [31:0] mem [0:63];
initial begin 
// to initialize values for x1 -> x7 & x9
mem[0]  = 32'b000000000000_00000_000_00000_0010011; // ADDI X0, X0, 0     
mem[1]  = 32'b111111111011_00000_000_00001_0010011; // ADDI x1,x0,-5 -> x1 = -5                                     *ADDI done*
mem[2]  = 32'b000000000001_00000_000_00010_0010011; // ADDI x2,x0,1 -> x2 = 1
mem[3]  = 32'b000000001001_00000_000_00011_0010011; // ADDI x3,x0,9 -> x3 = 9
mem[4]  = 32'b000000000110_00000_000_00100_0010011; // ADDI x4,x0,6 -> x4 = 6
mem[5]  = 32'b000010000000_00000_000_00101_0010011; // ADDI x5,x0,128 -> x5 = 128

mem[6] = 32'b0000000_00010_00000_000_00000_0100011; // SB x2,0(x0) -> mem[0] x2 = 1                                    *SB done*
mem[7] = 32'b0000000_00101_00000_000_00001_0100011; // SB x5,1(x0) -> mem[4] x5 =-128                              
mem[8] = 32'b000000000000_00000_000_01101_0000011; // LB x13,0(x0) -> x13 = 1                                          *LB done*
mem[9] = 32'b000000000000_00000_001_01110_0000011; // LH x14,0(x0) -> x14 = -32767                                        *LH done*
mem[10] = 32'b000000000000_00000_010_01111_0000011; // LW x15,0(x0) -> x15 = 32769                                         *LW done*
mem[11] = 32'b000000000100_00000_100_10000_0000011; // LBU x16,4(x0) -> x16 = 5 (as written in mem)                                        *LBU done*
mem[12] = 32'b000000000000_00000_101_10001_0000011; // LHU x17,0(x0) -> x17 = 32769                                         *LHU done*
mem[13] = 32'b0000000_00010_00000_000_01000_0100011; // SB x2,8(x0) -> mem[8] x2 = 1
mem[14] = 32'b0000000_00001_00000_001_01000_0100011; // SH x1,8(x0) -> mem[8,9] x3 =-5  [-5,-1]                                    *SH done*
mem[15] = 32'b000000000100_00000_010_01100_0100011; // SW x4,12(x0) -> mem[12] x4 =  6                                  *SW done*
mem[16] = 32'b000000001100_00000_010_01111_0000011; // LW x15,12(x0) -> x15 = 6                                         *LW done*

end 
  
assign data_out = mem[addr];


endmodule