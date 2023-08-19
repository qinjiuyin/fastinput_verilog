module Receive2uart(
	uart_rxd,
	bps_SET,
	Clk,
	Rst,
	
	Data_Byte,
	Rx_Done
);

	input uart_rxd;
	input [15:0] bps_SET;
	input Clk;
	input Rst;	

	output reg [7:0]Data_Byte;
	output reg Rx_Done;

	reg s0_uart_rx,s1_uart_rx;//同步寄存器
	reg tmp0_uart_rx,tmp1_uart_rx;//数据寄存器
	
	reg uart_state;
	reg [2:0]r_data_byte[7:0];
	wire nedege;
	reg [2:0]START_BIT;
	reg [2:0]STOP_BIT;	
//同步寄存器消除亚稳态
always@(posedge Clk or negedge Rst)begin
if(!Rst)begin
	s0_uart_rx <= 1'b0;
	s1_uart_rx <= 1'b0;
end
else begin
	s0_uart_rx <= uart_rxd;
	s1_uart_rx <= s0_uart_rx;
end
end
//数据寄存器
always@(posedge Clk or negedge Rst)begin
if(!Rst)begin
	tmp0_uart_rx <= 1'b0;
	tmp1_uart_rx <= 1'b0;
end
else begin
	tmp0_uart_rx <= s1_uart_rx;
	tmp1_uart_rx <= tmp0_uart_rx;
end
end

assign nedege = !tmp0_uart_rx & tmp1_uart_rx;




/*****************************************************************/
//波特率设置
reg [15:0]bps_DR;
always@(posedge Clk or negedge Rst)begin
if(!Rst)
	bps_DR <= 16'd26;
else begin
	case(bps_SET)
		0:bps_DR <= 16'd324;
		1:bps_DR <= 16'd162;
		2:bps_DR <= 16'd80;
		3:bps_DR <= 16'd53;
		4:bps_DR <= 16'd26;
		default:bps_DR <= 16'd26;
	endcase	
end
end
//时钟采样
reg [15:0]div_cnt;
reg bps_Clk;

always@(posedge Clk or negedge Rst)begin
if(!Rst)
	div_cnt <= 16'd0;
else if(uart_state)begin
	if(div_cnt == bps_DR)
		div_cnt <= 16'd0;
	else
		div_cnt <= div_cnt + 1'b1;
end	
else
		div_cnt <= 16'd0;
end

always@(posedge Clk or negedge Rst)begin
if(!Rst)
	bps_Clk <= 1'b0;
else if(div_cnt == 16'd1)begin
	bps_Clk <= 1'b1;
end	
else
	bps_Clk <= 1'b0;
end

reg [7:0]bps_cnt;
always@(posedge Clk or negedge Rst)begin
if(!Rst)
	bps_cnt <= 8'd0;
else if(bps_cnt == 8'd159 | (bps_cnt == 8'd12 && (START_BIT > 2)))	
	bps_cnt <= 8'd0;
else if(bps_Clk)
	bps_cnt <= bps_cnt + 1'b1;
else
	bps_cnt <= bps_cnt;
end

always@(posedge Clk or negedge Rst)begin
if(!Rst)
	Rx_Done <= 1'b0;
else if(bps_cnt == 8'd159)	
	Rx_Done <= 1'b1;
else
	Rx_Done <= 1'b0;
end

always@(posedge Clk or negedge Rst)begin
if(!Rst)begin
	START_BIT = 3'd0;
	r_data_byte[0] = 3'd0;
	r_data_byte[1] = 3'd0;
	r_data_byte[2] = 3'd0;
	r_data_byte[3] = 3'd0;
	r_data_byte[4] = 3'd0;
	r_data_byte[5] = 3'd0;
	r_data_byte[6] = 3'd0;
	r_data_byte[7] = 3'd0;	
	STOP_BIT = 3'd0;
end
else if(bps_Clk)begin
	case(bps_cnt)
		0:begin
		START_BIT = 3'd0;
		r_data_byte[0] = 3'd0;
		r_data_byte[1] = 3'd0;
		r_data_byte[2] = 3'd0;
		r_data_byte[3] = 3'd0;
		r_data_byte[4] = 3'd0;
		r_data_byte[5] = 3'd0;
		r_data_byte[6] = 3'd0;
		r_data_byte[7] = 3'd0;	
		STOP_BIT = 3'd0;	
		end
		6,7,8,9,10,11:START_BIT <= START_BIT + s1_uart_rx;
		22,23,24,25,26,27:r_data_byte[0] <= r_data_byte[0] + s1_uart_rx;
		38,39,40,40,42,43:r_data_byte[1] <= r_data_byte[1] + s1_uart_rx;
		54,55,56,57,58,59:r_data_byte[2] <= r_data_byte[2] + s1_uart_rx;
		70,71,72,73,74,75:r_data_byte[3] <= r_data_byte[3] + s1_uart_rx;
		86,87,88,89,90,91:r_data_byte[4] <= r_data_byte[4] + s1_uart_rx;
		102,103,104,105,106,107:r_data_byte[5] <= r_data_byte[5] + s1_uart_rx;
		118,119,120,121,122,123:r_data_byte[6] <= r_data_byte[6] + s1_uart_rx;
		134,135,136,137,138,139:r_data_byte[7] <= r_data_byte[7] + s1_uart_rx;
		150,151,152,153,154,155:STOP_BIT <= STOP_BIT + s1_uart_rx;	
		default:
			begin
				START_BIT = START_BIT;
				r_data_byte[0] = r_data_byte[0];
				r_data_byte[1] = r_data_byte[1];
				r_data_byte[2] = r_data_byte[2];
				r_data_byte[3] = r_data_byte[3];
				r_data_byte[4] = r_data_byte[4];
				r_data_byte[5] = r_data_byte[5];
				r_data_byte[6] = r_data_byte[6];
				r_data_byte[7] = r_data_byte[7];	
				STOP_BIT = STOP_BIT;							
			end
	endcase	
end
end

always@(posedge Clk or negedge Rst)begin
if(!Rst)
	Data_Byte <= 8'd0;
else if(bps_cnt == 8'd159)begin
	Data_Byte[0] = r_data_byte[0][2];
	Data_Byte[1] = r_data_byte[1][2];
	Data_Byte[2] = r_data_byte[2][2];
	Data_Byte[3] = r_data_byte[3][2];
	Data_Byte[4] = r_data_byte[4][2];
	Data_Byte[5] = r_data_byte[5][2];
	Data_Byte[6] = r_data_byte[6][2];
	Data_Byte[7] = r_data_byte[7][2];
end	
end

always@(posedge Clk or negedge Rst)begin
if(!Rst)
	uart_state <= 1'b0;
else if(nedege)
	uart_state <= 1'b1;	
else if(Rx_Done || (bps_cnt == 8'd12 && (START_BIT > 2)))
	uart_state <= 1'b0;	
else
	uart_state <= uart_state;	
end

	

endmodule
