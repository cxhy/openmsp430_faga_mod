 //----------------------------------------------------------------------------
// Copyright (C) 2001 Authors
//
// This source file may be used and distributed without restriction provided
// that this copyright statement is not removed from the file and that any
// derivative work contains the original copyright notice and the associated
// disclaimer.
//
// This source file is free software; you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published
// by the Free Software Foundation; either version 2.1 of the License, or
// (at your option) any later version.
//
// This source is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public
// License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this source; if not, write to the Free Software Foundation,
// Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
//
//----------------------------------------------------------------------------
//
// *File Name: openMSP430_fpga.v
//
// *Module Description:
//                      openMSP430 top
//
// *Author(s):
//              - Olivier Girard,    olgirard@gmail.com
//
//----------------------------------------------------------------------------
// $Rev: 205 $
// $LastChangedBy: olivier.girard $
// $LastChangedDate: 2016-03-19 15:47:31 $
//----------------------------------------------------------------------------

`include "openMSP430_defines.v"

module  openMSP430_fpga(
      dco_clk ,
	  lfxt_clk,
	  reset_n,
	  p1_dout
);
input  dco_clk ;
input  lfxt_clk;
input  reset_n;
output p1_dout;


// Data Memory interface
wire [`DMEM_MSB:0] dmem_addr;
wire               dmem_cen;
wire        [15:0] dmem_din;
wire         [1:0] dmem_wen;
wire        [15:0] dmem_dout;

// Program Memory interface
wire [`PMEM_MSB:0] pmem_addr;
wire               pmem_cen;
wire        [15:0] pmem_din;
wire         [1:0] pmem_wen;
wire        [15:0] pmem_dout;

// Peripherals interface
wire        [13:0] per_addr;
wire        [15:0] per_din;
wire        [15:0] per_dout;
wire         [1:0] per_we;
wire               per_en;

// Direct Memory Access interface
wire        [15:0] dma_dout;
wire               dma_ready;
wire               dma_resp;

wire        [15:1] dma_addr;
wire        [15:0] dma_din;
wire               dma_en;
wire               dma_priority;
wire         [1:0] dma_we;
wire               dma_wkup;

// Digital I/O
wire               irq_port1;
wire               irq_port2;
wire        [15:0] per_dout_dio;
wire         [7:0] p1_dout;
wire         [7:0] p1_dout_en;
wire         [7:0] p1_sel;
wire         [7:0] p2_dout;
wire         [7:0] p2_dout_en;
wire         [7:0] p2_sel;
wire         [7:0] p3_dout;
wire         [7:0] p3_dout_en;
wire         [7:0] p3_sel;
wire         [7:0] p4_dout;
wire         [7:0] p4_dout_en;
wire         [7:0] p4_sel;
wire         [7:0] p5_dout;
wire         [7:0] p5_dout_en;
wire         [7:0] p5_sel;
wire         [7:0] p6_dout;
wire         [7:0] p6_dout_en;
wire         [7:0] p6_sel;
wire          [7:0] p1_din;
wire          [7:0] p2_din;
wire          [7:0] p3_din;
wire          [7:0] p4_din;
wire          [7:0] p5_din;
wire          [7:0] p6_din;

///dma reg
wire         [15:0]dma_ctl0;
wire         [15:0]dma_ctl1;
wire         [15:0]dma0_ctl;
wire         [15:0]dma0_sa;
wire         [15:0]dma0_da;
wire         [15:0]dma0_sz;
wire         [15:0]dma1_ctl;
wire         [15:0]dma1_sa;
wire         [15:0]dma1_da;
wire         [15:0]dma1_sz;
wire         [15:0]dma2_ctl;
wire         [15:0]dma2_sa;
wire         [15:0]dma2_da;
wire         [15:0]dma2_sz;

// wire               trigger;
wire               trigger0;
wire               trigger1;
wire               trigger2;

wire               code_sel_tri;

wire    [15:0]  encoder_buffer_din;
wire           encoder_buffer_din_en;
wire    [15:0] decoder_buffer_dout;
wire           decoder_buffer_dout_en;
wire    [15:0]  code_ctrl;
wire           code_ctrl_en;
wire    [15:0] viterbi_long;

wire    [15:0] per_dout_d2v;


// Peripheral templates
wire        [15:0] per_dout_temp_16b;
wire        [15:0] per_dout_temp_8b;
wire        [15:0] per_dout_dma;
wire        [15:0] per_dout_uart;

// Timer A
wire               irq_ta0;
wire               irq_ta1;
wire        [15:0] per_dout_timerA;
wire               taclk;
wire               ta_cci0a;
wire               ta_cci0b;
wire               ta_cci1a;
wire               ta_cci1b;
wire               ta_cci2a;
wire               ta_cci2b;
wire               ta_out0;
wire               ta_out0_en;
wire               ta_out1;
wire               ta_out1_en;
wire               ta_out2;
wire               ta_out2_en;

// Clock / Reset & Interrupts
wire               dco_enable;
wire               dco_wkup;


wire               lfxt_enable;
wire               lfxt_wkup;

wire               mclk;
wire               aclk;
wire               aclk_en;
wire               smclk;
wire               smclk_en;

wire               puc_rst;
wire  [`IRQ_NR-3:0] irq;
wire  [`IRQ_NR-3:0] irq_acc;
wire  [`IRQ_NR-3:0] irq_in;
wire         [13:0] wkup;
wire        [13:0] wkup_in;


