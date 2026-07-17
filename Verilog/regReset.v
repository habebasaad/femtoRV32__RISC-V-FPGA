`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2025 08:34:34 AM
// Design Name: 
// Module Name: regReset
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


module regReset #(parameter n =32)(
    input clk, rst, regWrite, [n-1: 0] writeData,input [4:0] addread1,addread2,addwrite, output [n-1:0]  data1,data2
    );
    reg [n-1:0] regfile [31:0];
    assign data1=regfile[addread1];
    assign data2=regfile[addread2];
   
    integer i;
    always @(negedge clk or posedge rst)
    begin 
        if(rst==1) begin
        for ( i=0;i<32;i=i+1) 
            regfile[i]<=0;
        end 
        else begin 
          if (regWrite==1 && addwrite!=0 )
                regfile[addwrite]<= writeData;
        end   
    end 
endmodule
