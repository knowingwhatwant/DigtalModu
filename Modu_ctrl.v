module Modu_ctrl(
    //ctrl
    input clk,
    input rst,
    input [7:0]cov_data,     //MCU ctrl data
    //
    input [11:0] AM_data,
    input [11:0] DSB_data,
    input [11:0] FM_data,
    input [11:0] ASK_data,
    input [11:0] FSK_data,
    input [11:0] BPSK_data,
    input [11:0] QPSK_data,
    output [11:0] Modu_ed_Signal

);

parameter AM = 0;
parameter DSB = 1;
parameter FM = 2;
parameter ASK = 3;
parameter FSK = 4;
parameter BPSK = 5;
parameter QPSK = 6;


reg [11:0] Modu_ed_Signal_reg;

always@(posedge clk or negedge rst)
begin
    if(!rst) begin
        Modu_ed_Signal_reg <= 0;
    end
    else
    case (cov_data[2:0])
       AM:   Modu_ed_Signal_reg <= AM_data;
       DSB:  Modu_ed_Signal_reg <= DSB_data;
       FM:   Modu_ed_Signal_reg <= FM_data;
       ASK:  Modu_ed_Signal_reg <= ASK_data;
       FSK:  Modu_ed_Signal_reg <= FSK_data;
       BPSK: Modu_ed_Signal_reg <= BPSK_data;
       QPSK: Modu_ed_Signal_reg <= QPSK_data;
    endcase

end











endmodule

