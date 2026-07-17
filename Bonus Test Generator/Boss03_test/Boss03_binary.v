// RISC-V Binary Test Program
// 10 instructions in 8-bit memory
// Memory base address: 0 to 39
// x31 initialized to 128 for memory operations
// Little-endian byte ordering
module TestMemory;
    reg [7:0] mem [0:39];
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

        // addi x7, x0, 1159
        // 32'h48700393
        mem[8] = 8'h93;
        mem[9] = 8'h03;
        mem[10] = 8'h70;
        mem[11] = 8'h48;

        // sub x24, x0, x4
        // 32'h40400C33
        mem[12] = 8'h33;
        mem[13] = 8'h0C;
        mem[14] = 8'h40;
        mem[15] = 8'h40;

        // andi x20, x12, -1103
        // 32'hBB167A13
        mem[16] = 8'h13;
        mem[17] = 8'h7A;
        mem[18] = 8'h16;
        mem[19] = 8'hBB;

        // add x8, x24, x31
        // 32'h01FC0433
        mem[20] = 8'h33;
        mem[21] = 8'h04;
        mem[22] = 8'hFC;
        mem[23] = 8'h01;

        // sw x20, 0(x31)
        // 32'h014FA023
        mem[24] = 8'h23;
        mem[25] = 8'hA0;
        mem[26] = 8'h4F;
        mem[27] = 8'h01;

        // xori x15, x8, -1713
        // 32'h94F44793
        mem[28] = 8'h93;
        mem[29] = 8'h47;
        mem[30] = 8'hF4;
        mem[31] = 8'h94;

        // andi x3, x6, -456
        // 32'hE3837193
        mem[32] = 8'h93;
        mem[33] = 8'h71;
        mem[34] = 8'h83;
        mem[35] = 8'hE3;

        // sub x5, x3, x15
        // 32'h40F182B3
        mem[36] = 8'hB3;
        mem[37] = 8'h82;
        mem[38] = 8'hF1;
        mem[39] = 8'h40;
    end
endmodule
