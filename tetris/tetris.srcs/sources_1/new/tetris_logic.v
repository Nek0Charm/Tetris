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
    input [7:0] keyboard_data,
    input keyboard_ready,
    input start_sig,
    output reg[199:0] map,
    output over_sig,
    output reg[4:0] square_x,
    output reg[4:0] square_y,
    output reg[2:0] square_type,
    output reg[1:0] square_degree,
    output reg [15:0] score,
    output pause,
    output reset
);
    parameter I = 3'b000, J = 3'b001, L = 3'b010, Z = 3'b011, S = 3'b100, T = 3'b101, O = 3'b110;
    parameter   INIT = 4'b0000, 
                GENERATOR = 4'b0001, 
                WAIT = 4'b0010, 
                CHECK_IF_MOVABLE = 4'b0011, 
                CHECK_COMPLETE_ROW = 4'b0100, 
                DELETE_ROW = 4'b0101, 
                CHECK_IF_OVER = 4'b0110,
                UPDATE_MAP = 4'b0111,
                STOP = 4'b1000;
    parameter FALL = 2'b00, LEFT = 2'b01, RIGHT = 2'b10, ROTATE = 2'b11;  
    reg isMovable;
    reg over_sig_r;
    reg isOver;
    reg isDelete;
    reg [3:0] state;
    reg [4:0] next_x, next_y;
    reg [7:0] rand_num;
    reg [31:0] count_time;
    reg [4:0] complete_rows;//a
    reg [1:0] act;
    assign over_sig = over_sig_r;
    integer i,j,m,k,flag;
    integer shape[6:0][3:0][3:0];
    assign pause = (state == STOP) ? 1 : 0;
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
        shape[5][1][0] = 0; shape[5][1][1] = -10; shape[5][1][2] = -1; shape[5][1][3] = 10;
        shape[5][2][0] = 0; shape[5][2][1] = 1; shape[5][2][2] = -1; shape[5][2][3] = -10;
        shape[5][3][0] = 0; shape[5][3][1] = -10; shape[5][3][2] = 1; shape[5][3][3] = 10;

        // Row 6
        shape[6][0][0] = 0; shape[6][0][1] = 1; shape[6][0][2] = 10; shape[6][0][3] = 11;
        shape[6][1][0] = 0; shape[6][1][1] = 1; shape[6][1][2] = 10; shape[6][1][3] = 11;
        shape[6][2][0] = 0; shape[6][2][1] = 1; shape[6][2][2] = 10; shape[6][2][3] = 11;
        shape[6][3][0] = 0; shape[6][3][1] = 1; shape[6][3][2] = 10; shape[6][3][3] = 11;
    end
    reg [1:0] Fall_ready;
    always @(posedge clk) begin
        Fall_ready = {Fall_ready[0], keyboard_ready};
    end
    initial begin
        map = 200'b0;
        rand_num = 0;
        Fall_ready = 2'b00;
        score = 0;    
        square_degree = 0;
    end
    
    
    always @(posedge clk) begin
        rand_num = rand_num + 1;
        if(rst || !start_sig) begin
            map <= 200'b0;
            isOver <= 0;
            state <= INIT;
        end
        else begin
            case (state)
                INIT:begin
                    if(start_sig) begin
                        map <= 200'b0;
                        score <= 0;
                        isOver <= 0;
                        over_sig_r <= 0;
                        state <= GENERATOR;
                    end
                    else begin
                        state <= state;
                    end
                end
                GENERATOR: begin
                    square_type <= rand_num[3:0] % 7;
                    square_x <= rand_num[7:4] % 7 + 1;
                    square_y <= 1;
                    state <= WAIT;
                    count_time <= 0;
                end 
                WAIT: begin             
                    count_time <= count_time + 1;
                    if(Fall_ready == 2'b10 && keyboard_data == 8'h1c) begin
                        isMovable <= 1;
                        next_x <= square_x-1;
                        next_y <= square_y;
                        act <= LEFT;
                        state <= CHECK_IF_MOVABLE;
                    end
                    else if(Fall_ready == 2'b10 && keyboard_data == 8'h23) begin
                        isMovable <= 1;
                        next_x <= square_x+1;
                        next_y <= square_y;
                        act <= RIGHT;
                        state <= CHECK_IF_MOVABLE;
                    end
                    else if(Fall_ready == 2'b10 && keyboard_data == 8'h1d) begin
                        isMovable <= 1;
                        next_x <= square_x;
                        next_y <= square_y;
                        act <= ROTATE;
                        state <= CHECK_IF_MOVABLE;
                    end
                    else if(Fall_ready == 2'b10 && keyboard_data == 8'h1b) begin
                        isMovable <= 1;
                        next_x <= square_x;
                        next_y <= square_y+1;
                        act <= FALL;
                        state <= CHECK_IF_MOVABLE;
                    end
                    else if(Fall_ready == 2'b10 && keyboard_data == 8'h29) begin
                        state <= STOP;
                    end
                    else if(count_time < (50 / (score + 1) + 25) * 1000000) begin
                        state <= state;
                    end
                    else begin
                        act <= FALL;
                        isMovable <= 1;
                        next_x <= square_x;
                        next_y <= square_y+1;
                        count_time <= 0;
                        state <= CHECK_IF_MOVABLE;
                    end
                end
                CHECK_IF_MOVABLE: begin
                    case (act)
                        FALL: begin
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
                                square_x <= square_x;
                                square_y <= square_y;
                                state = UPDATE_MAP;
                            end
                        end
                        LEFT: begin                                              
                            for(i = 0; i < 4; i = i+1) begin
                                if(map[10*next_y+next_x+shape[square_type][square_degree][i]] == 1 
                                    || (10*next_y+next_x+shape[square_type][square_degree][i]) / 10 != (10*square_y+square_x+shape[square_type][square_degree][i]) / 10 ) 
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
                                state <= WAIT;
                            end
                        end
                        RIGHT: begin                    
                                for(i = 0; i < 4; i = i+1) begin
                                    if(map[10*next_y+next_x+shape[square_type][square_degree][i]] == 1
                                        || (10*next_y+next_x+shape[square_type][square_degree][i]) / 10 != (10*square_y+square_x+shape[square_type][square_degree][i]) / 10) 
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
                                state <= WAIT;
                            end
                        end
                        ROTATE:begin
                            if(square_type == I && (square_x > 7 || square_x < 1 || square_y > 18))begin
                                isMovable = 0;
                            end
                            else if ((square_type != O) 
                                    && (square_x == 0 || square_x == 9)) begin
                                isMovable = 0;
                            end                   
                            for(i = 0; i < 4; i = i+1) begin
                                if(map[10*next_y+next_x+shape[square_type][square_degree+2'b01][i]] == 1)
                                    isMovable = 0;
                            end
                            if(isMovable) begin
                                square_x <= next_x;
                                square_y <= next_y;
                                square_degree <= square_degree + 2'b01;
                                state <= WAIT;
                            end
                            else begin
                                square_x <= square_x;
                                square_y <= square_y;
                                state <= WAIT;
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
                    complete_rows <= 0;
                    flag <= 0;
                    for(j = 0;j < 20;j = j+1)begin
                        if(&map[j*10+:10]) begin
                            complete_rows = j;
                            flag = 1;
                            score = score + 1;
                        end 
                    end
                    
                    if (flag) begin
                        i <= complete_rows;
                        state <= DELETE_ROW;
                    end
                    else begin
                        state <= CHECK_IF_OVER;
                    end
                end
                DELETE_ROW: begin
                    if(i > 0) begin
                        map[i*10+:10] = map[(i-1)*10+:10];
                        i = i-1;
                    end
                    else begin
                        map[0+:10] = 10'b0;
                        state <= CHECK_COMPLETE_ROW;
                    end            
                end
                CHECK_IF_OVER:begin
                    isOver <= 0;
                    if(map[40+:10]!=10'b0)begin
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
                STOP: begin
                    if(Fall_ready == 2'b10 && keyboard_data == 8'h29) begin
                        state <= WAIT;
                    end
                    else begin
                        state <= state;
                    end
                end
            endcase
        end
    end
endmodule
