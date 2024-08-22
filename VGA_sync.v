module VGA_sync(
	input	CLOCK_50,
	input rst,
	input [7:0]R,
	input [7:0]G,
	input [7:0]B,
	
	output reg [7:0]VGA_R,
	output reg [7:0]VGA_G,
	output reg [7:0]VGA_B,
	output reg [11:0]Hpos,
	output reg [11:0]Vpos,
	output reg VGA_HS,
	output reg VGA_VS,
	output VGA_CLK,
	output VGA_BLANK_N,
	output VGA_SYNC_N
);
	wire reset;
	assign VGA_BLANK_N=1;
	assign VGA_SYNC_N=1;
	
	assign VGA_CLK=CLOCK_50;
	
	always@(posedge VGA_CLK or negedge rst) begin
		if(!rst)begin
			Hpos<=0;
			Vpos<=0;
		end
		else begin
			Hpos<=Hpos+1;
			if(Hpos==1040)begin
				Hpos<=0;
				Vpos<=Vpos+1;
				if(Vpos==666)Vpos<=0;
			end
		end
	end
	
	always@(*)begin
		if((Hpos>855) && (Hpos<976)) VGA_HS=0;
		else VGA_HS=1;
		if((Vpos>636) && (Vpos<643)) VGA_VS=0;
		else VGA_VS=1;
		if((Hpos<=799) && (Vpos<=599)) begin
			VGA_R=R;
			VGA_G=G;
			VGA_B=B;
		end
		else begin
			VGA_R=0;
			VGA_G=0;
			VGA_B=0;
		end
	end
endmodule
