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
// *File Name: dma_master.v
//
// *Module Description:
//                       dma主机
//
// *Author(s):
//              - guodezheng,    cxhy1981@gmail.com
//
//----------------------------------------------------------------------------
// $Rev: 134 $
// $LastChangedBy: guodezheng $
// $LastChangedDate: 2015/10/6 星期二 12:02:45 $
// 加入了结束判断位的起始信号和结束信号，送给decoder模块用于生成dmaen_done信号用于写入内存
// updata : 2016/01/21 为dmaxreq信号添加使能信号(dmaxreq_en)当使能位为高直到，dmaxreq会接受来自dmaxctl0[0]的配置否则为0
//                     每发生一次dmax_ctl读操作的时候dmax_ctl_en会被获得一个上升沿脉冲。当读操作结束以后会收到一个来自cha0_tf_done信号的上升沿脉冲
//                     在dmax_ctl_en信号出现之后，dmaxreq_en信号被拉高，直到接收到chax_tf_done信号，信号被拉低。
//----------------------------------------------------------------------------

module  dma_pri (
                       mclk                      ,
                       puc_rst                   ,

                       dma_ctl0                  ,
                       dma_ctl1                  ,
                       dma0_ctl                  ,
					             dma0_ctl_en               ,
                       dma1_ctl                  ,
					             dma1_ctl_en               ,
                       dma2_ctl                  ,
					             dma2_ctl_en               ,

                       cha0_tf_done              ,
                       cha1_tf_done              ,
                       cha2_tf_done              ,

                       dma_priority              ,
                       cha0_tri                  ,
                       cha1_tri                  ,
                       cha2_tri

);

input                                   mclk           ;
input                                   puc_rst        ;

input  [15:0]                           dma_ctl0       ;
input  [15:0]                           dma_ctl1       ;
input  [15:0]                           dma0_ctl       ;
input                                   dma0_ctl_en    ;
input  [15:0]                           dma1_ctl       ;
input                                   dma1_ctl_en    ;
input  [15:0]                           dma2_ctl       ;
input                                   dma2_ctl_en    ;
input                                   cha0_tf_done   ;
input                                   cha1_tf_done   ;
input                                   cha2_tf_done   ;

output                                  dma_priority   ;
output                                  cha0_tri       ;
output                                  cha1_tri       ;
output                                  cha2_tri       ;



wire  [15:0]                           dma_ctl0        ;
wire  [15:0]                           dma_ctl1        ;
wire  [15:0]                           dma0_ctl        ;
wire  [15:0]                           dma1_ctl        ;
wire  [15:0]                           dma2_ctl        ;
wire  [3:0]                            DMA0TSELx       ;
wire  [3:0]                            DMA1TSELx       ;
wire  [3:0]                            DMA2TSELx       ;
wire                                   dma0_ctl_en     ;
wire                                   dma1_ctl_en     ;
wire                                   dma2_ctl_en     ;
wire                                   cha0_tf_done    ;
wire                                   cha1_tf_done    ;
wire                                   cha2_tf_done    ;

wire                                   cha_tri         ;
reg                                    cha_tri_dly     ;
wire                                   cha_tri_pos     ;
wire                                   cha_tf_done     ;
reg                                    cha_tf_done_dly ;
wire                                   cha_tf_done_pos ;
wire                                   dma0req_en      ;
wire                                   dma1req_en      ;
wire                                   dma2req_en      ;
reg                                    dma0req_en_reg  ;
reg                                    dma1req_en_reg  ;
reg                                    dma2req_en_reg  ;


reg                                    cha0_tri        ;
reg                                    cha1_tri        ;
reg                                    cha2_tri        ;

reg                                    dma0_tri        ;
reg                                    dma1_tri        ;
reg                                    dma2_tri        ;
reg [2:0]                              last_txf_cha    ;

//  last_txf_cha      说明
//  000               复位之后进行第一次传输
//  001               上一次传输的是通道0
//  010               上一次传输的是通道1
//  100               上一次传输的是通道2



wire                                   ROUNDROBIN   ;
wire                                   DMAONFETCH   ;


parameter IDLE       = 4'b0001;
parameter CHA0       = 4'b0010;
parameter CHA1       = 4'b0100;
parameter CHA2       = 4'b1000;
reg       [3:0]      current_state;
reg       [3:0]      next_state   ;

assign     DMA0TSELx = dma_ctl0[3:0];
assign     DMA1TSELx = dma_ctl0[7:4];
assign     DMA2TSELx = dma_ctl0[11:8];

