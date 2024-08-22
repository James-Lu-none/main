module MenuScreen
(
input CLOCK_50,
input m,
input [1:0]cursor,
input Hpos,
input Vpos, 
output reg Draw0,
output reg Draw1
);	
	wire [63:0]DR0,DR1;
	PrintChar pi0(Hpos,Vpos,80,100,5,114,DR1[0]);
	PrintChar pi1(Hpos,Vpos,115,100,5,97,DR1[1]);
	PrintChar pi2(Hpos,Vpos,150,100,5,110,DR1[2]);
	PrintChar pi3(Hpos,Vpos,185,100,5,68,DR1[3]);
	PrintChar pi4(Hpos,Vpos,220,100,5,111,DR1[4]);
	PrintChar pi5(Hpos,Vpos,255,100,5,109,DR1[5]);
	PrintChar pi6(Hpos,Vpos,290,100,5,0,DR1[6]);
	PrintChar pi7(Hpos,Vpos,325,100,5,103,DR1[7]);
	PrintChar pi8(Hpos,Vpos,360,100,5,97,DR1[8]);
	PrintChar pi9(Hpos,Vpos,395,100,5,109,DR1[9]);
	PrintChar pi10(Hpos,Vpos,430,100,5,69,DR1[10]);
	PrintChar pi11(Hpos,Vpos,475,100,5,45,DR1[11]);
	PrintChar pi12(Hpos,Vpos,510,100,5,49,DR1[12]);
	PrintChar pi13(Hpos,Vpos,545,100,5,48,DR1[13]);
	
	PrintSquare psm0(Hpos,Vpos,80,200,360,50,3,0,DR0[0]);
	PrintSquare psm1(Hpos,Vpos,80,280,360,50,3,0,DR0[1]);
	PrintSquare psm2(Hpos,Vpos,80,360,360,50,3,0,DR0[2]);
	PrintSquare psm3(Hpos,Vpos,80,440,360,50,3,0,DR0[3]);
	
	
	PrintChar p0(Hpos,Vpos,80,210,5,83,DR0[4]);
	PrintChar p1(Hpos,Vpos,115,210,5,78,DR0[5]);
	PrintChar p2(Hpos,Vpos,150,210,5,65,DR0[6]);
	PrintChar p3(Hpos,Vpos,185,210,5,75,DR0[7]);
	PrintChar p4(Hpos,Vpos,220,210,5,69,DR0[8]);
	PrintChar p5(Hpos,Vpos,255,210,5,0,DR0[9]);
	PrintChar p6(Hpos,Vpos,290,210,5,71,DR0[10]);
	PrintChar p7(Hpos,Vpos,325,210,5,65,DR0[11]);
	PrintChar p8(Hpos,Vpos,360,210,5,77,DR0[12]);
	PrintChar p9(Hpos,Vpos,395,210,5,69,DR0[13]);
	
	PrintChar p10(Hpos,Vpos,80,290,5,79,DR0[14]);
	PrintChar p11(Hpos,Vpos,115,290,5,79,DR0[15]);
	PrintChar p12(Hpos,Vpos,185,290,5,88,DR0[16]);
	PrintChar p13(Hpos,Vpos,220,290,5,88,DR0[17]);
	
	PrintChar pcm0(Hpos,Vpos,450,200+80*cursor,5,42,DR0[18]);
	
	always@(posedge CLOCK_50)begin
		if(m)begin
			Draw0=|DR0;
			Draw1=|DR1;
		end
		else begin
			Draw0=0;
			Draw1=0;
		end	
	end
endmodule
