`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2025 09:41:05 AM
// Design Name: 
// Module Name: ALUControlU
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


module ALUControlU(
    input [1:0] ALUOp, [14:12] inst, input inst30, output reg [3:0]sel 
    );
    always @ * begin 
       case(ALUOp)
        2'b00: sel = 4'b0000; // Add 
        2'b01: sel = 4'b0001; // sub 
        2'b10: begin
            if(inst == 0) 
                sel = (inst30)? 4'b0001: 4'b0000;  // sub, not then add
            else if (inst == 3'b111 && ~inst30)
                sel = 4'b0101; //and 
            else if (inst == 3'b110 && ~inst30)
                sel = 4'b0100; //or 
            else if  (inst == 3'b001 && ~inst30)  //sll
                sel = 4'b1001; 
            else if  (inst == 3'b010 && ~inst30)  //slt
                sel = 4'b1101;
            else if  (inst == 3'b011 && ~inst30)  //sltu
                sel = 4'b1111;
            else if  (inst == 3'b100 && ~inst30)  //xor
                sel = 4'b0111;  
            else if  (inst == 3'b101 && ~inst30)  //srl
                sel = 4'b1000;    
            else if  (inst == 3'b101 && inst30)  //sra
                sel = 4'b1010;           
            //else sel = 4'b1111;  
            end  
        
           2'b11: begin if(inst == 0) 
                sel = 4'b0000;  //  add
            else if (inst == 3'b111 )
                sel = 4'b0101; //and 
            else if (inst == 3'b110 )
                sel = 4'b0100; //or 
            else if  (inst == 3'b001 && ~inst30)  //sll
                sel = 4'b1001; 
            else if  (inst == 3'b010)  //slt
                sel = 4'b1101;
            else if  (inst == 3'b011)  //sltu
                sel = 4'b1111;
            else if  (inst == 3'b100)  //xor
                sel = 4'b0111;  
            else if  (inst == 3'b101 && ~inst30)  //srl
                sel = 4'b1000;    
            else if  (inst == 3'b101 &&inst30)  //sra
                sel = 4'b1010;           
            //else sel = 4'b1111; 
        end 
        //default: sel = 4'b1111;
    endcase
    end 
endmodule
