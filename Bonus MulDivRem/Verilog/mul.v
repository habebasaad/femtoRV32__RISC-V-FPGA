module multi( input [31:0] A, B, output [31:0]mul, mulh, mulhsu, mulhu 
);
assign mul = (($signed(A)) * ($signed(B)));
assign mulh = (($signed(A)) * ($signed(B))) >>>32;
assign mulhsu = ( ($signed(A)) * ($signed({1'b0, B}))) >>>32;
assign mulhu = (A*B) >>32; 

endmodule 