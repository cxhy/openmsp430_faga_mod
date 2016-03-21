LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;


ENTITY fifo_ctl_out IS
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
   
END ENTITY;

ARCHITECTURE arch_fifo_out OF fifo_ctl_out IS
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

SIGNAL data_in : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL data_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL wr : STD_LOGIC;
SIGNAL rd : STD_LOGIC;
SIGNAL empty : STD_LOGIC;
SIGNAL full  : STD_LOGIC;

SIGNAl data_out_valid : STD_LOGIC;

SIGNAL viterbi_mod : STD_LOGIC;
SIGNAl encode_mod : STD_LOGIC;
SIGNAL i : INTEGER RANGE 0 TO 16;
SIGNAL k : INTEGER RANGE 0 TO 16;

SIGNAL trigger1_r : STD_LOGIC;
SIGNAL trigger1_pos : STD_LOGIC;


SIGNAL trigger1_flag : STD_LOGIC;

BEGIN
fifo_1 : fifo GENERIC MAP(
              wide => 15,
   			  long => 128
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

		  
PROCESS(clk,rst)
VARIABLE fifo_1_in_viterbi : STD_LOGIC_VECTOR(15 DOWNTO 0);
VARIABLE fifo_1_in_encode  : STD_LOGIC_VECTOR(15 DOWNTO 0);
-- VARIABLE i : INTEGER RANGE 0 TO 16;
VARIABLE x : INTEGER RANGE -2 TO 16;
VARIABLE j : INTEGER RANGE -1 TO 16;
BEGIN
IF(rst='0')THEN
   wr<='0';
   data_in<=(OTHERS=>'0');
   fifo_1_in_viterbi:=(OTHERS=>'0');
   fifo_1_in_encode:=(OTHERS=>'0');
   i<=0;
   k<=0;
ELSIF(clk 'EVENT AND clk='1')THEN
 IF(viterbi_mod='1')THEN
  IF(viterbi_out_end='0')THEN
    IF(viterbi_out_valid='1')THEN
	   -- FOR j IN 15 DOWNTO i LOOP
	      -- fifo_1_in_viterbi(j):='0';
	   -- END LOOP;
	   
	   j:=15;
	   clear_1:WHILE(j>=i)LOOP
		      fifo_1_in_viterbi(j):='0';
			  j:=j-1;
	   END LOOP;
	   
	   fifo_1_in_viterbi(i):=viterbi_out;
	   
       IF(i<15)THEN
         i<=i+1;
		 data_in<=(OTHERS=>'0');
	     wr<='0';
	   ELSE	   
		 i<=0;
		 data_in<=fifo_1_in_viterbi;
		 wr<='1';
	   END IF;  
    ELSE 
       wr<='0';
	   data_in<=(OTHERS=>'0');
    END IF;
  ELSE
    IF(i/=0)THEN
 	   wr<='1';
 	   data_in<=fifo_1_in_viterbi;
	   i<=0;
	ELSE
	   wr<='0';
 	   data_in<=(OTHERS=>'0');
	END IF;
  END IF;
 
  
 END IF;
 --------------------------------------------
 ---------------encode----------------------
 IF(encode_mod='1')THEN
    IF(encode_out_end='0')THEN
      IF(encode_out_valid='1')THEN
		 -- x:=16;
		 -- clear:WHILE(x>=k+2)LOOP
		      -- fifo_1_in_encode(x-1 DOWNTO x-2):=(OTHERS=>'0');
			  -- x:=x-2;
		 -- END LOOP;
		 
		 x:=14;
		 clear:WHILE(x>=k)LOOP
		      fifo_1_in_encode(x+1 DOWNTO x):=(OTHERS=>'0');
			  x:=x-2;
		 END LOOP;
		 
		 
		 fifo_1_in_encode(k+1 DOWNTO k):=encode_out;
		 
	     IF(k<14)THEN
	        k<=k+2;
		    wr<='0';
		    data_in<=(OTHERS=>'0');
	     ELSE
	        k<=0;
		    wr<='1';
		    data_in<=fifo_1_in_encode;
	     END IF;
	  ELSE
	   wr<='0';
	   data_in<=(OTHERS=>'0');
	  END IF;
	ELSE
	  IF(k/=0)THEN
	     wr<='1';
		 data_in<=fifo_1_in_encode;
	  ELSE
	     wr<='0';
 	     data_in<=(OTHERS=>'0');
	  END IF;
    END IF;
 END IF;
 
END IF;
END PROCESS;



--------------------------------------------------------------------------------
----------------------------------------------------------------------------
-- rd<=NOT(empty);  
---读fifo数据输出到外设区的内存单元，供dma数据搬运
--------------------------------------------------------
-----------来自经过优先级选择过后的通道1的触发信号，踩上升沿，
PROCESS(clk,rst)
BEGIN
IF(rst='0')THEN
  trigger1_r<='0';
  data_out_valid<='0';
ELSIF(clk 'EVENT AND clk='1')THEN
  trigger1_r<=trigger1;
  data_out_valid<=rd;
END IF;
END PROCESS;
trigger1_pos<=trigger1 AND (NOT trigger1_r);
---------------------------------------------------------
---------------------------------------------------------

--------------------------------------------------------
----因为encode模式和viterbi模式开始存储fifo中数据的时间点不同，通道1的触发出现的过早过着过晚，
----都会导致需要传送的数据不在dma传送的数据线上。
----所以通道1触发的时间点需要来自dma_master的触发信号和fifo中有数据这两者条件相互配合开始触发，才是合理的。

----我们操作通道1的触发时，必须需要在trigger1_pos为高脉冲之后，因为每次只能一个通道占用，
----如果当前通道没有触发脉冲的话，说明别的通道在占用，
----所以我们操作的触发信号必须在trigger1为高电平的某一段时间内触发。推迟或者单中的一段时间。

----encode模式由于encode时间较短，速度较快，在通道0传送的过程中已经解码完成，所有的数据就已经存入fifo中了，
----所以我们只需来自dma_master的通道1触发脉冲到来时，便可以开始读fifo，
----读到fifo中的数据直接就可以放到dma传送的数据线上，就可以被dma送走。

----viterbi模式由于decode时间较长，速度较慢，在通道0把所有的数据都传送完成之后，
-----dma_master已经这时候把通道1触发，这时就已经开始传送数据，
----但是此时dma传送的数据线上并没有来自viterbi的数据，因为此时的viterbi可能还未解码完成没有数据存放在fifo中，
----所以没发读出来数据这部分我们需要操作的就是，当来自dma_master的触发到来时，此时fifo中 并没有数据，
----需要等到viterbi_out_begin为高脉冲的时候fifo才有数据，
----这时候开始读fifo，读出的数据刚搞放到dma传送数据线上，所以我们要推迟通道1的触发，所以需要再输出一个
----经过操作多后的通道1脉冲给dma_master模块。

----由于两者模式的触发时间点不一样，所以有个选择赋值脉冲输出。

PROCESS(clk,rst)
VARIABLE rd_en : STD_LOGIC;
VARIABLE count : INTEGER RANGE 0 TO 16;
BEGIN
IF(rst='0')THEN
   rd_en:='0';
   rd<='0';
   count:=0;
ELSIF(clk 'EVENT AND clk='1')THEN
  IF(encode_mod='1')THEN
   IF(trigger1_pos='1')THEN--encode模式时需要来自dma_master的开始脉冲产生读信号
      rd_en:='1';
   END IF;
  END IF;
  
  IF(viterbi_mod='1')THEN---viterbi模式时需要来自viterbi数据译码结束时产生读信号
    IF(viterbi_out_end='1')THEN
	  rd_en:='1';
	END IF;
  END IF;
  
   IF(rd_en='1')THEN
     count:=count+1;---每8个周期读一次，因为需要将输出写入到外设区的内存单元，按照DMA取数的速度，需要8个周期更新一次新的数据
	 IF(count=8)THEN
	   count:=0;
	 END IF;
	 
     IF(count=2)THEN
       rd<='1';
	 ELSE
	   rd<='0';
	 END IF;
	 
	 IF(empty='1')THEN--fifo空就不需要再往外读了
	   rd<='0';
	   rd_en:='0';--空时，就停止读
	   count:=0;
	 END IF;
	  
   END IF;
  
   
END IF;
END PROCESS;

PROCESS(clk,rst)
BEGIN
IF(rst='0')THEN
   fifo_1_out<=(OTHERS=>'0');
   fifo_1_out_valid<='0';
ELSIF(clk 'EVENT AND clk='1')THEN
   fifo_1_out<=data_out;
   fifo_1_out_valid<=data_out_valid;
END IF;
END PROCESS;


PROCESS(clk,rst)
VARIABLE viterbi_end_flag : STD_LOGIC;
BEGIN
IF(rst='0')THEN
   viterbi_end_flag:='0';
   trigger1_flag<='0';
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_out_end='1')THEN
     viterbi_end_flag:='1';
   END IF;
   IF(trigger0='1')THEN
      viterbi_end_flag:='0';
   END IF;
   IF(trigger1='1' AND viterbi_end_flag='1')THEN
   ---当viterbi译码结束后，并且dma通道1还继续触发，则重新定义一个新的触发信号送给dma_master
      trigger1_flag<='1';
   ELSE
      trigger1_flag<='0';
   END IF;
END IF;
END PROCESS;

code_sel_tri<=trigger1 WHEN encode_mod='1' ELSE
              trigger1_flag WHEN viterbi_mod='1';

------------------------------------------------
------------------------------------------------		  

-----------------------------------------------------------------------------------
---------------------------------------------------------------------------------

END arch_fifo_out;