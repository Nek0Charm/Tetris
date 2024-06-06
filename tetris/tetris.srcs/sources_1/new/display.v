module display(
    input clk,
    input rst,
    input  [4:0]square_x,
    input  [4:0]square_y,
    input  [2:0]square_type,
    input  [1:0]square_degree,
    input [199:0] map,
    input [15:0] score,
    input  [1:0] state,
    input [8:0] row,
    input [9:0] col,
    output reg [11:0] color
    );

    integer i,j,k;
    parameter Start = 2'b00, Playing = 2'b01, Over = 2'b10;
    parameter   White = 12'b111111111111,
                Black = 12'b000000000000,
                Green = 12'h0f0,
                Grey = 12'h777;

    integer shape[6:0][3:0][3:0];
    initial begin
        // Row 0
        shape[0][0][0] = 0; shape[0][0][1] = -1; shape[0][0][2] = 1; shape[0][0][3] = 2;
        shape[0][1][0] = 0; shape[0][1][1] = 10; shape[0][1][2] = -10; shape[0][1][3] = -20;
        shape[0][2][0] = 0; shape[0][2][1] = -1; shape[0][2][2] = 1; shape[0][2][3] = 2;
        shape[0][3][0] = 0; shape[0][3][1] = 10; shape[0][3][2] = -10; shape[0][3][3] = -20;

        // Row 1
        shape[1][0][0] = 0; shape[1][0][1] = 10; shape[1][0][2] = 9; shape[1][0][3] = -10;
        shape[1][1][0] = 0; shape[1][1][1] = -1; shape[1][1][2] = 1; shape[1][1][3] = -11;
        shape[1][2][0] = 0; shape[1][2][1] = 10; shape[1][2][2] = -9; shape[1][2][3] = -10;
        shape[1][3][0] = 0; shape[1][3][1] = -1; shape[1][3][2] = 1; shape[1][3][3] = 11;

        // Row 2
        shape[2][0][0] = 0; shape[2][0][1] = 10; shape[2][0][2] = 11; shape[2][0][3] = -10;
        shape[2][1][0] = 0; shape[2][1][1] = -1; shape[2][1][2] = 1; shape[2][1][3] = 9;
        shape[2][2][0] = 0; shape[2][2][1] = 10; shape[2][2][2] = -11; shape[2][2][3] = -10;
        shape[2][3][0] = 0; shape[2][3][1] = 1; shape[2][3][2] = -1; shape[2][3][3] = -9;

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
    always begin
        case(state) 
        Start: begin
            color = White;
        end
        Playing:begin
            if(row < 200  && col < 100) begin
                if(map[row/10 * 10 + col / 10] == 1) begin
                    color = Grey;
                end
                else  begin
                    if(row/10 * 10 + col / 10 == square_y*10+square_x+shape[square_type][square_degree][0])
                            color = White;
                    else if(row/10 * 10 + col / 10 == square_y*10+square_x+shape[square_type][square_degree][1])
                            color = White;
                    else if(row/10 * 10 + col / 10 == square_y*10+square_x+shape[square_type][square_degree][2])
                            color = White;
                    else if(row/10 * 10 + col / 10 == square_y*10+square_x+shape[square_type][square_degree][3])
                            color = White;
                end
            end
            else begin
                color = Black;        
            end
        end
        Over: begin
            color = Green;
        end
        endcase
    end



endmodule