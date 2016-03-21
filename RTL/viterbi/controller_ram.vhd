--------------------------------------------------------
--------------------------------------------------------
--此模块包含了对4块RAM的读写过程的控制过程，实现4块RAM采用一次流水线
--的数据处理的能力，这样的操作减少存储和读取数据过程的时间，最大程度的
--提高数据的处理速度，4块ram位32*64的双口RAM
--------------------------------------------------------
--------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY controller_ram IS
PORT(
clk:IN STD_LOGIC;
rst:IN STD_LOGIC;
mmu_begin : IN STD_LOGIC;
mmu_en:IN STD_LOGIC;--模块的使能信号以及acs输入的有效数据位
mmu_in:IN STD_LOGIC_VECTOR(63 DOWNTO 0);---acs模块数据的额输入端
mmu_end:IN STD_LOGIC;
mmu_ram_1:OUT STD_LOGIC_VECTOR(63 DOWNTO 0);--RAM数据的数据输出端
mmu_ram_2:OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
mmu_ram_3:OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
mmu_ram_4:OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
mmu_addr_1_in:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);--RAM写操作的地址
mmu_addr_2_in:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
mmu_addr_3_in:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
mmu_addr_4_in:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
mmu_addr_1_out:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);--RAM读操作的地址
mmu_addr_2_out:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
mmu_addr_3_out:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
mmu_addr_4_out:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
mmu_ram_wr_1:OUT STD_LOGIC;--RAM的读写控制位
mmu_ram_wr_2:OUT STD_LOGIC;
mmu_ram_wr_3:OUT STD_LOGIC;
mmu_ram_wr_4:OUT STD_LOGIC;
mmu_out_begin : OUT STD_LOGIC;
mmu_out_end : OUT STD_LOGIC;
mmu_out_1_valid: OUT STD_LOGIC;--RAM的数据输出的有效位
mmu_out_2_valid: OUT STD_LOGIC;
mmu_out_3_valid: OUT STD_LOGIC;
mmu_out_4_valid: OUT STD_LOGIC
); 

END ENTITY;

ARCHITECTURE Behavioral OF controller_ram IS
SIGNAL counter:INTEGER;
SIGNAL cnt:INTEGER;
SIGNAL addr_1:STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL addr_2:STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL addr_3:STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL addr_4:STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL addr_1_t:STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL addr_2_t:STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL addr_3_t:STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL addr_4_t:STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL trace_sig:STD_LOGIC;
SIGNAL data_valid:STD_LOGIC_VECTOR(127 DOWNTO 0);
SIGNAL out_1_valid:STD_LOGIC;
SIGNAL out_2_valid:STD_LOGIC;
SIGNAL out_3_valid:STD_LOGIC;
SIGNAL out_4_valid:STD_LOGIC;
SIGNAL out_1_valid_t:STD_LOGIC;
SIGNAL out_2_valid_t:STD_LOGIC;
SIGNAL out_3_valid_t:STD_LOGIC;
SIGNAL out_4_valid_t:STD_LOGIC;

SIGNAL counter_h_level : STD_LOGIC;

SIGNAL mmu_out_end_r1 : STD_LOGIC;
SIGNAL mmu_out_end_r2 : STD_LOGIC;
SIGNAL mmu_out_end_r3 : STD_LOGIC;
SIGNAL mmu_out_end_r4 : STD_LOGIC;

SIGNAL  mmu_out_endpos : STD_LOGIC;

