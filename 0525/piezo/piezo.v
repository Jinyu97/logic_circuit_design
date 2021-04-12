module piezo (clk, rst, key_row, key_col, piezo_out);

	input clk, rst;
	input [3:0] key_row;
	output [2:0] key_col;
	output piezo_out;
	wire [11:0] key_data;
	
	keypad_scan U0_keypad (
		.clk	(clk),
		.rst	(rst),
		.key_col	(key_col),
		.key_row	(key_row),
		.key_data	(key_data) );
		
	piezo_tone U0_piezo_tone (
		.clk	(clk),
		.rst	(rst),
		.key_in	(key_data[7:0]),
		.piezo_freq	(piezo_out) );
	endmodule
	
	
module piezo_tone (clk, rst, key_in, piezo_freq);
	input clk, rst;
	input [7:0] key_in;
	output piezo_freq;
	reg [7:0] clk_count;
	reg clk1;
	
	parameter C_tone = 956;
	parameter D_tone = 851;
	parameter E_tone = 758;
	parameter F_tone = 716;
	parameter G_tone = 638;
	parameter A_tone = 568;
	parameter B_tone = 506;
	
	reg [9:0] piezo_cnt;
	reg piezo_freq;
	reg [9:0] cnt;
	
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
	
	always @(key_in) begin
	 case (key_in)
		8'b0000_0001 : piezo_cnt = C_tone;
		8'b0000_0010 : piezo_cnt = D_tone;
		8'b0000_0100 : piezo_cnt = E_tone;
		8'b0000_1000 : piezo_cnt = F_tone;
		8'b0001_0000 : piezo_cnt = G_tone;
		8'b0010_0000 : piezo_cnt = A_tone;
		8'b0100_0000 : piezo_cnt = B_tone;
		8'b1000_0000 : piezo_cnt = C_tone/2;
		default : piezo_cnt = 0;
	endcase
	end
	
	always @(posedge clk1 or posedge rst) begin
		if (rst) begin
			cnt <=0;
			piezo_freq <= 0;
		end
		else begin
			if (cnt == piezo_cnt) begin
				cnt <= 0;
				piezo_freq <= ~piezo_freq;
			end
			else	cnt <= cnt+1;
		end
		end
	endmodule 



module keypad_scan(clk, rst, key_col, key_row, key_data);
	input 	clk, rst;
	input	[3:0] 	key_row;
	output	[2:0]	key_col;
	output	[11:0]	key_data;
	reg [11:0] key_data;
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
endmodule