module Commu_Mod(
    input clk,
    input rst,
    input wr_en,
    input commu_clk,
    input [7:0]ext_data,
    output [7:0]cov_data,
    output valid    //transfer complete
);


reg [7:0] cov_data_reg;

always@(posedge commu_clk or negedge rst)
begin
    if(!rst)begin
        cov_data_reg <= 0;        
    end
    else if (wr_en) begin
        cov_data_reg <= ext_data;
    end 
end

assign cov_data = valid ? cov_data_reg : 0;




endmodule 





