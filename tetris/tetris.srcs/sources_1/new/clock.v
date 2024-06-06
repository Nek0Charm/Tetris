`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/06 15:41:13
// Design Name: 
// Module Name: clock
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

module clock(
    input clk,
    input reset,
    output SEG_CLK,SEG_CLR,SEG_DO,SEG_EN
    );
    wire clk_100ms,start;
    wire [23:0] num;
    wire CRn_s,CRn_min,CRn_h,CR_s,CR_min,CR_h;
    assign SEG_CLR=1'b1;
    wire CO0,CO1,CO2,CO3,CO4,CO5;
    wire f1,f2,f3,f4,f5;
    CRn_60 crn1(.num(num[7:0]), .btn(reset), .CRn(CRn_s));//满60清零
    CRn_60 crn2(.num(num[15:8]), .btn(reset), .CRn(CRn_min));
    CRn_24 crn3(.num(num[23:16]), .btn(reset), .CRn(CRn_h));//满24清零
    CRn_10 crn4(.num(num[3:0]), .CRn(CR_s));//满10清零
    CRn_10 crn5(.num(num[11:8]), .CRn(CR_min));
    CRn_10 crn6(.num(num[19:16]), .CRn(CR_h));
    clk_100ms clk1(.clk(clk), .clk_100ms(clk_100ms));
    Load_Gen load(.clk(~clk), .btn_in(clk_100ms), .Load_out(start));//每个显示周期给一个比较短的start
    My74LS161_10 My1(.CP(clk_100ms), .CRn(~(CRn_s+CR_s)), .LDn(1'b1), .D(num[3:0]), .CTT(1'b1), .CTP(1'b1), .Q(num[3:0]), .CO(CO0));
    My74LS161_6 My2(.CP(clk_100ms), .CRn(~CRn_s), .LDn(1'b1), .D(num[7:4]), .CTT(1'b1), .CTP(CO0), .Q(num[7:4]), .CO(CO1));
    My74LS161_10 My3(.CP(clk_100ms), .CRn(~(CRn_min+CR_min)), .LDn(1'b1), .D(num[11:8]), .CTT(1'b1), .CTP(CO1), .Q(num[11:8]), .CO(CO2));
    My74LS161_6 My4(.CP(clk_100ms), .CRn(~CRn_min), .LDn(1'b1), .D(num[15:12]), .CTT(1'b1), .CTP(CO2), .Q(num[15:12]), .CO(CO3));
    My74LS161_10 My5(.CP(clk_100ms), .CRn(~(CRn_h+CR_h)), .LDn(1'b1), .D(num[19:16]), .CTT(1'b1), .CTP(CO3), .Q(num[19:16]), .CO(CO4));
    My74LS161 My6(.CP(clk_100ms), .CRn(~CRn_h), .LDn(1'b1), .D(num[23:20]), .CTT(1'b1), .CTP(CO4), .Q(num[23:20]), .CO(CO5));
    SEG_DRV seg1(.clk(clk), .start(start), .num({num[3:0],num[7:4],num[11:8],num[15:12],num[19:16],num[23:20],8'b0}), .sclk(SEG_CLK), .sout(SEG_DO), .EN(SEG_EN));
endmodule

module f_10(input [3:0] num,input clk,output f);
    reg f_reg;
    always @(negedge clk)begin
        if(num==4'b1001)f_reg=1'b1;
        else f_reg=1'b0;
    end
    assign f=f_reg;
endmodule

module CRn_10(input [3:0] num,output CRn);
    assign CRn=num[3]&~num[2]&num[1]&~num[0];
endmodule

module CRn_60(input [7:0] num,input btn,output CRn);
    assign CRn=btn|(~num[7]&num[6]&num[5]&~num[4]&~num[3]&~num[2]&~num[1]&~num[0]);
endmodule

module CRn_24(input [7:0] num,input btn,output CRn);
    assign CRn=btn|(~num[7]&~num[6]&num[5]&~num[4]&~num[3]&num[2]&~num[1]&~num[0]);
endmodule

module Load_Gen(input wire clk,input wire btn_in,output reg Load_out);
    initial Load_out = 0;
    reg old_btn;
    always@(posedge clk) begin
        if ((old_btn == 1'b0) && (btn_in == 1'b1))//btn出现上升沿
            Load_out <= 1'b1;
        else
            Load_out <= 1'b0;
    end
    always@(posedge clk) begin//保存上一个周期btn的状态
        old_btn <= btn_in;
    end
endmodule

module clk_100ms( 
	input clk, 
	output reg clk_100ms
);
	reg [31:0] cnt;
	initial begin
		cnt = 32'b0;
	end
	wire[31:0] cnt_next;
	assign cnt_next = cnt + 1'b1;
	always @(posedge clk) begin
		if(cnt<5_000_000)begin
			cnt <= cnt_next;
		end
		else begin
			cnt <= 0;
			clk_100ms <= ~clk_100ms;
		end
	end
endmodule

module My74LS161_10(
    input CP,
    input CRn,
    input LDn,
    input [3:0] D,
    input CTT,
    input CTP,
    output [3:0] Q,
    output CO
);

    reg [3:0] Q_reg = 4'b0;

    always @(posedge CP or negedge CRn) begin
        if(!CRn) begin
            Q_reg=4'b0;
        end else begin
            if(!LDn)begin
                Q_reg=D;
            end
            else if(CTT&CTP)begin
                Q_reg=Q_reg+1'b1;
            end
        end
    end

    assign Q = Q_reg;
    assign CO = Q[3]&Q[0]&CTT&CTP;

endmodule

module My74LS161_6(
    input CP,
    input CRn,
    input LDn,
    input [3:0] D,
    input CTT,
    input CTP,
    output [3:0] Q,
    output CO
);

    reg [3:0] Q_reg = 4'b0;

    always @(posedge CP or negedge CRn) begin
        if(!CRn) begin
            Q_reg=4'b0;
        end else begin
            if(!LDn)begin
                Q_reg=D;
            end
            else if(CTT&CTP)begin
                Q_reg=Q_reg+1'b1;
            end
        end
    end

    assign Q = Q_reg;
    assign CO = Q[2]&Q[0]&CTT&CTP;

endmodule

