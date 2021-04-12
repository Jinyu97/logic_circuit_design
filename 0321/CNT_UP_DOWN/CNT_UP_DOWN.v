module CNT_UP_DOWN(Clock, Reset, Up, Down, Count);

input Clock, Reset, Up, Down;
output [3:0] Count;
reg [3:0] Count;

always @(posedge Clock) begin // Clock? ?? ????
	if(Reset) // Reset?? 0?? ???
	Count = 0;
	else
		case({Up,Down}) // Concatenation operator? ???? Up, Down -> 2bit
		2'b00 : Count = Count ; // Up==0, Down==0 --> hold signal
		2'b10 : Count = Count+1 ; // Up==1, Down==0 --> up counting
		2'b01 : Count = Count-1 ; // Up==0, Down==1 --> down counting
		default : Count = Count ; // Up==1, Down==1 --> hold signal
		endcase
	end
	
endmodule
