module FSK_Mod(
    input clk,
    input rst,
    input fsk_base_data,
    output [11:0] FSK_Mod_data
);

//The phase of FSK is continuous, so instead of switching between two carriers, the frequency control word of one carrier is modified

//parameter BIAS = 12'd1023;


parameter Freq_Word1 = 64'd153722867280913000 ;		//1MHz(120M Sampling frequency)
parameter Freq_Word2 = 64'd1537228672809130  ;      //10kHz(120M Sampling frequency)
parameter cnt_width = 9'd64;	//width of the Acc

//

//--------------------------------------------------------//
reg     [cnt_width-1:0]cnt_I = 0;       //Accmulator
wire    [11:0] 	addr_I;                 //rom address

always @(posedge clk or negedge rst) begin
	if(!rst)	begin
		cnt_I <= 0;
	end
	else	begin
        if(fsk_base_data) begin
	    cnt_I <= cnt_I + Freq_Word1;
        end else begin
        cnt_I <= cnt_I + Freq_Word2;
        end
	end
end

assign  addr_I = cnt_I[cnt_width-1:cnt_width-12];
//--------------------------------------------------------//

//--------------------Fsk rom output-------------------//
rom_ip	Sin_inst(
  	.clock		    (clk),
  	.address		(addr_I),
  	.q				(FSK_Mod_data)
);

endmodule

