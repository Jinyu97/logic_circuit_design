module AND_tb; // test bench
	wire y_out;
	reg a_in;
	reg b_in;

	AND U0( .Y (y_out), .A (a_in), .B (b_in) );

	initial 
		begin //test vector, initial? ?? ??
		a_in = 'b0; b_in = 'b0;
		#10	a_in = 'b0; b_in = 'b1; //10?? ?? ??, a=0 b=1(???)
		#10	a_in = 'b1; b_in = 'b0;
		#10	a_in = 'b1; b_in = 'b1;
		end //initial? ???
endmodule
