module f_adder_4(An, Bn, Cn_1, Sn, Cn);
	input An, Bn, Cn_1;
	output Sn, Cn;
	reg Sn, Cn;
	
	always@(An or Bn or Cn_1)
	{Cn, Sn} = An + Bn + Cn_1;
endmodule