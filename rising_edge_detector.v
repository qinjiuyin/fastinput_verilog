module rising_edge_detector (
    input clk,          // ʱ���ź�
    input reset_n,      // �͵�ƽ��Ч�ĸ�λ�ź�
    input input_signal, // �����ź�
    output rising_edge_detected // �����ؼ���ź�
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
