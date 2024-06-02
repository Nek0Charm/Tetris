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
    input keyboard_ready,
    output  square_x,
    output  square_y,
    output  square_type,
    output [199:0] map,
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
                            .over_sig(over_sig),
                            .map(map));
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




    integer shape[6:0][3:0][3:0];
    initial begin
        // Row 0
        shape[0][0][0] = 0; shape[0][0][1] = -1; shape[0][0][2] = 1; shape[0][0][3] = 2;
        shape[0][1][0] = 0; shape[0][1][1] = 10; shape[0][1][2] = -10; shape[0][1][3] = -20;
        shape[0][2][0] = 0; shape[0][2][1] = -1; shape[0][2][2] = 1; shape[0][2][3] = 2;
        shape[0][3][0] = 0; shape[0][3][1] = 10; shape[0][3][2] = -10; shape[0][3][3] = -20;

        // Row 1
        shape[1][0][0] = 0; shape[1][0][1] = 1; shape[1][0][2] = 2; shape[1][0][3] = 12;
        shape[1][1][0] = 0; shape[1][1][1] = -1; shape[1][1][2] = -10; shape[1][1][3] = -20;
        shape[1][2][0] = 0; shape[1][2][1] = 1; shape[1][2][2] = 2; shape[1][2][3] = -10;
        shape[1][3][0] = 0; shape[1][3][1] = 1; shape[1][3][2] = 10; shape[1][3][3] = 20;

        // Row 2
        shape[2][0][0] = 0; shape[2][0][1] = 1; shape[2][0][2] = 2; shape[2][0][3] = 10;
        shape[2][1][0] = 0; shape[2][1][1] = -1; shape[2][1][2] = 10; shape[2][1][3] = 20;
        shape[2][2][0] = 0; shape[2][2][1] = -1; shape[2][2][2] = -2; shape[2][2][3] = -10;
        shape[2][3][0] = 0; shape[2][3][1] = 1; shape[2][3][2] = -10; shape[2][3][3] = -20;

        // Row 3
        shape[3][0][0] = 0; shape[3][0][1] = -1; shape[3][0][2] = 10; shape[3][0][3] = 11;
        shape[3][1][0] = 0; shape[3][1][1] = -10; shape[3][1][2] = -1; shape[3][1][3] = 9;
        shape[3][2][0] = 0; shape[3][2][1] = -1; shape[3][2][2] = 10; shape[3][2][3] = 11;
        shape[3][3][0] = 0; shape[3][3][1] = -10; shape[3][3][2] = -1; shape[3][3][3] = 9;

        // Row 4
        shape[4][0][0] = 0; shape[4][0][1] = 1; shape[4][0][2] = 10; shape[4][0][3] = 9;
        shape[4][1][0] = 0; shape[4][1][1] = -10; shape[4][1][2] = 1; shape[4][1][3] = 11;
        shape[4][2][0] = 0; shape[4][2][1] = 1; shape[4][2][2] = 10; shape[4][2][3] = 9;
        shape[4][3][0] = 0; shape[4][3][1] = -10; shape[4][3][2] = 1; shape[4][3][3] = 11;

        // Row 5
        shape[5][0][0] = 0; shape[5][0][1] = 1; shape[5][0][2] = -1; shape[5][0][3] = 10;
        shape[5][1][0] = 0; shape[5][1][1] = -10; shape[5][1][2] = 1; shape[5][1][3] = 11;
        shape[5][2][0] = 0; shape[5][2][1] = 1; shape[5][2][2] = -1; shape[5][2][3] = 10;
        shape[5][3][0] = 0; shape[5][3][1] = -10; shape[5][3][2] = 1; shape[5][3][3] = 11;

        // Row 6
        shape[6][0][0] = 0; shape[6][0][1] = 1; shape[6][0][2] = 10; shape[6][0][3] = 11;
        shape[6][1][0] = 0; shape[6][1][1] = 1; shape[6][1][2] = 10; shape[6][1][3] = 11;
        shape[6][2][0] = 0; shape[6][2][1] = 1; shape[6][2][2] = 10; shape[6][2][3] = 11;
        shape[6][3][0] = 0; shape[6][3][1] = 1; shape[6][3][2] = 10; shape[6][3][3] = 11;
  end


    

    




    
    
endmodule
