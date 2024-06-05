`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/23 20:22:10
// Design Name: 
// Module Name: game
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


module game(
    input clk,
    input rst,
    input [7:0] keyboard_data,
    input   keyboard_ready,
    output  [4:0]square_x,
    output  [4:0]square_y,
    output  [2:0]square_type,
    output  [1:0]square_degree,
    output [199:0] map,
    output [15:0] score,
    output reg [1:0] state
    );
    parameter Start = 2'b00, Playing = 2'b01, Over = 2'b10;

    wire start_sig,over_sig;
    assign start_sig = ~state[0] & state[1];

    tetris_logic gamestart( .clk(clk), 
                            .rst(rst), 
                            .keyboard_data(keyboard_data), 
                            .keyboard_ready(keyboard_ready),
                            .start_sig(start_sig),
                            .square_type(square_type),
                            .square_x(square_x),
                            .square_y(square_y),
                            .square_degree(square_degree),
                            .over_sig(over_sig),
                            .score(score),
                            .map(map));
    initial begin
        state <= Playing;    
    end
    always @(posedge clk) begin
        case (state)
            Start: begin
                if(keyboard_ready && keyboard_data == 8'h29) begin
                    state <= Playing;
                end
                else begin
                    state <= state;
                end
            end
            Playing: begin
                if(over_sig) begin
                    state <= Over;
                end
                else begin
                    state <= state;
                end
            end
            Over: begin
                if(keyboard_ready && keyboard_data == 8'h29) begin
                    state <= Start;
                end
                else begin
                    state <= state;
                end
            end
            default: state <= Start;
        endcase
    end







    

    




    
    
endmodule
