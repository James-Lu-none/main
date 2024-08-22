module PrintSquare
(
input [11:0]Hpos,
input [11:0]Vpos,
input [11:0]Hori,
input [11:0]Vori,
input [11:0]width,
input [11:0]height,
input [11:0]thickness,
input fill,
output reg Draw
);
	reg [11:0]col,row;
	
	always@(*)begin
		col=Hpos-Hori;
		row=Vpos-Vori;
		if((col>=0 && col<=width+2*thickness-1) && (row>=0 && row<=height+2*thickness-1))begin
			if(!fill && (col>=thickness && col<=width+thickness-1) && (row>=thickness && row<=height+thickness-1))begin
				Draw=0;
			end
			else Draw=1;
		end
		else Draw=0;
	end
endmodule