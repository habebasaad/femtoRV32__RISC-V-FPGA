// RISC-V Binary Test Program
// 18 instructions in 8-bit memory
// Memory base address: 0 to 71
// x31 initialized to 128 for memory operations
// Little-endian byte ordering
module TestMemory;
    reg [7:0] mem [0:71];
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

        // addi x2, x0, 273
        // 32'h11100113
        mem[8] = 8'h13;
        mem[9] = 8'h01;
        mem[10] = 8'h10;
        mem[11] = 8'h11;

        // addi x15, x0, -1797
        // 32'h8FB00793
        mem[12] = 8'h93;
        mem[13] = 8'h07;
        mem[14] = 8'hB0;
        mem[15] = 8'h8F;

        // addi x22, x0, -1665
        // 32'h97F00B13
        mem[16] = 8'h13;
        mem[17] = 8'h0B;
        mem[18] = 8'hF0;
        mem[19] = 8'h97;

        // auipc x18, 51957
        // 32'h0CAF5917
        mem[20] = 8'h17;
        mem[21] = 8'h59;
        mem[22] = 8'hAF;
        mem[23] = 8'h0C;

        // sub x9, x22, x2
        // 32'h402B04B3
        mem[24] = 8'hB3;
        mem[25] = 8'h04;
        mem[26] = 8'h2B;
        mem[27] = 8'h40;

        // lhu x25, 0(x31)
        // 32'h000FDC83
        mem[28] = 8'h83;
        mem[29] = 8'hDC;
        mem[30] = 8'h0F;
        mem[31] = 8'h00;

        // lhu x21, 0(x31)
        // 32'h000FDA83
        mem[32] = 8'h83;
        mem[33] = 8'hDA;
        mem[34] = 8'h0F;
        mem[35] = 8'h00;

        // xori x1, x18, -1391
        // 32'hA9194093
        mem[36] = 8'h93;
        mem[37] = 8'h40;
        mem[38] = 8'h19;
        mem[39] = 8'hA9;

        // xor x16, x8, x29
        // 32'h01D44833
        mem[40] = 8'h33;
        mem[41] = 8'h48;
        mem[42] = 8'hD4;
        mem[43] = 8'h01;

        // lw x4, 0(x31)
        // 32'h000FA203
        mem[44] = 8'h03;
        mem[45] = 8'hA2;
        mem[46] = 8'h0F;
        mem[47] = 8'h00;

        // addi x21, x25, -13
        // 32'hFF3C8A93
        mem[48] = 8'h93;
        mem[49] = 8'h8A;
        mem[50] = 8'h3C;
        mem[51] = 8'hFF;

        // xori x7, x31, 598
        // 32'h256FC393
        mem[52] = 8'h93;
        mem[53] = 8'hC3;
        mem[54] = 8'h6F;
        mem[55] = 8'h25;

        // sb x21, 0(x31)
        // 32'h015F8023
        mem[56] = 8'h23;
        mem[57] = 8'h80;
        mem[58] = 8'h5F;
        mem[59] = 8'h01;

        // andi x29, x22, 31
        // 32'h01FB7E93
        mem[60] = 8'h93;
        mem[61] = 8'h7E;
        mem[62] = 8'hFB;
        mem[63] = 8'h01;

        // auipc x12, 40660
        // 32'h09ED4617
        mem[64] = 8'h17;
        mem[65] = 8'h46;
        mem[66] = 8'hED;
        mem[67] = 8'h09;

        // lbu x16, 0(x31)
        // 32'h000FC803
        mem[68] = 8'h03;
        mem[69] = 8'hC8;
        mem[70] = 8'h0F;
        mem[71] = 8'h00;
    end
endmodule
