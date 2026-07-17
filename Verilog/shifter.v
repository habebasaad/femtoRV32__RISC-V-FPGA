`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2025 01:08:36 PM
// Design Name: 
// Module Name: shifter
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


module shifter(input [31:0] a, input [4:0] shamt, input [1:0] type, output reg[31:0] r);
always @* begin
        case (type)
            2'b01: r = a << shamt;         // SLL
            2'b00: r = a >> shamt;         // SRL
            2'b10: r = $signed(a) >>> shamt; // SRA
            default: r = 32'b0;
        endcase
    end

endmodule
