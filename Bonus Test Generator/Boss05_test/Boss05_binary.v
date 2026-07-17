// RISC-V Binary Test Program
// 7 instructions in 8-bit memory
// Memory base address: 0 to 27
// x31 initialized to 128 for memory operations
// Little-endian byte ordering
module TestMemory;
    reg [7:0] mem [0:27];
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

        // addi x6, x0, -953
        // 32'hC4700313
        mem[8] = 8'h13;
        mem[9] = 8'h03;
        mem[10] = 8'h70;
        mem[11] = 8'hC4;

        // blt x6, x31, -32
        // 32'hFFF340E3
        mem[12] = 8'hE3;
        mem[13] = 8'h40;
        mem[14] = 8'hF3;
        mem[15] = 8'hFF;

        // beq x6, x31, 26
        // 32'h01F30D63
        mem[16] = 8'h63;
        mem[17] = 8'h0D;
        mem[18] = 8'hF3;
        mem[19] = 8'h01;

        // sw x6, 0(x31)
        // 32'h006FA023
        mem[20] = 8'h23;
        mem[21] = 8'hA0;
        mem[22] = 8'h6F;
        mem[23] = 8'h00;

        // lbu x25, 0(x31)
        // 32'h000FCC83
        mem[24] = 8'h83;
        mem[25] = 8'hCC;
        mem[26] = 8'h0F;
        mem[27] = 8'h00;
    end
endmodule
