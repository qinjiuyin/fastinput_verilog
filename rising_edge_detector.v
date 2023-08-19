module rising_edge_detector (
    input clk,          // 时钟信号
    input reset_n,      // 低电平有效的复位信号
    input input_signal, // 输入信号
    output rising_edge_detected // 上升沿检测信号
);

reg input_signal_d1 = 0;
reg input_signal_d2 = 0;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        input_signal_d1 <= 0;
        input_signal_d2 <= 0;
    end else begin
        input_signal_d1 <= input_signal;
        input_signal_d2 <= input_signal_d1;
    end
end

assign rising_edge_detected = ~input_signal_d2 & input_signal_d1;

endmodule
