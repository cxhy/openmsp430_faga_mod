//----------------------------------------------------------------------------
// Copyright (C) 2009 , Guo Dezheng
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
// $Rev:  $
// $CreatDate:   2015-11-19 15:21:53
// $LastChangedBy: guodezheng $
// $LastChangedDate:  2016-01-04 16:18:13
//----------------------------------------------------------------------------
//
// *File Name: dma_tfbuffer.v
//
// *Module Description:
//                       进行把enoder和decoder的数据暂时存储在018f和0190寄存器下面。
//                       可以让外部读取这两个寄存器下的数据以及向这两个地址下写数据。
//
// *Author(s):
//              - Guodezheng cxhy1981@gmail.com,
//
//----------------------------------------------------------------------------

// encoder_buffer 01cc
// decoder_buffer 01ce

module dma_tfbuffer(
    //Inputs
    mclk,
    puc_rst,
    per_addr,
    per_din,
    per_en,
    per_we,
    encoder_buffer_din,
    encoder_buffer_din_en,

    //Outputs
    decoder_buffer_dout,
    decoder_buffer_dout_en,
    code_ctrl,
    code_ctrl_en,
    viterbi_long,
    per_dout
);

 input                      mclk;
 input                      puc_rst;
 input          [13:0]      per_addr;
 input          [15:0]      per_din;
 input                      per_en;
 input          [1:0]       per_we;
 input          [15:0]      encoder_buffer_din;
 input                      encoder_buffer_din_en;

 output         [15:0]      decoder_buffer_dout;
 output                     decoder_buffer_dout_en;
 output         [15:0]      code_ctrl;
 output                     code_ctrl_en;
 output         [15:0]      viterbi_long;
 output         [15:0]      per_dout;

 parameter [14:0]               BASE_ADDR = 15'h0190;
 parameter DEC_WD    = 3;
 parameter [DEC_WD-1 :0] ENCODER_BUFFERIN            = 'h0,
                         DECODER_BUFFEROUT           = 'h2,
                         CODE_CTRLOUT                = 'h4,
						 VITERBI_LONG                = 'h6;


