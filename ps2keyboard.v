//'timescale 1ns/1ps

module ps2keyboard
(
input rst,
input clk_50,//50Mhz system clock 
input clk_in,//clk from keyboard
input data_in,//data from keyboard
output [7:0]SC0,
output [7:0]SC1,
output [7:0]SC2,
output GotCode,
output [9:0]key,
output reg [7:1]seg1,
output reg [7:1]seg2,
output reg [7:1]seg3,
output reg [7:1]seg4,
output reg [7:1]seg5,
output reg [7:1]seg6
);
	reg [10:0]tempdata;
	reg [7:0]data[5:0];
	reg [8:0]cnt1;
	reg [15:0]cnt2;
	reg [3:0]step,clk_cnt;
	wire [7:1]Nseg1,Nseg2,Nseg3,Nseg4,Nseg5,Nseg6;
	wire clk_97k;
	reg bussy,R;
	reg [4:0]i;
	
	
	always@(posedge clk_50) cnt1<=cnt1+1;
	assign clk_97k=cnt1[8];
	
	always@(posedge clk_97k)begin
		if(clk_in)begin
			cnt2<=cnt2+1;
			if(cnt2>16'd160)begin
				bussy<=0;
			end
		end
		else begin
			bussy<=1;
			cnt2<=0;
		end
	end
	
	always@(posedge clk_in or negedge bussy)begin
		if(!bussy)step<=0;
		else begin
			step<=step+1;
			if(step<4'b1010) tempdata[step]=data_in;
			if(step==4'b1000)begin
				for(i=1;i<6;i=i+1)begin
					data[i]<=data[i-1];
				end
				data[0] <= {tempdata[8:1]};
			end
		end
	end
	assign GotCode=bussy;
	assign SC0=data[0];
	assign SC1=data[1];
	assign SC2=data[2];
	
	//show scan code
	wire [7:0]v0,v1,v2;
	assign v0=data[0];
	assign v1=data[1];
	assign v2=data[2];
	
	HDIV U0(v0[7:4],Nseg1);
	HDIV U1(v0[3:0],Nseg2);
	HDIV U2(v1[7:4],Nseg3);
	HDIV U3(v1[3:0],Nseg4);
	HDIV U4(v2[7:4],Nseg5);
	HDIV U5(v2[3:0],Nseg6);
	
	always@(*)begin
		seg1=~Nseg1;
		seg2=~Nseg2;
		seg3=~Nseg3;
		seg4=~Nseg4;
		seg5=~Nseg5;
		seg6=~Nseg6;
	end
	
endmodule
