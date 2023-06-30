module TOP(
		input		clk,
		input		rst_n,
		output 		clk_120M,
		//output 		clk_50M,
		output	   [1:0]base_gen2,
		output 		clk_inv,
		output 		locked,
		output 		[11:0] adc_data,
		//output      [11:0] modu_data_100k,
		//test
		output      [11:0]carrier_data,
		output      [11:0]Cov_carrier_data,
		output      [11:0]Cov_adc_data
);




assign clk_inv = ~clk_120M;
wire clk_100k;



pll_ip PLL_mod_inst(
	.areset(~rst_n),
	.inclk0(clk),
	//.c0(clk_50M),
	.c1(clk_120M),
	.c2(clk_100k),
	.locked(locked)
);


//----------------1MHz-----------------//
wire    [11:0]  modu_data_10k;
//1MHz_Carrier
DDS_Mod  #(64'd1537228672809130)DDS_Mod_inst1(
    .clk        (clk_120M),
    .rst_n      (rst_n),
	.sin		(modu_data_10k)
);
//------------------------------------//

//---------------BPSK-----------------//
/*
QPSK_Mod Bpsk_Mod_inst(
	.clk(clk_120M),
	.rst(rst_n),
	.qpsk_base_data(base_gen2),
	.QPSK_Mod_data(adc_data),

);
*/



//------------------------------------//

//---------------AM-------------------//
AM_Mod Am_Mod_inst(
	.clk(clk_inv),
	.rst(rst_n),
	.adc_data(modu_data_10k),
	.AM_Mod_data(adc_data),
	//test port
	.carrier_data(carrier_data),
	.Cov_carrier_data(Cov_carrier_data),
	.Cov_adc_data(Cov_adc_data)
);









//----------------FSK-----------------//
//wire [11:0] FSK_Mod_data;
/*
FSK_Mod FSK_Mod_inst(
	.clk (clk_120M),
	.rst(rst_n),
	.fsk_base_data(base_gen),
	.FSK_Mod_data(FSK_Mod_data)
);
//-------------------------------------//


wire ASK_Mod_data;
//----------------ASK-----------------//

ASK_Mod ASK_Mod_inst(
	.clk (clk_120M),
	.rst (rst_n),
	.carrir_data(car_data),
	.ask_base_data(base_gen),
	.ASK_Mod_data(ASK_Mod_data)
);
*/
//------------------------------------//
//wire base_gen;

/*
//--------------Base_Gen--------------//
Base_Gen2 Base_Gen_inst(
	.clk(clk_100k),
	.rst(rst_n),
	.base_data(base_gen2)

);
*/
//------------------------------------//
endmodule
