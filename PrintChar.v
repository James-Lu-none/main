module PrintChar
(
input [11:0]Hpos,
input [11:0]Vpos,
input [11:0]Hori,
input [11:0]Vori,
input [11:0]size,
input [7:0]AsciiCode,
output reg Draw
);
	wire [0:48]graph;
	reg [11:0]col,row;
	reg D;
	AsciiToGraph G0(AsciiCode,graph);
	always@(*)begin
		row=(Vpos-Vori)/size;
		col=(Hpos-Hori)/size;
		if((row>=0 && row<=6) && (col>=0 && col<=6) && Vpos>=Vori && Hpos>=Vori)begin
			Draw=graph[row*7+col];
		end
		else Draw=0;	
	end
endmodule