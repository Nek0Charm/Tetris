`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/06 13:21:29
// Design Name: 
// Module Name: top_sim
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


module top_sim(

    );
    reg clk;
    wire rst;
    wire [3:0] R,G,B;
    wire HS,VS;
    wire [7:0] SEG;
    wire [3:0] AN;
    wire [6:0]LED;
    assign rst = 0;
    initial begin
        clk = 0;
    end
    always begin
        clk = ~clk;
        #10;
    end
    top m0(.clk(clk), .rst(rst),.SW(16'h0000), .BTNX(4'b1111),.BTNY(4'b1111), .R(R), .G(G), .B(B), .HS(HS), .VS(VS), .SEG(SEG), .AN(AN), .LED(LED));
endmodule
