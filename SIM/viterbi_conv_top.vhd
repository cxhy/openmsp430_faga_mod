LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY viterbi_conv_top IS
PORT(
     clk : IN STD_LOGIC;
	 rst : IN STD_LOGIC;
	 trigger0 : IN STD_LOGIC;
	 trigger1 : IN STD_LOGIC;
	 code_ctrl : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	 code_ctrl_en : IN STD_LOGIC;
	 viterbi_long : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	 
	 decoder_buffer_dout : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	 decoder_buffer_dout_en : IN STD_LOGIC;
	 
	 encoder_buffer_din : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	 encoder_buffer_din_en : OUT STD_LOGIC;
	 code_sel_tri : OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE arch_top OF viterbi_conv_top IS

SIGNAL   viterbi_in_start : STD_LOGIC;
SIGNAL   viterbi_in_end : STD_LOGIC;
SIGNAL   viterbi_in_0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL   viterbi_in_1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL   viterbi_in_valid : STD_LOGIC;
SIGNAL   viterbi_out_begin : STD_LOGIC;
SIGNAL   viterbi_out : STD_LOGIC;
SIGNAL   viterbi_out_valid : STD_LOGIC;
SIGNAL   viterbi_out_end : STD_LOGIC;

SIGNAL   encode_start : STD_LOGIC;
SIGNAL   encode_end : STD_LOGIC;
SIGNAL   encode_in : STD_LOGIC;
SIGNAL   encode_in_en : STD_LOGIC;
SIGNAL   encode_out_begin : STD_LOGIC;
SIGNAL   encode_out_end : STD_LOGIC;
SIGNAL   encode_out : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL   encode_out_valid : STD_LOGIC;



COMPONENT fifo_ctl_in IS
PORT(
      clk                  : IN STD_LOGIC;
      rst                  : IN STD_LOGIC;
      per_decode_in        : IN STD_LOGIC_VECTOR(15 DOWNTO 0);--外设区解码数据，需要译码货解码的数据
      per_decode_in_valid  : IN STD_LOGIC;--有效信号，避免同一个数据多次有效，影响了解码的数据
      code_ctrl            : IN STD_LOGIC_VECTOR(15 DOWNTO 0);--viterbi模式或者encode模式，受软件控制
      code_ctrl_en         : IN STD_LOGIC;--当软件有配置的时候会有一个周期的高电平
	  trigger              : IN STD_LOGIC;--当DMA通道0开始触发的时候，从外设区固定地址下有解码数据输出时，这时候就要启动fifo控制器，向code模块输送数据
      transfer_long        : IN STD_LOGIC_VECTOR(15 DOWNTO 0);--code的大小，viterbi解码时，帧长度即为transfer_long，encode编码时帧长度为transfer_long+6
                 
      fifo_0_out0_begin    : OUT STD_LOGIC;--vitebri模块开始脉冲
      fifo_0_out0_end      : OUT STD_LOGIC;--viterbi模块结束脉冲
      fifo_0_out0_0        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);--viterbi模块数据
      fifo_0_out0_1        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);--viterbi模块数据
      fifo_0_out0_valid    : OUT STD_LOGIC;--viterbi模块数据有效
                         
	  fifo_0_out1_begin    : OUT STD_LOGIC;--encode模块开始脉冲
	  fifo_0_out1_end      : OUT STD_LOGIC;--encode模块结束脉冲
      fifo_0_out1          : OUT STD_LOGIC;--encode模块数据
      fifo_0_out1_en       : OUT STD_LOGIC--encode模块数据有效
  );
END COMPONENT;

COMPONENT fifo_ctl_out IS
PORT(
        clk                : IN STD_LOGIC;
		rst                : IN STD_LOGIC;
		code_ctrl          : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		code_ctrl_en       : IN STD_LOGIC;
		viterbi_out_begin  : IN STD_LOGIC;
		viterbi_out_end    : IN STD_LOGIC;
		encode_out_begin   : IN STD_LOGIC;
		encode_out_end     : IN STD_LOGIC;
		        
		viterbi_out        : IN STD_LOGIC;
		viterbi_out_valid  : IN STD_LOGIC;
		encode_out         : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		encode_out_valid   : IN STD_LOGIC;
		trigger0           : IN STD_LOGIC;
		trigger1           : IN STD_LOGIC;
		       
        code_sel_tri       : OUT STD_LOGIC;			   
		fifo_1_out         : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		fifo_1_out_valid   : OUT STD_LOGIC
   );
