`define TRUE 1'b1
`define FALSE 1'b0

//지연
`define Y2RDELAY 3 // yellow->red
`define R2GDELAY 2 // red->green

module sig_control (hwy, cntry, X, clock, clear);

output [1:0] hwy, cntry; // 녹색, 노란색, 빨간색 3가지 상태의 신호를 위한 2비트 출력
reg [1:0] hwy, cntry; // 출력 신호를 레지스터로 선언
input X; // 만약 참이면, 간선도로에 차가 있음. 아니면 거짓
input clock, clear;

parameter RED = 2'd0, YELLOW = 2'd1, GREEN = 2'd2;

// 상태 정의
parameter S0 = 3'd0, 
		S1 = 3'd1, 
		S2 = 3'd2,
		S3 = 3'd3, 
		S4 = 3'd4;

// 내부 상태 변수
reg [2:0] state;
reg [2:0] next_state;

// clock의 상승 모서리에서만 상태가 바뀐다.
always @(posedge clock)
	if (clear)
		state <= S0; // S0 상태에서 제어기 시작
	else
		state <= next_state; // 상태 바뀜

// 주요도로와 간선도로의 신호의 값 계산		
always @(state)
	begin
		hwy = GREEN;
		cntry = RED;
		case(state)
			S0 : ;
			S1 : hwy = YELLOW;
			S2 : hwy = RED;
			S3 : begin
					hwy = RED;
					cntry = GREEN;
				 end
			S4 : begin
					hwy = RED;
					cntry = YELLOW;
				 end
		endcase
	end

// case문을 이용한 상태기	
always @(state or X)
	begin
		case (state)
			S0 : if(X)
					next_state = S1;
				 else
					next_state = S0;
			S1 : begin
					repeat(`Y2RDELAY) @(posedge clock);
					next_state = S2;
				 end
			S2 : begin
					repeat(`R2GDELAY) @(posedge clock);
					next_state = S3;
				 end
			S3 : if(X)
					next_state = S3;
				 else
					next_state = S4;
			S4 : begin
					repeat(`Y2RDELAY) @(posedge clock);
					next_state = S0;
				 end
			default : next_state = S0;
		endcase
	end
	
endmodule