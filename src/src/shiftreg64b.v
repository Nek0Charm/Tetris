`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/06 15:34:09
// Design Name: 
// Module Name: shiftreg64b
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


module SEG_DRV(
    input clk,
    input start,
    input [31:0] num,
    output sclk,
    output sout,
    output EN
);
    wire [64:0]Q;
    wire [63:0]out;
    wire S_L;
    MyMCnew MyMC1(.num(num[3:0]), .out(out[7:0]));
    MyMCnew MyMC2(.num(num[7:4]), .out(out[15:8]));
    MyMCnew MyMC3(.num(num[11:8]), .out(out[23:16]));
    MyMCnew MyMC4(.num(num[15:12]), .out(out[31:24]));
    MyMCnew MyMC5(.num(num[19:16]), .out(out[39:32]));
    MyMCnew MyMC6(.num(num[23:20]), .out(out[47:40]));
    MyMCnew MyMC7(.num(num[27:24]), .out(out[55:48]));
    MyMCnew MyMC8(.num(num[31:28]), .out(out[63:56]));

    SR_Latch SR1(.S(start&finish), .R(~finish), .Q(S_L));

    shift_reg65b s2(.Q(Q), .S_L(S_L), .clk(clk), .par_in(out), .shift_in(1'b1));

    assign finish = &Q[64:1];

    assign EN = !start && finish;
    assign sclk = finish | ~clk;
    assign sout = Q[0];
endmodule

module shift_reg65b(
    input clk,S_L,shift_in,
    input [63:0] par_in,
    output [64:0] Q
);
    wire Sbar,C16,B16,D16;
    shift_reg shift1(.S_L(S_L), .par_in(par_in[7:0]), .Q(Q[7:0]), 
                     .shift_in(Q[8]), .clk(clk));
    shift_reg shift2(.S_L(S_L), .par_in(par_in[15:8]), .Q(Q[15:8]), 
                     .shift_in(Q[16]), .clk(clk));
    shift_reg shift3(.S_L(S_L), .par_in(par_in[23:16]), .Q(Q[23:16]), 
                     .shift_in(Q[24]), .clk(clk));
    shift_reg shift4(.S_L(S_L), .par_in(par_in[31:24]), .Q(Q[31:24]), 
                     .shift_in(Q[32]), .clk(clk));
    shift_reg shift5(.S_L(S_L), .par_in(par_in[39:32]), .Q(Q[39:32]), 
                     .shift_in(Q[40]), .clk(clk));
    shift_reg shift6(.S_L(S_L), .par_in(par_in[47:40]), .Q(Q[47:40]), 
                     .shift_in(Q[48]), .clk(clk));
    shift_reg shift7(.S_L(S_L), .par_in(par_in[55:48]), .Q(Q[55:48]), 
                     .shift_in(Q[56]), .clk(clk));
    shift_reg shift8(.S_L(S_L), .par_in(par_in[63:56]), .Q(Q[63:56]), 
                     .shift_in(Q[64]), .clk(clk));
    not not64(Sbar,S_L);
    and and64(C64,shift_in,Sbar);
    and and65(B64,1'b0,S_L);
    or or64(D64,C64,B64);
    FD FD64(.Cp(clk), .D(D64), .Q(Q[64]));
endmodule

module shift_reg( Q,
                  S_L,
                  clk,
                  par_in,
                  shift_in );
   input       S_L;
   input       clk;
   input [7:0] par_in;
   input       shift_in;
   output [7:0] Q;
   wire D1,D2,D3,D4,D5,D6,D7,D8;
   wire C1,C2,C3,C4,C5,C6,C7,C8;
   wire B1,B2,B3,B4,B5,B6,B7,B8;
   wire Sbar;
   not not1(Sbar,S_L);

   and and1(C1,shift_in,Sbar);
   and and2(C2,Q[7],Sbar);
   and and3(C3,Q[6],Sbar);
   and and4(C4,Q[5],Sbar);
   and and5(C5,Q[4],Sbar);
   and and6(C6,Q[3],Sbar);
   and and7(C7,Q[2],Sbar);
   and and8(C8,Q[1],Sbar);
   and and9 (B1,par_in[7],S_L);
   and and10(B2,par_in[6],S_L);
   and and11(B3,par_in[5],S_L);
   and and12(B4,par_in[4],S_L);
   and and13(B5,par_in[3],S_L);
   and and14(B6,par_in[2],S_L);
   and and15(B7,par_in[1],S_L);
   and and16(B8,par_in[0],S_L);

   or or1(D1,C1,B1);
   or or2(D2,C2,B2);
   or or3(D3,C3,B3);
   or or4(D4,C4,B4);
   or or5(D5,C5,B5);
   or or6(D6,C6,B6);
   or or7(D7,C7,B7);
   or or8(D8,C8,B8);

   FD FD1(.Cp(clk), .D(D1), .Q(Q[7]));
   FD FD2(.Cp(clk), .D(D2), .Q(Q[6]));
   FD FD3(.Cp(clk), .D(D3), .Q(Q[5]));
   FD FD4(.Cp(clk), .D(D4), .Q(Q[4]));
   FD FD5(.Cp(clk), .D(D5), .Q(Q[3]));
   FD FD6(.Cp(clk), .D(D6), .Q(Q[2]));
   FD FD7(.Cp(clk), .D(D7), .Q(Q[1]));
   FD FD8(.Cp(clk), .D(D8), .Q(Q[0]));
endmodule

module FD(
    input Cp,
    input D,
    output Q
);
    reg Q_reg = 1'b0;//≥ı ºªØ
    always @(posedge Cp) begin
        Q_reg <= D;    
    end
    assign Q = Q_reg;
endmodule

module SR_Latch(
    input S,
    input R,
    output Q
);

    reg Q_reg = 1'b0;

    always @(*) begin
        if(!S && R) Q_reg = 1'b0;
        else if(S && !R) Q_reg = 1'b1;
    end

    assign Q = Q_reg;
endmodule

module MyMCnew(
    input [3:0]num,
    output [7:0]out
    );
    MyMC14495 m0(.D0(num[0]), .D1(num[1]), .D2(num[2]), .D3(num[3]), .LE(1'b0), .point(1'b1),
                .a(out[7]), .b(out[6]), .c(out[5]), .d(out[4]), .e(out[3]), .f(out[2]), .g(out[1]), .p(out[0]));
endmodule

module MyMC14495(D0,D1,D2,D3,LE,point,
                a,b,c,d,e,f,g,p);
    input D0, D1, D2, D3;
    input LE;
    input point;
    output wire a, b, c, d, e, f, g, p;

    assign a=((~D3&~D2&~D1&D0)|(~D3&D2&~D1&~D0)|(D3&~D2&D1&D0)|(D3&D2&~D1&D0))|LE;
    assign b=((~D3&D2&~D1&D0)|(D2&D1&~D0)|(D3&D2&~D0)|(D3&D1&D0))|LE;
    assign c=((~D3&~D2&D1&~D0)|(D3&D2&~D0)|(D3&D2&D1))|LE;
    assign d=((~D3&D2&~D1&~D0)|(D2&D1&D0)|(~D3&~D2&~D1&D0)|(D3&~D2&D1&~D0))|LE;
    assign e=((~D3&D0)|(~D3&D2&~D1)|(~D2&~D1&D0))|LE;
    assign f=((~D3&~D2&D0)|(~D3&~D2&D1)|(~D3&D1&D0)|(D3&D2&~D1&D0))|LE;
    assign g=((~D3&~D2&~D1)|(~D3&D2&D1&D0)|(D3&D2&~D1&~D0))|LE;
    assign p=~ point;
endmodule

