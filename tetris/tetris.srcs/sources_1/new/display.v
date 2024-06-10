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
                Blue = 12'hf00,
                Grey = 12'h777;
    parameter h_start = 11'd0;  
    parameter v_start = 11'd0;
    parameter border_width = 11'd5;
    parameter game_area_width = 11'd99;
    parameter game_area_height = 11'd199;
    parameter square = 11'd9;
    parameter firstnet_h = 11'd14;
    parameter firstnet_v = 11'd14;
    parameter netdistance = 11'd10;

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
        shape[5][1][0] = 0; shape[5][1][1] = -10; shape[5][1][2] = -1; shape[5][1][3] = 10;
        shape[5][2][0] = 0; shape[5][2][1] = 1; shape[5][2][2] = -1; shape[5][2][3] = -10;
        shape[5][3][0] = 0; shape[5][3][1] = -10; shape[5][3][2] = 1; shape[5][3][3] = 10;

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
          if( rst )
            color <= 12'hfff;
          else if( (col >= h_start && col < h_start + border_width && 
                   row >= v_start && row < v_start + 2 * border_width + game_area_height)
                ||(col >= h_start + border_width + game_area_width && col < h_start + game_area_width + 2 * border_width && 
                   row >= v_start && row < v_start + 2 * border_width + game_area_height)
                ||(col >= h_start + border_width && col < h_start + border_width + game_area_width && 
                   row >= v_start && row < v_start + border_width )
                ||(col >= h_start + border_width && col < h_start + border_width + game_area_width && 
                   row >= v_start + border_width + game_area_height && row < v_start + 2 * border_width + game_area_height )   
                   )  //border 
             color <= 12'h000;
          else if((col == firstnet_h || col == firstnet_h + netdistance || col == firstnet_h + netdistance * 2 || 
                 col == firstnet_h + netdistance * 3 || col == firstnet_h + netdistance * 4 || col == firstnet_h + netdistance * 5 || 
                 col == firstnet_h + netdistance * 6 || col == firstnet_h + netdistance * 7 || col == firstnet_h + netdistance * 8 ||
                 row == firstnet_v || row == firstnet_v + netdistance || row == firstnet_v + netdistance * 2 || 
                 row == firstnet_v + netdistance * 3 || row == firstnet_v + netdistance * 4 || row == firstnet_v + netdistance * 5 || 
                 row == firstnet_v + netdistance * 6 || row == firstnet_v + netdistance * 7 || row == firstnet_v + netdistance * 8 ||
                 row == firstnet_v + netdistance * 9 || row == firstnet_v + netdistance * 10 || row == firstnet_v + netdistance * 11 || 
                 row == firstnet_v + netdistance * 12 || row == firstnet_v + netdistance * 13 || row == firstnet_v + netdistance * 14 ||
                 row == firstnet_v + netdistance * 15 || row == firstnet_v + netdistance * 16 || row == firstnet_v + netdistance * 17 || 
                 row == firstnet_v + netdistance * 18 ) && (col >= h_start + border_width && col < h_start + border_width + game_area_width ) &&
                 (row >= v_start && row < v_start + 2 * border_width + game_area_height)
                ) //net 
             color <= 12'h000;        
             
              
            if(row>=5&&row < 205  && col>=5&&col < 105) begin
                if(map[(row-5)/10 * 10 + (col-5) / 10] == 1) begin
                    color = Grey;
                end
                else  begin
                    if((row-5)/10 * 10 + (col-5) / 10 == square_y*10+square_x+shape[square_type][square_degree][0])
                            color = Blue;
                    else if((row-5)/10 * 10 + (col-5) / 10 == square_y*10+square_x+shape[square_type][square_degree][1])
                            color = Blue;
                    else if((row-5)/10 * 10 + (col-5) / 10 == square_y*10+square_x+shape[square_type][square_degree][2])
                            color = Blue;
                    else if((row-5)/10 * 10 + (col-5) / 10 == square_y*10+square_x+shape[square_type][square_degree][3])
                            color = Blue;
                    else 
                        color = White;
                end
            end
            else if(row<210&&col<110)
                color = Black;
            else
                color = White;
        end
        Over: begin
            color = Blue;
        end
        endcase
    end



endmodule