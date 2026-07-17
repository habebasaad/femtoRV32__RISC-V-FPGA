`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2025 08:42:01 AM
// Design Name: 
// Module Name: nbitshift
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


module nbitshift #(parameter n = 8)(
        input [n-1:0] in, output [n-1:0] out
    );
    assign out = {in[n-2:0], 1'b0};
endmodule
