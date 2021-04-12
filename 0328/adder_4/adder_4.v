module adder_4(A0, A1, A2, A3, B0, B1, B2, B3, Cin, C3, S0, S1, S2, S3);
	input A0, A1, A2, A3, B0, B1, B2, B3, Cin;
	output C3, S0, S1, S2, S3;
	wire C0, C1, C2;
	
	f_adder U0(A0, B0, Cin, S0, C0);
	f_adder U1(A1, B1, C0, S1, C1);
	f_adder U2(A2, B2, C1, S2, C2);
	f_adder U3(A3, B3, C2, S3, C3);
endmodule