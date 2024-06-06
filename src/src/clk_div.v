module clk_div(
    input clk,
    output reg clk25MHZ = 0,
    output reg [1:0] clk100HZ_2b = 2'b00
    );
    reg [31:0] clkdiv;
	initial clkdiv = 32'b0; 
	always @(posedge clk) begin 
        clkdiv = clkdiv + 2'b1;
        if(clkdiv[1] == 1'b0) clk25MHZ = ~clk25MHZ;
        if(clkdiv[18] == 1'b0) clk100HZ_2b = clk100HZ_2b + 1'b1;    
    end
endmodule