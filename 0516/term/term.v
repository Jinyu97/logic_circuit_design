/*module term(clk, reset, OUT, seg_sel, D, C, B, A, D2, C2, B2, A2);
	input D, C, B, A, D2, C2, B2, A2; 
	input clk, reset;
	output [6:0] OUT;
	output [7:0] seg_sel;
    reg [3:0] rand1 = {D,C,B,A};
	reg [3:0] rand1 = {D2,C2,B2,A2};
	
	
	seg7 U0 (clk, reset, OUT, seg_sel, rand1, rand2);


endmodule

*/
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
	reg [13:0]  counts;

	always @(RAND1 or RAND2)
	begin
	DEC_1 <= RAND1;
	DEC_2 <= RAND2;
	end
	
	always @(posedge CLK or posedge RESET)  begin
	if(RESET) begin counts <= 0; CLK1 <= 1; end
	else if (counts >= 12499) begin counts <= 0; CLK1 <= !CLK1; end
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


/*
module keypad_scan(clk, rst, key_col, key_row, key_data, SEG_DEC, COM); //keypad 입력을 7-seg에 표시
	input 	clk, rst;
	input	[3:0] 	key_row;
	output	[2:0]	key_col;
	output	[11:0]	key_data;
	output [7:0] COM;
	output [6:0] SEG_DEC;
	reg [6:0] SEG_DEC;
	reg	[11:0]	key_data;
	reg	[2:0]	state;
	reg [13:0]  counts;
	reg clk1;
	wire	key_stop;
	// define state of FSM
	parameter no_scan = 3'b000;
	parameter column1 = 3'b001;
	parameter column2 = 3'b010;
	parameter column3 = 3'b100; 
	
	assign COM = 8'b11111110;
	assign key_stop = key_row[0] | key_row[1] | key_row[2] | key_row[3] ;
	assign key_col = state;
	
	always @(posedge clk or posedge rst)  begin
	  	if(rst) begin counts <= 0; clk1 <= 1; end
		else if (counts >= 12499) begin counts <= 0; clk1 <= !clk1; end
		else counts <= counts +1; end
	
	// FSM drive
	always @(posedge clk1 or posedge rst)
	begin
		if (rst) state <= no_scan;
		else begin
		  if (!key_stop) begin
		    case (state)
		    no_scan : state <= column1;
		    column1 : state <= column2;
		    column2 : state <= column3;
		    column3 : state <= column1;
		    default : state <= no_scan;
		    endcase
		  end
		end
	end
	// key_data
	always @ (posedge clk1) begin
	case (state)
	  column1 : case (key_row)
	  	4'b0001 : key_data <= 12'b0000_0000_0001; // key_1
	  	4'b0010 : key_data <= 12'b0000_0000_1000; // key_4 
	  	4'b0100 : key_data <= 12'b0000_0100_0000; // key_7
	  	4'b1000 : key_data <= 12'b0010_0000_0000; // key_*
	  	default : key_data <= 12'b000000000000;
	  	endcase
	  column2 : case (key_row)
	  	4'b0001 : key_data <= 12'b0000_0000_0010; // key_2
	  	4'b0010 : key_data <= 12'b0000_0001_0000; // key_5 
	  	4'b0100 : key_data <= 12'b0000_1000_0000; // key_8
	  	4'b1000 : key_data <= 12'b0100_0000_0000; // key_0
	  	default : key_data <= 12'b000000000000;
	  	endcase
	  column3 : case (key_row)
	  	4'b0001 : key_data <= 12'b0000_0000_0100; // key_3
	  	4'b0010 : key_data <= 12'b0000_0010_0000; // key_6 
	  	4'b0100 : key_data <= 12'b0001_0000_0000; // key_9
	  	4'b1000 : key_data <= 12'b1000_0000_0000; // key_#
	  	default : key_data <= 12'b000000000000;
	  	endcase	  	
	  default : key_data <= 12'b0000_0000_0000;
	endcase
	end

	
	always @(key_data)
	case (key_data) // gfe_dcba
	1 : SEG_DEC <= 7'h06; // 000_0110
	2 : SEG_DEC <= 7'h5b; // 101_1011
	4 : SEG_DEC <= 7'h4f; // 100_1111
	8 : SEG_DEC <= 7'h66; // 010_0110
	16 : SEG_DEC <= 7'h6d; // 110_1101
	32 : SEG_DEC <= 7'h7c; // 111_1100
	64 : SEG_DEC <= 7'h07; // 000_0111
	128 : SEG_DEC <= 7'h7f; // 111_1111
	256 : SEG_DEC <= 7'h67; // 110_0111
	1024 : SEG_DEC <= 7'h3f; // 011_1111
	endcase
	
endmodule
*/