module f_adder_2(An, Bn, Cn_1, Sn, Cn);
	input An, Bn, Cn_1;
	output Sn, Cn;
	
	assign 	Sn = An ^ Bn ^ Cn_1,
			Cn = (An & Bn) | (An & Cn_1) | (Bn & Cn_1);
endmodule