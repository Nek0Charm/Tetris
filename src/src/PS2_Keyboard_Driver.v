`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/26 14:23:53
// Design Name: 
// Module Name: PS2_Keyboard_Driver
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


//这是从qq群的视频里抄的

module PS2_Keyboard_Driver(
    input clk,              // FPGA的时钟信号，50MHz
    input rst,
    input rdn,              // 低电平有效
    input PS2C,             // 键盘的时钟信号
    input PS2D,             // 键盘的数据信号
    output reg [7:0] data,  // 打包提取数据
    output reg ready
    );
    localparam Idle = 2'b00, Rece = 2'b01, Ignore = 2'b10;
    reg [9:0] PS2_shift = 10'b1000000000;
    reg [1:0] state = Idle;
    reg [1:0] Fall_Clk;
    initial begin
        ready <= 0;
    end

    always @(posedge clk) begin
        Fall_Clk <= {Fall_Clk[0], PS2C};
    end
    always @(posedge clk) begin
        if (rst) begin
            PS2_shift <= 10'b1000000000;
            state <= Idle;
            ready <= 0;
        end
        else begin
            if (!rdn && ready)
                ready <= 0;
            else
                ready <= ready;

            case (state)
                Idle: begin
                    PS2_shift <= 10'b1000000000;
                    if ((Fall_Clk == 2'b10) && (!PS2D))
                        state <= Rece;
                    else
                        state <= Idle;
                end
                Rece: begin
                    if (Fall_Clk == 2'b10) begin
                        if (PS2_shift[0] && PS2D) begin
                            if (PS2_shift[8:1] == 8'hF0) begin
                                // 检测到断码F0，进入Ignore状态
                                state <= Ignore;
                            end else begin
                                // 接收通码
                                ready <= {^PS2_shift[9:1]};
                                data <= PS2_shift[8:1];
                                state <= Idle;
                            end
                        end
                        else begin
                            PS2_shift <= {PS2D, PS2_shift[9:1]}; // PS2协议的数据是从低位起的，所以这样写
                            state <= Rece;
                        end
                    end
                    else 
                        state <= Rece;
                end
                Ignore: begin
                    // 忽略断码后的一个字节
                    if (Fall_Clk == 2'b10) begin
                        PS2_shift <= {PS2D, PS2_shift[9:1]};
                        if (PS2_shift[0]) begin
                            state <= Idle;
                        end
                    end
                end
            endcase
        end
    end
endmodule
