module BPSK_Mod(
    input clk,
    input rst,
    input bpsk_base_data,
    output [11:0] BPSK_Mod_data
);


parameter Freq_Word = 64'd153722867280913000 ;		//1MHz(120M Sampling frequency)
parameter cnt_width = 9'd64;	//width of the Acc

parameter Phase_180 = 12'd2048;      //180 degree phase shift
parameter Cnt_Phase_180 = 64'h7ff_0000_0000_0000;//180 phase accmulator
//The upper 12 bits are for the address line, which is 12'd2047(12'h07ff)


//--------------------------DDS---------------------------//
reg     [cnt_width-1:0]cnt_I = 0;       //Accmulator
wire    [11:0] 	addr_I;                 //rom address


always @(posedge clk or negedge rst) begin
	if(!rst)	begin
		cnt_I <= 0;
	end
	else	begin
	    cnt_I <= cnt_I + Freq_Word;
	end
end







//fetch the 12bit address of the sin_rom
assign  addr_I =bpsk_base_data ? cnt_I[cnt_width-1:cnt_width-12]+Phase_180:cnt_I[cnt_width-1:cnt_width-12];
//--------------------------------------------------------//

//--------------------Bpsk rom output-------------------//
rom_ip	Sin_inst(
  	.clock		    (clk),
  	.address			(addr_I),
  	.q					(BPSK_Mod_data)
);



endmodule



