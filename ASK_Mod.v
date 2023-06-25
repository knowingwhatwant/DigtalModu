module ASK_Mod(
	input clk,
	input rst,
	input  [11:0]  carrir_data,		
	input   ask_base_data,	
	output [11:0]  ASK_Mod_data		
);

//杩樻病鏈夋坊鍔犲彲璋冭妭

parameter BIAS = 12'd1023; // 骞呭€煎噺鍗婁箣鍚庣殑涓績鍋忕Щ鍊

//wire [11:0] A_t;
//assign A_t = (ask_base_data>=12'd2047) ? (1'd1) : (1'd0);		//杩欓噷鍒ゆ柇杈撳嚭浠€涔


reg [11:0] ASK_data_reg;



always@(posedge clk or negedge rst)
begin
	if(!rst)
	begin
		ASK_data_reg <= 12'd0;
	end
	else begin
		if (ask_base_data) begin
        ASK_data_reg <= carrir_data;
  	    end else begin
    	ASK_data_reg <= (carrir_data>>1) + BIAS;
   	   end
	end
end



assign ASK_Mod_data = ASK_data_reg;















endmodule