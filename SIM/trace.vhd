-----------------------------------------------
--��ģ��������2������ģ�飬��2��64λ��viterbi���ݵķ����Ĵ���
--���ݵ�ĩβ�Ѿ�ȥ����viterbi������6��0   �����ݵ�����
-----------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY trace IS
PORT(
clk:IN STD_LOGIC;
rst:IN STD_LOGIC;
trace_begin : IN STD_LOGIC;
trace_end : IN STD_LOGIC;
trace_en_1:IN STD_LOGIC;--����1ʹ���ź�
trace_en_2:IN STD_LOGIC;--����2ʹ���ź�
trace_in_1:IN STD_LOGIC_VECTOR(63 DOWNTO 0);--����1������������
trace_in_2:IN STD_LOGIC_VECTOR(63 DOWNTO 0);--����2������������
min_state_1:IN STD_LOGIC_VECTOR(5 DOWNTO 0);--����1����С״̬��Ϣ
min_state_2:IN STD_LOGIC_VECTOR(5 DOWNTO 0);--����2����С״̬��Ϣ
state_valid_1:IN STD_LOGIC;--����1��С״̬����Чλ
state_valid_2:IN STD_LOGIC;--����2��С״̬����Чλ
viterbi_out_begin:OUT STD_LOGIC;
viterbi_out:OUT STD_LOGIC;--���ݵ�������
viterbi_out_valid:OUT STD_LOGIC;--���ݵ���Чλ�ź�
viterbi_out_end:OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE Behavioral OF trace IS
SIGNAL trace_out_1:STD_LOGIC;
SIGNAL trace_out_2:STD_LOGIC;
SIGNAL curr_state:INTEGER RANGE 0 TO 63;
SIGNAL curr_state_2:INTEGER RANGE 0 TO 63;
SIGNAL trace_sig_1:STD_LOGIC;
SIGNAL trace_sig_2:STD_LOGIC;
-- SIGNAL trace_sig_3:STD_LOGIC;
-- SIGNAL trace_sig_4:STD_LOGIC;

SIGNAL stack_reg_1:STD_LOGIC_VECTOR(63 DOWNTO 0);
SIGNAL stack_reg_2:STD_LOGIC_VECTOR(63 DOWNTO 0);
SIGNAL stack_en_1:STD_LOGIC;
SIGNAL stack_en_2:STD_LOGIC;
SIGNAL i:INTEGER;
SIGNAL j:INTEGER;
SIGNAL cnt:INTEGER;
--SIGNAL cnt_2:INTEGER;
SIGNAL temp_sig_1:STD_LOGIC;

SIGNAL temp_sig_3:STD_LOGIC;
SIGNAL temp_sig_4:STD_LOGIC;
SIGNAL k:INTEGER;
SIGNAL g:INTEGER;
SIGNAL counter:INTEGER;
SIGNAL counter_2:INTEGER;
SIGNAL counter_3:INTEGER;
SIGNAL counter_4:INTEGER;
SIGNAL shift_1_en:STD_LOGIC;
SIGNAL shift_2_en:STD_LOGIC;
SIGNAL control:STD_LOGIC;
--SIGNAL temp_1:STD_LOGIC;
--SIGNAL temp_2:STD_LOGIC;
SIGNAL counter_pos : STD_LOGIC;

SIGNAL viterbi_out_end_level : STD_LOGIC;
SIGNAL viterbi_out_end_level_r : STD_LOGIC;
SIGNAL viterbi_out_end_level_r1 : STD_LOGIC;

SIGNAL vit_out : STD_LOGIC;
SIGNAL vit_out_valid : STD_LOGIC;
SIGNAL vit_out_valid_r : STD_LOGIC;

SIGNAL data_flag : STD_LOGIC;
BEGIN
------------------------------------------------
--������mov_state������Ҫʵ�ֻ��ݵ�״̬ת�ƹ��̣�����С״̬��
--��Чλ��Чʱ�������ⲿ��������С״̬��Ϣ������ת��next_state
--��curr_state��
------------------------------------------------
 ----------------------------------------------
 --trace_back����ʵ�ֻ���1·���ݣ����а���˻���1�ͻ���2
 --���Ҹ��ݵ�ǰ��״̬ȷ������һ״̬����Ϣ��
 ----------------------------------------------
 trace_back:PROCESS(clk,rst)
 BEGIN
   IF(rst='0')THEN
	 trace_out_1<='0';
	 trace_out_2<='0';
	 trace_sig_1<='0';
	 trace_sig_2<='0';
	 curr_state<=0;
	 curr_state_2<=0;
	ELSIF(clk'EVENT AND clk='1')THEN
---------------------------------------------------
    IF(state_valid_1='1')THEN
	   curr_state<=CONV_INTEGER(min_state_1);
	ELSIF(state_valid_2='1')THEN
	   curr_state_2<=CONV_INTEGER(min_state_2);
	END IF;
--------------------------------------------------
    IF(trace_en_1='1')THEN
       IF(state_valid_1='0')THEN
    				IF(trace_in_1(curr_state)='0')THEN
    					curr_state<=curr_state/2;
    				ELSE
    					curr_state<=curr_state/2+32;
    				END IF;
       END IF;
	END IF;
 -----
   IF(trace_en_2='1')THEN
       IF(state_valid_2='0')THEN
				IF(trace_in_2(curr_state_2)='0')THEN
				  curr_state_2<=curr_state_2/2;
				ELSE
				  curr_state_2<=curr_state_2/2+32;
				END IF;
       END IF;
   END IF;
--------------------------------------------------
     trace_sig_1<=trace_en_1;
-------------------------------------------------
	  IF(trace_en_1='1')THEN---����1
			IF((curr_state REM 2)=0)THEN
			  trace_out_1<='0';
			ELSE
			  trace_out_1<='1';
			END IF;
			stack_en_1<='1';
	 ELSE
	      stack_en_1<='0';
	 END IF;
-------------------------------------------------
     trace_sig_2<=trace_en_2;
-------------------------------------------------
   IF(trace_en_2='1')THEN---����2
			IF((curr_state_2 REM 2)=0)THEN
				  trace_out_2<='0';
			ELSE
				  trace_out_2<='1';
			END IF;
		  stack_en_2<='1';
	 ELSE
	     stack_en_2<='0';
	 END IF;
	  ---------
	END IF;
 END PROCESS;
------------------------------------------------
--ʹ�����64λ�ļĴ��������stack�������ݵķ���
------------------------------------------------
PROCESS(clk,rst)
VARIABLE trace_end_flag : STD_LOGIC;
BEGIN
  IF(rst='0')THEN
   i<=63;----
	j<=63;
	temp_sig_1<='0';
	temp_sig_3<='0';
	temp_sig_4<='0';
	k<=0;
	cnt<=0;
	g<=0;
	vit_out<='0';
	vit_out_valid<='0';
	counter<=0;
	counter_2<=0;
	counter_3<=0;
	counter_4<=0;
	shift_1_en<='0';
	shift_2_en<='0';
	control<='0';
	viterbi_out_end_level<='0';
  ELSIF(clk'EVENT AND clk='1')THEN
      IF(trace_begin='1')THEN
	     trace_end_flag:='0';
		 i<=63;----
	     j<=63;
	     temp_sig_1<='0';
	     temp_sig_3<='0';
	     temp_sig_4<='0';
	     k<=0;
	     cnt<=0;
	     g<=0;
	     vit_out<='0';
	     vit_out_valid<='0';
	     counter<=0;
	     counter_2<=0;
	     counter_3<=0;
	     counter_4<=0;
	     shift_1_en<='0';
	     shift_2_en<='0';
	     control<='0';
		 viterbi_out_end_level<='0';
	  END IF;
      IF(trace_end='1')THEN
	    trace_end_flag:='1';
	  END IF;
  
      
		IF(stack_en_1='1')THEN--reg_1--��ջ����Ч�ź��ɻ��ݵ���Ч�ź�ȷ��
		  IF(i=0)THEN--�����ɼĴ����ĸ�λ��ʼ��δ���
			 i<=63;
		  ELSE
			 i<=i-1;
		  END IF;
		  stack_reg_1(i)<=trace_out_1;
		END IF;
---------------------------------------
		IF(stack_en_2='1')THEN--reg_2
		  IF(j=0)THEN
			 j<=63;
		  ELSE
			 j<=j-1;
		  END IF;
		  stack_reg_2(j)<=trace_out_2;
   	    END IF;
--------------------------------------------------------------
----���������ݴ���reg_1ʱ����ʼ���������ݴ���64λ�Ĵ���ʱ��ʼȡ������
----
--------------------------------------------------------------
     IF(stack_en_1='1' AND stack_en_2='1')THEN
	    IF(counter_3=31)THEN
		   counter_3<=0;
		 ELSE
		   counter_3<=counter_3+1;
		 END IF;
		 counter_4<=counter_3;
	  END IF;
	  IF(stack_en_1='1' OR stack_en_2='1')THEN
	     counter_pos<='1';
	     temp_sig_1<='1';
	     IF(counter=127)THEN
		     counter<=64;
		  ELSE
		     counter<=counter+1;
		  END IF;

		  IF(counter<=32)THEN
		    cnt<=63-counter;
			 --cnt_2<=63;
		  ELSIF(counter<=63)THEN
		    cnt<=63-counter;
		    --cnt_2<=95-counter;
		  ELSIF(counter<=95)THEN
		    --cnt_2<=31-counter_4;
		    cnt<=31-counter_4;
			 shift_1_en<='1';
		  ELSE
		    shift_2_en<='1';
		    --cnt_2<=31-counter_4;
		    cnt<=31-counter_4;
		  END IF;
		  counter_2<=counter;
	  ELSE
	     counter_pos<='0';
	  END IF;
--------------------------------------------------------
   IF(counter_pos='1')THEN
     IF(counter_2<63 AND stack_en_1='0' AND stack_en_2='0' AND temp_sig_1='1' AND control='0')THEN
	    temp_sig_3<='1';
		 temp_sig_4<='0';
	  ELSIF((counter_2=63 OR counter_2=127) AND stack_en_1='0' AND stack_en_2='0' AND temp_sig_1='1')THEN
	    temp_sig_3<='1';
		 temp_sig_4<='0';
	  ELSIF(counter_2>63 AND counter_2<=95 AND shift_1_en='1')THEN--���ݴ���64��ʱ��ʼ��ȡ�Ĵ����ĵ�32λ���ݣ�ʵ����������Ϊ32�Ĳ���
	     control<='1';
		  IF(k=31)THEN
		    shift_1_en<='0';
			 temp_sig_4<='1';
			 k<=0;
		  ELSE
			 k<=k+1;
			 temp_sig_4<='0';
			 temp_sig_3<='0';
		  END IF;
		  vit_out<=stack_reg_1(k);
		  vit_out_valid<='1';
	  END IF;
	  
	  IF(counter_2=95 AND stack_en_1='0' AND stack_en_2='0' AND temp_sig_1='1')THEN
	       temp_sig_4<='1';
			 temp_sig_3<='0';
	  ELSIF(counter_2>95 AND counter_2<=127 AND shift_2_en='1')THEN
		  IF(g=31)THEN
		    shift_2_en<='0';
			 temp_sig_3<='1';
			 g<=0;
		  ELSE
			 g<=g+1;
			 temp_sig_3<='0';
			 temp_sig_4<='0';
		  END IF;
		  vit_out<=stack_reg_2(g);
		  vit_out_valid<='1';
	  END IF;
	ELSE
	   vit_out<='0';
	   vit_out_valid<='0';
	END IF;
--------------------------------------------------------

	  
      IF(trace_end_flag='1')THEN
		  IF(temp_sig_3='1')THEN---���ݽ���ʱreg_1������64ʱ������
			 IF(cnt<=63)THEN
			   cnt<=cnt+1;--cnt�ĳ�ֵ�������������ֵĽ����õ�������������������ʱ����ʼȡ���ݵ�λ��
				vit_out<=stack_reg_1(cnt);
				vit_out_valid<='1';
			 ELSE
				vit_out_valid<='0';
				vit_out<='0';
				viterbi_out_end_level<='1';
			 END IF;
		  END IF;
	  -----------------------------
		 IF(temp_sig_4='1')THEN---���ݽ���ʱreg_2������64ʱ������
			 IF(cnt<=63)THEN
			   cnt<=cnt+1;
				vit_out<=stack_reg_2(cnt);
				vit_out_valid<='1';
			 ELSE
				vit_out_valid<='0';
				vit_out<='0';
				viterbi_out_end_level<='1';
			 END IF; 
		 END IF;
	END IF;
--------------------------------------------------------
  END IF;
 END PROCESS;
 ---------------------------------------------
 PROCESS(clk,rst)
 BEGIN
 IF(rst='0')THEN
   viterbi_out_end_level_r<='0';
   viterbi_out_end_level_r1<='0';
 ELSIF(clk 'EVENT AND clk='1')THEN
   viterbi_out_end_level_r<=viterbi_out_end_level;
   viterbi_out_end_level_r1<=viterbi_out_end_level_r;
 END IF;
 END PROCESS;
  viterbi_out_end<=viterbi_out_end_level_r AND (NOT viterbi_out_end_level_r1);
 ---------------------------------------------
 PROCESS(clk,rst)
 BEGIN
 IF(rst='0')THEN
   viterbi_out_valid<='0';
   viterbi_out<='0';
   data_flag<='0';
   vit_out_valid_r<='0';
 ELSIF(clk 'EVENT AND clk='1')THEN
   viterbi_out_valid<=vit_out_valid;
   vit_out_valid_r<=vit_out_valid;
   viterbi_out<=vit_out;
   IF(vit_out_valid_r='1')THEN
      data_flag<='1';
   END IF;
   IF(trace_begin='1')THEN
     data_flag<='0';
   END IF;
 END IF;
 END PROCESS; 
 
 viterbi_out_begin<=vit_out_valid AND (NOT vit_out_valid_r) WHEN data_flag='0';
 
END Behavioral;