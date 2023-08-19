module fastinput (
    input rst,
    input clk,

	input [3:0]CheckIO,
	input  receive,
    output write
);

wire tx_done;
wire [7:0] data_rx;
wire RxDone;

reg WriteEnable;
reg [7:0]WriteBuffer[18:0];

Write2uart Write2uart(
	.Clk(clk),
	.Rst(rst),
	.Send_en(WriteEnable),
	.Send_Data(8'haa),
	.bps_SET(16'd4),
	
	.uart_txd(write),
	.TX_Done(tx_done),
	.uart_state()
);

fastinput_in fastinput_in (
    .rst(rst),
    .clk(clk),

    .Fast(CheckIO),
    .channel0(channel0),
    .channel1(channel1),
    .channel2(channel2),
    .channel3(channel3)
);

Receive2uart Receive2uart(
	.uart_rxd(receive),
	.bps_SET(16'd4),
	.Clk(clk),
	.Rst(rst),
	
	.Data_Byte(data_rx),
	.Rx_Done(RxDone)
);

always @(posedge clk or negedge rst) begin
	if (!rst) begin
		WriteEnable <= 1'b0;
		WriteBuffer[0] <=8'h02;
		WriteBuffer[1] <=8'd0;
		WriteBuffer[2] <=8'd0;
		WriteBuffer[3] <=8'd0;
		WriteBuffer[4] <=8'd0;
		WriteBuffer[5] <=8'd0;
		WriteBuffer[6] <=8'd0;
		WriteBuffer[7] <=8'd0;
		WriteBuffer[8] <=8'd0;
		WriteBuffer[9] <=8'd0;
		WriteBuffer[10]<= 8'd0;
		WriteBuffer[11]<= 8'd0;
		WriteBuffer[12]<= 8'd0;
		WriteBuffer[13]<= 8'd0;
		WriteBuffer[14]<= 8'd0;
		WriteBuffer[15]<= 8'd0;
		WriteBuffer[16]<= 8'd0;
		WriteBuffer[17]<= 8'd0;
		WriteBuffer[18]<= 8'd0;
	end
	else if(RxDone == 1'b1 && WriteEnable==1'b0)begin
		WriteEnable <= 1'b1;
		WriteBuffer[1] <= 0;
	end

end
	

endmodule