//dma0req自动复位模块
// assign     dma0req   = dma0_ctl[0];
// assign     dma1req   = dma1_ctl[0];
// assign     dma2req   = dma2_ctl[0];
assign     dma0req   = (dma0req_en) ?  dma0_ctl[0] : 1'b0;
assign     dma1req   = (dma1req_en) ?  dma1_ctl[0] : 1'b0;
assign     dma2req   = (dma2req_en) ?  dma2_ctl[0] : 1'b0;

always @(posedge mclk or posedge puc_rst) begin
    if(puc_rst) dma0req_en_reg <= 0;
    else begin
        if(dma0_ctl_en)        dma0req_en_reg <= 1'b1;
        else if(cha0_tf_done)  dma0req_en_reg <= 1'b0;
    end
end

always @(posedge mclk or posedge puc_rst) begin
    if(puc_rst) dma1req_en_reg <= 0;
    else begin
        if(dma1_ctl_en)        dma1req_en_reg <= 1'b1;
        else if(cha1_tf_done)  dma1req_en_reg <= 1'b0;
    end
end

always @(posedge mclk or posedge puc_rst) begin
    if(puc_rst) dma2req_en_reg <= 0;
    else begin
        if(dma2_ctl_en)        dma2req_en_reg <= 1'b1;
        else if(cha2_tf_done)  dma2req_en_reg <= 1'b0;
    end
end

assign dma0req_en = dma0req_en_reg;
assign dma1req_en = dma1req_en_reg;
assign dma2req_en = dma2req_en_reg;
//dma0req自动复位模块

//为tf_done信号添加tf_done_sy标志位，使得一个通道在信号传输结束以后把done信号转换为持续的电平信号
reg cha0_tf_done_sy;
reg cha1_tf_done_sy;
reg cha2_tf_done_sy;
always @(posedge mclk or posedge puc_rst) begin
  if(puc_rst)   cha0_tf_done_sy <= 0;
  else begin
      if(cha0_tf_done)       cha0_tf_done_sy <= 1'b1;
      else if(cha0_tri)      cha0_tf_done_sy <= 1'b0;
  end
end

always @(posedge mclk or posedge puc_rst) begin
  if(puc_rst)   cha1_tf_done_sy <= 0;
  else begin
      if(cha1_tf_done)       cha1_tf_done_sy <= 1'b1;
      else if(cha1_tri)      cha1_tf_done_sy <= 1'b0;
  end
end

always @(posedge mclk or posedge puc_rst) begin
  if(puc_rst)   cha2_tf_done_sy <= 0;
  else begin
      if(cha2_tf_done)       cha2_tf_done_sy <= 1'b1;
      else if(cha2_tri)      cha2_tf_done_sy <= 1'b0;
  end
end




assign     ROUNDROBIN = dma_ctl1[1];
assign     DMAONFETCH = dma_ctl1[2];
assign     dma_priority = DMAONFETCH;

assign cha_tf_done = cha0_tf_done |
                     cha1_tf_done |
                     cha2_tf_done ;
assign cha_tri     = cha0_tri     |
                     cha1_tri     |
                     cha2_tri     ;
always @(posedge mclk or posedge puc_rst) begin
    if (puc_rst) begin
        // reset
        cha_tri_dly     <= 1'b0;
        cha_tf_done_dly <= 1'b0;
    end
    else begin
        cha_tri_dly     <= cha_tri;
        cha_tf_done_dly <= cha_tf_done;
    end
end
assign cha_tri_pos     = cha_tri      & (~cha_tri_dly);
assign cha_tf_done_pos = cha_tf_done  & (~cha_tf_done_dly);

