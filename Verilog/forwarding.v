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

 module forwarding ( input [4:0]ID_EX_RegRs1, [4:0]ID_EX_RegRs2, [4:0]EX_MEM_RegRd, [4:0]MEM_WB_RegRd, input EX_MEM_RegWrite, MEM_WB_RegWrite , output reg [1:0] forwardA, forwardB);
 
  always @* begin 
      // EX hazard
        forwardA = 2'b00;
        forwardB = 2'b00;
//    if ( EX_MEM_RegWrite & (EX_MEM_RegRd != 0)) begin 
//      if (EX_MEM_RegRd == ID_EX_RegRs1)
//        forwardA = 2'b10;
//      if (EX_MEM_RegRd == ID_EX_RegRs2) 
//        forwardB = 2'b10;
//    end
      // MEM hazard
    if ( MEM_WB_RegWrite & (MEM_WB_RegRd != 0)) begin
      if ((MEM_WB_RegRd == ID_EX_RegRs1))
        forwardA = 2'b01;

    if ((MEM_WB_RegRd== ID_EX_RegRs2))
        forwardB = 2'b01;
    end
 
  end 
endmodule

