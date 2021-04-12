module piezo_99 (clk, rst, piezo_out);

	input clk, rst;
	output piezo_out;

	piezo_tone U0_piezo_tone (
		.clk	(clk),
		.rst	(rst),
		.piezo_freq	(piezo_out) );
	endmodule
	
	
module piezo_tone (clk, rst, piezo_freq);
	input clk, rst;
	output piezo_freq;
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
	
	
	always @(negedge clk or posedge rst) // CLK2
		if(rst) clk2<=0;
		else if (clk_count2==5000000) begin clk_count2<=0; clk2=1; end
		else begin clk_count2 <= clk_count2+1; clk2<=0; end
	
	
 always@(posedge clk2) begin // SEC_SEG
	if(rst) countt <=0;
	else countt <= countt+1; end	

 always@(posedge clk2) begin
	if(countt < 23)
			if(note==12) note <=0;
			else note <= note+1;
	else
	 piezo_cnt <= 0;
	end
		
	always@(note)
	case(note)		
		0 : piezo_cnt <= G_tone;
		1 : piezo_cnt <= 0;
		2 : piezo_cnt <= G_tone;
		3 : piezo_cnt <= 0;
		4 : piezo_cnt <= E_tone;
		5 : piezo_cnt <= 0;
		6 : piezo_cnt <= D_tone;
		7 : piezo_cnt <= 0;
		8 : piezo_cnt <= G_tone;
		9 : piezo_cnt <= 0;
		10 : piezo_cnt <= G_tone;
		11 : piezo_cnt <= 0;
		12 : piezo_cnt <= 0;

	endcase
	
	
	
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