reg     tf_done_reg ;
always @(posedge mclk or posedge puc_rst)begin
    if(puc_rst == 1'b1)begin
        tf_done_reg <= 1'b0;
    end
    else begin
        if (cha_tf_done_pos == 1'b1) begin
            tf_done_reg <= 1'b1;
        end
        if (cha_tri_pos == 1'b1)begin
            tf_done_reg <= 1'b0;
        end
    end
end

// always @(posedge mclk or posedge puc_rst)begin
//     if(puc_rst == 1'b1)begin
//         tf_done_reg <= 1'b0;
//     end
//     else begin
//        if (cha_tf_done_pos | cha_tri_pos )  tf_done_reg <= ~tf_done_reg;
//     end
// end




//对dmaxtsel信号进行触发信号的归一化处理。
always@(posedge mclk or posedge puc_rst )begin
    if(puc_rst == 1'b1)begin
        dma0_tri <= 1'b0;
    end
    else begin
        case (DMA0TSELx)
            0000    : dma0_tri <= dma0req;
            default : dma0_tri <= 1'b0;
        endcase
    end
end


always@(posedge mclk or posedge puc_rst )begin
    if(puc_rst == 1'b1)begin
        dma1_tri  <= 1'b0;
    end
    else begin
        case(DMA1TSELx)
            0000    : dma1_tri <= dma1req;
            default : dma1_tri <= 1'b0;
        endcase
    end
end


always@(posedge mclk or posedge puc_rst)begin
    if(puc_rst == 1'b1)begin
        dma2_tri  <= 1'b0;
    end
    else begin
        case(DMA2TSELx)
            0000    : dma2_tri <= dma2req;
            default : dma2_tri <= 1'b0;
        endcase
    end
end

//状态机
//
always@(posedge mclk or posedge puc_rst )begin
    if(puc_rst == 1'b1)begin
        current_state <= IDLE;
    end
    else begin
        current_state <= next_state;
    end
end

//idle ： 是否是循环优先级，如果不是，那么判断通道0是否有触发信号，如果有，则进入状态CHA0
//当通道0无触发信号是，则判断通道1。类似直到通道2.如果通道2仍然没有触发信号，则留在本状态
//如果是循环优先级，则需要根据变量last_txf_cha判断上一次传输通道序号
//如果自从上一次复位以来没有传输，那么优先级为 0-1-2
//如果上一次通道为1，则优先级为2-0-1
//如果上一次通道为2，则优先级为0-1-2
//如果上一次通道为0，则优先级为1-2-0
always@(*)begin
    if(puc_rst == 1'b1)begin
        next_state <= IDLE;
    end
    else begin
 case(current_state)
            IDLE    :    begin
                if(ROUNDROBIN == 1'b0)begin
                    if(dma0_tri)begin
                        next_state <= CHA0;
                    end
                    else if(dma1_tri)begin
                        next_state <= CHA1;
                    end
                    else if(dma2_tri)begin
                        next_state <= CHA2;
                    end
                    else begin
                    end
                end
                else begin
                //2time
                    if(last_txf_cha == 3'b000)begin
                        if(dma0_tri)begin
                            next_state <= CHA0;
                        end
                        else if(dma1_tri)begin
                            next_state <= CHA1;
                        end
                        else if(dma2_tri)begin
                            next_state <= CHA2;
                        end
                        else begin
                        end
                    end
                    else if(last_txf_cha == 3'b001)begin
                        if(dma1_tri)begin
                            next_state <= CHA1;
                        end
                        else if(dma2_tri)begin
                            next_state <= CHA2;
                        end
                        else if(dma0_tri)begin
                            next_state <= CHA0;
                        end
                        else begin
                        end
                    end
                    else if(last_txf_cha == 3'b010)begin
                        if(dma2_tri)begin
                            next_state <= CHA2;
                        end
                        else if(dma0_tri)begin
                            next_state <= CHA0;
                        end
                        else if(dma1_tri)begin
                            next_state <= CHA1;
                        end
                        else begin
                        end
                    end
                    else if(last_txf_cha == 3'b100)begin
                        if(dma0_tri)begin
                            next_state <= CHA0;
                        end
                        else if(dma1_tri)begin
                            next_state <= CHA1;
                        end
                        else if(dma2_tri)begin
                            next_state <= CHA2;
                        end
                        else begin
                        end
                    end
                    else begin
                    end
                end
            end
            CHA0    :    next_state = (cha0_tf_done_sy == 1'b1) ? IDLE : CHA0;
            CHA1    :    next_state = (cha1_tf_done_sy == 1'b1) ? IDLE : CHA1;
            CHA2    :    next_state = (cha2_tf_done_sy == 1'b1) ? IDLE : CHA2;
            default :    next_state = IDLE;
        endcase
    end
end

always@(posedge mclk or posedge puc_rst )begin
    if(puc_rst == 1'b1)begin
        last_txf_cha <= 3'b0;
        cha0_tri     <= 1'b0;
        cha1_tri     <= 1'b0;
        cha2_tri     <= 1'b0;
    end
    else begin
        case(current_state)
            IDLE    :    begin
            end
            CHA0    :    begin
                last_txf_cha <= 3'b001;
                cha0_tri      = (cha0_tf_done_sy == 1'b1 ) ? 1'b0 : dma0_tri;
            end
            CHA1    :begin
                last_txf_cha <= 3'b010;
                cha1_tri      = (cha1_tf_done_sy == 1'b1 ) ? 1'b0 : dma1_tri;
            end
            CHA2    :begin
                last_txf_cha <= 3'b100;
                cha2_tri      = (cha2_tf_done_sy == 1'b1 ) ? 1'b0 : dma2_tri;
            end
            default : begin
            end
        endcase
    end
end






endmodule // dma_priority


