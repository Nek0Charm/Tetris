module top (
	input clk,					//FPGA板上的时钟信??
    input rst,					//重置信号
	input PS2C,					//键盘脉冲信号
	input PS2D,					//键盘数据信号
			//七段数码??
    output LED
);

    reg rdn;
	wire [7:0] keyboard_data;
	wire keyboard_ready;
	reg [1:0] rdn_state;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rdn <= 1;
            rdn_state <= 2'b00;
        end else begin
            case (rdn_state)
                2'b00: begin
                    if (keyboard_ready) begin
                        rdn <= 0;      // 数据准备好时，rdn 信号有效
                        rdn_state <= 2'b01;
                    end
                end
                2'b01: begin
                    rdn <= 1;          // 保持 rdn 信号无效
                    rdn_state <= 2'b10;
                end
                2'b10: begin
                    rdn_state <= 2'b00; // 准备进入下一次检测
                end
                default: begin
                    rdn <= 1;
                    rdn_state <= 2'b00;
                end
            endcase
        end
    end
	PS2_Keyboard_Driver pkd(.clk(clk), .rst(rst), .rdn(rdn), .data(keyboard_data), .ready(keyboard_ready));
    assign LED = (keyboard_ready && keyboard_data == 8'h29) ? 1 : 0;
	//DispNum displaynumber(.clk100HZ(clk100HZ), .rst(rst), .HEXS(16'h1234), .EN(4'b1111), .P(4'b0000), .SEG(SEG), .AN(AN));
	
endmodule	