wire               dbg_freeze;
wire               dbg_uart_txd;
wire               dbg_uart_rxd;

wire               uart_rxd;
wire               uart_txd;


assign p1_din                  = 8'h00;
assign p2_din                  = 8'h00;
assign p3_din                  = 8'h00;
assign p4_din                  = 8'h00;
assign p5_din                  = 8'h00;
assign p6_din                  = 8'h00;
assign taclk                   = 1'b0;
assign ta_cci0a                = 1'b0;
assign ta_cci0b                = 1'b0;
assign ta_cci1a                = 1'b0;
assign ta_cci1b                = 1'b0;
assign ta_cci2a                = 1'b0;
assign ta_cci2b                = 1'b0;

//
// Program Memory
//----------------------------------

// rom #(`PMEM_MSB, `PMEM_SIZE) pmem_0 (

////OUTPUTs
    // .ram_dout          (pmem_dout),            // Program Memory data output

////INPUTs
    // .ram_addr          (pmem_addr),            // Program Memory address
    // .ram_cen           (pmem_cen),             // Program Memory chip enable (low active)
    // .ram_clk           (mclk),                 // Program Memory clock
    // .ram_din           (pmem_din),             // Program Memory data input
    // .ram_wen           (pmem_wen)              // Program Memory write enable (low active)
// );

rom16x2048 rom_0 (
       .clock  (mclk),
       .clken  (~pmem_cen),
       .address        (pmem_addr),
       .q              ( pmem_dout )
);

//
// Data Memory
//----------------------------------

// ram #(`DMEM_MSB, `DMEM_SIZE) dmem_0 (

////OUTPUTs
    // .ram_dout          (dmem_dout),            // Data Memory data output

////INPUTs
    // .ram_addr          (dmem_addr),            // Data Memory address
    // .ram_cen           (dmem_cen),             // Data Memory chip enable (low active)
    // .ram_clk           (mclk),                 // Data Memory clock
    // .ram_din           (dmem_din),             // Data Memory data input
    // .ram_wen           (dmem_wen)              // Data Memory write enable (low active)
// );

ram16x512 ram (
        .address (dmem_addr),
        .clken   (~dmem_cen),
        .clock   (mclk),
        .data    (dmem_din[15:0]),
        .q       (dmem_dout[15:0]),
        .wren    ( ~(&dmem_wen[1:0]) ),
        .byteena ( ~dmem_wen[1:0] )
);

