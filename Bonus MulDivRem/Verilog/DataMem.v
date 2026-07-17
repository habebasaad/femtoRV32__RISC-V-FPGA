`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2025 11:12:52 AM
// Design Name: 
// Module Name: DataMem
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


module DataMem (input clk, input MemRead, input MemWrite, input [7:0] addr, input [31:0] data_in, [14:12]inst, output reg [31:0] data_out);

reg [7:0] mem [0:255];
integer i;
    initial begin 
        for(i = 0; i < 256; i = i+1)
            mem[i]=0;
    end 
    initial begin

        mem[0]=8'd17; //i
        mem[4] = 8'd9;   // next word (addr 4) n
        mem[8] = 8'd25;  // next word (addr 8) x
    end
    // func3 = inst [14:12];
    always @* begin 
    if (MemRead) begin 
        case (inst)
        3'b000:   data_out = { {24{mem[addr][7]}}, mem[addr]}; //lb 
        3'b001:   data_out = { {16{mem[addr+1][7]}},mem[addr+1], mem[addr]}; //lh
        3'b010:   data_out = {mem[addr+3],mem[addr+2] ,mem[addr+1], mem[addr]}; //lw
        3'b100:   data_out = { {24'b0}, mem[addr]}; //lbu
        3'b101:   data_out = { {16'b0},mem[addr+1], mem[addr]}; //lhu 
        default:  data_out = 0; 
        endcase
    end 
    end 
    

always @(posedge clk) begin 

    if (MemWrite)begin
        case (inst) 
        3'b000: begin // SB
                mem[addr] <= data_in[7:0];
            end
        3'b001: begin // SH
                mem[addr]   <= data_in[7:0];
                mem[addr+1] <= data_in[15:8];
            end
        3'b010: begin // SW
                mem[addr]   <= data_in[7:0];
                mem[addr+1] <= data_in[15:8];
                mem[addr+2] <= data_in[23:16];
                mem[addr+3] <= data_in[31:24];
            end
        endcase 
    
    end
end 
endmodule