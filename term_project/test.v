//MAIN
module test (clk, rst, seg_c, seg_sel, sw10, sw1, piezo_out);


	input 	clk, rst;
	input [7:0] sw10, sw1;

	output [6:0] seg_c;
	output [7:0] seg_sel;
	output piezo_out;
	reg [6:0] seg_c;
	reg [7:0] seg_sel;
	
	reg [3:0] r1, r2;
	reg [3:0] ans10, ans1;
	wire [6:0] answer;
	wire [6:0] answer_sw;
	
	reg [7:0] clk_count;
	reg [51:0] clk_count2;
	reg clk1, clk2;
	reg [4:0] note;
	reg [5:0] countt;

	parameter C_tone = 956;
	parameter D_tone = 851;
	parameter E_tone = 758;
	parameter F_tone = 716;
	parameter G_tone = 638;
	parameter A_tone = 568;
	parameter B_tone = 506;
	
	reg [9:0] piezo_cnt;
	reg piezo_out;
	reg [9:0] cnt;
	
	
	
	reg [3:0] number;
	reg [2:0] check;
	

random u0 (number, rst, clk);
display u1(clk, rst, seg_c, seg_sel, number, sw10, sw1, r1, r2, ans10, ans1);

 assign answer = r1*r2;
 assign answer_sw = ans10*10+ans1;


	
	always @(posedge clk)
	begin
		if (rst) 
			clk_count <= 0;
		
		else if (clk_count == 49)//clk = 25MHzÀÏ ¶§.
		begin
			clk_count <= 0;
			clk1 <= 1;
		end
		else
		begin
			clk_count <= clk_count+1;
			clk1 <= 0;
		end
	end
	
	
	always @(negedge clk or posedge rst) // CLK2
		if(rst) clk2<=0;
		else if (clk_count2==3000000) begin clk_count2<=0; clk2=1; end
		else begin clk_count2 <= clk_count2+1; clk2<=0; end
	
	
 always@(posedge clk2) begin // SEC_SEG
	if(rst) countt <=0;
	else countt <= countt+1; end	
	


always @(answer_sw) begin
if(answer==answer_sw)
	 check<=0;
else
	 check<=1;
 end
 
always@(posedge clk2) begin
	if ((countt < 8) && (note<7)) note <= note+1;
	else note=0;
	end

always@(note or check)	begin	
if (check==1)
	case(note)
		0 : piezo_cnt <= 0;
		1 : piezo_cnt <= A_tone;
		2 : piezo_cnt <= A_tone;
		3 : piezo_cnt <= 0;
		4 : piezo_cnt <= 0;
		5 : piezo_cnt <= 0;
		6 : piezo_cnt <= 0;
		7 : piezo_cnt <= 0;
		8 : piezo_cnt <= 0;		
	
		
	endcase
else 
	case(note)		
		0 : piezo_cnt <= 0;
		1 : piezo_cnt <= C_tone;
		2 : piezo_cnt <= 0;
		3 : piezo_cnt <= E_tone;
		4 : piezo_cnt <= 0;
		5 : piezo_cnt <= G_tone;
		6 : piezo_cnt <= 0;
		7 : piezo_cnt <= C_tone/2;
		8 : piezo_cnt <= 0;
	
		
		
	endcase
	

end


	always @(posedge clk1 or posedge rst) begin
		if (rst) begin
			cnt <=0;
			piezo_out <= 0;
		end
		else begin
			if (cnt == piezo_cnt) begin
				cnt <= 0;
				piezo_out <= ~piezo_out;
			end
			else	cnt <= cnt+1;
		end
		end



endmodule



module random(ran, rst, clk);


parameter maxnum = 16;

parameter select4 = 8;
parameter select3 = 4;
parameter select2 = 3;
parameter select1 = 2;
parameter select0 = 1;

 
input clk, rst;


output [3:0] ran;
reg [3:0] ran;


reg clk3;
reg [(maxnum-1):0] ranreg;
reg regtmp;

