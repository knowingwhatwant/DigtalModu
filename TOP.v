module TOP(
		input		clk,
		input		rst_n,
		output 		clk_120M,
		output 		clk_50M,
		output      base_gen,
		output 		clk_inv,
		output 		locked,
		output 		[11:0] FSK_Mod_data
);




assign clk_inv = ~clk_120M;
wire clk_1M;

pll_ip PLL_mod_inst(
	.areset(~rst_n),
	.inclk0(clk),
	.c0(clk_50M),
	.c1(clk_120M),
	.c2(clk_1M),
	.locked(locked)
);


//----------------1MHz-----------------//
wire    [11:0]  car_data_1M;
//1MHz_Carrier
DDS_Mod  #(64'd153722867280913000)DDS_Mod_inst1(
    .clk        (clk_120M),
    .rst_n      (rst_n),
	.sin		(car_data_1M)
);
//------------------------------------//

//----------------10kHz-----------------//
wire    [11:0]  car_data_10k;
//10kHz_Carrier
DDS_Mod  #(64'd1537228672809130)DDS_Mod_inst2(
    .clk        (clk_120M),
    .rst_n      (rst_n),
	.sin		(car_data_10k)
);
//------------------------------------//

//----------------FSK-----------------//
//wire [11:0] FSK_Mod_data;

FSK_Mod FSK_Mod_inst(
	.clk (clk_120M),
	.rst(rst_n),
	.fsk_base_data(base_gen),
	.FSK_Mod_data(FSK_Mod_data)
);
//-------------------------------------//


wire ASK_Mod_data;
//----------------ASK-----------------//
/*
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


//--------------Base_Gen--------------//
Base_Gen Base_Gen_inst(
	.clk(clk_1M),
	.rst(rst_n),
	.base_data(base_gen)

);

//------------------------------------//
endmodule