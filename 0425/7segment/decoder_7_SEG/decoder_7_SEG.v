module decoder_7_SEG(A, B, C, D, COM, sa, sb, sc, sd, se, sf, sg);
	input D,C,B,A;
	output sa,sb,sc,sd,se,sf,sg;
	output [7:0] COM;

	assign sa = D | B |(C ~^ A);
	assign sb = ~(C &( B^A ));
	assign sc = C | ~B | A;
	assign sd = D|(~C & ~A)|(~C & B)|(B & ~A)|(C & ~B & A);
	assign se = (~C & ~A)|(B & ~A);
	assign sf = D|(~B & ~A)|(C & ~B)|(C & ~A);
	assign sg = D|( C^B )|(C & ~A);
	assign COM = 8'b11111110;
	
endmodule
