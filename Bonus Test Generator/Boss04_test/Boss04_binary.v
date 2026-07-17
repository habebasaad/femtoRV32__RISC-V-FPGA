// RISC-V Binary Test Program
// 17 instructions in 8-bit memory
// Memory base address: 0 to 67
// x31 initialized to 128 for memory operations
// Little-endian byte ordering
module TestMemory;
    reg [7:0] mem [0:67];
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

        // addi x2, x0, 716
        // 32'h2CC00113
        mem[8] = 8'h13;
        mem[9] = 8'h01;
        mem[10] = 8'hC0;
        mem[11] = 8'h2C;

        // addi x20, x0, -1966
        // 32'h85200A13
        mem[12] = 8'h13;
        mem[13] = 8'h0A;
        mem[14] = 8'h20;
        mem[15] = 8'h85;

        // addi x27, x0, 487
        // 32'h1E700D93
        mem[16] = 8'h93;
        mem[17] = 8'h0D;
        mem[18] = 8'h70;
        mem[19] = 8'h1E;

        // slt x30, x2, x31
        // 32'h01F12F33
        mem[20] = 8'h33;
        mem[21] = 8'h2F;
        mem[22] = 8'hF1;
        mem[23] = 8'h01;

        // jal x30, 212718
        // 32'h6EF33F6F
        mem[24] = 8'h6F;
        mem[25] = 8'h3F;
        mem[26] = 8'hF3;
        mem[27] = 8'h6E;

        // jal x25, 271362
        // 32'h40242CEF
        mem[28] = 8'hEF;
        mem[29] = 8'h2C;
        mem[30] = 8'h24;
        mem[31] = 8'h40;

        // lh x8, 0(x31)
        // 32'h000F9403
        mem[32] = 8'h03;
        mem[33] = 8'h94;
        mem[34] = 8'h0F;
        mem[35] = 8'h00;

        // sb x8, 0(x31)
        // 32'h008F8023
        mem[36] = 8'h23;
        mem[37] = 8'h80;
        mem[38] = 8'h8F;
        mem[39] = 8'h00;

        // sltu x29, x25, x20
        // 32'h014CBEB3
        mem[40] = 8'hB3;
        mem[41] = 8'hBE;
        mem[42] = 8'h4C;
        mem[43] = 8'h01;

        // sltu x7, x25, x29
        // 32'h01DCB3B3
        mem[44] = 8'hB3;
        mem[45] = 8'hB3;
        mem[46] = 8'hDC;
        mem[47] = 8'h01;

        // xori x17, x29, 373
        // 32'h175EC893
        mem[48] = 8'h93;
        mem[49] = 8'hC8;
        mem[50] = 8'h5E;
        mem[51] = 8'h17;

        // sll x25, x17, x27
        // 32'h01B89CB3
        mem[52] = 8'hB3;
        mem[53] = 8'h9C;
        mem[54] = 8'hB8;
        mem[55] = 8'h01;

        // or x9, x16, x6
        // 32'h006864B3
        mem[56] = 8'hB3;
        mem[57] = 8'h64;
        mem[58] = 8'h68;
        mem[59] = 8'h00;

        // beq x8, x27, -66
        // 32'hFBB40FE3
        mem[60] = 8'hE3;
        mem[61] = 8'h0F;
        mem[62] = 8'hB4;
        mem[63] = 8'hFB;

        // sll x15, x7, x25
        // 32'h019397B3
        mem[64] = 8'hB3;
        mem[65] = 8'h97;
        mem[66] = 8'h93;
        mem[67] = 8'h01;
    end
endmodule
