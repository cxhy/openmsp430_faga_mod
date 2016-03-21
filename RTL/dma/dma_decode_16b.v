//----------------------------------------------------------------------------
// Copyright (C) 2009 , Olivier Girard
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the authors nor the names of its contributors
//       may be used to endorse or promote products derived from this software
//       without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
// OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
// THE POSSIBILITY OF SUCH DAMAGE
//
//----------------------------------------------------------------------------
//
// *File Name: template_periph_16b.v
//
// *Module Description:
//                       16 bit peripheral template.
//
// *Author(s):
//              - Olivier Girard,    olgirard@gmail.com
//
//----------------------------------------------------------------------------
// $Rev: 134 $
// $LastChangedBy: olivier.girard $
// $LastChangedDate:  2016-01-08 15:00:32
//----------------------------------------------------------------------------

module  dma_decode_16b (

// OUTPUTs
    per_dout,                       // Peripheral data output

	//dma reg output
	dma_ctl0,
	dma_ctl1,
	dma0_ctl,
	dma0_ctl_en,
	dma0_sa ,
	dma0_da ,
	dma0_sz ,
	dma1_ctl,
	dma1_ctl_en,
	dma1_sa ,
	dma1_da ,
	dma1_sz ,
	dma2_ctl,
	dma2_ctl_en,
	dma2_sa ,
	dma2_da ,
	dma2_sz ,

// INPUTs
    mclk,                           // Main system clock
    per_addr,                       // Peripheral address
    per_din,                        // Peripheral data input
    per_en,                         // Peripheral enable (high active)
    per_we,                         // Peripheral write enable (high active)
    puc_rst                         // Main system reset
);

// OUTPUTs
//=========
output       [15:0] per_dout;       // Peripheral data output

//dam reg output
output  reg    [15:0] dma_ctl0;
output  reg    [15:0] dma_ctl1;
output  reg    [15:0] dma0_ctl;
output  reg    [15:0] dma0_sa ;
output  reg    [15:0] dma0_da ;
output  reg    [15:0] dma0_sz ;
output  reg    [15:0] dma1_ctl;
output  reg    [15:0] dma1_sa ;
output  reg    [15:0] dma1_da ;
output  reg    [15:0] dma1_sz ;
output  reg    [15:0] dma2_ctl;
output  reg    [15:0] dma2_sa ;
output  reg    [15:0] dma2_da ;
output  reg    [15:0] dma2_sz ;

output  reg           dma0_ctl_en;
output  reg           dma1_ctl_en;
output  reg           dma2_ctl_en;

// INPUTs
//=========
input               mclk;           // Main system clock
input        [13:0] per_addr;       // Peripheral address
input        [15:0] per_din;        // Peripheral data input
input               per_en;         // Peripheral enable (high active)
input         [1:0] per_we;         // Peripheral write enable (high active)
input               puc_rst;        // Main system reset


//=============================================================================
// 1)  PARAMETER DECLARATION
//=============================================================================

// DMA Register base address (must be aligned to decoder bit width)
parameter       [14:0] BASE_ADDR   = 15'h0100;

// Decoder bit width (defines how many bits are considered for address decoding)
parameter              DEC_WD      =  8;

// Register addresses offset
parameter [DEC_WD-1:0] DMACTL0     = 'h22,
                       DMACTL1     = 'h24,
                       DMA0CTL     = 'hE0,
                       DMA0SA      = 'hE2,
					             DMA0DA      = 'hE4,
					             DMA0SZ      = 'hE6,
					             DMA1CTL     = 'hE8,
					             DMA1SA      = 'hEA,
					             DMA1DA      = 'hEC,
					             DMA1SZ      = 'hEE,
					             DMA2CTL     = 'hF0,
					             DMA2SA      = 'hF2,
					             DMA2DA      = 'hF4,
					             DMA2SZ      = 'hF6,
                       TFDONE      = 'hF8;

