//----------------------------------------------------------------------------
//
// *File Name      :       uart_rx.v
// *Version        :
//                         1.0
// *Module Description:
//                         uart接收模块
//
// *Author(s)      :
//                        - Guodezheng cxhy1981@gmail.com,
// *LastChangeBy   :      guodezheng
// *CreatTime      :      2016-03-22 10:10:15
// *LastChangeTime :      2016-04-01 10:11:31
//----------------------------------------------------------------------------
`timescale 1ns / 1ps
module uart_rx(
                clk          ,
                rst_n        ,
                rs232_rx     ,
                rx_data      ,
                rx_int       ,
                clk_bps      ,
                bps_start
            );



input clk;
input rst_n;
input rs232_rx;
input clk_bps;
output bps_start;
output[7:0] rx_data;
output rx_int;


reg rs232_rx0,rs232_rx1,rs232_rx2,rs232_rx3;
wire neg_rs232_rx;

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
            rs232_rx0 <= 1'b0;
            rs232_rx1 <= 1'b0;
            rs232_rx2 <= 1'b0;
            rs232_rx3 <= 1'b0;
        end
    else begin
            rs232_rx0 <= rs232_rx;
            rs232_rx1 <= rs232_rx0;
            rs232_rx2 <= rs232_rx1;
            rs232_rx3 <= rs232_rx2;
        end
end

assign neg_rs232_rx = rs232_rx3 & rs232_rx2 & ~rs232_rx1 & ~rs232_rx0;

//----------------------------------------------------------------
reg bps_start_r;
reg[3:0] num;
reg rx_int;

always @ (posedge clk or negedge rst_n)
    if(!rst_n) begin
            bps_start_r <= 1'bz;
            rx_int <= 1'b0;
        end
    else if(neg_rs232_rx) begin     //接收到串口接收线rs232_rx的下降沿标志信号
            bps_start_r <= 1'b1;    //启动串口准备数据接收
            rx_int <= 1'b1;         //接收数据中断信号使能
        end
    else if(num==4'd12) begin       //接收完有用数据信息
            bps_start_r <= 1'b0;    //数据接收完毕，释放波特率启动信号
            rx_int <= 1'b0;         //接收数据中断信号关闭
        end

assign bps_start = bps_start_r;

//----------------------------------------------------------------
reg[7:0] rx_data_r;     //串口接收数据寄存器，保存直至下一个数据来到
//----------------------------------------------------------------

reg[7:0] rx_temp_data;  //当前接收数据寄存器

always @ (posedge clk or negedge rst_n)
    if(!rst_n) begin
            rx_temp_data <= 8'd0;
            num <= 4'd0;
            rx_data_r <= 8'd0;
        end
    else if(rx_int) begin   //接收数据处理
        if(clk_bps) begin   //读取并保存数据,接收数据为一个起始位，8bit数据，1或2个结束位
                num <= num+1'b1;
                case (num)
                        4'd1: rx_temp_data[0] <= rs232_rx;  //锁存第0bit
                        4'd2: rx_temp_data[1] <= rs232_rx;  //锁存第1bit
                        4'd3: rx_temp_data[2] <= rs232_rx;  //锁存第2bit
                        4'd4: rx_temp_data[3] <= rs232_rx;  //锁存第3bit
                        4'd5: rx_temp_data[4] <= rs232_rx;  //锁存第4bit
                        4'd6: rx_temp_data[5] <= rs232_rx;  //锁存第5bit
                        4'd7: rx_temp_data[6] <= rs232_rx;  //锁存第6bit
                        4'd8: rx_temp_data[7] <= rs232_rx;  //锁存第7bit
                        default: ;
                    endcase
            end
        else if(num == 4'd12) begin     //我们的标准接收模式下只有1+8+1(2)=11bit的有效数据
                num <= 4'd0;            //接收到STOP位后结束,num清零
                rx_data_r <= rx_temp_data;  //把数据锁存到数据寄存器rx_data中
            end
        end

assign rx_data = rx_data_r;

endmodule


