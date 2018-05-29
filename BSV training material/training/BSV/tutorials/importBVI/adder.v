// import options for a combinational circuit such as an adder
module adder (A, B, X);
    parameter W = 1;            // Data width
   
    input [W-1:0] A, B;

    output [W-1:0] X;
endmodule
    
