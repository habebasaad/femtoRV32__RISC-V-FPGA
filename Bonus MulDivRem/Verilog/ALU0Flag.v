module ALU0Flag(
	input   wire [31:0] a, b,
	input   wire [4:0]  shamt,
	output  reg  [31:0] r,
	output  wire  cf, zf, vf, sf,
	input   wire [4:0]  alufn
);

    wire [31:0] add, sub, op_b, mul, mulh, mulhsu, mulhu, div, divu, rem, remu ;
    wire cfa, cfs;
    
    assign op_b = (~b);
    
    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b);
    
    assign zf = (add == 0);
    assign sf = add[31]; //1
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf); //0
    
    wire[31:0] sh;
    shifter shifter0(.a(a), .shamt(shamt), .type(alufn[1:0]),  .r(sh));
    multi beb(a, b, mul, mulh, mulhsu, mulhu );
    divRem bebo(a, b, div, divu, rem, remu );
    
    always @ * begin
        r = 0;
        (* parallel_case *)
        case (alufn)
            // arithmetic
            5'b000_00 : r = add; //add 
            5'b000_01 : r = add; //sub
            5'b000_11 : r = b;  // not used now 
            // logic
            5'b001_00:  r = a | b; //or 
            5'b001_01:  r = a & b;  // and 
            5'b001_11:  r = a ^ b;  // xor 
            // shift
            5'b010_00:  r=sh;  // srl
            5'b010_01:  r=sh;  //sll
            5'b010_10:  r=sh;  //sra
            // slt & sltu
            5'b011_01:  r = {31'b0,(sf != vf)}; //slt
            5'b011_11:  r = {31'b0,(~cf)};    //sltu  
            // mul 
            5'b100_01:  r = mul;
            5'b100_10:  r = mulh;
            5'b100_11:  r = mulhsu;
            5'b101_00:  r = mulhu;	
            //div 
            5'b101_01:  r = div;
            5'b101_11:  r = divu;
            //rem 
            5'b110_00:  r = rem;
            5'b110_01:  r = remu;
        endcase
    end
endmodule