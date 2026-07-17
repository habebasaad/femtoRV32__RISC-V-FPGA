module rca #(parameter n=32)(
    input [n-1:0] A, B,
    input cin,
    output [n-1:0] sum, 
    output cout,
    output vFlag
    );
    wire [n:0] c;
    assign c[0] = cin;
    
    genvar i;
    generate 
    for ( i=0; i<n; i=i+1)
    begin 
        fullAdder fa(.A(A[i]),
            .B(B[i]),
            .cin(c[i]),
            .cout (c[i+1]),
            .sum (sum[i])
            );
    end
    endgenerate  
    assign  cout = c[n] ;
    assign vFlag = c[n-1] ^ c[n];
endmodule