//
// openMSP430 Instance
//----------------------------------

openMSP430 dut (

// OUTPUTs
    .aclk              (aclk),                 // ASIC ONLY: ACLK
    .aclk_en           (aclk_en),              // FPGA ONLY: ACLK enable
    .dbg_freeze        (dbg_freeze),           // Freeze peripherals
    .dbg_i2c_sda_out   (),    // Debug interface: I2C SDA OUT
    .dbg_uart_txd      (dbg_uart_txd),         // Debug interface: UART TXD
    .dco_enable        (dco_enable),           // ASIC ONLY: Fast oscillator enable
    .dco_wkup          (dco_wkup),             // ASIC ONLY: Fast oscillator wake-up (asynchronous)
    .dmem_addr         (dmem_addr),            // Data Memory address
    .dmem_cen          (dmem_cen),             // Data Memory chip enable (low active)
    .dmem_din          (dmem_din),             // Data Memory data input
    .dmem_wen          (dmem_wen),             // Data Memory write byte enable (low active)
    .irq_acc           (irq_acc),              // Interrupt request accepted (one-hot signal)
    .lfxt_enable       (lfxt_enable),          // ASIC ONLY: Low frequency oscillator enable
    .lfxt_wkup         (lfxt_wkup),            // ASIC ONLY: Low frequency oscillator wake-up (asynchronous)
    .mclk              (mclk),                 // Main system clock
    .dma_dout          (dma_dout),             // Direct Memory Access data output
    .dma_ready         (dma_ready),            // Direct Memory Access is complete
    .dma_resp          (dma_resp),             // Direct Memory Access response (0:Okay / 1:Error)
    .per_addr          (per_addr),             // Peripheral address
    .per_din           (per_din),              // Peripheral data input
    .per_en            (per_en),               // Peripheral enable (high active)
    .per_we            (per_we),               // Peripheral write byte enable (high active)
    .pmem_addr         (pmem_addr),            // Program Memory address
    .pmem_cen          (pmem_cen),             // Program Memory chip enable (low active)
    .pmem_din          (pmem_din),             // Program Memory data input (optional)
    .pmem_wen          (pmem_wen),             // Program Memory write byte enable (low active) (optional)
    .puc_rst           (puc_rst),              // Main system reset
    .smclk             (smclk),                // ASIC ONLY: SMCLK
    .smclk_en          (smclk_en),             // FPGA ONLY: SMCLK enable

// INPUTs
    .cpu_en            (1'b1),               // Enable CPU code execution (asynchronous)
    .dbg_en            (1'b0),               // Debug interface enable (asynchronous)
    .dbg_i2c_addr      (7'h00),             // Debug interface: I2C Address
    .dbg_i2c_broadcast (7'h00),        // Debug interface: I2C Broadcast Address (for multicore systems)
    .dbg_i2c_scl       (1'b1),        // Debug interface: I2C SCL
    .dbg_i2c_sda_in    (1'b1),     // Debug interface: I2C SDA IN
    .dbg_uart_rxd      (dbg_uart_rxd),         // Debug interface: UART RXD (asynchronous)
    .dco_clk           (dco_clk),              // Fast oscillator (fast clock)
    .dmem_dout         (dmem_dout),            // Data Memory data output
    .irq               (irq_in),               // Maskable interrupts
    .lfxt_clk          (lfxt_clk),             // Low frequency oscillator (typ 32kHz)
    .dma_addr          (dma_addr),             // Direct Memory Access address
    .dma_din           (dma_din),              // Direct Memory Access data input
    .dma_en            (dma_en),               // Direct Memory Access enable (high active)
    .dma_priority      (dma_priority),         // Direct Memory Access priority (0:low / 1:high)
    .dma_we            (dma_we),               // Direct Memory Access write byte enable (high active)
    .dma_wkup          (dma_wkup),             // ASIC ONLY: DMA Sub-System Wake-up (asynchronous and non-glitchy)
    .nmi               (1'b0),                  // Non-maskable interrupt (asynchronous)
    .per_dout          (per_dout),             // Peripheral data output
    .pmem_dout         (pmem_dout),            // Program Memory data output
    .reset_n           (reset_n),              // Reset Pin (low active, asynchronous)
    .scan_enable       (1'b0),          // ASIC ONLY: Scan enable (active during scan shifting)
    .scan_mode         (1'b0),            // ASIC ONLY: Scan mode
    .wkup              (|wkup_in)              // ASIC ONLY: System Wake-up (asynchronous)
);

//
// Digital I/O
//----------------------------------
omsp_gpio #(.P1_EN(1),
            .P2_EN(1),
            .P3_EN(1),
            .P4_EN(1),
            .P5_EN(1),
            .P6_EN(1)) gpio_0 (

// OUTPUTs
    .irq_port1         (irq_port1),            // Port 1 interrupt
    .irq_port2         (irq_port2),            // Port 2 interrupt
    .p1_dout           (p1_dout),              // Port 1 data output
    .p1_dout_en        (p1_dout_en),           // Port 1 data output enable
    .p1_sel            (p1_sel),               // Port 1 function select
    .p2_dout           (p2_dout),              // Port 2 data output
    .p2_dout_en        (p2_dout_en),           // Port 2 data output enable
    .p2_sel            (p2_sel),               // Port 2 function select
    .p3_dout           (p3_dout),              // Port 3 data output
    .p3_dout_en        (p3_dout_en),           // Port 3 data output enable
    .p3_sel            (p3_sel),               // Port 3 function select
    .p4_dout           (p4_dout),              // Port 4 data output
    .p4_dout_en        (p4_dout_en),           // Port 4 data output enable
    .p4_sel            (p4_sel),               // Port 4 function select
    .p5_dout           (p5_dout),              // Port 5 data output
    .p5_dout_en        (p5_dout_en),           // Port 5 data output enable
    .p5_sel            (p5_sel),               // Port 5 function select
    .p6_dout           (p6_dout),              // Port 6 data output
    .p6_dout_en        (p6_dout_en),           // Port 6 data output enable
    .p6_sel            (p6_sel),               // Port 6 function select
    .per_dout          (per_dout_dio),         // Peripheral data output

// INPUTs
    .mclk              (mclk),                 // Main system clock
    .p1_din            (p1_din),               // Port 1 data input
    .p2_din            (p2_din),               // Port 2 data input
    .p3_din            (p3_din),               // Port 3 data input
    .p4_din            (p4_din),               // Port 4 data input
    .p5_din            (p5_din),               // Port 5 data input
    .p6_din            (p6_din),               // Port 6 data input
    .per_addr          (per_addr),             // Peripheral address
    .per_din           (per_din),              // Peripheral data input
    .per_en            (per_en),               // Peripheral enable (high active)
    .per_we            (per_we),               // Peripheral write enable (high active)
    .puc_rst           (puc_rst)               // Main system reset
);

//
// Timers
//----------------------------------

omsp_timerA timerA_0 (

// OUTPUTs
    .irq_ta0           (irq_ta0),              // Timer A interrupt: TACCR0
    .irq_ta1           (irq_ta1),              // Timer A interrupt: TAIV, TACCR1, TACCR2
    .per_dout          (per_dout_timerA),      // Peripheral data output
    .ta_out0           (ta_out0),              // Timer A output 0
    .ta_out0_en        (ta_out0_en),           // Timer A output 0 enable
    .ta_out1           (ta_out1),              // Timer A output 1
    .ta_out1_en        (ta_out1_en),           // Timer A output 1 enable
    .ta_out2           (ta_out2),              // Timer A output 2
    .ta_out2_en        (ta_out2_en),           // Timer A output 2 enable

// INPUTs
    .aclk_en           (aclk_en),              // ACLK enable (from CPU)
    .dbg_freeze        (dbg_freeze),           // Freeze Timer A counter
    .inclk             (1'b0),                // INCLK external timer clock (SLOW)
    .irq_ta0_acc       (irq_acc[`IRQ_NR-7]),   // Interrupt request TACCR0 accepted
    .mclk              (mclk),                 // Main system clock
    .per_addr          (per_addr),             // Peripheral address
    .per_din           (per_din),              // Peripheral data input
    .per_en            (per_en),               // Peripheral enable (high active)
    .per_we            (per_we),               // Peripheral write enable (high active)
    .puc_rst           (puc_rst),              // Main system reset
    .smclk_en          (smclk_en),             // SMCLK enable (from CPU)
    .ta_cci0a          (ta_cci0a),             // Timer A compare 0 input A
    .ta_cci0b          (ta_cci0b),             // Timer A compare 0 input B
    .ta_cci1a          (ta_cci1a),             // Timer A compare 1 input A
    .ta_cci1b          (ta_cci1b),             // Timer A compare 1 input B
    .ta_cci2a          (ta_cci2a),             // Timer A compare 2 input A
    .ta_cci2b          (ta_cci2b),             // Timer A compare 2 input B
    .taclk             (taclk)                 // TACLK external timer clock (SLOW)
);

//
// Peripheral templates
//----------------------------------

template_periph_8b template_periph_8b_0 (

// OUTPUTs
    .per_dout          (per_dout_temp_8b),     // Peripheral data output

// INPUTs
    .mclk              (mclk),                 // Main system clock
    .per_addr          (per_addr),             // Peripheral address
    .per_din           (per_din),              // Peripheral data input
    .per_en            (per_en),               // Peripheral enable (high active)
    .per_we            (per_we),               // Peripheral write enable (high active)
    .puc_rst           (puc_rst)               // Main system reset
);

template_periph_16b template_periph_16b_0 (

// OUTPUTs
    .per_dout          (per_dout_temp_16b),     // Peripheral data output

// INPUTs
    .mclk              (mclk),                 // Main system clock
    .per_addr          (per_addr),             // Peripheral address
    .per_din           (per_din),              // Peripheral data input
    .per_en            (per_en),               // Peripheral enable (high active)
    .per_we            (per_we),               // Peripheral write enable (high active)
    .puc_rst           (puc_rst)               // Main system reset
);
//
// Combine peripheral data bus
//----------------------------------

assign per_dout = per_dout_dio       |
                  per_dout_timerA    |
                  per_dout_temp_8b   |
				  per_dout_temp_16b  |
				  per_dout_d2v       |
                  per_dout_dma       |
                  per_dout_uart      ;


//
// Map peripheral interrupts & wakeups
//----------------------------------------


assign irq     = {`IRQ_NR-2{1'b0}};
assign irq_in  = irq  | {1'b0,                 // Vector 13  (0xFFFA)
                         1'b0,                 // Vector 12  (0xFFF8)
                         1'b0,                 // Vector 11  (0xFFF6)
                         1'b0,                 // Vector 10  (0xFFF4) - Watchdog -
                         irq_ta0,              // Vector  9  (0xFFF2)
                         irq_ta1,              // Vector  8  (0xFFF0)
                         1'b0,                 // Vector  7  (0xFFEE)
                         1'b0,                 // Vector  6  (0xFFEC)
                         1'b0,                 // Vector  5  (0xFFEA)
                         1'b0,                 // Vector  4  (0xFFE8)
                         irq_port2,            // Vector  3  (0xFFE6)
                         irq_port1,            // Vector  2  (0xFFE4)
                         1'b0,                 // Vector  1  (0xFFE2)
                         {`IRQ_NR-15{1'b0}}};  // Vector  0  (0xFFE0)

assign wkup    = 14'h0000;
assign wkup_in = wkup | {1'b0,                 // Vector 13  (0xFFFA)
                         1'b0,                 // Vector 12  (0xFFF8)
                         1'b0,                 // Vector 11  (0xFFF6)
                         1'b0,                 // Vector 10  (0xFFF4) - Watchdog -
                         1'b0,                 // Vector  9  (0xFFF2)
                         1'b0,                 // Vector  8  (0xFFF0)
                         1'b0,                 // Vector  7  (0xFFEE)
                         1'b0,                 // Vector  6  (0xFFEC)
                         1'b0,                 // Vector  5  (0xFFEA)
                         1'b0,                 // Vector  4  (0xFFE8)
                         1'b0,                 // Vector  3  (0xFFE6)
                         1'b0,                 // Vector  2  (0xFFE4)
                         1'b0,                 // Vector  1  (0xFFE2)
                         1'b0};                // Vector  0  (0xFFE0)




/////////////////dma_master///////////////////////

dma_master u_dma_master(
		.mclk       (mclk),
		.puc_rst    (puc_rst),
		.dma_ready  (dma_ready),
		.dma_resp   (dma_resp),
		.dma_dout   (dma_dout),

		.per_addr   (per_addr),             // Peripheral address
        .per_din    (per_din),              // Peripheral data input
		.per_en     (per_en),               // Peripheral enable (high active)///
		.per_we     (per_we),               // Peripheral write enable (high active)
		.code_sel_tri (code_sel_tri),

		.per_dout   (per_dout_dma),    // Peripheral data output
		.trigger0   (trigger0),
		.trigger1   (trigger1),
		.trigger2   (trigger2),

		.dma_wkup   (dma_wkup),
		.dma_addr   (dma_addr),
		.dma_din    (dma_din),
		.dma_en     (dma_en),
		.dma_we     (dma_we),
		.dma_priority (dma_priority)
);

dma_tfbuffer dma_tfbuffer_u(
    .mclk                   (mclk),
    .puc_rst                (puc_rst),
    .per_addr               (per_addr),
    .per_din                (per_din),
    .per_en                 (per_en),
    .per_we                 (per_we),
    .encoder_buffer_din     (encoder_buffer_din),
	.encoder_buffer_din_en  (encoder_buffer_din_en),
    .decoder_buffer_dout    (decoder_buffer_dout),
	.decoder_buffer_dout_en (decoder_buffer_dout_en),
    .code_ctrl              (code_ctrl),
	.code_ctrl_en           (code_ctrl_en),
	.viterbi_long           (viterbi_long),
    .per_dout               (per_dout_d2v)
    );


viterbi_conv_top viterbi_conv_top_0(
     .clk                        (mclk),
	 .rst                        (~puc_rst),
	 .trigger0                   (trigger0),
	 .trigger1                   (trigger1),
	 .code_ctrl                  (code_ctrl),
	 .code_ctrl_en               (code_ctrl_en),
	 .viterbi_long               (viterbi_long),

	 .decoder_buffer_dout        (decoder_buffer_dout),
	 .decoder_buffer_dout_en     (decoder_buffer_dout_en),

	 .encoder_buffer_din         (encoder_buffer_din),
	 .encoder_buffer_din_en      (encoder_buffer_din_en),
	 .code_sel_tri               (code_sel_tri)
     );
////////////////////////////////////////////////////


//uart
//已经声明了 per_dout_uart 、 uart_rxd  、  uart_txd  三个变量。并把per_dout_uart接到外设输出口上

uart uart_u(
        //input
        .mclk       (mclk),
        .puc_rst    (puc_rst),
        .uart_rxd   (uart_rxd),
        .per_addr   (per_addr),             // Peripheral address
        .per_din    (per_din),              // Peripheral data input
        .per_en     (per_en),               // Peripheral enable (high active)
        .per_we     (per_we),               // Peripheral write enable (high active)
        //output
        .uart_txd   (uart_txd),
        .per_dout   (per_dout_uart)          // Peripheral data output
    );



endmodule
