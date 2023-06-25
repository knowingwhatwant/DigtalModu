module DDS_Mod#(parameter   Freq = 64'd153722867280913000 //1MHz(120MHz Sampling Frequency)
)(
    input 	clk,
    input   rst_n,
	output   [11:0]  sin		//carrier output
);
//--------------------------------------------------------//
parameter   cnt_width =  9'd64;					//Acc width   
//--------------------------------------------------------//

//--------------------------------------------------------//
reg     [cnt_width-1:0]cnt_I = 0;
wire    [11:0] 	addr_I;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)	begin
		cnt_I <= 0;
	end
	else	begin
	    cnt_I <= cnt_I + Freq;
	end
end

assign  addr_I = cnt_I[cnt_width-1:cnt_width-12];
//--------------------------------------------------------//

//--------------------rom_output-------------------//
rom_ip	Sin_inst(
  	.clock		(clk),
  	.address		(addr_I),
  	.q				(sin)
);

endmodule
