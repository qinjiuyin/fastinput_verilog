module Write2uart(
	Clk,
	Rst,
	Send_en,
	Send_Data,
	bps_SET,
	
	uart_txd,
	TX_Done,
	uart_state
);

input Clk;
input Rst;
 
input Send_en;
input [7:0] Send_Data;
output reg uart_txd;

reg bps_clk;
reg [15:0] div_cnt;
output reg uart_state;
reg [15:0] bps_DR;
input [15:0] bps_SET;

output reg TX_Done;
reg [3:0] bps_cnt;

always@(posedge Clk or negedge Rst)begin
if(!Rst)
	bps_clk	<= 1'b0;
else if(div_cnt==16'd1)
	bps_clk	<= 1'b1;	
else
	bps_clk	<= 1'b0;
end
always@(posedge Clk or negedge Rst)begin
if(!Rst)
 uart_state <= 1'b0;
else if(Send_en)
 uart_state <= 1'b1;
else if(bps_cnt == 4'd11)
 uart_state <= 1'b0; 
else
 uart_state <= uart_state;
end

always@(posedge Clk or negedge Rst)begin
if(!Rst)
	bps_cnt <= 0;
else if(bps_cnt==4'd11)
	bps_cnt <= 0;
else if(bps_clk)
	bps_cnt <= bps_cnt + 1'b1;		
else
	bps_cnt <= bps_cnt;	
	
end

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
	bps_DR <= 16'd433;	
else begin
	case(bps_SET)
	 16'd0  :bps_DR <= 16'd5207;//9600
	 16'd1  :bps_DR <= 16'd2603;//19200
	 16'd2 :bps_DR <= 16'd1301;//38400
	 16'd3 :bps_DR <= 16'd867;//57600
	 16'd4:bps_DR <= 16'd433;//115200
	 default:bps_DR <= 16'd433;
	endcase
end
end

always@(posedge Clk or negedge Rst)begin
if(!Rst)
 TX_Done <= 1'b0;
else if(bps_cnt == 4'd11)
 TX_Done <= 1'b1;
else
 TX_Done <= 1'b0;
end

reg [7:0] tSend_Data;
always@(posedge Clk or negedge Rst)begin
if(!Rst)
 tSend_Data <= 8'b0;
else if(Send_en)
 tSend_Data <= Send_Data;
else
 tSend_Data <= tSend_Data;
end

always@(posedge Clk or negedge Rst)begin
if(!Rst)
 uart_txd <= 1'b1;
else begin
	case(bps_cnt)
		4'd0:uart_txd  <= 1'b1;
		4'd1:uart_txd  <= 1'b0;
		4'd2:uart_txd  <= tSend_Data[0];
		4'd3:uart_txd  <= tSend_Data[1];
		4'd4:uart_txd  <= tSend_Data[2];
		4'd5:uart_txd  <= tSend_Data[3];
		4'd6:uart_txd  <= tSend_Data[4];
		4'd7:uart_txd  <= tSend_Data[5];
		4'd8:uart_txd  <= tSend_Data[6];
		4'd9:uart_txd  <= tSend_Data[7];
		4'd10:uart_txd <= 1'b1;
		default:uart_txd  <= 1'b1;
	endcase
end	
end
endmodule
