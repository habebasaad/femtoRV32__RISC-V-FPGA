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

 module hazard ( input [4:0]IF_ID_RegRs1, [4:0]IF_ID_RegRs2, [4:0]ID_EX_RegRd, input ID_EX_MemRead, output reg stall);
 
  always @* begin 
      
      stall =0;
      if ( (IF_ID_RegRs1 == ID_EX_RegRd) || (IF_ID_RegRs2 == ID_EX_RegRd) ) begin
        if ( ID_EX_MemRead && (ID_EX_RegRd != 0))
          stall = 1;
        end
  end 
endmodule

