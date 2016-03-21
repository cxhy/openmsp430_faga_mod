LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY fifo_ctl_in IS
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
END ENTITY;

ARCHITECTURE arch_fifo_in OF fifo_ctl_in IS
COMPONENT fifo IS
  GENERIC(
       wide : INTEGER;
	   long : INTEGER
  );
  PORT(
       clk : IN STD_LOGIC;
	   rst : IN STD_LOGIC;
	   wr  : IN STD_LOGIC;
	   rd  : IN STD_LOGIC;
	   data_in : IN STD_LOGIC_VECTOR(wide DOWNTO 0);
	   empty : OUT STD_LOGIC;
	   full  : OUT STD_LOGIC;
	   data_out : OUT STD_LOGIC_VECTOR(wide DOWNTO 0)
  );
END COMPONENT;

SIGNAL data_in : STD_LOGIC_VECTOR(7 DOWNTO 0);--fifo的输入数据
SIGNAL data_out : STD_LOGIC_VECTOR(7 DOWNTO 0);--fifo的输出数据
SIGNAL wr : STD_LOGIC;--fifo的写使能
SIGNAL rd : STD_LOGIC;--fifo的读使能
SIGNAL empty : STD_LOGIC;--fifo空标志
SIGNAL full  : STD_LOGIC;--fifo满标志
SIGNAL data_out_valid : STD_LOGIC;--fifo输出数据有效
SIGNAL trigger_r : STD_LOGIC;--为了踩trigger上升沿
SIGNAL trigger_pos : STD_LOGIC;--踩trigger上升沿
SIGNAL per_in_valid_r : STD_LOGIC;--解码外设区每个数据只需一个周期的高电平有效就可以了，所以踩上升沿
SIGNAL per_in_valid_pos : STD_LOGIC;
SIGNAL encode_mod : STD_LOGIC;--encode模式标志位
SIGNAL viterbi_mod : STD_LOGIC;--viterbi模式标志位

SIGNAL viterbi_long : INTEGER RANGE -1 TO 2048;
-- SIGNAL viterbi_long : INTEGER ;
SIGNAL encode_long : INTEGER RANGE -1 TO 2048;
-- SIGNAL encode_long : INTEGER;
SIGNAL flag_viterbi : STD_LOGIC;--当viterbi开始脉冲触发后，viterbi一直有效工作的标志位
SIGNAL viterbi_valid_begin : STD_LOGIC;--viterbi开始脉冲寄存器
SIGNAL viterbi_valid_end : STD_LOGIC;--viterbi结束脉冲寄存器


SIGNAL flag_encode : STD_LOGIC;--当encode开始脉冲触发后，viterbi一直有效工作的标志位
SIGNAL encode_valid_begin : STD_LOGIC;--encode开始脉冲寄存器
SIGNAL encode_valid_end : STD_LOGIC;--encode结束脉冲寄存器
SIGNAL encode_valid_end_r : STD_LOGIC;--为满足时序结束脉冲临时延时寄存器
SIGNAL i : INTEGER RANGE 0 TO 8;
SIGNAL data_8b : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAl data_8b_en : STD_LOGIC;
SIGNAL fifo_out : STD_LOGIC;--encode数据输出
SIGNAL fifo_out_en : STD_LOGIC;--encode数据输出使能

-- SIGNAL data_out_valid_r : STD_LOGIC;


BEGIN
fifo_0 : fifo GENERIC MAP(
              wide => 7,
			  long => 7
          )
          PORT MAP(
		      clk => clk,
	          rst => rst,
	          wr  => wr,
	          rd  => rd,
	          data_in => data_in,
	          empty => empty,
	          full  => full,
	          data_out => data_out
		  );
---------------------------------------------------------------------------
------------------每个有效数据取一个周期的上升沿有效-----------------------
PROCESS(clk,rst)
BEGIN
IF(rst='0')THEN
   per_in_valid_r<='0';
