`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2025 08:13:12 AM
// Design Name: 
// Module Name: nbitRegmod
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


module nbitRegmod # (parameter n = 8)( input clk, load, rst, [n-1:0]D, output [n-1:0]Q );
    wire [n-1: 0]w;
    genvar i;
    generate
        for(i = 0; i<n; i = i+1 ) begin
            mux2to1 m(Q[i], D[i], load, w[i]);
            DFlipFlop flipo(clk, rst, w[i], Q[i]);
        end
    endgenerate
    
endmodule
