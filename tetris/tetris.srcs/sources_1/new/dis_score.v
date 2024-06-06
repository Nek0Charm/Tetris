`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/06 15:29:54
// Design Name: 
// Module Name: dis_score
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


module dis_score(
    input clk,
    input [15:0] score,
    output [7:0] SEG,
    output [3:0] AN
    );
    reg [15:0] bcd;
    wire [31:0] div_res;
    clock_div c0 (.clk(clk),.rst(1'b0),.div_res(div_res));
    bintobcd b0 
    (
        .bin_in(score[7:0]),
        .bcd_out(bcd[7:0])
    );
    bintobcd b1
    (
        .bin_in(score[15:8]),
        .bcd_out(bcd[15:8])
    );
    DispNum display(.HEXS({bcd}), .clk(clk_div), .EN(4'b1111), .P(4'b1111), .AN(AN), .SEG(SEG));
endmodule