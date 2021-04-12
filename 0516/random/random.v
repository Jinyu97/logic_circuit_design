module random(acount_10, acount_1, SEG_C, SEG_SEL, CLK, RESET);

output [3:0] acount_10, acount_1;
output [6:0] SEG_C;
output [7:0] SEG_SEL;
input CLK, RESET;
reg [6:0] SEG_C;
reg [7:0] SEG_SEL;
reg [3:0] acount_10, acount_1;
reg [51:0] CLK_COUNT;
reg [51:0] CLK_COUNT2;
reg [6:0] RAND;
reg CLK1, CLK2;


	always @(negedge CLK or posedge RESET)
		if(RESET) CLK1<=0;
		else if (CLK_COUNT==249999) begin CLK_COUNT<=0; CLK1<=1; end
		else begin CLK_COUNT <= CLK_COUNT+1; CLK1<=0; end

	always @(negedge CLK or posedge RESET)
		if(RESET) CLK2<=0;
		else if (CLK_COUNT2==2499999) begin CLK_COUNT2<=0; CLK2<=1; end
		else begin CLK_COUNT2 <= CLK_COUNT2+1; CLK2<=0; end


	always @(negedge CLK1)
		if (RAND==99) begin RAND<=0; end
		else begin RAND <= RAND+1; end
		
	always @(negedge CLK2)
		begin
	    acount_10 <= RAND/10;
		acount_1 <= RAND%10;

		end	
			
		term u0(CLK, RESET, SEG_C, SEG_SEL, acount_10, acount_1);				
				

endmodule

module term(CLK, RESET, SEG_C, SEG_SEL, RAND1, RAND2);
	input CLK, RESET;
	input [3:0] RAND1, RAND2;
	output [6:0] SEG_C;
	output [7:0] SEG_SEL;
	reg [6:0] SEG_C;
	reg [3:0] DEC_1, DEC_2, DEC_TMP;
	reg [18:0] CLK_COUNT;
	reg [1:0] SEL_SEG;
	reg [7:0] SEG_SEL;
	reg CLK1;
	reg [51:0]  counts;

	always @(RAND1 or RAND2)
	begin
	DEC_1 <= RAND1;
	DEC_2 <= RAND2;
	end
	
	always @(posedge CLK or posedge RESET)  begin
	if(RESET) begin counts <= 0; CLK1 <= 1; end
	else if (counts >= 2499999) begin counts <= 0; CLK1 <= !CLK1; end
	else counts <= counts +1; end

	always@(negedge CLK1) // SEL_SEG
		if(SEL_SEG==1) SEL_SEG <=0;
		else SEL_SEG <= SEL_SEG+1;

	always@(DEC_1 or DEC_2 or SEL_SEG)
		case (SEL_SEG)
		0 : DEC_TMP <= DEC_1;
		1 : DEC_TMP <= DEC_2;
	endcase

	always@(SEL_SEG)
		case(SEL_SEG)
		0 : SEG_SEL <= 8'b01111111;
		1 : SEG_SEL <= 8'b11011111;
		endcase

	SEG_DEC U0 (DEC_TMP,SEG_C);

endmodule

module SEG_DEC(DIGIT, SEG_DEC);
	input [3:0] DIGIT;
	output [6:0] SEG_DEC;
	reg [6:0] SEG_DEC;

	always @(DIGIT)
	case (DIGIT) // gfe_dcba
	0 : SEG_DEC <= 7'h3f; // 011_1111
	1 : SEG_DEC <= 7'h06; // 000_0110
	2 : SEG_DEC <= 7'h5b; // 101_1011
	3 : SEG_DEC <= 7'h4f; // 100_1111
	4 : SEG_DEC <= 7'h66; // 010_0110
	5 : SEG_DEC <= 7'h6d; // 110_1101
	6 : SEG_DEC <= 7'h7c; // 111_1100
	7 : SEG_DEC <= 7'h07; // 000_0111
	8 : SEG_DEC <= 7'h7f; // 111_1111
	9 : SEG_DEC <= 7'h67; // 110_0111
	endcase
endmodule