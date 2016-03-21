------------------------------------------------------
--��ģ����Ҫ��Ϊ�������ݵĿ���ģ�飬��Ҫʵ�ֽ�4��ram ��
--�������ݣ����ջ��ݵ�Ҫ�󣬺ϲ�Ϊ�ʺ�2�����ݽ��̶�ȡ��������
------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY trace_controller IS 
PORT(
clk:IN STD_LOGIC;
rst:IN STD_LOGIC;
data_in_1:IN STD_LOGIC_VECTOR(63 DOWNTO 0);--ram����������
data_in_2:IN STD_LOGIC_VECTOR(63 DOWNTO 0);
data_in_3:IN STD_LOGIC_VECTOR(63 DOWNTO 0);
data_in_4:IN STD_LOGIC_VECTOR(63 DOWNTO 0);
data_valid_1:IN STD_LOGIC;--ram��������Чλ
data_valid_2:IN STD_LOGIC;
data_valid_3:IN STD_LOGIC;
data_valid_4:IN STD_LOGIC;
min_state_in:IN STD_LOGIC_VECTOR(5 DOWNTO 0);--��acs��������С״̬��Ϣ
state_in_valid:IN STD_LOGIC;
min_state_out_1:OUT STD_LOGIC_VECTOR(5 DOWNTO 0);--�ֱ�����С״̬ת��Ϊ2�����ݽ��̵��ź�
min_state_out_2:OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
state_valid_1:OUT STD_LOGIC;--��С״̬����Чλ�ź�
state_valid_2:OUT STD_LOGIC;
data_out_1:OUT STD_LOGIC_VECTOR(63 DOWNTO 0);--���ݵ�������
data_out_2:OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
data_1_valid:OUT STD_LOGIC;--���ݵ���Чλ��Ϣ
data_2_valid:OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE Behavioral OF trace_controller IS
SIGNAL counter_1:INTEGER;
SIGNAL counter_2:INTEGER;
SIGNAL state_sig_1:STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL state_sig_2:STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL state_sig_3:STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL state_sig_4:STD_LOGIC_VECTOR(5 DOWNTO 0);

SIGNAL state_valid_1_sig:STD_LOGIC;
SIGNAL state_valid_2_sig:STD_LOGIC;
SIGNAL state_valid_3_sig:STD_LOGIC;
SIGNAL state_valid_4_sig:STD_LOGIC;

BEGIN
----------------------------------------------------------
--Control_1���̽����ݰ�Ҫ��ת��Ϊ1·�����������ź�
----------------------------------------------------------
state_process:PROCESS(clk,rst)
VARIABLE t:STD_LOGIC;
BEGIN
 IF(rst='0')THEN
   state_valid_1_sig<='0';
	state_valid_2_sig<='0';
	state_valid_3_sig<='0';
	state_valid_4_sig<='0';
	state_sig_1<="000000";
	state_sig_2<="000000";
	state_sig_3<="000000";
	state_sig_4<="000000";
	min_state_out_1<="000000";
	min_state_out_2<="000000";
	t:='0';
 ELSIF(clk'EVENT AND clk='1')THEN
   IF(t='0' AND state_in_valid='1')THEN
	    t:='1';
		 state_sig_1<=min_state_in;
		 state_valid_1_sig<='1';
	ELSIF(t='1' AND state_in_valid='1')THEN
	    t:='0';
		 state_sig_2<=min_state_in;
		 state_valid_2_sig<='1';
	ELSE
	     state_valid_1_sig<='0';
		  state_valid_2_sig<='0';
	END IF;
	  state_sig_3<=state_sig_1;
	  state_sig_4<=state_sig_2;
	  min_state_out_1<=state_sig_3;
	  min_state_out_2<=state_sig_4;
	  state_valid_3_sig<=state_valid_1_sig;
	  state_valid_1<=state_valid_3_sig;
	  state_valid_4_sig<=state_valid_2_sig;
	  state_valid_2<=state_valid_4_sig;
 END IF;
END PROCESS;

-- state_process:PROCESS(clk,rst)
-- VARIABLE t:STD_LOGIC;
-- BEGIN
 -- IF(rst='0')THEN
   -- state_valid_1_sig<='0';
	-- state_valid_2_sig<='0';
	-- state_valid_3_sig<='0';
	-- state_valid_4_sig<='0';
	-- state_sig_1<="000000";
	-- state_sig_2<="000000";
	-- state_sig_3<="000000";
	-- state_sig_4<="000000";
	-- min_state_out_1<="000000";
	-- min_state_out_2<="000000";
	-- t:='0';
 -- ELSIF(clk'EVENT AND clk='1')THEN
   -- IF(t='0' AND state_in_valid='1')THEN
	    -- t:='1';
		 -- min_state_out_1<=min_state_in;
		 -- state_valid_1<='1';
	-- ELSIF(t='1' AND state_in_valid='1')THEN
	    -- t:='0';
		 -- min_state_out_2<=min_state_in;
		 -- state_valid_2<='1';
	-- ELSE
	     -- state_valid_1<='0';
		  -- state_valid_2<='0';
	-- END IF;
 -- END IF;
-- END PROCESS;

-- state_process:PROCESS(clk,rst)
-- VARIABLE t:STD_LOGIC;
-- BEGIN
 -- IF(rst='0')THEN
   -- state_valid_1_sig<='0';
	-- state_valid_2_sig<='0';
	-- state_valid_3_sig<='0';
	-- state_valid_4_sig<='0';
	-- state_sig_1<="000000";
	-- state_sig_2<="000000";
	-- state_sig_3<="000000";
	-- state_sig_4<="000000";
	-- min_state_out_1<="000000";
	-- min_state_out_2<="000000";
	-- t:='0';
 -- ELSIF(clk'EVENT AND clk='1')THEN
   -- IF(t='0' AND state_in_valid='1')THEN
	    -- t:='1';
		 -- state_sig_1<=min_state_in;
		 -- state_valid_1_sig<='1';
	-- ELSIF(t='1' AND state_in_valid='1')THEN
	    -- t:='0';
		 -- state_sig_2<=min_state_in;
		 -- state_valid_2_sig<='1';
	-- ELSE
	     -- state_valid_1_sig<='0';
		  -- state_valid_2_sig<='0';
	-- END IF;
	  -- min_state_out_1<=state_sig_1;
	  -- min_state_out_2<=state_sig_2;
	  -- state_valid_1<=state_valid_1_sig;
	  -- state_valid_2<=state_valid_2_sig;
 -- END IF;
-- END PROCESS;


Control_1:PROCESS(clk,rst)---�������ݿ��ƽ���1
BEGIN
  IF(rst='0')THEN
		data_1_valid<='0';
		data_out_1<=(OTHERS=>'0');
		counter_1<=0;
  ELSIF(clk'EVENT AND clk='1')THEN
    
    IF(data_valid_1='1' OR data_valid_2='1' OR data_valid_3='1' OR data_valid_4='1')THEN
	    
	   IF(counter_1=127)THEN
		  counter_1<=0;
		ELSE
		  counter_1<=counter_1+1;
		END IF;
		
			 IF(counter_1<=63)THEN
				IF(data_valid_2='1')THEN
				  data_out_1<=data_in_2;
				  data_1_valid<='1';
				ELSIF(data_valid_1='1')THEN
				  data_out_1<=data_in_1;
				  data_1_valid<='1';
				ELSE
				  data_1_valid<='0';
				  data_out_1<=(OTHERS=>'0');
				END IF;
			   ---------------------------

				--------------------------
			 ELSIF(counter_1<=127)THEN
				IF(data_valid_4='1')THEN
				  data_out_1<=data_in_4;
				  data_1_valid<='1';
				ELSIF(data_valid_3='1')THEN
				  data_out_1<=data_in_3;
				  data_1_valid<='1';
				ELSE
				  data_out_1<=(OTHERS=>'0');
				  data_1_valid<='0';
				END IF;

			 ELSE
				  data_out_1<=(OTHERS=>'0');
				  data_1_valid<='0';
			 END IF;
	 ELSE
	    data_1_valid<='0';
		 data_out_1<=(OTHERS=>'0');
	 END IF;
  END IF;
END PROCESS;
-----------------------------------------------------
--Control_2���̽����ݰ�Ҫ��ת��Ϊ1·�����������ź�
-----------------------------------------------------
Control_2:PROCESS(clk,rst)---�������ݿ��ƽ���2
BEGIN
  IF(rst='0')THEN
		data_2_valid<='0';
		data_out_2<=(OTHERS=>'0');
		counter_2<=0;
  ELSIF(clk'EVENT AND clk='1')THEN
    IF(data_valid_1='1' OR data_valid_2='1' OR data_valid_3='1' OR data_valid_4='1')THEN
	   IF(counter_2=159)THEN
		  counter_2<=32;     
		ELSE
		  counter_2<=counter_2+1;
		END IF;
		
		 IF(counter_2<=95 AND counter_2>31)THEN
			IF(data_valid_3='1')THEN
			  data_out_2<=data_in_3;
			  data_2_valid<='1';
			ELSIF(data_valid_2='1')THEN
			  data_out_2<=data_in_2;
			  data_2_valid<='1';
			ELSE
			  data_2_valid<='0';
			  data_out_2<=(OTHERS=>'0');
			END IF;
		 ELSIF(counter_2<=159 AND counter_2>95)THEN
			IF(data_valid_1='1')THEN
			  data_out_2<=data_in_1;
			  data_2_valid<='1';
			ELSIF(data_valid_4='1')THEN
			  data_out_2<=data_in_4;
			  data_2_valid<='1';
			ELSE
			  data_out_2<=(OTHERS=>'0');
			  data_2_valid<='0';
			END IF;
		 ELSE
			 data_out_2<=(OTHERS=>'0');
			 data_2_valid<='0';
		 END IF;
	 ELSE
	    data_2_valid<='0';
		 data_out_2<=(OTHERS=>'0');
	 END IF;
  END IF;
END PROCESS;

END Behavioral;