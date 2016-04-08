//----------------------------------------------------------------------------
//
// *File Name: uart_top.v
//
// *Module Description:    UART模块的顶层。
//
//
// *Author(s):
//              - Guodezheng cxhy1981@gmail.com,
//
//----------------------------------------------------------------------------
// *LastChangeBy   :      guodezheng
// *CreatTime      :      2016-03-19 21:13:55
// *LastChangeTime :      2016-04-07 14:30:31
//----------------------------------------------------------------------------


module uart_top(
    //input
    mclk,
    puc_rst,
    rs232_rx,
    per_addr,
    per_din,
    per_en,
    per_we,
    //output
    rs232_tx,
    per_dout
);

// OUTPUTs
//=========
output       [15:0] per_dout;       // Peripheral data output

// INPUTs
//=========
input               mclk;           // Main system clock
input        [13:0] per_addr;       // Peripheral address
input        [15:0] per_din;        // Peripheral data input
input               per_en;         // Peripheral enable (high active)
input         [1:0] per_we;         // Peripheral write enable (high active)
input               puc_rst;        // Main system reset


output              rs232_tx;
input               rs232_rx;

wire                bps_start1;
wire                bps_start2;
wire                clk_bps1;
wire                clk_bps2;
wire          [7:0] rx_data;
wire                rx_int;


//decoder 模块是高电平复位
//uart模块是低电平复位在链接除了高电平信号以外的信号的时候应该把复位信号取反。


// uart_decoder      uart_decoder_u  ();

uart_speed_select   uart_speed_rx_u(
                            .clk(mclk),  //波特率选择模块
                            .rst_n(~puc_rst),
                            .bps_start(bps_start1),
                            .clk_bps(clk_bps1)
                        );

uart_rx          uart_rx_u(
                            .clk(mclk),  //接收数据模块
                            .rst_n(~puc_rst),
                            .rs232_rx(rs232_rx),
                            .rx_data(rx_data),
                            .rx_int(rx_int),
                            .clk_bps(clk_bps1),
                            .bps_start(bps_start1)
                        );

uart_speed_select        uart_speed_tx_u(
                            .clk(mclk),  //波特率选择模块
                            .rst_n(~puc_rst),
                            .bps_start(bps_start2),
                            .clk_bps(clk_bps2)
                        );

uart_tx          uart_tx_u(
                            .clk(mclk),  //发送数据模块
                            .rst_n(~puc_rst),
                            .rx_data(rx_data),
                            .rx_int(rx_int),
                            .rs232_tx(rs232_tx),
                            .clk_bps(clk_bps2),
                            .bps_start(bps_start2)
                        );



endmodule // uart_top
