module IncMain #(
parameter L=20,
parameter size=10)
(
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	input 		     [3:0]		KEY,

	input 		     [9:0]		SW,

	output		     [9:0]		LEDR,

	output		     [7:1]		HEX0,
	output		     [7:1]		HEX1,
	output		     [7:1]		HEX2,
	output		     [7:1]		HEX3,
	output		     [7:1]		HEX4,
	output		     [7:1]		HEX5,

	output		          		VGA_BLANK_N,
	output		     [7:0]		VGA_B,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS,

	input 		          		AUD_ADCDAT,
	inout 		          		AUD_ADCLRCK,
	inout 		          		AUD_BCLK,
	output		          		AUD_DACDAT,
	inout 		          		AUD_DACLRCK,
	output		          		AUD_XCK,

	inout 		          		PS2_CLK,
	inout 		          		PS2_DAT,
	
	output		          		FPGA_I2C_SCLK,
	inout 		          		FPGA_I2C_SDAT
);
	//sync
	wire [11:0]Hpos,Vpos;
	VGA_sync S0(
	.CLOCK_50(CLOCK_50),.rst(SW[0]),
	.R(R),.G(G),.B(B),
	.Hpos(Hpos),.Vpos(Vpos),
	.VGA_HS(VGA_HS),.VGA_VS(VGA_VS),.VGA_CLK(VGA_CLK),.VGA_BLANK_N(VGA_BLANK_N),.VGA_SYNC_N(VGA_SYNC_N),
	.VGA_R(VGA_R),.VGA_G(VGA_G),.VGA_B(VGA_B));
	

	//get scan code
	ps2keyboard K0(.clk_50(CLOCK_50),.clk_in(PS2_CLK),.data_in(PS2_DAT),.SC0(SC[0]),.SC1(SC[1]),.SC2(SC[2]),.GotCode(GotCode));
	
	//sampling keyboard scan code
	reg go;
	reg [3:0]kb_input,prevkb;
	reg [7:0]key;
	wire [7:0]SC[3:0];
	wire GotCode;
	always@(negedge GotCode or negedge SW[0])begin
		if(!SW[0])begin
			go<=0;
			kb_input<=4'b0000;
		end
		else begin
			if((SC[1]==8'hF0))begin
				key<=8'h00;
			end
			else begin
				key<=SC[0];
				case(key)
					8'h1d:kb_input<=4'b0000;
					8'h1b:kb_input<=4'b0001;
					8'h1c:kb_input<=4'b0010;
					8'h23:kb_input<=4'b0011;
					8'h5A:begin
						kb_input<=4'b0000;
						go<=1;
					end
				endcase
			end
			
			if(over)begin
				go<=0;
			end
		end
	end
	
	//highest score update
	reg [3:0]hi[4:0];
	reg [3:0]score[4:0];
	always@(*)begin
		if(!SW[0])begin
			hi[0]=0;
			hi[1]=0;
			hi[2]=0;
			hi[3]=0;
			hi[4]=0;
		end
		else begin	
			if({score[4],score[3],score[2],score[1],score[0]}>{hi[4],hi[3],hi[2],hi[1],hi[0]})begin
				hi[0]=score[0];
				hi[1]=score[1];
				hi[2]=score[2];
				hi[3]=score[3];
				hi[4]=score[4];
			end
		end
	end

	//print color set
	reg [7:0]R,G,B;
	always@(posedge CLOCK_50)begin
		if(|D0)begin
			R<=255;
			G<=255;
			B<=255;
		end	
		else if(|D1)begin 
			R<=0;
			G<=255;
			B<=0;
		end
		else if(|D2)begin
			R<=255;
			G<=255;
			B<=0;
		end
		else if((|D3) && over)begin 
			R<=210;
			G<=0;
			B<=0;
		end
		else if(|D4 && cnt2[24])begin 
			R<=0;
			G<=200;
			B<=200;
		end
		else begin 
			R<=100;
			G<=100;
			B<=100;
		end
	end
	
	//print game 
	wire [L:0]D0,D1,D2,D3,D4,D5,D6;
	
	generate
		PrintSquare F(Hpos,Vpos,foodX,foodY,size,size,0,1,D2[0]);
		PrintSquare TT(Hpos,Vpos,198,148,400,400,4,0,D0[0]);
		
		PrintChar pc0(Hpos,Vpos,190,90,3,83,D0[1]);
		PrintChar pc1(Hpos,Vpos,217,90,3,67,D0[2]);
		PrintChar pc2(Hpos,Vpos,244,90,3,79,D0[3]);
		PrintChar pc3(Hpos,Vpos,271,90,3,82,D0[4]);
		PrintChar pc4(Hpos,Vpos,298,90,3,69,D0[5]);
		PrintChar pc5(Hpos,Vpos,325,90,3,58,D0[6]);
		
		PrintChar pc6(Hpos,Vpos,352,90,3,score[4]+48,D0[7]);
		PrintChar pc7(Hpos,Vpos,379,90,3,score[3]+48,D0[8]);
		PrintChar pc8(Hpos,Vpos,406,90,3,score[2]+48,D0[9]);
		PrintChar pc9(Hpos,Vpos,433,90,3,score[1]+48,D0[10]);
		PrintChar pc10(Hpos,Vpos,460,90,3,score[0]+48,D0[11]);
		
		PrintChar Go0(Hpos,Vpos,306,200,3,71,D3[0]);
		PrintChar Go1(Hpos,Vpos,327,200,3,65,D3[1]);
		PrintChar Go2(Hpos,Vpos,348,200,3,77,D3[2]);
		PrintChar Go3(Hpos,Vpos,369,200,3,69,D3[3]);
		PrintChar Go4(Hpos,Vpos,390,200,3,0,D3[4]);
		PrintChar Go5(Hpos,Vpos,411,200,3,79,D3[5]);
		PrintChar Go6(Hpos,Vpos,432,200,3,86,D3[6]);
		PrintChar Go7(Hpos,Vpos,453,200,3,69,D3[7]);
		PrintChar Go8(Hpos,Vpos,474,200,3,82,D3[8]);
		
		PrintChar HI0(Hpos,Vpos,190,116,2,72,D0[12]);
		PrintChar HI1(Hpos,Vpos,204,116,2,73,D0[13]);
		PrintChar HI2(Hpos,Vpos,218,116,2,58,D0[14]);
		
		PrintChar HI3(Hpos,Vpos,232,116,2,hi[4]+48,D0[15]);
		PrintChar HI4(Hpos,Vpos,246,116,2,hi[3]+48,D0[16]);
		PrintChar HI5(Hpos,Vpos,260,116,2,hi[2]+48,D0[17]);
		PrintChar HI6(Hpos,Vpos,274,116,2,hi[1]+48,D0[18]);
		PrintChar HI7(Hpos,Vpos,288,116,2,hi[0]+48,D0[19]);
		
		PrintChar e0(Hpos,Vpos,302,224,2,69,D4[0]);
		PrintChar e1(Hpos,Vpos,316,224,2,110,D4[1]);
		PrintChar e2(Hpos,Vpos,330,224,2,116,D4[2]);
		PrintChar e3(Hpos,Vpos,344,224,2,101,D4[3]);
		PrintChar e4(Hpos,Vpos,358,224,2,114,D4[4]);
		PrintChar e5(Hpos,Vpos,372,224,2,0,D4[5]);
		PrintChar e6(Hpos,Vpos,386,224,2,84,D4[6]);
		PrintChar e7(Hpos,Vpos,400,224,2,111,D4[7]);
		PrintChar e8(Hpos,Vpos,414,224,2,0,D4[8]);
		PrintChar e9(Hpos,Vpos,428,224,2,83,D4[9]);
		PrintChar e10(Hpos,Vpos,442,224,2,116,D4[10]);
		PrintChar e11(Hpos,Vpos,456,224,2,97,D4[11]);
		PrintChar e12(Hpos,Vpos,470,224,2,114,D4[12]);
		PrintChar e13(Hpos,Vpos,484,224,2,116,D4[13]);
		
	endgenerate
	
	//game update
	always@(posedge CLOCK_50) begin
		if(SW[1] && go)begin
			cnt1<=cnt1+1;
		end
	end
	//blink
	always@(posedge CLOCK_50) begin
		if(!go) cnt2<=cnt2+1;
		else cnt2=0;
	end
	
	assign LEDR[0]=over;
	assign LEDR[1]=cnt1[21];
	//snake game flow
	reg food,update,over;
	reg [11:0]foodX,foodY,curX,curY,length;
	reg [25:0]cnt1,cnt2,cnt3;
	reg [7:0]j,k;
	reg [11:0]snakeX[L:0];
	reg [11:0]snakeY[L:0];
	always@(posedge cnt1[21] or negedge go)begin
		if(!go)begin
			foodX<=(10*(Hpos%37))+220;
			foodY<=(10*(Vpos%37))+170;
			food<=1;
			over<=0;
			length<=5;
			for(k=0;k<5;k=k+1)score[k]<=0;
			curX<=400;
			curY<=350;
			snakeX[0]<=400;
			snakeY[0]<=350;
			for(j=1;j<L;j=j+1)begin
				snakeX[j]<=610;
				snakeY[j]<=810;
			end
		end
		else if(!over)begin
			case(kb_input)
				4'b0000:curY<=curY-size;
				4'b0001:curY<=curY+size;
				4'b0010:curX<=curX-size;
				4'b0011:curX<=curX+size;
			endcase
			for(j=0;j<L;j=j+1)begin
				if(j<length)begin
					snakeX[j+1]<=snakeX[j];
					snakeY[j+1]<=snakeY[j];
				end
			end
			snakeX[0]<=curX;
			snakeY[0]<=curY;
			
			for(cnt3=2;cnt3<L;cnt3=cnt3+1) if(snakeX[0]==snakeX[cnt3] && snakeY[0]==snakeY[cnt3]) over<=1;
			if(snakeX[0]<220 || snakeX[0]>570 || snakeY[0]<170 || snakeY[0]>520)over<=1;
			
			if(!food)begin
				foodX<=(10*(Hpos%37))+220;
				foodY<=(10*(Vpos%37))+170;
				food<=1;
			end
			if(snakeX[0]==foodX && snakeY[0]==foodY)begin
				food<=0;
				length<=length+1;
				score[0]<=score[0]+5;
			end
			if(score[0]>9)begin
				score[0]<=0;
				score[1]<=score[1]+1;
			end
			if(score[1]>9)begin
				score[1]<=0;
				score[2]<=score[2]+1;
			end
			if(score[2]>9)begin
				score[2]<=0;
				score[3]<=score[3]+1;
			end
			if(score[3]>9)begin
				score[3]<=0;
				score[4]<=score[4]+1;
			end
		end
	end
	
	
	//draw snake
	genvar i;
	generate
		for(i=0;i<L;i=i+1)begin:K
			PrintSquare ps0(Hpos,Vpos,snakeX[i],snakeY[i],size,size,0,1,D1[i]);
		end
	endgenerate
	
	
endmodule
