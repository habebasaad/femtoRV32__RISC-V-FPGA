`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2025 11:09:23 AM
// Design Name: 
// Module Name: divRem
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


module divRem( input [31:0] A, B, output reg [31:0] div, divu, rem, remu 
    );
    always @*  begin 
        if (B == 0) begin 
        div = 32'hFFFF_FFFF; // -1
        divu = 32'hFFFF_FFFF; // max negstive 
        rem = A;
        remu = A; 
        end 
        else begin 
        div = ($signed(A)) / ($signed(B));
       // divu =  ($signed({1'b0, A})) / ($signed({1'b0, B}));
        divu = A / B;
        rem = ($signed(A)) % ($signed(B));
        remu = (A % B);
        end 
    end 
     
endmodule
