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


module SingleMem (input clk, input MemRead, input MemWrite, input [7:0] addr, input [31:0] data_in, [14:12]inst, output reg [31:0] data_out);

reg [7:0] mem [0:255];
integer i;
    initial begin 
        for(i = 0; i < 256; i = i+1)
            mem[i]=0;
    end 
	//address 0->127 instruction memory 
    initial begin 
    //128, 132, 136
        // ADDI x0,x0,0
    mem[0] = 8'b00010011; // bits [7:0]
    mem[1] = 8'b00000000; // bits [15:8]
    mem[2] = 8'b00000000; // bits [23:16]
    mem[3] = 8'b00000000; // bits [31:24]
  
   // ADDI x31,x0,128
    mem[4] = 8'b10010011;  // bits [7:0]
    mem[5] = 8'b0_000_1111;    // bits [15:8]
    mem[6] = 8'b00000000; // bits [23:16]
    mem[7] = 8'b00001000; // bits [31:24]
      
   //mem[1]  = 32'b111111111011_00000_000_00001_0010011; // ADDI x1,x0,-5 -> x1 = -7                                        *ADDI done*
    mem[8]  = 8'b10010011; // 0x93
    mem[9]  = 8'b00000000; // 0x00
    mem[10] = 8'b10010000; // 0xB0
    mem[11] = 8'b11111111; // 0xFF
    
    //mem[2]  = 32'b000000000001_00000_000_00010_0010011; // ADDI x2,x0,1 -> x2 = 1
    mem[12] = 8'b00010011; // 0x13
    mem[13] = 8'b00000001; // 0x01
    mem[14] = 8'b00010000; // 0x10
    mem[15] = 8'b00000000; // 0x00
    
    //mem[3]  = 32'b00000001 0010_0000 0_000_0001 1_0010011; // ADDI x3,x0,18 -> x3 = 18
    mem[16] = 8'b10010011; // 0x93
    mem[17] = 8'b00000001; // 0x03
    mem[18] = 8'b00100000; // 0x18
    mem[19] = 8'b00000001; // 0x00
    
    //mem[4]  = 32'b000000000110_00000_000_00100_0010011; // ADDI x4,x0,6 -> x4 = 6
    mem[20] = 8'b00010011; // 0x13
    mem[21] = 8'b00000010; // 0x02
    mem[22] = 8'b01100000; // 0x60
    mem[23] = 8'b00000000; // 0x00

    // mem[5] = 32'b00000010 00100000 10000010 10110011; // MUL x5,x1,x2 -> x5 = x1 * x2 = -5 * 1 = -5 (signed lower 32 bits)
    mem[24] = 8'b10110011; // 0x33
    mem[25] = 8'b10000010; // 0x05
    mem[26] = 8'b00100000; // 0x08
    mem[27] = 8'b00000010; // 0x02
    
    // mem[6] = 32'b0000001_00010_0000 1_001_0010 1_0110011; // MULH x5,x1,x2 -> x5 = (x1 * x2) >> 32 = (-5 * 1) >> 32 = -1 (signed upper 32 bits)  00000010001000001001001010110011
    mem[28] = 8'b10110011; // 0xB3
    mem[29] = 8'b10010010; // 0x05
    mem[30] = 8'b00100000; // 0x08
    mem[31] = 8'b00000010; // 0x02
    
    // mem[7] = 32'b0000001_00010_0000 1_010_0010 1_0110011; // MULHSU x5,x1,x2 -> x5 = (signed(x1) * unsigned(x2)) >> 32 = (-5 * 1) >> 32 = -1 (upper 32 bits) 00000010001000001010001010110011
    mem[32] = 8'b10110011; // 0x33
    mem[33] = 8'b10100010; // 0x45
    mem[34] = 8'b00100000; // 0x08
    mem[35] = 8'b00000010; // 0x02
    
    // mem[8] = 32'b0000001_00010_00001_011_00101_0110011; // MULHU x5,x1,x2 -> x5 = (unsigned(x1) * unsigned(x2)) >> 32 = (4294967291 * 1) >> 32 = 0 (upper 32 bits, since x1 is negative but treated unsigned)
    mem[36] = 8'b10110011; // 0xB3
    mem[37] = 8'b10110010; // 0x45
    mem[38] = 8'b00100000; // 0x08
    mem[39] = 8'b00000010; // 0x02
    
    //mem[9]  = 32'b11111110 1110_0000 0_000_0011 0_0010011; // ADDI x6,x0,-18 -> x3 = -18
    mem[40] = 8'b00010011; // 0x93
    mem[41] = 8'b00000011; // 0x03
    mem[42] = 8'b11100000; // 0x18
    mem[43] = 8'b11111110; // 0x00
    
    // mem[10] = 32'b00000010 01000011 01000010 10110011; // DIV x5,x6,x4 -> x5 = signed(x3) / signed(x4) = -18 / 6 = -3 (quotient)
    mem[44] = 8'b10110011; // 0x33
    mem[45] = 8'b01000010; // 0x85
    mem[46] = 8'b01000011; // 0x30
    mem[47] = 8'b00000010; // 0x02
    
    // mem[11] = 32'b00000010 01000011 01010010 10110011; // DIVU x5,x3,x4 -> x5 = unsigned(x3) / unsigned(x4) = 18 / 6 = 3 (quotient)
    mem[48] = 8'b10110011; // 0xB3
    mem[49] = 8'b11010010; // 0x85
    mem[50] = 8'b01000001; // 0x30
    mem[51] = 8'b00000010; // 0x02
    
    // mem[12] = 32'b00000010 00010001 11100010 10110011; // REM x5,x3,x1 -> x5 = signed(x3) % signed(x4) = 18 % -7 = 4 (remainder)
    mem[52] = 8'b10110011; // 0x33
    mem[53] = 8'b11100010; // 0xC5
    mem[54] = 8'b00010001; // 0x30
    mem[55] = 8'b00000010; // 0x02
    
    // mem[13] = 32'b00000010 00010011 01110010 10110011; // REMU x5,x6,x1 -> x5 = unsigned(x3) % unsigned(x4) = -18 % -7 = -18 (remainder)
    mem[56] = 8'b10110011; // 0xB3
    mem[57] = 8'b01110010; // 0xC5
    mem[58] = 8'b00010011; // 0x30
    mem[59] = 8'b00000010; // 0x02
    
    end

	//address 128->255 data memory
    initial begin

        mem[128] = 8'd1; //i
        mem[132] = 8'd5;   // next word (addr 4) n
        mem[136] = 8'd0;  // next word (addr 8) x
    end
    
    always @* begin 
    if ( MemRead) begin 
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

    if ( MemWrite)begin
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