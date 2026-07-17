`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2025 08:28:25 AM
// Design Name: 
// Module Name: nbitmux
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


module nbitmux #(parameter n = 8)( input [n-1:0] in0, in1, input sel, output [n-1:0] out    );
genvar i;
generate 
    for(i=0; i<n; i=i+1) begin
        mux2to1 mmm(in0[i], in1[i], sel, out[i]);
    end
endgenerate
endmodule
