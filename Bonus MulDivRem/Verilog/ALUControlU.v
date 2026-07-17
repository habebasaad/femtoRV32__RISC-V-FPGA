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
    input [1:0] ALUOp, [14:12] inst, input inst30, inst25, output reg [4:0]sel 
    );
    always @ * begin 
       case(ALUOp)
        2'b00: sel = 5'b00000; // Add 
        2'b01: sel = 5'b00001; // sub 
        2'b10: begin
            if(inst == 3'b000 && ~inst25 ) 
                sel = (inst30)? 5'b00001: 5'b00000;  // sub, not then add
            else if (inst == 3'b111 && ~inst30 && ~inst25)
                sel = 5'b00101; //and 
            else if (inst == 3'b110 && ~inst30 && ~inst25)
                sel = 5'b00100; //or 
            else if  (inst == 3'b001 && ~inst30 && ~inst25)  //sll
                sel = 5'b01001; 
            else if  (inst == 3'b010 && ~inst30 && ~inst25)  //slt
                sel = 5'b01101;
            else if  (inst == 3'b011 && ~inst30 && ~inst25)  //sltu
                sel = 5'b01111;
            else if  (inst == 3'b100 && ~inst30 && ~inst25)  //xor
                sel = 5'b00111;  
            else if  (inst == 3'b101 && ~inst30 && ~inst25)  //srl
                sel = 5'b01000;    
            else if  (inst == 3'b101 && inst30 && ~inst25)  //sra
                sel = 5'b01010;
            else if  (inst == 3'b000 && ~inst30 && inst25)  //mul 
                sel = 5'b100_01;
            else if  (inst == 3'b001 && ~inst30 && inst25)  //mulh 
                sel = 5'b100_10;
            else if  (inst == 3'b010 && ~inst30 && inst25)  //mulhsu 
                sel = 5'b100_11;
            else if  (inst == 3'b011 && ~inst30 && inst25)  //mulhu 
                sel = 5'b101_00;
            else if  (inst == 3'b100 && ~inst30 && inst25)  //div 
                sel = 5'b101_01;
            else if  (inst == 3'b101 && ~inst30 && inst25)  //divu 
                sel = 5'b101_11;
            else if  (inst == 3'b110 && ~inst30 && inst25)  //rem 
                sel = 5'b110_00;
            else if  (inst == 3'b111 && ~inst30 && inst25)  //remu 
                sel = 5'b110_01;               
            //else sel = 5'b01111;  
            end  
        
           2'b11: begin if(inst == 0) 
                sel = 5'b00000;  //  add
            else if (inst == 3'b111 )
                sel = 5'b00101; //and 
            else if (inst == 3'b110 )
                sel = 5'b00100; //or 
            else if  (inst == 3'b001 && ~inst30)  //sll
                sel = 5'b01001; 
            else if  (inst == 3'b010)  //slt
                sel = 5'b01101;
            else if  (inst == 3'b011)  //sltu
                sel = 5'b01111;
            else if  (inst == 3'b100)  //xor
                sel = 5'b00111;  
            else if  (inst == 3'b101 && ~inst30)  //srl
                sel = 5'b01000;    
            else if  (inst == 3'b101 &&inst30)  //sra
                sel = 5'b01010;           
            //else sel = 5'b01111; 
        end 
        //default: sel = 5'b01111;
    endcase
    end 
endmodule