END COMPONENT;

COMPONENT viterbi_top IS 
PORT(
clk:IN STD_LOGIC; ---系统的时钟信号
rst:IN STD_LOGIC; ---系统的复位信号
viterbi_in_start : IN STD_LOGIC;
viterbi_in_end : IN STD_LOGIC;
viterbi_in_0:IN STD_LOGIC_VECTOR(3 DOWNTO 0);---系统的数据输入端口1
viterbi_in_1:IN STD_LOGIC_VECTOR(3 DOWNTO 0);---系统的数据输入端口2
viterbi_in_valid:IN STD_LOGIC;---数据的有效信号
viterbi_out_begin:OUT STD_LOGIC;
viterbi_out: OUT STD_LOGIC;---viterbi的译码结果
viterbi_out_valid:OUT STD_LOGIC;---输出信号的有效信号
viterbi_out_end:OUT STD_LOGIC
);
END COMPONENT;

COMPONENT conv_encode7 IS
PORT(
        clk : IN STD_LOGIC;
		  rst : IN STD_LOGIC;
		  encode_start : IN STD_LOGIC;
		  encode_end : IN STD_LOGIC;
		  encode_in : IN STD_LOGIC;
		  encode_in_en : IN STD_LOGIC;
		  encode_out_begin : OUT STD_LOGIC;
		  encode_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		  encode_out_valid : OUT STD_LOGIC;
		  encode_out_end : OUT STD_LOGIC
   );
END COMPONENT;
BEGIN

 fifo_ctl_0 : fifo_ctl_in 
 PORT MAP(                    
   clk                   => clk,
   rst                   => rst,
   per_decode_in         => decoder_buffer_dout,
   per_decode_in_valid   => decoder_buffer_dout_en,
   code_ctrl             => code_ctrl,
   code_ctrl_en          => code_ctrl_en,
   trigger               => trigger0,
   transfer_long         => viterbi_long,
                      
   fifo_0_out0_begin     => viterbi_in_start,
   fifo_0_out0_end       => viterbi_in_end,
   fifo_0_out0_0         => viterbi_in_0,
   fifo_0_out0_1         => viterbi_in_1,
   fifo_0_out0_valid     => viterbi_in_valid,
                         
   fifo_0_out1_begin     => encode_start,
   fifo_0_out1_end       => encode_end,
   fifo_0_out1           => encode_in,
   fifo_0_out1_en        => encode_in_en
   );	

   
fifo_ctl_1 : fifo_ctl_out 
PORT MAP(                 
   clk                   => clk,
   rst                   => rst,
   code_ctrl             => code_ctrl,
   code_ctrl_en          => code_ctrl_en,
   viterbi_out_begin     => viterbi_out_begin,
   viterbi_out_end       => viterbi_out_end,
   encode_out_begin      => encode_out_begin,
   encode_out_end        => encode_out_end,
                        
   viterbi_out           => viterbi_out,
   viterbi_out_valid     => viterbi_out_valid,
   encode_out            => encode_out,
   encode_out_valid      => encode_out_valid,
   trigger0              => trigger0,
   trigger1              => trigger1,
                         
   code_sel_tri          => code_sel_tri,   
   fifo_1_out            => encoder_buffer_din,
   fifo_1_out_valid      => encoder_buffer_din_en
   );
	

u_viterbi : viterbi_top 
PORT MAP(
   clk                 => clk,
   rst                 => rst,
   viterbi_in_start    => viterbi_in_start,
   viterbi_in_end      => viterbi_in_end,
   viterbi_in_0        => viterbi_in_0,
   viterbi_in_1        => viterbi_in_1,
   viterbi_in_valid    => viterbi_in_valid,
                      
   viterbi_out_begin   => viterbi_out_begin,
   viterbi_out         => viterbi_out,
   viterbi_out_valid   => viterbi_out_valid,
   viterbi_out_end     => viterbi_out_end
   );

u_conv_encode7 : conv_encode7
PORT MAP (
   clk                 => clk,
   rst                 => rst,
   encode_start        => encode_start,
   encode_end          => encode_end,
   encode_in           => encode_in,
   encode_in_en        => encode_in_en,
   encode_out_begin    => encode_out_begin,
   encode_out          => encode_out,
   encode_out_valid    => encode_out_valid,
   encode_out_end      => encode_out_end
   );
   
END arch_top;