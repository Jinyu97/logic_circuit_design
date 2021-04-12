module mux_4to1_tb;

reg [3:0] i0,i1,i2,i3; // ???? ??
reg [1:0] sel; // ???? ??
wire [3:0] out; // ???? ??

mux_4to1 mux(i0, i1, i2, i3, sel, out); //mux_4to1? instantiation

initial
begin
	#10 i0 = 4'b0000; //???? ??
	i1 = 4'b0001;
	i2 = 4'b0010;
	i3 = 4'b0011;
	sel = 2'b00; // i0 ??
	$display("time %d, i0=%b, i1=%b, i2=%b, i3=%b, sel=%b, out=%b ?n", $time, i0, i1, i2, i3, sel, out);
	#10 sel = 2'b01; // i1 ??
	$display("time %d, i0=%b, i1=%b, i2=%b, i3=%b, sel=%b, out=%b ?n", $time, i0, i1, i2, i3, sel, out);
	#20 sel = 2'b10; // i2 ??
	$display("time %d, i0=%b, i1=%b, i2=%b, i3=%b, sel=%b, out=%b ?n", $time, i0, i1, i2, i3, sel, out);
	#25 i0 = 4'b1111;
	i1 = 4'b1110;
	i2 = 4'b1100;
	i3 = 4'b1000;
	#5 sel = 2'b11; // i3 ??
	$display("time %d, i0=%b, i1=%b, i2=%b, i3=%b, sel=%b, out=%b ?n", $time, i0, i1, i2, i3, sel, out);
	#10 $stop; // simulation ??
end

endmodule