parameter                DEC_SZ  = (1 << DEC_WD);                                   //8
parameter [DEC_SZ-1:0]   DEC_REG = {{DEC_SZ-1{1'b0}},1'b1};                         //0000_0001

parameter [DEC_SZ-1:0]   ENCODER_BUFFERIN_D  = (DEC_REG << ENCODER_BUFFERIN),       //0000_0001
                         DECODER_BUFFEROUT_D = (DEC_REG << DECODER_BUFFEROUT),      //0000_0100
                         CODE_CTRLOUT_D      = (DEC_REG << CODE_CTRLOUT),
                         VITERBI_LONG_D      = (DEC_REG << VITERBI_LONG);						 //0001_0000

wire           reg_sel          = per_en & (per_addr [13:DEC_WD-1] == BASE_ADDR[14:DEC_WD]);

wire      [DEC_WD-1:0] reg_addr = {per_addr[DEC_WD-2:0], 1'b0};


wire      [DEC_SZ-1:0] reg_dec  = (ENCODER_BUFFERIN_D         & {DEC_SZ{(reg_addr == ENCODER_BUFFERIN)}})|       //00           >>1 == 00
                                  (DECODER_BUFFEROUT_D        & {DEC_SZ{(reg_addr == DECODER_BUFFEROUT)}})|       //02           >>1 == 01
                                  (CODE_CTRLOUT_D             & {DEC_SZ{(reg_addr == CODE_CTRLOUT)}})     |
				                  (VITERBI_LONG_D             & {DEC_SZ{(reg_addr == VITERBI_LONG)}});       //04           >>1 == 10


wire              reg_write =  per_we  & reg_sel;
 // wire              reg_read  = ~|per_we & reg_sel & encoder_buffer_din_en;
wire              reg_read  = ~|per_we & reg_sel;

wire [DEC_SZ-1:0] reg_wr    = reg_dec & {DEC_SZ{reg_write}};
wire [DEC_SZ-1:0] reg_rd    = reg_dec & {DEC_SZ{reg_read}};


//encoder_buffer_din_reg
wire [15:0] encoder_buffer_din_reg;
assign encoder_buffer_din_reg = encoder_buffer_din;
// omsp_sync_cell encoder_buffer_din_0  (.data_out(encoder_buffer_din_reg[0 ]), .data_in(encoder_buffer_din[0 ]), .clk(mclk), .rst(puc_rst));
// omsp_sync_cell encoder_buffer_din_1  (.data_out(encoder_buffer_din_reg[1 ]), .data_in(encoder_buffer_din[1 ]), .clk(mclk), .rst(puc_rst));
// omsp_sync_cell encoder_buffer_din_2  (.data_out(encoder_buffer_din_reg[2 ]), .data_in(encoder_buffer_din[2 ]), .clk(mclk), .rst(puc_rst));
// omsp_sync_cell encoder_buffer_din_3  (.data_out(encoder_buffer_din_reg[3 ]), .data_in(encoder_buffer_din[3 ]), .clk(mclk), .rst(puc_rst));
// omsp_sync_cell encoder_buffer_din_4  (.data_out(encoder_buffer_din_reg[4 ]), .data_in(encoder_buffer_din[4 ]), .clk(mclk), .rst(puc_rst));
// omsp_sync_cell encoder_buffer_din_5  (.data_out(encoder_buffer_din_reg[5 ]), .data_in(encoder_buffer_din[5 ]), .clk(mclk), .rst(puc_rst));
// omsp_sync_cell encoder_buffer_din_6  (.data_out(encoder_buffer_din_reg[6 ]), .data_in(encoder_buffer_din[6 ]), .clk(mclk), .rst(puc_rst));
// omsp_sync_cell encoder_buffer_din_7  (.data_out(encoder_buffer_din_reg[7 ]), .data_in(encoder_buffer_din[7 ]), .clk(mclk), .rst(puc_rst));
// omsp_sync_cell encoder_buffer_din_8  (.data_out(encoder_buffer_din_reg[8 ]), .data_in(encoder_buffer_din[8 ]), .clk(mclk), .rst(puc_rst));
// omsp_sync_cell encoder_buffer_din_9  (.data_out(encoder_buffer_din_reg[9 ]), .data_in(encoder_buffer_din[9 ]), .clk(mclk), .rst(puc_rst));
// omsp_sync_cell encoder_buffer_din_10 (.data_out(encoder_buffer_din_reg[10]), .data_in(encoder_buffer_din[10]), .clk(mclk), .rst(puc_rst));
// omsp_sync_cell encoder_buffer_din_11 (.data_out(encoder_buffer_din_reg[11]), .data_in(encoder_buffer_din[11]), .clk(mclk), .rst(puc_rst));
// omsp_sync_cell encoder_buffer_din_12 (.data_out(encoder_buffer_din_reg[12]), .data_in(encoder_buffer_din[12]), .clk(mclk), .rst(puc_rst));
// omsp_sync_cell encoder_buffer_din_13 (.data_out(encoder_buffer_din_reg[13]), .data_in(encoder_buffer_din[13]), .clk(mclk), .rst(puc_rst));
// omsp_sync_cell encoder_buffer_din_14 (.data_out(encoder_buffer_din_reg[14]), .data_in(encoder_buffer_din[14]), .clk(mclk), .rst(puc_rst));
// omsp_sync_cell encoder_buffer_din_15 (.data_out(encoder_buffer_din_reg[15]), .data_in(encoder_buffer_din[15]), .clk(mclk), .rst(puc_rst));

//decoder_bufferout1
reg  [15:0] decoder_bufferout1;

wire        decoder_bufferout1_wr = reg_wr[DECODER_BUFFEROUT];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst) decoder_bufferout1 <=  16'h0000;
  else if (decoder_bufferout1_wr) decoder_bufferout1 <=  per_din;

assign decoder_buffer_dout = decoder_bufferout1;

//decoder_buffer_douten
reg         decoder_buffer_douten;

reg         decoder_buffer_douten_dly1;

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)               decoder_buffer_douten<=1'b0;
  else if (decoder_bufferout1_wr) decoder_buffer_douten<=1'b1;
  else                       decoder_buffer_douten<=1'b0;

// assign decoder_buffer_dout_en = decoder_buffer_douten;

always@(posedge mclk or posedge puc_rst)begin
	if (puc_rst)    decoder_buffer_douten_dly1 <= 1'b0;
	else  decoder_buffer_douten_dly1 <= decoder_buffer_douten;
end
assign decoder_buffer_dout_en = decoder_buffer_douten | decoder_buffer_douten_dly1;

//code_ctrlout2
reg  [15:0] code_ctrlout2;

wire        code_ctrlout2_wr = reg_wr[CODE_CTRLOUT];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        code_ctrlout2 <=  16'h0000;
  else if (code_ctrlout2_wr) code_ctrlout2 <=  per_din;

assign code_ctrl = code_ctrlout2;


//code_ctrlen
reg         code_ctrlen;

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)               code_ctrlen <=  1'b0;
  else if (code_ctrlout2_wr) code_ctrlen <=1'b1;
  else                       code_ctrlen<=1'b0;

assign code_ctrl_en = code_ctrlen;

reg  [15:0] viterbi_long3;
wire        viterbi_long3_wr = reg_wr[VITERBI_LONG];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst) viterbi_long3 <=  16'h0000;
  else if (viterbi_long3_wr) viterbi_long3 <=  per_din;

assign viterbi_long=viterbi_long3;


wire [15:0] decoder_buffer_dout_rd     = decoder_bufferout1     & {16{reg_rd[DECODER_BUFFEROUT]}};
wire [15:0] code_ctrl_rd               = code_ctrlout2          & {16{reg_rd[CODE_CTRLOUT     ]}};
wire [15:0] encoder_buffer_din_reg_rd  = encoder_buffer_din_reg & {16{reg_rd[ENCODER_BUFFERIN ]}};
wire [15:0] viterbi_long_rd            = viterbi_long3  & {16{reg_rd[VITERBI_LONG]}};


wire [15:0] per_dout  =  decoder_buffer_dout_rd           |
                         encoder_buffer_din_reg_rd        |
                         code_ctrl_rd                     |
						 viterbi_long_rd;

//en_buffer_din
endmodule  //dma_tfbuffer.v