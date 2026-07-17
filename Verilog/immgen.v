`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2025 08:54:00 AM
// Design Name: 
// Module Name: immgen
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


module immgen( input [31:0] inst, output reg [31:0] gen_out);
    wire [6:0] opcode;
   // reg [11:0] imm;
    assign opcode = inst[6:0];
    always @(*) begin 
    // imm = 12'b0;
        case(opcode)  
            7'b1100011:  gen_out =  {{20{inst[31]}}, inst[31],inst[7],inst[30:25],inst[11:8]}; //beq 
            7'b0100011:  gen_out = {{20{inst[31]}}, inst[31:25],inst[11:7]};  //sw
            7'b0000011:  gen_out = {{20{inst[31]}},inst[31:20]};//lw
            7'b0010011:  gen_out = {{20{inst[31]}}, inst[31:20]};// i
            7'b0110111:  gen_out = {inst[31:12], 12'b0}; // lui 
            7'b0010111:  gen_out = {inst[31:12], 12'b0}; // Auipc 
            7'b1101111:  gen_out = {{13{inst[31]}}, inst[19:12], inst[20], inst[30:21]}; //Jal
            7'b1100111:  gen_out = {{20{inst[31]}}, inst[31:20]}; //JalR
            default:  gen_out=0;
        endcase 
        
    end 

endmodule
