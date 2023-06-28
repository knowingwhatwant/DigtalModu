module AM_Mod#(parameter ma = 12'd1000) //100~1000 for 10% ~ 100%
(
	input	clk,
	input	rst,
	input	[11:0]	adc_data,
	output	[11:0]	AM_Mod_data,

	//test port
	output  [11:0]	carrier_data,
	output  [11:0]	Cov_carrier_data,
	output  [11:0]	Cov_adc_data
		
);


//---------------DDS_Carrier--------------------//
parameter Freq_I = 64'd153722867280913000 ;		//car= 1MHz sampling freqency 120M
parameter cnt_width = 9'd64;

reg     [cnt_width-1:0]cnt_I;
wire    [11:0]   addr_I;

always @(posedge clk or negedge rst) begin
	if(!rst)	begin
		cnt_I <= 0;
    end else begin
        cnt_I <= cnt_I + Freq_I;            //carrier for 1MHz
	end
end

assign  addr_I = cnt_I[cnt_width-1:cnt_width-12];

//----------------ROM----------------//
rom_ip				Sin_inst_Carrier(
  	.clock		    (clk),
  	.address		(addr_I),
  	.q				(carrier_data)
);

//------Bias of modulation signal-----//

wire [11:0] Modu_bias = 12'd1023-ma;		//center bias for scaled signal
//wire [11:0] Peak_data =(ma<<1);

//wire [11:0] Cov_adc_data;
wire [23:0] Modu_mult_data;

//adc_data_scaled
mul_ip_12_12 MULT_ScaledAdc_inst(
    .clock	(clk),
    .dataa  (adc_data),
    .datab  (ma),
    .result (Modu_mult_data)
);


assign Cov_adc_data = Modu_mult_data[22:11] + Modu_bias;


//-------------AM-------------//

//modulation signal

wire		[23:0]	mult_data;
//wire		[11:0]	carrier_data;
//wire      [11:0]  Cov_carrier_data;
reg	[11:0] Cov_carrier_data_reg;
//assign Cov_carrier_data = (carrier_data >=12'd2048)? (carrier_data - 12'd2048):(12'd2048 - carrier_data);

always@(posedge clk or negedge rst)
begin
	if(!rst)begin
		Cov_carrier_data_reg <= 0;
	end
	else if(carrier_data > 12'd2048)begin
		Cov_carrier_data_reg <= carrier_data - 12'd2048;
	end
	else if(carrier_data == 12'd2048)begin
		Cov_carrier_data_reg <= 1;
	end
	else begin
		Cov_carrier_data_reg <= 12'd2048 - carrier_data;
	end
end

assign Cov_carrier_data = Cov_carrier_data_reg;




mul_ip_12_12 MULT_inst(
   	.clock	    (clk),
   	.dataa		(Cov_carrier_data),
   	.datab		(Cov_adc_data),
   	.result		(mult_data)
);


//assign AM_Mod_data = (carrier_data >= 12'd2048)? (12'd2048+mult_data[23:12]) : (12'd2048-mult_data[23:12]);

reg [11:0] AM_Mod_data_reg;

always@(posedge clk or negedge rst)
begin
	if(!rst)begin
		AM_Mod_data_reg <= 12'd2048;
	end
	else if(carrier_data > 12'd2048) begin
		AM_Mod_data_reg <= 12'd2048 + mult_data[23:12];
	end
	else if(carrier_data == 12'd2048) begin
		AM_Mod_data_reg <= 12'd2048;
	end
	else begin
		AM_Mod_data_reg <= 12'd2048 - mult_data[23:12];
	end
end

assign AM_Mod_data = AM_Mod_data_reg;


endmodule
