// RISC-V Binary Test Program
// 20 instructions in 8-bit memory
// Memory base address: 0 to 79
// x31 initialized to 128 for memory operations
// Little-endian byte ordering
module TestMemory;
    reg [7:0] mem [0:79];
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

        // addi x8, x0, 1682
        // 32'h69200413
        mem[8] = 8'h13;
        mem[9] = 8'h04;
        mem[10] = 8'h20;
        mem[11] = 8'h69;

        // addi x13, x0, -479
        // 32'hE2100693
        mem[12] = 8'h93;
        mem[13] = 8'h06;
        mem[14] = 8'h10;
        mem[15] = 8'hE2;

        // addi x17, x0, -224
        // 32'hF2000893
        mem[16] = 8'h93;
        mem[17] = 8'h08;
        mem[18] = 8'h00;
        mem[19] = 8'hF2;

        // and x24, x31, x8
        // 32'h008FFC33
        mem[20] = 8'h33;
        mem[21] = 8'hFC;
        mem[22] = 8'h8F;
        mem[23] = 8'h00;

        // lbu x12, 0(x31)
        // 32'h000FC603
        mem[24] = 8'h03;
        mem[25] = 8'hC6;
        mem[26] = 8'h0F;
        mem[27] = 8'h00;

        // sw x12, 0(x31)
        // 32'h00CFA023
        mem[28] = 8'h23;
        mem[29] = 8'hA0;
        mem[30] = 8'hCF;
        mem[31] = 8'h00;

        // sltu x6, x17, x24
        // 32'h0188B333
        mem[32] = 8'h33;
        mem[33] = 8'hB3;
        mem[34] = 8'h88;
        mem[35] = 8'h01;

        // xor x4, x12, x17
        // 32'h01164233
        mem[36] = 8'h33;
        mem[37] = 8'h42;
        mem[38] = 8'h16;
        mem[39] = 8'h01;

        // lbu x30, 0(x31)
        // 32'h000FCF03
        mem[40] = 8'h03;
        mem[41] = 8'hCF;
        mem[42] = 8'h0F;
        mem[43] = 8'h00;

        // ebreak
        // 32'h00100073
        mem[44] = 8'h73;
        mem[45] = 8'h00;
        mem[46] = 8'h10;
        mem[47] = 8'h00;

        // sh x6, 0(x31)
        // 32'h006F9023
        mem[48] = 8'h23;
        mem[49] = 8'h90;
        mem[50] = 8'h6F;
        mem[51] = 8'h00;

        // slt x11, x31, x24
        // 32'h018FA5B3
        mem[52] = 8'hB3;
        mem[53] = 8'hA5;
        mem[54] = 8'h8F;
        mem[55] = 8'h01;

        // addi x7, x31, -1726
        // 32'h942F8393
        mem[56] = 8'h93;
        mem[57] = 8'h83;
        mem[58] = 8'h2F;
        mem[59] = 8'h94;

        // ori x18, x11, 814
        // 32'h32E5E913
        mem[60] = 8'h13;
        mem[61] = 8'hE9;
        mem[62] = 8'hE5;
        mem[63] = 8'h32;

        // ori x1, x26, 1050
        // 32'h41AD6093
        mem[64] = 8'h93;
        mem[65] = 8'h60;
        mem[66] = 8'hAD;
        mem[67] = 8'h41;

        // add x3, x20, x28
        // 32'h01CA01B3
        mem[68] = 8'hB3;
        mem[69] = 8'h01;
        mem[70] = 8'hCA;
        mem[71] = 8'h01;

        // sw x24, 0(x31)
        // 32'h018FA023
        mem[72] = 8'h23;
        mem[73] = 8'hA0;
        mem[74] = 8'h8F;
        mem[75] = 8'h01;

        // lh x19, 0(x31)
        // 32'h000F9983
        mem[76] = 8'h83;
        mem[77] = 8'h99;
        mem[78] = 8'h0F;
        mem[79] = 8'h00;
    end
endmodule
