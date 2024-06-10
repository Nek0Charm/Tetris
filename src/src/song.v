`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/10 15:08:32
// Design Name: 
// Module Name: song
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

module	song(clk,start_game,buzzer);	//ģ������song		
input	   clk;					//ϵͳʱ��50MHz	
input      start_game;          //��Ϸ��ʼ����
output	buzzer;					//�����������
reg		buzzer_r;				//�Ĵ���
reg[8:0] state;				//����״̬��
reg[16:0]count,count_end;
reg[23:0]count1;
//���ײ���:D=F/2K  (D:����,F:ʱ��Ƶ��,K:����Ƶ��)
parameter      L3 = 17'd75850,  //����3
                L5 = 17'd63776, //����5
                L6 = 17'd56818,	//����6
				L7 = 17'd50618,	//����7
				M1 = 17'd47774,	//����1
				M2 = 17'd42568,	//����2
				M3 = 17'd37919,	//����3
				M4 = 17'd35791, //����4
				M5 = 17'd31888,	//����5
				M6 = 17'd28409,	//����6
				M7 = 17'd25419, //����7
				H1 = 17'd23889;//����1			
parameter	TIME = 12000000;	//����ÿһ�����ĳ���(250ms)									
assign buzzer = buzzer_r;			//�������
always@(posedge clk && start_game) begin
	count <= count + 1'b1;		//��������1
	if(count == count_end) begin	
		count <= 17'h0;			//����������
		buzzer_r <= !buzzer_r;		//���ȡ��
	end
end

//���� ������Ƶ��ϵ��������������
always @(posedge clk && start_game) begin
   if(count1 < TIME)             //һ������250mS
      count1 = count1 + 1'b1;
   else begin
      count1 = 24'd0;
      if(state == 8'd123)
         state = 8'd0;
      else
         state = state + 1'b1;
   case(state)//114321 
    8'd0,8'd1:count_end=M1;  
	8'd2,8'D3:count_end=M1;
	8'D4,8'D5,8'D6,8'D7:count_end=M4;
	8'D8,8'D9:count_end=M3;
	8'D10,8'D11:count_end=M2;
	8'D12,8'D13:count_end=M1;
	//1221312
	8'D14:count_end=M1;
	8'D15:count_end=M1;
	8'D16,8'D17:count_end=M2;
	8'D18,8'D19:count_end=M2;
	8'D20,8'D21:count_end=M1;
	8'D22,8'D23:count_end=M3;
	8'D24,8'D25:count_end=M1;
	8'D26,8'D27,8'D28,8'D29:count_end=M2;
	// 12321221312 
	8'D30,8'D31,8'd32,8'd33:count_end=M1;
	8'd34,8'D35,8'D36,8'D37:count_end=M2;  
	8'D38,8'D39,8'D40,8'D41:count_end=M3;
	8'D42,8'D43,8'D44,8'D45:count_end=M2;
	8'D46,8'D47:count_end=M1;
	8'D48,8'D49:count_end=M2;
	8'D50,8'D51:count_end=M2;	
	8'D52,8'D53:count_end=M1;
	8'D54,8'D55:count_end=M3;
	8'D56,8'D57:count_end=M1;
	8'D58,8'D59,8'D60,8'D61:count_end=M2;
	
	//12132 12132 
	8'D62,8'D63,8'd64,8'D65:count_end=M1;
	8'D66,8'D67:count_end=M2;
	8'D68,8'D69:count_end=M1;
	8'D70,8'D71,8'D72,8'D73:count_end=M3;
	8'D74,8'D75,8'D76,8'D77:count_end=M2;
	
	8'D78,8'D79,8'D80,8'D81:count_end=M1;
	8'D82,8'D83:count_end=M2;
	8'D84,8'D85:count_end=M1;
	8'D86,8'D87,8'D88,8'D89:count_end=M3;
    8'D90,8'D91,8'D92,8'D93:count_end=M2;
   
    //112 323 323231
    8'D94,8'D95:count_end=M1;
    8'D96,8'D97:count_end=M1;
    8'D98,8'D99,8'D100,8'D101:count_end=M2;
    8'D102,8'D103:count_end=M3;
    8'D104,8'D105:count_end=M2;  
    8'D106,8'D107,8'D108,8'D109:count_end=M3;
    
    8'D110,8'D111:count_end=M3;
    8'D112,8'D113:count_end=M2;
    8'D114,8'D115:count_end=M3;
    8'D116,8'D117:count_end=M2;
    8'D118,8'D119,8'D120,8'D121:count_end=M3;
    8'D122,8'D123:count_end=M1;
   
   
   default: count_end = 16'h0;
   endcase
   end
end
endmodule

