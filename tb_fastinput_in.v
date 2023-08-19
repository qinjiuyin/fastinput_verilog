`timescale 1ns/1ps
`define clock_period 20
module tb_fastinput_in;

reg rst;
reg clk;
reg [3:0]Fast;

wire [31:0] channel0;
wire [31:0] channel1;
wire [31:0] channel2;
wire [31:0] channel3;

fastinput_in fastinput_in (
    .rst(rst),
    .clk(clk),

    .Fast(Fast),
    .channel0(channel0),
    .channel1(channel1),
    .channel2(channel2),
    .channel3(channel3)
);



initial clk=1;
always #(`clock_period/2) clk = ~clk;

initial begin
rst = 1'b0;
Fast = 4'd0;
#100
rst = 1'b1;
Fast[0] = 1'b1;
#100
Fast[0] = 1'b0;
#100
Fast[0] = 1'b1;
#100
Fast[0] = 1'b0;
#100
Fast[0] = 1'b1;
#100
Fast[0] = 1'b0;
#100
Fast[0] = 1'b1;
#100
Fast[0] = 1'b0;
#100
$stop;
end



endmodule
