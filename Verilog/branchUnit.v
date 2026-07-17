`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2025 09:29:28 AM
// Design Name: 
// Module Name: branchUnit
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


module branchUnit( input branch, zFlag, sFlag, cFlag, vFlag, [14:12]inst, output branchOut);
reg outflags;

always @ * begin 
    case (inst)
        3'b000: outflags = zFlag;
        3'b001: outflags = ~zFlag;
        3'b100: outflags = (sFlag != vFlag);
        3'b101: outflags = (sFlag == vFlag);
        3'b110: outflags = ~cFlag;
        3'b111: outflags = cFlag;
        
    endcase

end 
assign branchOut = branch & outflags;
endmodule
