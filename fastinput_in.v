module fastinput_in (
    input rst,
    input clk,

    input [3:0]Fast,
    output reg [31:0] channel0,
    output reg [31:0] channel1,
    output reg [31:0] channel2,
    output reg [31:0] channel3
);

wire Rchannel0;
wire Rchannel1;
wire Rchannel2;
wire Rchannel3;

rising_edge_detector rising_edge_detector0 (
    .clk(clk),          // 时钟信号
    .reset_n(rst),      // 低电平有效的复位信号
    .input_signal(Fast[0]), // 输入信号
   .rising_edge_detected(Rchannel0) // 上升沿检测信号
);

rising_edge_detector rising_edge_detector1 (
    .clk(clk),          // 时钟信号
    .reset_n(rst),      // 低电平有效的复位信号
    .input_signal(Fast[1]), // 输入信号
   .rising_edge_detected(Rchannel1) // 上升沿检测信号
);

rising_edge_detector rising_edge_detector2 (
    .clk(clk),          // 时钟信号
    .reset_n(rst),      // 低电平有效的复位信号
    .input_signal(Fast[2]), // 输入信号
   .rising_edge_detected(Rchannel2) // 上升沿检测信号
);

rising_edge_detector rising_edge_detector3 (
    .clk(clk),          // 时钟信号
    .reset_n(rst),      // 低电平有效的复位信号
    .input_signal(Fast[3]), // 输入信号
   .rising_edge_detected(Rchannel3) // 上升沿检测信号
);

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        channel0 <= 32'd0;
    end else if(Rchannel0) begin
        channel0 <= channel0 + 1'b1;
    end
    else begin
        channel0 <= channel0;
    end
end

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        channel1 <= 32'd0;
    end else if(Rchannel1) begin
        channel1 <= channel1 + 1'b1;
    end
    else begin
        channel1 <= channel1;
    end
end

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        channel2 <= 32'd0;
    end else if(Rchannel2) begin
        channel2 <= channel2 + 1'b1;
    end
    else begin
        channel2 <= channel2;
    end
end

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        channel3 <= 32'd0;
    end else if(Rchannel3) begin
        channel3 <= channel3 + 1'b1;
    end
    else begin
        channel3 <= channel3;
    end
end

endmodule
