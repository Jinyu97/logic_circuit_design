`define MSB 4 // define ? : MSB? 4
module mux_4to1 (i0, i1, i2, i3, sel, out); // module ??

input [`MSB-1:0] i0, i1, i2, i3; // 4bit input
input [1:0] sel;
output [`MSB-1:0] out;
reg [`MSB-1:0] out;

always @(sel or i0 or i1 or i2 or i3) // always ??? ???? ???? ??
begin // ??? sensitive lists? ??? ?
	if(sel==0) out = i0; //sel? 0??,
	else if(sel==1) out = i1; //sel? 1??,
	else if(sel==2) out = i2; //sel? 2??,
	else out = i3;
end

endmodule
