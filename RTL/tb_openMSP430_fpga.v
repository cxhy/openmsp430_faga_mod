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
`include "../RTL/openmsp430/openMSP430_defines.v"
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
//
// Generate Clock & Reset
//------------------------------
reg                dco_clk;
initial
  begin
     dco_clk          = 1'b0;
     forever
       begin
          #25;   // 20 MHz
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
initial
  begin
     reset_n       = 1'b1;
     #93;
     reset_n       = 1'b0;
     #593;
     reset_n       = 1'b1;
  end


openMSP430_fpga msp430(
      .dco_clk     (dco_clk),
	  .lfxt_clk    (lfxt_clk),
	  .reset_n     (reset_n),
	  .p1_dout     (p1_dout)
);



endmodule
