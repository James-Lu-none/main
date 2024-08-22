module HDIV(
input [3:0]Din,
output reg [7:1]Seg
);
	always@(*)begin
		case(Din)
			4'h0:Seg=7'b1111110;
			4'h1:Seg=7'b0110000;
			4'h2:Seg=7'b1101101;
			4'h3:Seg=7'b1111001;
			4'h4:Seg=7'b0110011;
			4'h5:Seg=7'b1011011;
			4'h6:Seg=7'b1011111;
			4'h7:Seg=7'b1110000;
			4'h8:Seg=7'b1111111;
			4'h9:Seg=7'b1111011;
			4'ha:Seg=7'b1110111;
			4'hb:Seg=7'b0011111;
			4'hc:Seg=7'b1001110;
			4'hd:Seg=7'b0111101;
			4'he:Seg=7'b1001111;
			4'hf:Seg=7'b1000111;
		endcase
	end
endmodule
