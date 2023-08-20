module fastinput (
    input rst,
    input clk,

	input [3:0]CheckIO,
	input  receive,
    output write
);

wire [7:0] data_rx;
wire RxDone;
wire tx_done;

wire [15:0] crc_value;

wire [31:0] channel0;
wire [31:0] channel1;
wire [31:0] channel2;
wire [31:0] channel3;
wire [7:0]  data_tx;

wire [31:0] Check;
wire ReadyWrite1;

reg WriteEnable;
reg ReadyWrite0;

reg [7:0]WriteBuffer[18:0];

reg [4:0]cntSend;
reg [7:0]SendData;

assign Check = channel0 + channel1 + channel2 + channel3;

Write2uart Write2uart(
	.Clk(clk),
	.Rst(rst),
	.Send_en(WriteEnable),
	.Send_Data(SendData),
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


rising_edge_detector rising_edge_detectortx (
    .clk(clk),         
    .reset_n(rst),     
    .input_signal(ReadyWrite0), 
    .rising_edge_detected(ReadyWrite1) 
);

always @(posedge clk or negedge rst) begin
	if (!rst) begin
		WriteEnable <= 1'b0;
	end
	else if (ReadyWrite1) begin
		WriteEnable <= 1'b1;
	end
	else if(cntSend == 5'd18)begin
		WriteEnable <= 1'b0;
	end
	else begin
		WriteEnable <= WriteEnable;
	end
end


always @(posedge clk or negedge rst) begin
    if (!rst) begin
        cntSend <= 5'd0;  
    end 
	else if (tx_done) begin
        cntSend <= cntSend + 1;  
    end
	else if (cntSend == 5'd18) begin
        cntSend <= 5'd0; 
    end
	else begin
		cntSend <= cntSend;
	end
end

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        SendData <= 8'd0;  
    end 
	else if (tx_done) begin
        if (cntSend < 19) 
            SendData <= WriteBuffer[cntSend];
    end
	else begin
		SendData <= SendData;
	end
end


always @(posedge clk or negedge rst) begin
	if (!rst) begin
		ReadyWrite0 <= 1'b0;
	end
	else if(RxDone == 1'b1 && WriteEnable==1'b0 && data_rx == 8'h05)begin
		ReadyWrite0 <= 1'b1;
	end
	else if(tx_done == 1'b1)begin
		ReadyWrite0 <= 1'b0;
	end
	else begin
		ReadyWrite0 <= ReadyWrite0;
	end
end

always @(posedge clk or negedge rst) begin
	if (!rst) begin
		WriteBuffer[0] <=8'h06;
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
	else if(RxDone == 1'b1 && WriteEnable==1'b0 && data_rx == 8'h05)begin
		WriteBuffer[1]		<= channel0[7:0];
		WriteBuffer[2]		<= channel0[15:8];
		WriteBuffer[3]		<= channel0[23:16];
		WriteBuffer[4]		<= channel0[31:24];
		WriteBuffer[5]		<= channel1[7:0];
		WriteBuffer[6]		<= channel1[15:8];
		WriteBuffer[7]		<= channel1[23:16];
		WriteBuffer[8]		<= channel1[31:24];
		WriteBuffer[9]		<= channel2[7:0];
		WriteBuffer[10]	<= channel2[15:8];
		WriteBuffer[11]	<= channel2[23:16];
		WriteBuffer[12]	<= channel2[31:24];
		WriteBuffer[13]	<= channel3[7:0];
		WriteBuffer[14]	<= channel3[15:8];
		WriteBuffer[15]	<= channel3[23:16];
		WriteBuffer[16]	<= channel3[31:24];
		WriteBuffer[17] 	<= Check[7:0];
		WriteBuffer[18] 	<= Check[15:8];
	end
	else begin
		WriteBuffer[1] 	<= WriteBuffer[1]; 
		WriteBuffer[2]		<=	WriteBuffer[2];	
		WriteBuffer[3]		<=	WriteBuffer[3];	
		WriteBuffer[4]		<=	WriteBuffer[4];	
		WriteBuffer[5]		<=	WriteBuffer[5];	
		WriteBuffer[6]		<=	WriteBuffer[6];	
		WriteBuffer[7]		<=	WriteBuffer[7];	
		WriteBuffer[8]		<=	WriteBuffer[8];	
		WriteBuffer[9]		<=	WriteBuffer[9];	
		WriteBuffer[10]	<=	WriteBuffer[10];
		WriteBuffer[11]	<=	WriteBuffer[11];
		WriteBuffer[12]	<=	WriteBuffer[12];
		WriteBuffer[13]	<=	WriteBuffer[13];
		WriteBuffer[14]	<=	WriteBuffer[14];
		WriteBuffer[15]	<=	WriteBuffer[15];
		WriteBuffer[16]	<=	WriteBuffer[16];
		WriteBuffer[17]	<=	WriteBuffer[17];
		WriteBuffer[18]	<=	WriteBuffer[18];
	end
end
	

endmodule
