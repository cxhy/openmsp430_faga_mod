--------------------------------------------------------
--------------------------------------------------------
--��ģ������˶�4��RAM�Ķ�д���̵Ŀ��ƹ��̣�ʵ��4��RAM����һ����ˮ��
--�����ݴ���������������Ĳ������ٴ洢�Ͷ�ȡ���ݹ��̵�ʱ�䣬���̶ȵ�
--������ݵĴ����ٶȣ�4��ramλ32*64��˫��RAM
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
mmu_en:IN STD_LOGIC;--ģ���ʹ���ź��Լ�acs�������Ч����λ
mmu_in:IN STD_LOGIC_VECTOR(63 DOWNTO 0);---acsģ�����ݵĶ������
mmu_end:IN STD_LOGIC;
mmu_ram_1:OUT STD_LOGIC_VECTOR(63 DOWNTO 0);--RAM���ݵ����������
mmu_ram_2:OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
mmu_ram_3:OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
mmu_ram_4:OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
mmu_addr_1_in:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);--RAMд�����ĵ�ַ
mmu_addr_2_in:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
mmu_addr_3_in:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
mmu_addr_4_in:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
mmu_addr_1_out:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);--RAM�������ĵ�ַ
mmu_addr_2_out:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
mmu_addr_3_out:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
mmu_addr_4_out:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
mmu_ram_wr_1:OUT STD_LOGIC;--RAM�Ķ�д����λ
mmu_ram_wr_2:OUT STD_LOGIC;
mmu_ram_wr_3:OUT STD_LOGIC;
mmu_ram_wr_4:OUT STD_LOGIC;
mmu_out_begin : OUT STD_LOGIC;
mmu_out_end : OUT STD_LOGIC;
mmu_out_1_valid: OUT STD_LOGIC;--RAM�������������Чλ
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
--Out_valid���̣���4��ram������źŵ���Чλ�Ŀ���
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
--Write_Read_process���̣���Ҫ�ǿ���4��ram���ε�д�������
--4��ram����ˮ�����ζ���������
------------------------------------------------------
Write_Read_process:PROCESS(clk,rst)-----RAM��д��������
VARIABLE flag_mmu : STD_LOGIC;
BEGIN
 IF(rst='0')THEN
  counter<=0;
  addr_1<="00000";---д��ַ�ĳ�ʼֵλ0
  addr_2<="00000";
  addr_3<="00000";
  addr_4<="00000";
  addr_1_t<="11111";---����ַ�ĳ�ʼֵλ31��
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
      addr_1<="00000";---д��ַ�ĳ�ʼֵλ0
      addr_2<="00000";
      addr_3<="00000";
      addr_4<="00000";
      addr_1_t<="11111";---����ַ�ĳ�ʼֵλ31��
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
 
   IF(mmu_en='1')THEN------ʹ���ź���Чʱ����ʼ�����ݵ�д��
      counter_h_level<='1';
	  trace_sig<='1';------���ݵĿ�ʼ�ź�
     IF(counter=223)THEN----��ʼ���㣬Ϊ�˷���������ݵĴ�ŵ�RAm�Ͷ�Ӧ�ĵ�ַ
	     counter<=96;
	  ELSE
	     counter<=counter+1;
	  END IF;
	  IF(counter>127)THEN----�洢��Ч�źŵı�ʾ
		   data_valid(counter-128)<='1';
	  ELSE
		   data_valid(counter)<='1';
	  END IF;
		 --------------------------
		 --��ʼ������ݣ�
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
       --���ݴ洢�����Ļ��ݴ���
	  ------------------------------------------
	IF(flag_mmu='1' AND trace_sig='1')THEN--���ݴ洢����ʱ����ʼ��ȡ��ʣ�������
	        
			IF(cnt>1)THEN--��ȡ���ݵĽ�������-----------------------
			   cnt<=cnt-1;
				IF(counter=223)THEN---����û��ֹͣ����Ȼ�������Ա㽫����ram������ȫ����Ҫ��ȡ��
				 counter<=96;
				ELSE
				 counter<=counter+1;
				END IF;
				IF(counter>127)THEN----Ϊ�����ݵ���ȷ�������洢�����󣬲�д�����ݣ������ݵ���Чλ���ο�ʼΪ0��
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
--����1����
---------------------------------------------------
   IF(counter_h_level='1')THEN
	 IF((counter>63 AND counter<=95)OR(counter>191 AND counter<=223))THEN---���ݴ洢64��ʱ��ʼ����RAM-2
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
	 
	 IF(counter>95 AND counter<=127)THEN ---��ʼ����RAM-1
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
	 
	 IF(counter>127 AND counter<=159)THEN --���ݴ洢128��ʱ��ʼ����RAM-4
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
	 
	 IF(counter>159 AND counter<=191)THEN ---��ʼ����RAM-3
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
--����2���֣�
---------------------------------------------------------
	 IF(counter>95 AND counter<=127)THEN ---��ʼ����RAM-3
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
	 
	 IF(counter>127 AND counter<=159)THEN ---��ʼ����RAM-2
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
	 IF(counter>159 AND counter<=191)THEN ---��ʼ����RAM-1
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
	 
	 IF(counter>191 AND counter<=223)THEN ---��ʼ����RAM-4
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
	 --���ݵ���Чλ
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