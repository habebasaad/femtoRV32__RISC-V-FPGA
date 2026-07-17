`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2025 09:18:24 AM
// Design Name: 
// Module Name: controlUnit
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


module controlUnit(
    input [6:2] inst, output reg branch, MemRead, reg [1:0]MemToreg, output reg [1:0] ALUOp, output reg MemWrite, ALUSrc, RegWrite, jal, jalr, cont
    );
    // in memtoreg: 0 memory adi, 1 alu 3adi, 2 lui (imm), 3 auipc (imm+pc)
    always @ * begin
        case (inst)
        5'b01100: begin branch = 0; MemRead = 0; MemToreg = 2'b00; ALUOp = 2'b10; MemWrite = 0; ALUSrc =0; RegWrite = 1; jal =0; jalr = 0; cont =1; // R
        end
        5'b00000: begin branch = 0; MemRead = 1; MemToreg = 2'b01; ALUOp = 2'b00; MemWrite = 0; ALUSrc =1; RegWrite = 1; jal =0; jalr = 0; cont =1; // load
        end 
        5'b01000: begin branch = 0; MemRead = 0; MemToreg = 2'bxx; ALUOp = 2'b00; MemWrite = 1; ALUSrc =1; RegWrite = 0; jal =0; jalr = 0; cont =1; // store
        end 
        5'b11000: begin branch = 1; MemRead = 0; MemToreg = 2'bxx; ALUOp = 2'b01; MemWrite = 0; ALUSrc =0; RegWrite = 0; jal =0; jalr = 0; cont =1;// branch
        end
        5'b00100: begin branch = 0; MemRead = 0; MemToreg = 2'b00; ALUOp = 2'b11; MemWrite = 0; ALUSrc = 1; RegWrite = 1; jal =0; jalr = 0; cont =1;// i
        end
        5'b01101: begin branch = 0; MemRead = 0; MemToreg = 2'b10; ALUOp = 2'bxx; MemWrite = 0; ALUSrc = 1'bx; RegWrite = 1; jal =0; jalr = 0; cont =1;// lui 10 = out of immediate gen
        end 
        5'b00101: begin branch = 0; MemRead = 0; MemToreg = 2'b11; ALUOp = 2'bxx; MemWrite = 0; ALUSrc = 1'bx; RegWrite = 1; jal =0; jalr = 0; cont =1;// auipc 10 = out of immediate gen
        end 
        // not finish 
        5'b11011: begin branch = 0; MemRead = 0; MemToreg = 2'b11; ALUOp =2'bxx; MemWrite = 0; ALUSrc = 1'bx; RegWrite = 1; jal =1; jalr = 0;cont =1; // jal
        end 
        5'b11001: begin branch = 0; MemRead = 0; MemToreg = 2'b11; ALUOp = 2'b00; MemWrite = 0; ALUSrc = 1; RegWrite = 1; jal =0; jalr = 1;cont =1; // jalr
        end
        5'b00011:begin branch = 0; MemRead = 0; MemToreg = 2'b00; ALUOp = 2'b00; MemWrite = 0; ALUSrc = 0; RegWrite = 0; jal =0; jalr = 0; cont =0;// stall
        end
        5'b11100: begin branch = 0; MemRead = 0; MemToreg = 2'b00; ALUOp = 2'b00; MemWrite = 0; ALUSrc = 0; RegWrite = 0; jal =0; jalr = 0; cont =0; // stall
        end
         
        default:  begin branch = 0; MemRead = 0; MemToreg = 2'b00; ALUOp = 2'b11; MemWrite = 0; ALUSrc =0; RegWrite = 0; jal =0; jalr = 0; cont =0;
        
        end
            
        endcase
    end 
endmodule
