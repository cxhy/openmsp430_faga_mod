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
// *File Name: tb_openMSP430_fpga.v
//
// *Module Description:
//                      tb_openMSP430_fpga testbench
//
// *Author(s):
//              - Olivier Girard,    olgirard@gmail.com
//
//----------------------------------------------------------------------------
// $Rev: 205 $
// $LastChangedBy: olivier.girard $
// $LastChangedDate: 2015-07-15 22:59:52 +0200 (Wed, 15 Jul 2015) $
//----------------------------------------------------------------------------
`include "timescale.v"
`include "openMSP430_defines.v"
module  tb_openMSP430_fpga;

//
// Initialize Memory
//------------------------------
// integer            tb_idx;

// initial
  // begin
     ////Initialize data memory
     // for (tb_idx=0; tb_idx < `DMEM_SIZE/2; tb_idx=tb_idx+1)
       // dmem_0.mem[tb_idx] = 16'h0000;

     ////Initialize program memory
     // #10 $readmemh("./pmem.mem", pmem_0.mem);
  // end

wire         [7:0] p1_dout;
reg               uart_rxd;
wire               uart_txd;
//
// Generate Clock & Reset
//------------------------------
reg                dco_clk;
initial
  begin
     dco_clk          = 1'b0;
     forever
       begin
          // #25;   // 20 MHz
          #10;      // 50 Mhz
            dco_clk = ~dco_clk;
       end
  end

reg                lfxt_clk;
initial
  begin
     lfxt_clk          = 1'b0;
     forever
       begin
          #763;  // 655 kHz
            lfxt_clk = ~lfxt_clk;
       end
  end


reg reset_n;

parameter BPS9600   = 32'd104_167;      //104167ns= 5207 * 20  在50M时钟下面就是5207个clk上升沿 cnt = mclk/bps(50 000 000 /9600 = 5207) (100 000 000 / 9600 = 104167)
integer tx_bps;
integer rx_bps;
reg [7:0] cnt;
reg [7:0] data_temp;
reg rx_flag;
reg [7:0] tx_data;
print_task print();

initial
  begin
     reset_n       = 1'b1;
     #93;
     reset_n       = 1'b0;
     #593;
     reset_n       = 1'b1;

     uart_rxd = 1;
     #1000;


     rx_bps = BPS9600;
     tx_bps = BPS9600;
    for(cnt=0; cnt<255; cnt=cnt+1)begin
      tx_task(cnt);
      @(negedge rx_flag)begin
          if(data_temp == cnt)begin
              $write("order data transmit: %d,receive:%d;OK\n",cnt,data_temp);
          end
          else begin
              $write("order data transmit: %d,receive:%d;error\n",cnt,data_temp);
              print.error("false");
          end
      end
    end
    #1000
    for(cnt=0; cnt<255; cnt=cnt+1)begin
        tx_data = {$random};
        tx_task(tx_data);
        @(negedge rx_flag)begin
            if(data_temp == tx_data)begin
                $write("random data transmit: %d,receive:%d;OK\n",cnt,data_temp);
            end
            else begin
                $write("random data transmit: %d,receive:%d;error\n",cnt,data_temp);
                print.error("false");
            end
        end
    end
    print.terminate;
  end

task tx_task;
    input [7:0] txdata;
    integer i;
    begin
        uart_rxd = 0;
        #tx_bps;
        for (i = 0; i < 8; i = i + 1) begin
            uart_rxd = txdata[7-i];
            #tx_bps;
        end
        uart_rxd = 1;
        #tx_bps;
    end
endtask

integer j;
always@(negedge uart_txd)begin
    #(tx_bps/2);
    if(uart_txd == 0)begin
        rx_flag = 1;
        #tx_bps;
        for (j = 0; j < 8; j = j + 1) begin
            data_temp[7-j] = uart_txd;
            #tx_bps;
        end
        rx_flag = 0;
    end
end

openMSP430_fpga msp430(
      .dco_clk     (dco_clk),
      .lfxt_clk    (lfxt_clk),
      .reset_n     (reset_n),
      .uart_rxd    (uart_rxd),
      .uart_txd    (uart_txd),
      .p1_dout     (p1_dout)
);




endmodule
