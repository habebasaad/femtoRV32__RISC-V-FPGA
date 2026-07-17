// RISC-V Binary Test Program
// 31 instructions in 8-bit memory
// Memory base address: 0 to 123
// x31 initialized to 128 for memory operations
// Little-endian byte ordering
module TestMemory;
    reg [7:0] mem [0:123];
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

        // addi x28, x0, -851
        // 32'hCAD00E13
        mem[8] = 8'h13;
        mem[9] = 8'h0E;
        mem[10] = 8'hD0;
        mem[11] = 8'hCA;

        // addi x13, x0, -1262
        // 32'hB1200693
        mem[12] = 8'h93;
        mem[13] = 8'h06;
        mem[14] = 8'h20;
        mem[15] = 8'hB1;

        // addi x25, x0, 824
        // 32'h33800C93
        mem[16] = 8'h93;
        mem[17] = 8'h0C;
        mem[18] = 8'h80;
        mem[19] = 8'h33;

        // addi x16, x0, 262
        // 32'h10600813
        mem[20] = 8'h13;
        mem[21] = 8'h08;
        mem[22] = 8'h60;
        mem[23] = 8'h10;

        // addi x3, x0, 1763
        // 32'h6E300193
        mem[24] = 8'h93;
        mem[25] = 8'h01;
        mem[26] = 8'h30;
        mem[27] = 8'h6E;

        // and x26, x3, x13
        // 32'h00D1FD33
        mem[28] = 8'h33;
        mem[29] = 8'hFD;
        mem[30] = 8'hD1;
        mem[31] = 8'h00;

        // jal x10, 5500
        // 32'h57C0156F
        mem[32] = 8'h6F;
        mem[33] = 8'h15;
        mem[34] = 8'hC0;
        mem[35] = 8'h57;

        // sub x25, x13, x25
        // 32'h41968CB3
        mem[36] = 8'hB3;
        mem[37] = 8'h8C;
        mem[38] = 8'h96;
        mem[39] = 8'h41;

        // lhu x29, 0(x31)
        // 32'h000FDE83
        mem[40] = 8'h83;
        mem[41] = 8'hDE;
        mem[42] = 8'h0F;
        mem[43] = 8'h00;

        // lh x27, 0(x31)
        // 32'h000F9D83
        mem[44] = 8'h83;
        mem[45] = 8'h9D;
        mem[46] = 8'h0F;
        mem[47] = 8'h00;

        // and x25, x31, x13
        // 32'h00DFFCB3
        mem[48] = 8'hB3;
        mem[49] = 8'hFC;
        mem[50] = 8'hDF;
        mem[51] = 8'h00;

        // lb x26, 0(x31)
        // 32'h000F8D03
        mem[52] = 8'h03;
        mem[53] = 8'h8D;
        mem[54] = 8'h0F;
        mem[55] = 8'h00;

        // addi x23, x27, -407
        // 32'hE69D8B93
        mem[56] = 8'h93;
        mem[57] = 8'h8B;
        mem[58] = 8'h9D;
        mem[59] = 8'hE6;

        // jalr x25, 0(x3)
        // 32'h00018CE7
        mem[60] = 8'hE7;
        mem[61] = 8'h8C;
        mem[62] = 8'h01;
        mem[63] = 8'h00;

        // ecall
        // 32'h00000073
        mem[64] = 8'h73;
        mem[65] = 8'h00;
        mem[66] = 8'h00;
        mem[67] = 8'h00;

        // sub x24, x10, x26
        // 32'h41A50C33
        mem[68] = 8'h33;
        mem[69] = 8'h0C;
        mem[70] = 8'hA5;
        mem[71] = 8'h41;

        // auipc x12, 12887
        // 32'h03257617
        mem[72] = 8'h17;
        mem[73] = 8'h76;
        mem[74] = 8'h25;
        mem[75] = 8'h03;

        // beq x24, x31, 14
        // 32'h01FC0763
        mem[76] = 8'h63;
        mem[77] = 8'h07;
        mem[78] = 8'hFC;
        mem[79] = 8'h01;

        // ori x6, x23, -289
        // 32'hEDFBE313
        mem[80] = 8'h13;
        mem[81] = 8'hE3;
        mem[82] = 8'hFB;
        mem[83] = 8'hED;

        // andi x21, x3, 1516
        // 32'h5EC1FA93
        mem[84] = 8'h93;
        mem[85] = 8'hFA;
        mem[86] = 8'hC1;
        mem[87] = 8'h5E;

        // slt x20, x22, x2
        // 32'h002B2A33
        mem[88] = 8'h33;
        mem[89] = 8'h2A;
        mem[90] = 8'h2B;
        mem[91] = 8'h00;

        // lui x31, 43166
        // 32'h0A89EFB7
        mem[92] = 8'hB7;
        mem[93] = 8'hEF;
        mem[94] = 8'h89;
        mem[95] = 8'h0A;

        // sb x20, 0(x31)
        // 32'h014F8023
        mem[96] = 8'h23;
        mem[97] = 8'h80;
        mem[98] = 8'h4F;
        mem[99] = 8'h01;

        // lbu x22, 0(x31)
        // 32'h000FCB03
        mem[100] = 8'h03;
        mem[101] = 8'hCB;
        mem[102] = 8'h0F;
        mem[103] = 8'h00;

        // or x28, x12, x3
        // 32'h00366E33
        mem[104] = 8'h33;
        mem[105] = 8'h6E;
        mem[106] = 8'h36;
        mem[107] = 8'h00;

        // ori x30, x16, -1411
        // 32'hA7D86F13
        mem[108] = 8'h13;
        mem[109] = 8'h6F;
        mem[110] = 8'hD8;
        mem[111] = 8'hA7;

        // bge x16, x13, 36
        // 32'h02D85263
        mem[112] = 8'h63;
        mem[113] = 8'h52;
        mem[114] = 8'hD8;
        mem[115] = 8'h02;

        // sll x27, x31, x22
        // 32'h016F9DB3
        mem[116] = 8'hB3;
        mem[117] = 8'h9D;
        mem[118] = 8'h6F;
        mem[119] = 8'h01;

        // ecall
        // 32'h00000073
        mem[120] = 8'h73;
        mem[121] = 8'h00;
        mem[122] = 8'h00;
        mem[123] = 8'h00;
    end
endmodule
