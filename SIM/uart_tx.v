//----------------------------------------------------------------------------
//
// *File Name      :       uart_tx.v
// *Version        :
//                         1.0
// *Module Description:
//                         uart发送模块
//
// *Author(s)      :
//                        - Guodezheng cxhy1981@gmail.com,
// *LastChangeBy   :      guodezheng
// *CreatTime      :      2016-03-22 10:13:00
// *LastChangeTime :      2016-04-01 10:13:33
//----------------------------------------------------------------------------
`timescale 1ns / 1ps
module uart_tx(
                   clk         ,
                   rst_n       ,
                   rx_data     ,
                   rx_int      ,
                   rs232_tx    ,
                   clk_bps     ,
                   bps_start
            );

input clk;
input rst_n;
input clk_bps;
input[7:0] rx_data;
input rx_int;
output rs232_tx;
output bps_start;

//---------------------------------------------------------
reg rx_int0,rx_int1,rx_int2;    //rx_int信号寄存器，捕捉下降沿滤波用
wire neg_rx_int;    // rx_int下降沿标志位

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
            rx_int0 <= 1'b0;
            rx_int1 <= 1'b0;
            rx_int2 <= 1'b0;
        end
    else begin
            rx_int0 <= rx_int;
            rx_int1 <= rx_int0;
            rx_int2 <= rx_int1;
        end
end

assign neg_rx_int =  ~rx_int1 & rx_int2;    //捕捉到下降沿后，neg_rx_int拉高保持一个主时钟周期

//---------------------------------------------------------
reg[7:0] tx_data;   //待发送数据的寄存器
//---------------------------------------------------------
reg bps_start_r;
reg tx_en;  //发送数据使能信号，高有效
reg[3:0] num;

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
            bps_start_r <= 1'bz;
            tx_en <= 1'b0;
            tx_data <= 8'd0;
        end
    else if(neg_rx_int) begin
            bps_start_r <= 1'b1;
            tx_data <= rx_data;
            tx_en <= 1'b1;
        end
    else if(num==4'd11) begin
            bps_start_r <= 1'b0;
            tx_en <= 1'b0;
        end
end

assign bps_start = bps_start_r;

//---------------------------------------------------------
reg rs232_tx_r;

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
            num <= 4'd0;
            rs232_tx_r <= 1'b1;
        end
    else if(tx_en) begin
            if(clk_bps) begin
                    num <= num+1'b1;
                    case (num)
                        4'd0: rs232_tx_r <= 1'b0;   //发送起始位
                        4'd1: rs232_tx_r <= tx_data[0]; //发送bit0
                        4'd2: rs232_tx_r <= tx_data[1]; //发送bit1
                        4'd3: rs232_tx_r <= tx_data[2]; //发送bit2
                        4'd4: rs232_tx_r <= tx_data[3]; //发送bit3
                        4'd5: rs232_tx_r <= tx_data[4]; //发送bit4
                        4'd6: rs232_tx_r <= tx_data[5]; //发送bit5
                        4'd7: rs232_tx_r <= tx_data[6]; //发送bit6
                        4'd8: rs232_tx_r <= tx_data[7]; //发送bit7
                        4'd9: rs232_tx_r <= 1'b1;   //发送结束位
                        default: rs232_tx_r <= 1'b1;
                        endcase
                end
            else if(num==4'd11) num <= 4'd0;    //复位
        end
end

assign rs232_tx = rs232_tx_r;

endmodule
