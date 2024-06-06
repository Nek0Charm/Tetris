module top (
	input clk,					//FPGA板上的时钟信�?
    input rst,					//重置信号
	input PS2C,					//键盘脉冲信号
	input PS2D,					//键盘数据信号
    output [3:0] R, G, B,		//VGA
    output HS, VS,
	output [7:0] SEG,			//七段数码�?
    output [3:0] AN
);

    wire clk25MHZ;
	wire [1:0] clk100HZ;
	clk_div divider(.clk(clk), .clk25MHZ(clk25MHZ), .clk100HZ_2b(clk100HZ));

	wire [7:0] keyboard_data;
	wire keyboard_ready;
	PS2_Keyboard_Driver pkd(.clk(clk), .rst(rst), .rdn(1'b0), .data(keyboard_data), .ready(keyboard_ready));
	//assign keyboard_ready = 1;
	//assign keyboard_data = 8'h29;
	wire [199:0] map;
	wire [4:0] square_x;
	wire [4:0] square_y;
	wire [2:0] square_type;
	wire [1:0] square_degree;
	wire [1:0] state;
	wire [15:0] score;
	wire [8:0] row;
	wire [9:0] col;
	wire rdn;
	wire [11:0] pixel;
	VGA vga0(.clk(clk25MHZ), .rst(rst), .R(R), .G(G), .B(B), .HS(HS), .VS(VS), .row(row), .col(col), .rdn(rdn), .Din(pixel));
 	game game0(	.clk(clk), 
				.rst(rst), 
				.keyboard_data(keyboard_data), 
				.keyboard_ready(keyboard_ready),
				.square_degree(square_degree),
				.square_type(square_type),
				.square_x(square_x),
				.square_y(square_y),
				.map(map),
				.score(score),
				.state(state));
	display dis(.clk(clk25MHZ), 
				.rst(rst), 
				.square_degree(square_degree),
				.square_type(square_type),
				.square_x(square_x),
				.square_y(square_y),
				.map(map),
				.score(score),
				.state(state),
				.row(row),
				.col(col),
				.color(pixel));
	DispNum displaynumber(.clk100HZ(clk100HZ), .rst(rst), .HEXS(16'h1234), .EN(4'b1111), .P(4'b0000), .SEG(SEG), .AN(AN));
	
endmodule	