-- SIGNAL  mmu_out_beginpos : STD_LOGIC;
SIGNAL mmu_out_begin_r1 : STD_LOGIC;
SIGNAL mmu_out_begin_r2 : STD_LOGIC;
BEGIN   
-------------------------------------------------
--Out_valid进程，对4块ram的输出信号的有效位的控制
-------------------------------------------------
Out_valid:PROCESS(clk,rst)
BEGIN
 IF(rst='0')THEN
  mmu_out_1_valid<='0';
  mmu_out_2_valid<='0';
  mmu_out_3_valid<='0';
  mmu_out_4_valid<='0';
 ELSIF(clk'EVENT AND clk='1')THEN
        mmu_out_1_valid<=out_1_valid_t OR out_1_valid;
		  mmu_out_2_valid<=out_2_valid_t OR out_2_valid;
		  mmu_out_3_valid<=out_3_valid_t OR out_3_valid;
		  mmu_out_4_valid<=out_4_valid_t OR out_4_valid;
 END IF;
END PROCESS;
------------------------------------------------------
--Write_Read_process进程，主要是控制4块ram依次的写入操作和
--4块ram的流水线依次读出操作。
------------------------------------------------------
Write_Read_process:PROCESS(clk,rst)-----RAM的写操作进程
VARIABLE flag_mmu : STD_LOGIC;
BEGIN
 IF(rst='0')THEN
  counter<=0;
  addr_1<="00000";---写地址的初始值位0
  addr_2<="00000";
  addr_3<="00000";
  addr_4<="00000";
  addr_1_t<="11111";---读地址的初始值位31，
  addr_2_t<="11111";
  addr_3_t<="11111";
  addr_4_t<="11111";
  data_valid<=(OTHERS=>'0');
  cnt<=0;
  out_1_valid<='0';
  out_2_valid<='0';
  out_3_valid<='0';
  out_4_valid<='0';
  out_1_valid_t<='0';
  out_2_valid_t<='0';
  out_3_valid_t<='0';
  out_4_valid_t<='0';
  trace_sig<='0';
  flag_mmu:='0';
  mmu_out_end_r1<='0';
  counter_h_level<='0';
  
  mmu_ram_1<=(OTHERS=>'0');
  mmu_ram_2<=(OTHERS=>'0');
  mmu_ram_3<=(OTHERS=>'0');
  mmu_ram_4<=(OTHERS=>'0');
  mmu_addr_1_in<=(OTHERS=>'0');
  mmu_addr_2_in<=(OTHERS=>'0');
  mmu_addr_3_in<=(OTHERS=>'0');
  mmu_addr_4_in<=(OTHERS=>'0');
  mmu_addr_1_out<=(OTHERS=>'1');
  mmu_addr_2_out<=(OTHERS=>'1');
  mmu_addr_3_out<=(OTHERS=>'1');
  mmu_addr_4_out<=(OTHERS=>'1');
  mmu_ram_wr_1<='0';
  mmu_ram_wr_2<='0';
  mmu_ram_wr_3<='0';
  mmu_ram_wr_4<='0';
  
  mmu_out_begin_r1<='0';
 ELSIF(clk'EVENT AND clk='1')THEN
   IF(mmu_begin='1')THEN
      counter<=0;
      addr_1<="00000";---写地址的初始值位0
      addr_2<="00000";
      addr_3<="00000";
      addr_4<="00000";
      addr_1_t<="11111";---读地址的初始值位31，
      addr_2_t<="11111";
      addr_3_t<="11111";
      addr_4_t<="11111";
      data_valid<=(OTHERS=>'0');
      cnt<=0;
      out_1_valid<='0';
      out_2_valid<='0';
      out_3_valid<='0';
      out_4_valid<='0';
      out_1_valid_t<='0';
      out_2_valid_t<='0';
      out_3_valid_t<='0';
      out_4_valid_t<='0';
      trace_sig<='0';
	  flag_mmu:='0';
	  mmu_out_end_r1<='0';
	  counter_h_level<='0';
	  
	  mmu_ram_1<=(OTHERS=>'0');
      mmu_ram_2<=(OTHERS=>'0');
      mmu_ram_3<=(OTHERS=>'0');
      mmu_ram_4<=(OTHERS=>'0');
      mmu_addr_1_in<=(OTHERS=>'0');
      mmu_addr_2_in<=(OTHERS=>'0');
      mmu_addr_3_in<=(OTHERS=>'0');
      mmu_addr_4_in<=(OTHERS=>'0');
      mmu_addr_1_out<=(OTHERS=>'1');
      mmu_addr_2_out<=(OTHERS=>'1');
      mmu_addr_3_out<=(OTHERS=>'1');
      mmu_addr_4_out<=(OTHERS=>'1');
      mmu_ram_wr_1<='0';
      mmu_ram_wr_2<='0';
      mmu_ram_wr_3<='0';
      mmu_ram_wr_4<='0';
	  
	  mmu_out_begin_r1<='0';
   END IF;
   IF(mmu_end='1')THEN
      flag_mmu:='1';
   END IF;
 
   IF(mmu_en='1')THEN------使能信号有效时，开始有数据的写入
      counter_h_level<='1';
	  trace_sig<='1';------回溯的开始信号
     IF(counter=223)THEN----开始计算，为了方便操作数据的存放的RAm和对应的地址
	     counter<=96;
	  ELSE
	     counter<=counter+1;
	  END IF;
	  IF(counter>127)THEN----存储有效信号的标示
		   data_valid(counter-128)<='1';
	  ELSE
		   data_valid(counter)<='1';
	  END IF;
		 --------------------------
		 --开始存放数据，
		 --------------------------
	  IF(counter<=31)THEN  
						 mmu_ram_wr_1<='1';
						 mmu_addr_1_in<=addr_1;
		             mmu_ram_1<=mmu_in;
					    addr_1<=addr_1+'1';
						 cnt<=127-counter;
	  ELSIF(counter>31 AND counter<=63)THEN  
						 mmu_ram_wr_2<='1';
						 mmu_addr_2_in<=addr_2;
						 mmu_ram_2<=mmu_in;
						 addr_2<=addr_2+'1';
						 cnt<=127-counter;
	  ELSIF(counter>63 AND counter<=95)THEN
						 mmu_ram_wr_3<='1';
						 mmu_addr_3_in<=addr_3;
						 mmu_ram_3<=mmu_in;
						 addr_3<=addr_3+'1';
						 cnt<=159-counter;
	  ELSIF(counter>95 AND counter<=127)THEN
					    addr_4<=addr_4+'1';
						 mmu_ram_wr_4<='1';
						 mmu_addr_4_in<=addr_4;
						 mmu_ram_4<=mmu_in;
						 cnt<=191-counter;---------------------
	  ELSIF(counter>127 AND counter<=159)THEN
						 mmu_ram_wr_1<='1';
						 mmu_addr_1_in<=addr_1;
		             mmu_ram_1<=mmu_in;
					    addr_1<=addr_1+'1';
						 cnt<=223-counter;
	  ELSIF(counter>159 AND counter<=191)THEN
						 mmu_ram_wr_2<='1';
						 mmu_addr_2_in<=addr_2;
						 mmu_ram_2<=mmu_in;
						 addr_2<=addr_2+'1';
						 cnt<=255-counter;
	  ELSIF(counter>191 AND counter<=223)THEN
						 mmu_ram_wr_3<='1';
						 mmu_addr_3_in<=addr_3;
						 mmu_ram_3<=mmu_in;
						 addr_3<=addr_3+'1';
						 cnt<=287-counter;
	  END IF;
	ELSE
	   IF(flag_mmu='0')THEN
	      counter_h_level<='0';
	   END IF;
	END IF;
	  ------------------------------------------
       --数据存储结束的回溯处理
	  ------------------------------------------
	IF(flag_mmu='1' AND trace_sig='1')THEN--数据存储结束时，开始读取出剩余的数据
	        
			IF(cnt>1)THEN--读取数据的结束控制-----------------------
			   cnt<=cnt-1;
				IF(counter=223)THEN---计数没有停止，依然计数，以便将存入ram的数据全部按要求取出
				 counter<=96;
				ELSE
				 counter<=counter+1;
				END IF;
				IF(counter>127)THEN----为了数据的正确读出，存储结束后，不写入数据，但数据的有效位依次开始为0，
				  data_valid(counter-128)<='0';-----
				ELSE
				  data_valid(counter)<='0';------
				END IF; 
			    counter_h_level<='1';
			ELSE
			  out_1_valid<='0';
			  out_2_valid<='0';
			  out_3_valid<='0';
			  out_4_valid<='0';
			  out_1_valid_t<='0';
			  out_2_valid_t<='0';
			  out_3_valid_t<='0';
			  out_4_valid_t<='0';
			  counter<=0;
			  counter_h_level<='0';
			  mmu_out_end_r1<='1';
			END IF;
    END IF;
-- END IF;
---------------------------------------------------
--回溯1部分
---------------------------------------------------
   IF(counter_h_level='1')THEN
	 IF((counter>63 AND counter<=95)OR(counter>191 AND counter<=223))THEN---数据存储64个时开始回溯RAM-2
	      IF(data_valid(conv_integer(addr_2_t)+32)='1')THEN
		    mmu_out_begin_r1<='1';
			   mmu_ram_wr_2<='0';
		      mmu_addr_2_out<=addr_2_t;
				out_2_valid<='1';
			ELSE
			   out_2_valid<='0';
			END IF;
	       addr_2_t<=addr_2_t-'1';
	 ELSE
	         out_2_valid<='0';
	 END IF;		
	 
	 IF(counter>95 AND counter<=127)THEN ---开始回溯RAM-1
	      IF(data_valid(conv_integer(addr_1_t))='1')THEN
			   mmu_ram_wr_1<='0';
		      mmu_addr_1_out<=addr_1_t;
				out_1_valid<='1';
			ELSE
			   out_1_valid<='0';
			END IF;
	       addr_1_t<=addr_1_t-'1';
	 ELSE
	         out_1_valid<='0';
	 END IF;	
	 
	 IF(counter>127 AND counter<=159)THEN --数据存储128个时开始回溯RAM-4
	      IF(data_valid(conv_integer(addr_4_t)+96)='1')THEN
			   mmu_ram_wr_4<='0';
		      mmu_addr_4_out<=addr_4_t;
				out_4_valid<='1';
			ELSE
			   out_4_valid<='0';
			END IF;
	       addr_4_t<=addr_4_t-'1';
	 ELSE
	         out_4_valid<='0';
	 END IF;	 
	 
	 IF(counter>159 AND counter<=191)THEN ---开始回溯RAM-3
	      IF(data_valid(conv_integer(addr_3_t)+64)='1')THEN
			   mmu_ram_wr_3<='0';
		      mmu_addr_3_out<=addr_3_t;
				out_3_valid<='1';		
			ELSE
			   out_3_valid<='0';
			END IF;
	       addr_3_t<=addr_3_t-'1';
	 ELSE
	         out_3_valid<='0';
	 END IF;
	 

---------------------------------------------------------
--回溯2部分，
---------------------------------------------------------
	 IF(counter>95 AND counter<=127)THEN ---开始回溯RAM-3
	      IF(data_valid(conv_integer(addr_3_t)+64)='1')THEN
			   mmu_ram_wr_3<='0';
		      mmu_addr_3_out<=addr_3_t;
				out_3_valid_t<='1';
			ELSE
			   out_3_valid_t<='0';
			END IF;
	         addr_3_t<=addr_3_t-'1';
	 ELSE
	         out_3_valid_t<='0';
	 END IF;	
	 
	 IF(counter>127 AND counter<=159)THEN ---开始回溯RAM-2
	      IF(data_valid(conv_integer(addr_2_t)+32)='1')THEN
			   mmu_ram_wr_2<='0';
		      mmu_addr_2_out<=addr_2_t;
				out_2_valid_t<='1';
			ELSE
			   out_2_valid_t<='0';
			END IF;
	         addr_2_t<=addr_2_t-'1';
	 ELSE
	        out_2_valid_t<='0';
	 END IF;	 
	 IF(counter>159 AND counter<=191)THEN ---开始回溯RAM-1
	      IF(data_valid(conv_integer(addr_1_t))='1')THEN
			   mmu_ram_wr_1<='0';
		      mmu_addr_1_out<=addr_1_t;
				out_1_valid_t<='1';	
			ELSE
			   out_1_valid_t<='0';
			END IF;
	         addr_1_t<=addr_1_t-'1';
	 ELSE
	         out_1_valid_t<='0';
	 END IF;	
	 
	 IF(counter>191 AND counter<=223)THEN ---开始回溯RAM-4
	      IF(data_valid(conv_integer(addr_4_t)+96)='1')THEN
			   mmu_ram_wr_4<='0';
		      mmu_addr_4_out<=addr_4_t;
				
				out_4_valid_t<='1';
			ELSE
			   out_4_valid_t<='0';
			END IF;
	         addr_4_t<=addr_4_t-'1';
	 ELSE
	         out_4_valid_t<='0';
	 END IF;		 

	 ------------------------------------------------------
	 --数据的有效位
	 ------------------------------------------------------
--      mmu_out_1_valid<=out_1_valid_t OR out_1_valid;
--		  mmu_out_2_valid<=out_2_valid_t OR out_2_valid;
--		  mmu_out_3_valid<=out_3_valid_t OR out_3_valid;
--		  mmu_out_4_valid<=out_4_valid_t OR out_4_valid;
    ------------------------------------------------------
  ELSE
     out_1_valid<='0';
	 out_2_valid<='0';
	 out_3_valid<='0';
	 out_4_valid<='0';
	 out_1_valid_t<='0';
	 out_2_valid_t<='0';
	 out_3_valid_t<='0';
	 out_4_valid_t<='0';
  END IF;
 END IF;
END PROCESS;

PROCESS(clk,rst)
BEGIN
IF(rst='0')THEN
   mmu_out_end_r2<='0';
   mmu_out_end_r3<='0';
   mmu_out_end_r4<='0';
ELSIF(clk 'EVENT AND clk='1')THEN
   mmu_out_end_r2<=mmu_out_end_r1;
   mmu_out_end_r3<=mmu_out_end_r2;
   mmu_out_end_r4<=mmu_out_end_r3;
END IF;
END PROCESS;
mmu_out_endpos<=mmu_out_end_r3 AND (NOT mmu_out_end_r4);

-- PROCESS(clk,rst)
-- BEGIN
-- IF(rst='0')THEN
   -- mmu_out_begin<='0';
   -- mmu_out_end<='0';
-- ELSIF(clk 'EVENT AND clk='1')THEN
   -- mmu_out_begin<=mmu_begin;
   -- mmu_out_end<=mmu_out_endpos;
-- END IF;
-- END PROCESS;

PROCESS(clk,rst)
BEGIN
IF(rst='0')THEN
   mmu_out_begin_r2<='0';
ELSIF(clk 'EVENT AND clk='1')THEN
   mmu_out_begin_r2<=mmu_out_begin_r1;
END IF;
END PROCESS;
mmu_out_begin<=mmu_out_begin_r1 AND (NOT mmu_out_begin_r2);
PROCESS(clk,rst)
BEGIN
IF(rst='0')THEN
   -- mmu_out_begin<='0';
   mmu_out_end<='0';
ELSIF(clk 'EVENT AND clk='1')THEN
   -- mmu_out_begin<=mmu_out_beginpos;
   mmu_out_end<=mmu_out_endpos;
END IF;
END PROCESS;
 ------------------------------------------

END Behavioral;