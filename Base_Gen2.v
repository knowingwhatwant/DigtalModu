module Base_Gen2(
    input clk,
    input rst,
    output [1:0]base_data
);


reg [1:0] base_data_reg;


assign base_data = base_data_reg;

always@(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        base_data_reg <= 2'd00;
    end
    else begin
        base_data_reg <= base_data_reg + 1'd1;  //clk
    end
end



endmodule





