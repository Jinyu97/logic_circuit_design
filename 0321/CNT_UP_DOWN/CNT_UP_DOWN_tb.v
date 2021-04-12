module CNT_UP_DOWN_tb;

reg Clock, Reset, Up, Down;
wire [3:0] Count;

CNT_UP_DOWN CNT(Clock, Reset, Up, Down, Count); // CNT_UP_DOWN? instantiation

initial
begin
	Clock = 1'b1; // Clock? ???
	Reset = 1'b1; // Reset? ???
end

always
	#5 Clock = ~Clock; // Clock generation

initial
begin
	#20 Up = 0; Down =0; // select hold
	#30 Up = 1; Down =0; // select up
	#30 Up = 0; Down =1; // select down
	#30 Up = 1; Down =1; // select hold
end

endmodule
