//----------------------------------------------------------------------------
//
// *File Name: uart.v
//
// *Module Description:    UART模块的顶层。
//
//
// *Author(s):
//              - Guodezheng cxhy1981@gmail.com,
//
//----------------------------------------------------------------------------
// $LastChangedBy: guodezheng $
// $LastChangedDate: 2016-03-19 17:38:06 $
//----------------------------------------------------------------------------

module uart_top(
    //input
    mclk,
    puc_rst,
    uart_rxd,
    per_addr,
    per_din,
    per_en,
    per_we,
    //output
    uart_txd,
    per_dout
);

// OUTPUTs
//=========
output       [15:0] per_dout;       // Peripheral data output
output

// INPUTs
//=========
input               mclk;           // Main system clock
input        [13:0] per_addr;       // Peripheral address
input        [15:0] per_din;        // Peripheral data input
input               per_en;         // Peripheral enable (high active)
input         [1:0] per_we;         // Peripheral write enable (high active)
input               puc_rst;        // Main system reset

endmoudle //uart_top.v