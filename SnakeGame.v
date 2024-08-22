module SnakeGame#(
parameter L=100,
parameter size=10)
(
input [3:0]kb,
input Active,
output reg over,
input [1:0]D,
input clk_50,
input [15:0]Hpos,
input [15:0]Vpos,
output reg Draw0,
output reg Draw1,
output [L:0]C,
output [15:0]X0,
output [15:0]X1,
output [15:0]X2,
output [15:0]X3,

output [15:0]Y0,
output [15:0]Y1,
output [15:0]Y2,
output [15:0]Y3

); 
	reg [15:0]cnt1,cnt2;
	reg [15:0]curX,curY,t;
	wire [1:0]dir;	//1:up 2:down 3:left 4:right
	reg [7:0]j,s,TL;
	reg [7:0]length;
	reg [7:0]word1[5:0];
	wire [10:0]D0;
	wire [L:0]TD;
	wire [L:0]D1;
	reg [15:0]snakeX[L+2:0];
	reg [15:0]snakeY[L+2:0];
	PrintChar pc0(Hpos,Vpos,100,100,1,83,D0[0]);
	PrintChar pc1(Hpos,Vpos,107,100,1,67,D0[1]);
	PrintChar pc2(Hpos,Vpos,114,100,1,79,D0[2]);
	PrintChar pc3(Hpos,Vpos,121,100,1,82,D0[3]);
	PrintChar pc4(Hpos,Vpos,128,100,1,69,D0[4]);
	PrintChar pc5(Hpos,Vpos,135,100,1,58,D0[5]);
	
	always@(posedge clk_50) cnt1<=cnt1+1;
	
	genvar i;
	generate
		for(i=0;i<L;i=i+1)begin:K
			PrintSquare ps0(Hpos,Vpos,snakeX[i],snakeY[i],size,size,0,1,D1[i]);
		end
	endgenerate
	PrintSquare ps0(Hpos,Vpos,snakeX[0],snakeY[0],size,size,0,1,D0[6]);
	//PrintSquare ps1(Hpos,Vpos,snakeX[1],snakeY[1],size,size,0,1,color1[1]);
	//PrintSquare ps2(Hpos,Vpos,snakeX[2],snakeY[2],size,size,0,1,color1[2]);
	//PrintSquare ps0(Hpos,Vpos,5,5,size,size,0,1,color1[0]);
	reg food;
	reg [15:0]foodX;
	reg [15:0]foodY;
	always@(*)begin
		if(!food)begin
			foodX=Hpos;
			foodY=Vpos;
			food=1;
		end
		if(snakeX[0]==foodX && snakeY[0]==foodY)begin
			food=0;
			//length=length+1;
		end
		//if(snakeX[1]<200 || snakeX[1]>600 || snakeY[1]<100 || snakeY[1]>500)begin
		//	over=1;
		//end
	end
	
	always@(posedge cnt1)begin
		if(Active && !over) begin
			Draw0=| D0;
			Draw1=| D1;
			case(kb)
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
			snakeX[0]=curX;
			snakeY[0]=curY;
		end
		else begin
			Draw0=0;
			Draw1=0;
			curX=300;
			curY=400;
			length=5;
			for(j=0;j<L;j=j+1)begin
				snakeX[j]<=810;
				snakeY[j]<=610;
			end
		end
	end
	///////////////////////////////////////
	//assign dir=D;
	assign X0=snakeX[0];
	assign X1=snakeX[1];
	assign X2=snakeX[2];
	assign X3=snakeX[3];
	
	assign Y0=snakeY[0];
	assign Y1=snakeY[1];
	assign Y2=snakeY[2];
	assign Y3=snakeY[3];

endmodule