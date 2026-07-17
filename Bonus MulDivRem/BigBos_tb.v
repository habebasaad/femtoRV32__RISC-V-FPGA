`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2025 02:20:06 PM
// Design Name: 
// Module Name: BigBos_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module BigBoss_tb( );
reg clk, ssdclk, rst;
reg [1:0]ledSel;
reg [3:0]ssdSel;
wire [15:0] led;
wire [3:0] Anode;
wire [6:0] LED_out;
//pipeline oog( clk, ssdclk, rst, ledSel, ssdSel, led, Anode, LED_out);
//pipelineForwardingHazardFlush OOH( clk, ssdclk, rst, ledSel, ssdSel, led, Anode, LED_out);
pipelineSingle Olla( clk, ssdclk, rst, ledSel, ssdSel, led, Anode, LED_out);
    initial begin
        ssdclk = 0;
        forever #(5) ssdclk = ~ssdclk;
    end 
    initial begin
        clk = 0;
        forever #(5) clk = ~clk;

    end
    
    initial begin 
       // clk = 0;
        rst = 1;
        #10 
        rst = 0;
       // clk = 1;
        ledSel=0;
        ssdSel = 0;
       

    end 
endmodule
