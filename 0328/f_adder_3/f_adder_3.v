module f_adder_3(An, Bn, Cn_1, Sn, Cn);
	input An, Bn, Cn_1;
	output Sn, Cn;
	
	H_ADDER H_U0(An, Bn, X0, X1);
	H_ADDER H_U1(X0, Cn_1, Sn, X2);
	or(Cn, X1, X2);
endmodule