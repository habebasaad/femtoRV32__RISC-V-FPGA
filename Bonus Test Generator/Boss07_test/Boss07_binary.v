// RISC-V Binary Test Program
// 8 instructions in 8-bit memory
// Memory base address: 0 to 31
// x31 initialized to 128 for memory operations
// Little-endian byte ordering
module TestMemory;
    reg [7:0] mem [0:31];
    initial begin

        // Fixed Initialization Instructions
        // ADDI x0, x0, 0
        mem[0] = 8'h13; // bits [7:0]
        mem[1] = 8'h00; // bits [15:8]
        mem[2] = 8'h00; // bits [23:16]
        mem[3] = 8'h00; // bits [31:24]

        // ADDI x31, x0, 128
        mem[4] = 8'h93; // bits [7:0]
        mem[5] = 8'h0F; // bits [15:8]
        mem[6] = 8'h00; // bits [23:16]
        mem[7] = 8'h08; // bits [31:24]

        // addi x3, x0, 715
        // 32'h2CB00193
        mem[8] = 8'h93;
        mem[9] = 8'h01;
        mem[10] = 8'hB0;
        mem[11] = 8'h2C;

        // sub x19, x3, x3
        // 32'h403189B3
        mem[12] = 8'hB3;
        mem[13] = 8'h89;
        mem[14] = 8'h31;
        mem[15] = 8'h40;

        // addi x22, x19, 1816
        // 32'h71898B13
        mem[16] = 8'h13;
        mem[17] = 8'h8B;
        mem[18] = 8'h89;
        mem[19] = 8'h71;

        // sltu x3, x3, x19
        // 32'h0131B1B3
        mem[20] = 8'hB3;
        mem[21] = 8'hB1;
        mem[22] = 8'h31;
        mem[23] = 8'h01;

        // bgeu x3, x22, -42
        // 32'hFD61FBE3
        mem[24] = 8'hE3;
        mem[25] = 8'hFB;
        mem[26] = 8'h61;
        mem[27] = 8'hFD;

        // sltu x21, x3, x3
        // 32'h0031BAB3
        mem[28] = 8'hB3;
        mem[29] = 8'hBA;
        mem[30] = 8'h31;
        mem[31] = 8'h00;
    end
endmodule