integer i;

reg [50:0] clk_count5;

always @(negedge clk3 or posedge rst)
begin
if (rst)
ranreg <= 16'b0010111010110101;
else
begin

ran = {ranreg[select3], ranreg[select2], ranreg[select1], ranreg[select0]};
regtmp = (ranreg[select3]^ranreg[select2]^ranreg[select1]^ranreg[select0]);

for (i = 0;  i < maxnum-1 ; i = i+1)
	begin
	ranreg[i] = ranreg[i+1];
	end
ranreg[maxnum-1] = regtmp;
end

end

always @(negedge clk or posedge rst) 
begin
if (rst)
	clk3 <= 0;
else if (clk_count5 == 199999999)
	begin
	clk_count5 <= 0;
	clk3 <= 1;
	end
else
	begin
	clk_count5 <= clk_count5+1;
	clk3 <= 0;
	end
end

endmodule


module display(CLK, RESET, SEG_C, SEG_SEL, RAND, sw10, sw1, RAND1, RAND2, ANS10, ANS1);
	input CLK, RESET;
	input [3:0] RAND;
	input [7:0] sw10, sw1;
	output [6:0] SEG_C;
	output [7:0] SEG_SEL;
	output [3:0] RAND1, RAND2;
	output [3:0] ANS10, ANS1;
	wire [3:0] RAND1, RAND2;
	wire [3:0] ANS10, ANS1;
	reg [6:0] SEG_C;
	reg [11:0] DEC_1, DEC_2, DEC_3, DEC_4, DEC_TMP;
	reg [18:0] CLK_COUNT;
	reg [1:0] SEL_SEG;
	reg [7:0] SEG_SEL;
	reg CLK1;
	reg [13:0]  counts;
	

	assign RAND1 = RAND/2;
	assign RAND2 = RAND%10;

	change u2(ANS10, sw10);
	change u3(ANS1, sw1);






	always @(RAND1 or RAND2 or ANS10 or ANS1)
	begin
	DEC_1 <= RAND1;
	DEC_2 <= RAND2;
	DEC_3 <= ANS10;
	DEC_4 <= ANS1;
	end
	
	always @(posedge CLK or posedge RESET)  begin
	if(RESET) begin counts <= 0; CLK1 <= 1; end
	else if (counts >= 12499) begin counts <= 0; CLK1 <= !CLK1; end
	else counts <= counts +1; end

	always@(negedge CLK1) // SEL_SEG
		if(SEL_SEG==3) SEL_SEG <=0;
		else SEL_SEG <= SEL_SEG+1;

	always@(DEC_1 or DEC_2 or DEC_3 or DEC_4 or SEL_SEG)
		case (SEL_SEG)
		0 : DEC_TMP <= DEC_1;
		1 : DEC_TMP <= DEC_2;
		2 : DEC_TMP <= DEC_3;
		3 : DEC_TMP <= DEC_4;
	endcase

	always@(SEL_SEG)
		case(SEL_SEG)
		0 : SEG_SEL <= 8'b01111111;
		1 : SEG_SEL <= 8'b11011111;
		2 : SEG_SEL <= 8'b11111101;
		3 : SEG_SEL <= 8'b11111110;
		endcase

	SEG_DEC k2 (DEC_TMP,SEG_C);

endmodule


module SEG_DEC(DIGIT, SEG_DEC);
	input [11:0] DIGIT;
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


module change(out, in);
 output [3:0] out;
 input [7:0] in;
 reg [3:0] out;

always @(in)
 case(in)
 	8'b11111111 : out <= 0;
	8'b01111111 : out <= 8;
	8'b10111111 : out <= 7;
	8'b11011111 : out <= 6;
	8'b11101111 : out <= 5;
	8'b11110111 : out <= 4;
	8'b11111011 : out <= 3;
	8'b11111101 : out <= 2;
	8'b11111110 : out <= 1;
	8'b01111110 : out <= 9;
	endcase
endmodule