ELSIF(clk 'EVENT AND clk='1')THEN
   per_in_valid_r<=per_decode_in_valid;
END IF;
END PROCESS;
per_in_valid_pos<=per_decode_in_valid AND (NOT per_in_valid_r);	 

---------------------------------------------------------------------------
------------------fifo 8bit 写入数据，先写低8位，后写高8位----------------- 
PROCESS(clk,rst)
VARIABLE count : STD_LOGIC:='0';
BEGIN
IF(rst='0')THEN
  count:='0';
  data_in<=(OTHERS=>'0');
  wr<='0';
ELSIF(clk 'EVENT AND clk='1')THEN
  IF(per_in_valid_pos='1')THEN
    count:=NOT(count);
    IF(count='1')THEN
	  data_in(7 DOWNTO 0)<=per_decode_in(7 DOWNTO 0);
	  wr<='1';
	ELSE
	  data_in(7 DOWNTO 0)<=per_decode_in(15 DOWNTO 8);
	  wr<='1';
	END IF;
  ELSE
    wr<='0';
  END IF;
  
  IF(viterbi_valid_end='1' OR encode_valid_end='1')THEN
     count:='0';
  END IF;
  
END IF;
END PROCESS;


------------------------------------------------------------
----------------译码或者编码模式选择------------------------
PROCESS(clk,rst)
BEGIN
IF(rst='0')THEN
   encode_mod<='0'; 
   viterbi_mod<='0';
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(code_ctrl_en='1')THEN
     IF(code_ctrl="0000000000000001")THEN
        viterbi_mod<='1';
	    encode_mod<='0';
     ELSIF(code_ctrl="0000000000000000")THEN
        encode_mod<='1';
	    viterbi_mod<='0';
     ELSE
        encode_mod<='0'; 
	    viterbi_mod<='0'; 
     END IF;  
   END IF;
END IF;
END PROCESS;
-----------------------------------------------------------
-----------不空则读----------------------------------------
rd<=NOT(empty);
---------------------------------------------------------------------------------------
---------读后一个周期就是数据输出有效标志位，对帧信号起始位进行一个周期的上升沿采集----
PROCESS(clk,rst)
BEGIN
IF(rst='0')THEN
  data_out_valid<='0';
  trigger_r<='0';
ELSIF(clk 'EVENT AND clk='1')THEN
  data_out_valid<=rd;
  trigger_r<=trigger;
END IF;
END PROCESS;
trigger_pos<=trigger AND (NOT trigger_r);



-------------------------------------------------------------------------------------------------------------
--------输出给viterbi输入的接口处理，由输入开始脉冲和帧信号长度，控制viterbi的开始脉冲、数据信号(4bit)和结束脉冲---
PROCESS(clk,rst)
-- VARIABLE viterbi_long : INTEGER RANGE 0 TO 2049;
BEGIN
IF(rst='0')THEN
  flag_viterbi<='0';
  viterbi_valid_begin<='0';
  viterbi_valid_end<='0';
  viterbi_long<=0;
ELSIF(clk 'EVENT AND clk='1')THEN
  IF(viterbi_mod='1')THEN
    IF(trigger_pos='1')THEN
       flag_viterbi<='1';
	   viterbi_valid_begin<='1';
 	   viterbi_valid_end<='0';
	   viterbi_long<=conv_integer(transfer_long)-1;
	ELSE 
	   viterbi_valid_begin<='0';
    END IF;
    
    IF(flag_viterbi='1' AND viterbi_valid_end='0')THEN
      IF(data_out_valid='1')THEN
 	   viterbi_long<=viterbi_long-1;
        IF(viterbi_long=0)THEN
 		 viterbi_valid_end<='1';
 		 flag_viterbi<='0';
 	    END IF;
 	  END IF;
    ELSE
       viterbi_valid_end<='0';
    END IF;
  ELSE
     flag_viterbi<='0';
     viterbi_valid_end<='0';
     viterbi_long<=0;
  END IF;
END IF;
END PROCESS;

PROCESS(clk,rst)
BEGIN
IF(rst='0')THEN
  fifo_0_out0_end<='0';
  fifo_0_out0_begin<='0';
ELSIF(clk 'EVENT AND clk='1')THEN
  IF(viterbi_mod='1')THEN
     fifo_0_out0_begin<=viterbi_valid_begin;
     fifo_0_out0_end<=viterbi_valid_end;
  ELSE
     fifo_0_out0_end<='0';
     fifo_0_out0_begin<='0';
  END IF;
END IF;
END PROCESS;

PROCESS(clk,rst)
BEGIN
IF(rst='0')THEN
  fifo_0_out0_0<=(OTHERS=>'0');
  fifo_0_out0_1<=(OTHERS=>'0');
  fifo_0_out0_valid<='0';
  
ELSIF(clk 'EVENT AND clk='1')THEN
  IF(viterbi_mod='1')THEN
    IF(flag_viterbi='1' AND viterbi_valid_end='0')THEN
      IF(data_out_valid='1')THEN
        fifo_0_out0_0<=data_out(7 DOWNTO 4);
	    fifo_0_out0_1<=data_out(3 DOWNTO 0);
	    fifo_0_out0_valid<='1';
	  ELSE
	    fifo_0_out0_valid<='0';
      END IF;
	ELSE
	  fifo_0_out0_0<=(OTHERS=>'0');
      fifo_0_out0_1<=(OTHERS=>'0');
      fifo_0_out0_valid<='0';
	  
	END IF;
  END IF;
END IF;
END PROCESS;
---------------------------------------------------------------
---------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------
-------输出给encode模块输入的接口处理，由输入开始脉冲和帧信号长度，控制encode的开始脉冲、数据信号(1bit)和结束脉冲--------------------
PROCESS(clk,rst)
-- VARIABLE encode_long : INTEGER RANGE 0 TO 2049;
VARIABLE flag : STD_LOGIC;
BEGIN
IF(rst='0')THEN
  flag_encode<='0';
  encode_valid_begin<='0';
  encode_valid_end<='0';
  i<=0;
  data_8b<=(OTHERS=>'0');
  data_8b_en<='0';
  fifo_out<='0';
  fifo_out_en<='0';
  encode_long<=40;
  flag:='0';
  -- data_out_valid_r<='0';
ELSIF(clk 'EVENT AND clk='1')THEN
  IF(encode_mod='1')THEN
     IF(trigger_pos='1')THEN
	    flag_encode<='1';
		encode_valid_begin<='1';
		encode_valid_end<='0';
		i<=0;
		data_8b<=(OTHERS=>'0');
		data_8b_en<='0';
		fifo_out<='0';
		fifo_out_en<='0';
		encode_long<=conv_integer(transfer_long)-1;
		flag:='0';
	 ELSE
	    encode_valid_begin<='0';
	 END IF;
	 
	 -- data_out_valid_r<=data_out_valid;
	 IF(flag_encode='1' AND encode_valid_end='0')THEN
	   flag:='1';
       IF(data_out_valid='1')THEN
         data_8b<=data_out;
	     data_8b_en<='1';
	   END IF;
	   
	   IF(encode_long=0)THEN
	      encode_valid_end<='1';
		  flag_encode<='0';
	   END IF;
	   
	   IF(data_8b_en='1')THEN
	     fifo_out<=data_8b(i);
		 i<=i+1;
	     fifo_out_en<='1';
		 encode_long<=encode_long-1;
		 IF(encode_long=0)THEN
		    encode_long<=40;
			data_8b_en<='0';
			i<=0;
		 ELSE
		   IF(i=7)THEN
	         i<=0;
			 IF(data_out_valid='0')THEN
		       data_8b_en<='0';
			 END IF;
	       END IF;
		 END IF;
	   END IF;
	 ELSE
	    encode_valid_end<='0';
	    fifo_out_en<='0';
	    fifo_out<='0';
	 END IF;
  ELSE
     encode_long<=0;
	 flag_encode<='0';
	 encode_valid_end<='0';
	 data_8b_en<='0';
	 flag:='0';
  END IF;
END IF;
END PROCESS;

PROCESS(clk,rst)
BEGIN
IF(rst='0')THEN
  fifo_0_out1_begin<='0';
  fifo_0_out1_end<='0';
  fifo_0_out1<='0';
  fifo_0_out1_en<='0';
  encode_valid_end_r<='0';
ELSIF(clk 'EVENT AND clk='1')THEN
  IF(encode_mod='1')THEN
	 encode_valid_end_r<=encode_valid_end;
	 fifo_0_out1_begin<=encode_valid_begin;
	 fifo_0_out1_end<=encode_valid_end_r;
     fifo_0_out1<=fifo_out;
	 fifo_0_out1_en<=fifo_out_en;	 
  ELSE
    fifo_0_out1_begin<='0';
    fifo_0_out1_end<='0';
	fifo_0_out1<='0';
    fifo_0_out1_en<='0';
	encode_valid_end_r<='0';
  END IF;
END IF;
END PROCESS;

-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------

END arch_fifo_in;