`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/06 15:35:09
// Design Name: 
// Module Name: My74LS161
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


module My74LS161(
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
    assign CO = (Q == 4'hF);

endmodule


