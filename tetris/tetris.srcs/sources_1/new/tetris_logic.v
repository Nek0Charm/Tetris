`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/02 14:18:36
// Design Name: 
// Module Name: tetris_logic
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


module tetris_logic(
    input clk,
    input rst,
    input keyboard_data,
    input keyboard_ready,
    input start_sig,
    output reg[199:0] map,
    output over_sig,
    output reg[4:0] square_x,
    output reg[4:0] square_y,
    output reg[2:0] square_type,
    output reg[1:0] square_degree,
    output reg [15:0] score
    );
    parameter I = 3'b000, J = 3'b001, L = 3'b010, Z = 3'b011, S = 3'b100, T = 3'b101, O = 3'b110;
    parameter   INIT = 3'b000, 
                GENERATOR = 3'b001, 
                WAIT = 3'b010, 
                CHECK_IF_MOVABLE = 3'b011, 
                CHECK_COMPLETE_ROW = 3'b100, 
                DELETE_ROW = 3'b101, 
                CHECK_IF_OVER = 3'b110,
                UPDATE_MAP = 3'b111;
    parameter FALL = 2'b00, LEFT = 2'b01, RIGHT = 2'b10, ROTATE = 2'b11;  
    reg over_sig_r;
    reg isMovable;
    reg isOver;
    reg isDelete;
    reg [2:0] state;
    reg [4:0] next_x, next_y;
    reg [2:0] rand_num;
    reg [31:0] count_time;
    reg [4:0] complete_rows [19:0];//a
    reg [4:0] complete_num;//a
    wire [1:0] act;
    assign act = (keyboard_data == 8'h1c) ? LEFT 
                :(keyboard_data == 8'h23) ? RIGHT
                :(keyboard_data == 8'h1d) ? ROTATE
                :FALL;
    assign over_sig = over_sig_r;
    integer i,j,m,k,flag;
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
    
    always @(posedge clk) begin
        rand_num <= rand_num + 3'b001;
        if(rand_num == 7 ) begin
            rand_num <= 3'b000;
        end 
        if(rst || !start_sig) begin
            map <= 200'b0;
            score <= 0;
            over_sig_r <= 1;
            state <= INIT;
        end
        else begin
            case (state)
                INIT:begin
                    if(start_sig) begin
                        state <= GENERATOR;
                    end
                    else begin
                        state <= state;
                    end
                end
                GENERATOR: begin
                    square_type <= rand_num;
                    square_x <= 5;
                    square_y <= 2;
                    state <= WAIT;
                    count_time <= 0;
                end 
                WAIT: begin
                    if(act != FALL) begin
                        state <= CHECK_IF_MOVABLE;
                    end
                    if(count_time < 500000) begin
                        count_time = count_time + 1;
                        state <= state;
                    end
                    else begin
                        count_time = 0;
                        state <= CHECK_IF_MOVABLE;
                    end
                end
                CHECK_IF_MOVABLE: begin
                    isMovable = 1;
                    case (act)
                        FALL: begin
                            next_x <= square_x;
                            next_y <= square_y + 1; 
                            for(i = 0; i < 4; i = i+1) begin
                                if(map[10*next_y+next_x+shape[square_type][square_degree][i]] == 1 
                                    || 10*next_y+next_x+shape[square_type][square_degree][i] > 199) 
                                    isMovable = 0;
                            end               
                            if(isMovable) begin
                                square_x <= next_x;
                                square_y <= next_y;
                                state <= WAIT;
                            end
                            else begin
                                square_x = square_x;
                                square_y = square_y;
                                state <= UPDATE_MAP;
                            end
                        end
                        LEFT: begin
                            next_x = square_x-1;
                            next_y = square_y;                                               
                            for(i = 0; i < 4; i = i+1) begin
                                if(map[10*next_y+next_x+shape[square_type][square_degree][i]] == 1 
                                    || 10*next_y+next_x+shape[square_type][square_degree][i] / 10 != 10*square_y+square_x+shape[square_type][square_degree][i] / 10 ) 
                                    isMovable = 0;
                            end                           
                            if(isMovable) begin
                                square_x <= next_x;
                                square_y <= next_y;
                                state <= WAIT;
                            end
                            else begin
                                square_x <= square_x;
                                square_y <= square_y;
                                state <= UPDATE_MAP;
                            end
                        end
                        RIGHT: begin
                            next_x = square_x + 1;
                            next_y = square_y;                       
                                for(i = 0; i < 4; i = i+1) begin
                                    if(map[10*next_y+next_x+shape[square_type][square_degree][i]] == 1
                                        || 10*next_y+next_x+shape[square_type][square_degree][i] / 10 != 10*square_y+square_x+shape[square_type][square_degree][i] / 10) 
                                        isMovable = 0;
                                end                   
                            if(isMovable) begin
                                square_x <= next_x;
                                square_y <= next_y;
                                state <= WAIT;
                            end
                            else begin
                                square_x <= square_x;
                                square_y <= square_y;
                                state <= UPDATE_MAP;
                            end
                        end
                        ROTATE:begin
                            next_x = square_x;
                            next_y = square_y;
                            if(square_type == I && (square_x > 7 || square_x < 1 || square_y > 18))begin
                                isMovable = 0;
                            end
                            for(i = 0; i < 4; i = i+1) begin
                                if(map[10*next_y+next_x+shape[square_type][square_degree+2'b01][i]] == 1)
                                    isMovable = 0;
                            end
                            if(isMovable) begin
                                square_x <= next_x;
                                square_y <= next_y;
                                state <= WAIT;
                            end
                            else begin
                                square_x <= square_x;
                                square_y <= square_y;
                                square_degree <= square_degree + 2'b01;
                                state <= UPDATE_MAP;
                            end
                        end

                    endcase
                    
                end
                UPDATE_MAP: begin
                    for(i = 0; i < 4; i = i+1) begin
                        map[10*square_y+square_x+shape[square_type][square_degree][i]] <= 1;
                    end
                    state <= CHECK_COMPLETE_ROW;
                end
                CHECK_COMPLETE_ROW: begin
                    complete_num <= 0;
                    for(j = 0;j < 20;j = j+1)begin
                        flag <= 0;
                        for(m = j*10;m < j*10+10; m= m+1)begin
                            if(!map[m])begin
                                flag <= 1;
                            end
                        end
                        if(!flag)begin
                            complete_rows[complete_num] <= j;
                            complete_num <= complete_num + 1;
                            score <= 1 + 2*score; 
                        end
                    end
                    if(complete_num > 0)begin
                        state <= DELETE_ROW;
                    end
                    else begin
                        state <= CHECK_IF_OVER;
                    end
                end

                DELETE_ROW: begin
                    for (k = 0; k < complete_num; k = k + 1) begin
                        for (i = complete_rows[k]; i > 0; i = i - 1) begin
                            map[i*10+:10] <= map[(i-1)*10+:10];                       
                        end
                        map[0+:10] <= 10'b0;
                    end
                    state <= GENERATOR;
                end

                CHECK_IF_OVER:begin
                    isOver <= 0;
                    if(map[30+:10]!=10'b0)begin
                        isOver <= 1;
                    end
                    if(isOver)begin
                        over_sig_r <= 1;
                        state <= INIT;
                    end
                    else begin
                        state <= GENERATOR;
                    end
                end
            endcase
        end
    end
endmodule