// Register one-hot decoder utilities
parameter              DEC_SZ      =  (1 << DEC_WD);
parameter [DEC_SZ-1:0] BASE_REG    =  {{DEC_SZ-1{1'b0}}, 1'b1};

// Register one-hot decoder
parameter [DEC_SZ-1:0] DMACTL0_D     = (BASE_REG << DMACTL0  ),
                       DMACTL1_D     = (BASE_REG << DMACTL1  ),
                       DMA0CTL_D     = (BASE_REG << DMA0CTL  ),
                       DMA0SA_D      = (BASE_REG << DMA0SA   ),
					             DMA0DA_D      = (BASE_REG << DMA0DA   ),
					             DMA0SZ_D      = (BASE_REG << DMA0SZ   ),
					             DMA1CTL_D     = (BASE_REG << DMA1CTL  ),
					             DMA1SA_D      = (BASE_REG << DMA1SA   ),
					             DMA1DA_D      = (BASE_REG << DMA1DA   ),
					             DMA1SZ_D      = (BASE_REG << DMA1SZ   ),
					             DMA2CTL_D     = (BASE_REG << DMA2CTL  ),
					             DMA2SA_D      = (BASE_REG << DMA2SA   ),
					             DMA2DA_D      = (BASE_REG << DMA2DA   ),
					             DMA2SZ_D      = (BASE_REG << DMA2SZ   ),
                       TFDONE_D      = (BASE_REG << TFDONE   );

//============================================================================
// 2)  REGISTER DECODER
//============================================================================

// Local register selection
wire              reg_sel   =  per_en & (per_addr[13:DEC_WD-1]==BASE_ADDR[14:DEC_WD]);

// Register local address
wire [DEC_WD-1:0] reg_addr  =  {per_addr[DEC_WD-2:0], 1'b0};

// Register address decode
wire [DEC_SZ-1:0] reg_dec   =  (DMACTL0_D   &  {DEC_SZ{(reg_addr == DMACTL0  )}})  |
                               (DMACTL1_D   &  {DEC_SZ{(reg_addr == DMACTL1  )}})  |
                               (DMA0CTL_D   &  {DEC_SZ{(reg_addr == DMA0CTL  )}})  |
                               (DMA0SA_D    &  {DEC_SZ{(reg_addr == DMA0SA   )}})  |
							                 (DMA0DA_D    &  {DEC_SZ{(reg_addr == DMA0DA   )}})  |
							                 (DMA0SZ_D    &  {DEC_SZ{(reg_addr == DMA0SZ   )}})  |
							                 (DMA1CTL_D   &  {DEC_SZ{(reg_addr == DMA1CTL  )}})  |
							                 (DMA1SA_D    &  {DEC_SZ{(reg_addr == DMA1SA   )}})  |
							                 (DMA1DA_D    &  {DEC_SZ{(reg_addr == DMA1DA   )}})  |
							                 (DMA1SZ_D    &  {DEC_SZ{(reg_addr == DMA1SZ   )}})  |
							                 (DMA2CTL_D   &  {DEC_SZ{(reg_addr == DMA2CTL  )}})  |
							                 (DMA2SA_D    &  {DEC_SZ{(reg_addr == DMA2SA   )}})  |
							                 (DMA2DA_D    &  {DEC_SZ{(reg_addr == DMA2DA   )}})  |
							                 (DMA2SZ_D    &  {DEC_SZ{(reg_addr == DMA2SZ   )}})  |
                               (TFDONE_D    &  {DEC_SZ{(reg_addr == TFDONE   )}})  ;

// Read/Write probes
wire              reg_write =  |per_we & reg_sel;
wire              reg_read  = ~|per_we & reg_sel;

// Read/Write vectors
wire [DEC_SZ-1:0] reg_wr    = reg_dec & {DEC_SZ{reg_write}};
wire [DEC_SZ-1:0] reg_rd    = reg_dec & {DEC_SZ{reg_read}};


//============================================================================
// 3) REGISTERS
//============================================================================

// dma_ctl0 Register
//-----------------
// reg  [15:0] dma_ctl0;

wire        dma_ctl0_wr = reg_wr[DMACTL0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        dma_ctl0 <=  16'h0000;
  else if (dma_ctl0_wr) dma_ctl0 <=  per_din;


// dma_ctl1 Register
//-----------------
// reg  [15:0] dma_ctl1;

wire        dma_ctl1_wr = reg_wr[DMACTL1];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        dma_ctl1 <=  16'h0000;
  else if (dma_ctl1_wr) dma_ctl1 <=  per_din;


// dma0_ctl Register
//-----------------
// reg  [15:0] dma0_ctl;

wire        dma0_ctl_wr = reg_wr[DMA0CTL];

// reg dma0_ctl_en;

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        dma0_ctl <=  16'h0000;
  else if (dma0_ctl_wr) dma0_ctl <=  per_din;

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        dma0_ctl_en <=1'b0;
  else if (dma0_ctl_wr) dma0_ctl_en <=1'b1;
  else                  dma0_ctl_en<=1'b0;
  
  
// dma0_sa Register
//-----------------
// reg  [15:0] dma0_sa;

wire        dma0_sa_wr = reg_wr[DMA0SA];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        dma0_sa <=  16'h0000;
  else if (dma0_sa_wr) dma0_sa <=  per_din;

  // dma0_da Register
//-----------------
// reg  [15:0] dma0_da;

wire        dma0_da_wr = reg_wr[DMA0DA];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        dma0_da <=  16'h0000;
  else if (dma0_da_wr) dma0_da <=  per_din;

  // dma0_sz Register
//-----------------
// reg  [15:0] dma0_sz;

wire        dma0_sz_wr = reg_wr[DMA0SZ];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        dma0_sz <=  16'h0000;
  else if (dma0_sz_wr) dma0_sz <=  per_din;

  // dma1_ctl Register
//-----------------
// reg  [15:0] dma1_ctl;

wire        dma1_ctl_wr = reg_wr[DMA1CTL];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        dma1_ctl <=  16'h0000;
  else if (dma1_ctl_wr) dma1_ctl <=  per_din;
  
always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        dma1_ctl_en <=1'b0;
  else if (dma1_ctl_wr) dma1_ctl_en <=1'b1;
  else                  dma1_ctl_en<=1'b0;

  // dma1_sa Register
//-----------------
// reg  [15:0] dma1_sa;

wire        dma1_sa_wr = reg_wr[DMA1SA];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        dma1_sa <=  16'h0000;
  else if (dma1_sa_wr) dma1_sa <=  per_din;

  // dma1_da Register
//-----------------
// reg  [15:0] dma1_da;

wire        dma1_da_wr = reg_wr[DMA1DA];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        dma1_da <=  16'h0000;
  else if (dma1_da_wr) dma1_da <=  per_din;

  // dma1_sz Register
//-----------------
// reg  [15:0] dma1_sz;

wire        dma1_sz_wr = reg_wr[DMA1SZ];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        dma1_sz <=  16'h0000;
  else if (dma1_sz_wr) dma1_sz <=  per_din;

  // dma2_ctl Register
//-----------------
// reg  [15:0] dma2_ctl;

wire        dma2_ctl_wr = reg_wr[DMA2CTL];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        dma2_ctl <=  16'h0000;
  else if (dma2_ctl_wr) dma2_ctl <=  per_din;
  
always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        dma2_ctl_en <=1'b0;
  else if (dma2_ctl_wr) dma2_ctl_en <=1'b1;
  else                  dma2_ctl_en<=1'b0;

  // dma2_sa Register
//-----------------
// reg  [15:0] dma2_sa;

wire        dma2_sa_wr = reg_wr[DMA2SA];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        dma2_sa <=  16'h0000;
  else if (dma2_sa_wr) dma2_sa <=  per_din;

  // dma2_da Register
//-----------------
// reg  [15:0] dma2_da;

wire        dma2_da_wr = reg_wr[DMA2DA];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        dma2_da <=  16'h0000;
  else if (dma2_da_wr) dma2_da <=  per_din;

  // dma2_sz Register
//-----------------
// reg  [15:0] dma2_sz;

wire        dma2_sz_wr = reg_wr[DMA2SZ];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        dma2_sz <=  16'h0000;
  else if (dma2_sz_wr) dma2_sz <=  per_din;



//============================================================================
// 4) DATA OUTPUT GENERATION
//============================================================================

// Data output mux
wire [15:0] dma_ctl0_rd  = dma_ctl0  & {16{reg_rd[DMACTL0]}};
wire [15:0] dma_ctl1_rd  = dma_ctl1  & {16{reg_rd[DMACTL1]}};
wire [15:0] dma0_ctl_rd  = dma0_ctl  & {16{reg_rd[DMA0CTL]}};
wire [15:0] dma0_sa_rd   = dma0_sa   & {16{reg_rd[DMA0SA ]}};
wire [15:0] dma0_da_rd   = dma0_da   & {16{reg_rd[DMA0DA ]}};
wire [15:0] dma0_sz_rd   = dma0_sz   & {16{reg_rd[DMA0SZ ]}};
wire [15:0] dma1_ctl_rd  = dma1_ctl  & {16{reg_rd[DMA1CTL]}};
wire [15:0] dma1_sa_rd   = dma1_sa   & {16{reg_rd[DMA1SA ]}};
wire [15:0] dma1_da_rd   = dma1_da   & {16{reg_rd[DMA1DA ]}};
wire [15:0] dma1_sz_rd   = dma1_sz   & {16{reg_rd[DMA1SZ ]}};
wire [15:0] dma2_ctl_rd  = dma2_ctl  & {16{reg_rd[DMA2CTL]}};
wire [15:0] dma2_sa_rd   = dma2_sa   & {16{reg_rd[DMA2SA ]}};
wire [15:0] dma2_da_rd   = dma2_da   & {16{reg_rd[DMA2DA ]}};
wire [15:0] dma2_sz_rd   = dma2_sz   & {16{reg_rd[DMA2SZ ]}};


wire [15:0] per_dout   =  dma_ctl0_rd  |
                          dma_ctl1_rd  |
                          dma0_ctl_rd  |
                          dma0_sa_rd   |
						              dma0_da_rd   |
                          dma0_sz_rd   |
                          dma1_ctl_rd  |
						              dma1_sa_rd   |
						              dma1_da_rd   |
						              dma1_sz_rd   |
						              dma2_ctl_rd  |
						              dma2_sa_rd   |
						              dma2_da_rd   |
                          dma2_sz_rd    ;

endmodule // template_pericntrl4_rd  |ph_16b
