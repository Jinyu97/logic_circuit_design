module f_adder_1(An, Bn, Cn_1, Sn, Cn);
	input An, Bn, Cn_1;
	output Sn, Cn;
	wire X0, X1, X2, X3;
	
	xor(X0, An, Bn), (Sn, X0, Cn_1);
	and(X1, An, Bn), (X2, An, Cn_1), (X3, Bn, Cn_1);
	or(Cn, X1, X2, X3);
endmodule