// Code your design here

// Module for a single full-adder
module full_adder(
  input A, B, Cin,
  output S, Cout
);
  
  wire net1, net2, net3;
  
  // Refering to Digital Circuit of Full Adder
  xor (net1, A, B);
  xor (S, net1, Cin);
  and (net3, A, B);
  and (net2, net1, Cin);
  or (Cout, net2, net3);
endmodule

// Module for a single half-adder (needed for PLUS3)
module half_adder(
  input A, B,
  output S, C
);
  
  // Refering to Digital Circuit of Half Adder
  and (C, A, B);
  xor (S, A, B);
endmodule

// Module for an 8-bit Ripple Carry Full Adder
module full_adder8(
  input [7:0] A, B,
  input Cin,
  output [7:0] S,
  output Cout);
  
  wire [6:0] carry;
  
  // Applying single full-adders to implement 8-bit adder
  full_adder fa0(
    .A(A[0]),
    .B(B[0]),
    .Cin(Cin),
    .S(S[0]),
    .Cout(carry[0])
  );
  
  full_adder fa1(
    .A(A[1]),
    .B(B[1]),
    .Cin(carry[0]),
    .S(S[1]),
    .Cout(carry[1])
  );
  
  full_adder fa2(
    .A(A[2]),
    .B(B[2]),
    .Cin(carry[1]),
    .S(S[2]),
    .Cout(carry[2])
  );
  
  full_adder fa3(
    .A(A[3]),
    .B(B[3]),
    .Cin(carry[2]),
    .S(S[3]),
    .Cout(carry[3])
  );
  
  full_adder fa4(
    .A(A[4]),
    .B(B[4]),
    .Cin(carry[3]),
    .S(S[4]),
    .Cout(carry[4])
  );
  
  full_adder fa5(
    .A(A[5]),
    .B(B[5]),
    .Cin(carry[4]),
    .S(S[5]),
    .Cout(carry[5])
  );
  
  full_adder fa6(
    .A(A[6]),
    .B(B[6]),
    .Cin(carry[5]),
    .S(S[6]),
    .Cout(carry[6])
  );
  
  full_adder fa7(
    .A(A[7]),
    .B(B[7]),
    .Cin(carry[6]),
    .S(S[7]),
    .Cout(Cout)
  );
  
endmodule 

// Module for adding 3 when bin value >= 5
// Part of the Double Dabble Algorithm implementation
module PLUS3(
  input A0, A1, A2, A3,
  output Q0, Q1, Q2, Q3
);
  
  wire net1, net2, net3, net4, net5, net6, net7, net8;
  
  // Refering to Digital Circuit from
  // electronics.stackexchange.com/questions/440910/k-maps-for-forming-8bit-binary-to-8bit-bcd-digital-circuit
  
  or (net1, A0, A1);
  and (net2, A2, net1);
  or (net3, A3, net2);
  xor (net4, A0, net3);
  and (net5, net3, net4);
  and (net6, ~A1, net5);
  xor (net7, net3, net6);
  
  half_adder ha0(A2, net7, Q2, net8);
  
  xor (Q3, net8, A3);
  xor (Q1, A1, net5);
  assign Q0 = net4;
  
endmodule

// Module for Binary to BCD converter

// Refering to Digital Circuit from
// electronics.stackexchange.com/questions/440910/k-maps-for-forming-8bit-binary-to-8bit-bcd-digital-circuit

module BIN2BCD(
  input [7:0] A,
  output [3:0] HUNDREDS,
  output [3:0] TENS,
  output [3:0] ONES);
  
  wire [3:0] PLUS3_0;
  wire [3:0] PLUS3_1;
  wire [3:0] PLUS3_2;
  wire [3:0] PLUS3_3;
  wire [3:0] PLUS3_5;
  wire [3:0] PLUS3_6;
  
  assign ONES[0] = A[0];
  
  // Implementing PLU3 modules to carry out full Double Dabble
  PLUS3 P30(
    A[5],
    A[6],
    A[7],
    0,
    PLUS3_0[0],
    PLUS3_0[1],
    PLUS3_0[2],
    PLUS3_0[3]
  );
  
  PLUS3 P31(
    A[4],
    PLUS3_0[0],
    PLUS3_0[1],
    PLUS3_0[2],
    PLUS3_1[0],
    PLUS3_1[1],
    PLUS3_1[2],
    PLUS3_1[3]
  );
  
  PLUS3 P32(
    A[3],
    PLUS3_1[0],
    PLUS3_1[1],
    PLUS3_1[2],
    PLUS3_2[0],
    PLUS3_2[1],
    PLUS3_2[2],
    PLUS3_2[3]
  );
  
  PLUS3 P33(
    A[2],
    PLUS3_2[0],
    PLUS3_2[1],
    PLUS3_2[2],
    PLUS3_3[0],
    PLUS3_3[1],
    PLUS3_3[2],
    PLUS3_3[3]
  );
  
  PLUS3 P34(
    A[1],
    PLUS3_3[0],
    PLUS3_3[1],
    PLUS3_3[2],
    ONES[1],
    ONES[2],
    ONES[3],
    TENS[0]
  );
  
  PLUS3 P35(
    PLUS3_2[3],
    PLUS3_1[3],
    PLUS3_0[3],
    0,
    PLUS3_5[0],
    PLUS3_5[1],
    PLUS3_5[2],
    HUNDREDS[1]
  );
  
  PLUS3 P36(
    PLUS3_3[3],
    PLUS3_5[0],
    PLUS3_5[1],
    PLUS3_5[2],
    TENS[1],
    TENS[2],
    TENS[3],
    HUNDREDS[0]
  );
  
  assign HUNDREDS[2] = 0;
  assign HUNDREDS[3] = 0;
endmodule

// Module for a single unit of BCD to 7SD
// Assuming 7SD is Common-Anode
// whereby HIGH input will light up the segments

// Can be synthesised by analysing truth table of BCD to 7SD
// Then producing K-map, then synthesising logic equations
module BCD27SD(
  input A, B, C, D,
  output a, b, c, d, e, f, g
);
  
  wire net1, net2, net3, net4, net5, net6, net7, net8, net9;
  
  and (net1, B, ~D);
  and (net2, B, ~C);
  and (net3, net2, D);
  and (net4, ~B, C);
  and (net5, C, ~D);
  and (net6, ~C, ~D);
  and (net7, C, D);
  and (net8, ~B, ~D);
  and (net9, B, D);
  
  or (a, A, C, net8, net9);
  or (b, ~B, net6, net7);
  or (c, B, ~C, D);
  or (d, A, net3, net4, net5, net8);
  or (e, net5, net8);
  or (f, A, net1, net2, net6);
  or (g, A, net2, net4, net5);
endmodule