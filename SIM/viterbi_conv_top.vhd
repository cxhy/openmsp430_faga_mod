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
      per_decode_in        : IN STD_LOGIC_VECTOR(15 DOWNTO 0);--�������������ݣ���Ҫ��������������
      per_decode_in_valid  : IN STD_LOGIC;--��Ч�źţ�����ͬһ�����ݶ����Ч��Ӱ���˽��������
      code_ctrl            : IN STD_LOGIC_VECTOR(15 DOWNTO 0);--viterbiģʽ����encodeģʽ�����������
      code_ctrl_en         : IN STD_LOGIC;--����������õ�ʱ�����һ�����ڵĸߵ�ƽ
	  trigger              : IN STD_LOGIC;--��DMAͨ��0��ʼ������ʱ�򣬴��������̶���ַ���н����������ʱ����ʱ���Ҫ����fifo����������codeģ����������
      transfer_long        : IN STD_LOGIC_VECTOR(15 DOWNTO 0);--code�Ĵ�С��viterbi����ʱ��֡���ȼ�Ϊtransfer_long��encode����ʱ֡����Ϊtransfer_long+6
                 
      fifo_0_out0_begin    : OUT STD_LOGIC;--vitebriģ�鿪ʼ����
      fifo_0_out0_end      : OUT STD_LOGIC;--viterbiģ���������
      fifo_0_out0_0        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);--viterbiģ������
      fifo_0_out0_1        : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);--viterbiģ������
      fifo_0_out0_valid    : OUT STD_LOGIC;--viterbiģ��������Ч
                         
	  fifo_0_out1_begin    : OUT STD_LOGIC;--encodeģ�鿪ʼ����
	  fifo_0_out1_end      : OUT STD_LOGIC;--encodeģ���������
      fifo_0_out1          : OUT STD_LOGIC;--encodeģ������
      fifo_0_out1_en       : OUT STD_LOGIC--encodeģ��������Ч
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
clk:IN STD_LOGIC; ---ϵͳ��ʱ���ź�
rst:IN STD_LOGIC; ---ϵͳ�ĸ�λ�ź�
viterbi_in_start : IN STD_LOGIC;
viterbi_in_end : IN STD_LOGIC;
viterbi_in_0:IN STD_LOGIC_VECTOR(3 DOWNTO 0);---ϵͳ����������˿�1
viterbi_in_1:IN STD_LOGIC_VECTOR(3 DOWNTO 0);---ϵͳ����������˿�2
viterbi_in_valid:IN STD_LOGIC;---���ݵ���Ч�ź�
viterbi_out_begin:OUT STD_LOGIC;
viterbi_out: OUT STD_LOGIC;---viterbi��������
viterbi_out_valid:OUT STD_LOGIC;---����źŵ���Ч�ź�
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