LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY compare IS
PORT(
     clk : IN STD_LOGIC;
	  rst : IN STD_LOGIC;
	  viterbi_in_start : IN STD_LOGIC;
	  smaller1_en  : IN STD_LOGIC;
	  smaller2_en  : IN STD_LOGIC;
	  smaller_en   : IN STD_LOGIC;
	  currentAccumulateDistance0  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance1  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance2  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance3  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance4  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance5  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance6  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance7  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	                                                    
	  currentAccumulateDistance8  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);                          
	  currentAccumulateDistance9  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance10 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance11 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance12 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance13 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance14 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance15 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	                                                    
	  currentAccumulateDistance16 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance17 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance18 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance19 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance20 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance21 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance22 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance23 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	                                                    
	  currentAccumulateDistance24 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance25 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance26 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance27 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance28 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance29 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance30 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance31 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	                                                    
	  currentAccumulateDistance32 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance33 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance34 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance35 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance36 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance37 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance38 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance39 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	                                                    
	  currentAccumulateDistance40 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance41 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance42 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance43 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance44 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance45 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance46 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance47 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	                                                    
	  currentAccumulateDistance48 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance49 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance50 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance51 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance52 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance53 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance54 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance55 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	                                                    
	  currentAccumulateDistance56 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance57 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance58 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance59 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance60 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance61 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance62 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  currentAccumulateDistance63 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	  
	  smallest         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	  smallest_index_r : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
	  smallest_index_r_valid : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE arch_compare OF compare IS
SIGNAL smallest1_0  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL smallest1_1  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL smallest1_2  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL smallest1_3  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL smallest1_4  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL smallest1_5  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL smallest1_6  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL smallest1_7  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL smallest1_8  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL smallest1_9  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL smallest1_10 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL smallest1_11 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL smallest1_12 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL smallest1_13 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL smallest1_14 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL smallest1_15 : STD_LOGIC_VECTOR(7 DOWNTO 0);

SIGNAL smallest_index1_0  : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL smallest_index1_1  : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL smallest_index1_2  : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL smallest_index1_3  : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL smallest_index1_4  : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL smallest_index1_5  : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL smallest_index1_6  : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL smallest_index1_7  : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL smallest_index1_8  : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL smallest_index1_9  : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL smallest_index1_10 : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL smallest_index1_11 : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL smallest_index1_12 : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL smallest_index1_13 : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL smallest_index1_14 : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL smallest_index1_15 : STD_LOGIC_VECTOR(5 DOWNTO 0);

SIGNAL smallest2_0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL smallest2_1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL smallest2_2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL smallest2_3 : STD_LOGIC_VECTOR(7 DOWNTO 0);

SIGNAL smallest_index2_0 : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL smallest_index2_1 : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL smallest_index2_2 : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL smallest_index2_3 : STD_LOGIC_VECTOR(5 DOWNTO 0);

FUNCTION smaller(a,b,c,d: STD_LOGIC_VECTOR;state_in0,state_in1,state_in2,state_in3 : INTEGER) RETURN STD_LOGIC_VECTOR IS
VARIABLE sml : STD_LOGIC_VECTOR(7 DOWNTO 0);
VARIABLE index : STD_LOGIC_VECTOR(5 DOWNTO 0);
VARIABLE temp_out : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
 sml:=a;
 index:=conv_std_logic_vector(state_in0,6);
 IF(sml>b)THEN
   sml:=b;
   index:=conv_std_logic_vector(state_in1,6);
 END IF;
 IF(sml>c)THEN
   sml:=c;
   index:=conv_std_logic_vector(state_in2,6);
 END IF;
 IF(sml>d)THEN
   sml:=d;
   index:=conv_std_logic_vector(state_in3,6);
 END IF;
 temp_out:=sml&index;
 RETURN temp_out;
END FUNCTION;
BEGIN

---------------------------------------------------------------------------------------------------------------
-------------------------------------第1级64选16的比较，每个进程4选一的比较，有16个进程-----------------------
PROCESS(clk,rst)
VARIABLE smaller_temp1_0 : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   smallest_index1_0<=(OTHERS=>'0');
   smallest1_0<=(OTHERS=>'0');
   smaller_temp1_0:=(OTHERS=>'0');
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_in_start='1')THEN
      smallest_index1_0<=(OTHERS=>'0');
      smallest1_0<=(OTHERS=>'0');
      smaller_temp1_0:=(OTHERS=>'0');
   END IF;
   IF(smaller1_en='1')THEN
      smaller_temp1_0:=smaller(currentAccumulateDistance0,currentAccumulateDistance1,currentAccumulateDistance2,currentAccumulateDistance3,0,1,2,3);
      smallest1_0<=smaller_temp1_0(13 DOWNTO 6);
	  smallest_index1_0<=smaller_temp1_0(5 DOWNTO 0);
   -- ELSE
      -- smallest_index1_0<=(OTHERS=>'0');
      -- smallest1_0<=(OTHERS=>'0');
      -- smaller_temp1_0:=(OTHERS=>'0');
   END IF; 
END IF;
END PROCESS;

PROCESS(clk,rst)
VARIABLE smaller_temp1_1 : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   smallest_index1_1<=(OTHERS=>'0');
   smallest1_1<=(OTHERS=>'0');
   smaller_temp1_1:=(OTHERS=>'0');
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_in_start='1')THEN
      smallest_index1_1<=(OTHERS=>'0');
      smallest1_1<=(OTHERS=>'0');
      smaller_temp1_1:=(OTHERS=>'0');
   END IF;
   IF(smaller1_en='1')THEN
      smaller_temp1_1:=smaller(currentAccumulateDistance4,currentAccumulateDistance5,currentAccumulateDistance6,currentAccumulateDistance7,4,5,6,7);
      smallest1_1<=smaller_temp1_1(13 DOWNTO 6);
	  smallest_index1_1<=smaller_temp1_1(5 DOWNTO 0);
   -- ELSE
      -- smallest_index1_1<=(OTHERS=>'0');
      -- smallest1_1<=(OTHERS=>'0');
      -- smaller_temp1_1:=(OTHERS=>'0');
   END IF; 
END IF;
END PROCESS;

PROCESS(clk,rst)
VARIABLE smaller_temp1_2 : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   smallest_index1_2<=(OTHERS=>'0');
   smallest1_2<=(OTHERS=>'0');
   smaller_temp1_2:=(OTHERS=>'0');
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_in_start='1')THEN
      smallest_index1_2<=(OTHERS=>'0');
      smallest1_2<=(OTHERS=>'0');
      smaller_temp1_2:=(OTHERS=>'0');
   END IF;
   IF(smaller1_en='1')THEN
      smaller_temp1_2:=smaller(currentAccumulateDistance8,currentAccumulateDistance9,currentAccumulateDistance10,currentAccumulateDistance11,8,9,10,11);
      smallest1_2<=smaller_temp1_2(13 DOWNTO 6);
	  smallest_index1_2<=smaller_temp1_2(5 DOWNTO 0);
   -- ELSE
      -- smallest_index1_2<=(OTHERS=>'0');
      -- smallest1_2<=(OTHERS=>'0');
      -- smaller_temp1_2:=(OTHERS=>'0');
   END IF; 
END IF;
END PROCESS;

PROCESS(clk,rst)
VARIABLE smaller_temp1_3 : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   smallest_index1_3<=(OTHERS=>'0');
   smallest1_3<=(OTHERS=>'0');
   smaller_temp1_3:=(OTHERS=>'0');
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_in_start='1')THEN
      smallest_index1_3<=(OTHERS=>'0');
      smallest1_3<=(OTHERS=>'0');
      smaller_temp1_3:=(OTHERS=>'0');
   END IF;
   IF(smaller1_en='1')THEN
      smaller_temp1_3:=smaller(currentAccumulateDistance12,currentAccumulateDistance13,currentAccumulateDistance14,currentAccumulateDistance15,12,13,14,15);
      smallest1_3<=smaller_temp1_3(13 DOWNTO 6);
	  smallest_index1_3<=smaller_temp1_3(5 DOWNTO 0);
   -- ELSE
      -- smallest_index1_3<=(OTHERS=>'0');
      -- smallest1_3<=(OTHERS=>'0');
      -- smaller_temp1_3:=(OTHERS=>'0');
   END IF; 
END IF;
END PROCESS;

PROCESS(clk,rst)
VARIABLE smaller_temp1_4 : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   smallest_index1_4<=(OTHERS=>'0');
   smallest1_4<=(OTHERS=>'0');
   smaller_temp1_4:=(OTHERS=>'0');
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_in_start='1')THEN
      smallest_index1_4<=(OTHERS=>'0');
      smallest1_4<=(OTHERS=>'0');
      smaller_temp1_4:=(OTHERS=>'0');
   END IF;
   IF(smaller1_en='1')THEN
      smaller_temp1_4:=smaller(currentAccumulateDistance16,currentAccumulateDistance17,currentAccumulateDistance18,currentAccumulateDistance19,16,17,18,19);
      smallest1_4<=smaller_temp1_4(13 DOWNTO 6);
	  smallest_index1_4<=smaller_temp1_4(5 DOWNTO 0);
   -- ELSE
      -- smallest_index1_4<=(OTHERS=>'0');
      -- smallest1_4<=(OTHERS=>'0');
      -- smaller_temp1_4:=(OTHERS=>'0');
   END IF; 
END IF;
END PROCESS;

PROCESS(clk,rst)
VARIABLE smaller_temp1_5 : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   smallest_index1_5<=(OTHERS=>'0');
   smallest1_5<=(OTHERS=>'0');
   smaller_temp1_5:=(OTHERS=>'0');
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_in_start='1')THEN
      smallest_index1_5<=(OTHERS=>'0');
      smallest1_5<=(OTHERS=>'0');
      smaller_temp1_5:=(OTHERS=>'0');
   END IF;
   IF(smaller1_en='1')THEN
      smaller_temp1_5:=smaller(currentAccumulateDistance20,currentAccumulateDistance21,currentAccumulateDistance22,currentAccumulateDistance23,20,21,22,23);
      smallest1_5<=smaller_temp1_5(13 DOWNTO 6);
	  smallest_index1_5<=smaller_temp1_5(5 DOWNTO 0);
   -- ELSE
      -- smallest_index1_5<=(OTHERS=>'0');
      -- smallest1_5<=(OTHERS=>'0');
      -- smaller_temp1_5:=(OTHERS=>'0');
   END IF; 
END IF;
END PROCESS;

PROCESS(clk,rst)
VARIABLE smaller_temp1_6 : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   smallest_index1_6<=(OTHERS=>'0');
   smallest1_6<=(OTHERS=>'0');
   smaller_temp1_6:=(OTHERS=>'0');
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_in_start='1')THEN
      smallest_index1_6<=(OTHERS=>'0');
      smallest1_6<=(OTHERS=>'0');
      smaller_temp1_6:=(OTHERS=>'0');
   END IF;
   IF(smaller1_en='1')THEN
      smaller_temp1_6:=smaller(currentAccumulateDistance24,currentAccumulateDistance25,currentAccumulateDistance26,currentAccumulateDistance27,24,25,26,27);
      smallest1_6<=smaller_temp1_6(13 DOWNTO 6);
	  smallest_index1_6<=smaller_temp1_6(5 DOWNTO 0);
   -- ELSE
      -- smallest_index1_6<=(OTHERS=>'0');
      -- smallest1_6<=(OTHERS=>'0');
      -- smaller_temp1_6:=(OTHERS=>'0');
   END IF; 
END IF;
END PROCESS;

PROCESS(clk,rst)
VARIABLE smaller_temp1_7 : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   smallest_index1_7<=(OTHERS=>'0');
   smallest1_7<=(OTHERS=>'0');
   smaller_temp1_7:=(OTHERS=>'0');
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_in_start='1')THEN
      smallest_index1_7<=(OTHERS=>'0');
      smallest1_7<=(OTHERS=>'0');
      smaller_temp1_7:=(OTHERS=>'0');
   END IF;
   IF(smaller1_en='1')THEN
      smaller_temp1_7:=smaller(currentAccumulateDistance28,currentAccumulateDistance29,currentAccumulateDistance30,currentAccumulateDistance31,28,29,30,31);
      smallest1_7<=smaller_temp1_7(13 DOWNTO 6);
	  smallest_index1_7<=smaller_temp1_7(5 DOWNTO 0);
   -- ELSE
      -- smallest_index1_7<=(OTHERS=>'0');
      -- smallest1_7<=(OTHERS=>'0');
      -- smaller_temp1_7:=(OTHERS=>'0');
   END IF; 
END IF;
END PROCESS;

PROCESS(clk,rst)
VARIABLE smaller_temp1_8 : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   smallest_index1_8<=(OTHERS=>'0');
   smallest1_8<=(OTHERS=>'0');
   smaller_temp1_8:=(OTHERS=>'0');
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_in_start='1')THEN
      smallest_index1_8<=(OTHERS=>'0');
      smallest1_8<=(OTHERS=>'0');
      smaller_temp1_8:=(OTHERS=>'0');
   END IF;
   IF(smaller1_en='1')THEN
      smaller_temp1_8:=smaller(currentAccumulateDistance32,currentAccumulateDistance33,currentAccumulateDistance34,currentAccumulateDistance35,32,33,34,35);
      smallest1_8<=smaller_temp1_8(13 DOWNTO 6);
	  smallest_index1_8<=smaller_temp1_8(5 DOWNTO 0);
   -- ELSE
      -- smallest_index1_8<=(OTHERS=>'0');
      -- smallest1_8<=(OTHERS=>'0');
      -- smaller_temp1_8:=(OTHERS=>'0');
   END IF; 
END IF;
END PROCESS;

PROCESS(clk,rst)
VARIABLE smaller_temp1_9 : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   smallest_index1_9<=(OTHERS=>'0');
   smallest1_9<=(OTHERS=>'0');
   smaller_temp1_9:=(OTHERS=>'0');
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_in_start='1')THEN
      smallest_index1_9<=(OTHERS=>'0');
      smallest1_9<=(OTHERS=>'0');
      smaller_temp1_9:=(OTHERS=>'0');
   END IF;
   IF(smaller1_en='1')THEN
      smaller_temp1_9:=smaller(currentAccumulateDistance36,currentAccumulateDistance37,currentAccumulateDistance38,currentAccumulateDistance39,36,37,38,39);
      smallest1_9<=smaller_temp1_9(13 DOWNTO 6);
	  smallest_index1_9<=smaller_temp1_9(5 DOWNTO 0);
   -- ELSE
      -- smallest_index1_9<=(OTHERS=>'0');
      -- smallest1_9<=(OTHERS=>'0');
      -- smaller_temp1_9:=(OTHERS=>'0');
   END IF; 
END IF;
END PROCESS;

PROCESS(clk,rst)
VARIABLE smaller_temp1_10 : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   smallest_index1_10<=(OTHERS=>'0');
   smallest1_10<=(OTHERS=>'0');
   smaller_temp1_10:=(OTHERS=>'0');
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_in_start='1')THEN
      smallest_index1_10<=(OTHERS=>'0');
      smallest1_10<=(OTHERS=>'0');
      smaller_temp1_10:=(OTHERS=>'0');
   END IF;
   IF(smaller1_en='1')THEN
      smaller_temp1_10:=smaller(currentAccumulateDistance40,currentAccumulateDistance41,currentAccumulateDistance42,currentAccumulateDistance43,40,41,42,43);
      smallest1_10<=smaller_temp1_10(13 DOWNTO 6);
	  smallest_index1_10<=smaller_temp1_10(5 DOWNTO 0);
   -- ELSE
      -- smallest_index1_10<=(OTHERS=>'0');
      -- smallest1_10<=(OTHERS=>'0');
      -- smaller_temp1_10:=(OTHERS=>'0');
   END IF; 
END IF;
END PROCESS;

PROCESS(clk,rst)
VARIABLE smaller_temp1_11 : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   smallest_index1_11<=(OTHERS=>'0');
   smallest1_11<=(OTHERS=>'0');
   smaller_temp1_11:=(OTHERS=>'0');
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_in_start='1')THEN
      smallest_index1_11<=(OTHERS=>'0');
      smallest1_11<=(OTHERS=>'0');
      smaller_temp1_11:=(OTHERS=>'0');
   END IF;
   IF(smaller1_en='1')THEN
      smaller_temp1_11:=smaller(currentAccumulateDistance44,currentAccumulateDistance45,currentAccumulateDistance46,currentAccumulateDistance47,44,45,46,47);
      smallest1_11<=smaller_temp1_11(13 DOWNTO 6);
	  smallest_index1_11<=smaller_temp1_11(5 DOWNTO 0);
   -- ELSE
      -- smallest_index1_11<=(OTHERS=>'0');
      -- smallest1_11<=(OTHERS=>'0');
      -- smaller_temp1_11:=(OTHERS=>'0');
   END IF; 
END IF;
END PROCESS;

PROCESS(clk,rst)
VARIABLE smaller_temp1_12 : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   smallest_index1_12<=(OTHERS=>'0');
   smallest1_12<=(OTHERS=>'0');
   smaller_temp1_12:=(OTHERS=>'0');
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_in_start='1')THEN
      smallest_index1_12<=(OTHERS=>'0');
      smallest1_12<=(OTHERS=>'0');
      smaller_temp1_12:=(OTHERS=>'0');
   END IF;
   IF(smaller1_en='1')THEN
      smaller_temp1_12:=smaller(currentAccumulateDistance48,currentAccumulateDistance49,currentAccumulateDistance50,currentAccumulateDistance51,48,49,50,51);
      smallest1_12<=smaller_temp1_12(13 DOWNTO 6);
	  smallest_index1_12<=smaller_temp1_12(5 DOWNTO 0);
   -- ELSE
      -- smallest_index1_12<=(OTHERS=>'0');
      -- smallest1_12<=(OTHERS=>'0');
      -- smaller_temp1_12:=(OTHERS=>'0');
   END IF; 
END IF;
END PROCESS;

PROCESS(clk,rst)
VARIABLE smaller_temp1_13 : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   smallest_index1_13<=(OTHERS=>'0');
   smallest1_13<=(OTHERS=>'0');
   smaller_temp1_13:=(OTHERS=>'0');
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_in_start='1')THEN
      smallest_index1_13<=(OTHERS=>'0');
      smallest1_13<=(OTHERS=>'0');
      smaller_temp1_13:=(OTHERS=>'0');
   END IF;
   IF(smaller1_en='1')THEN
      smaller_temp1_13:=smaller(currentAccumulateDistance52,currentAccumulateDistance53,currentAccumulateDistance54,currentAccumulateDistance55,52,53,54,55);
      smallest1_13<=smaller_temp1_13(13 DOWNTO 6);
	  smallest_index1_13<=smaller_temp1_13(5 DOWNTO 0);
   -- ELSE
      -- smallest_index1_13<=(OTHERS=>'0');
      -- smallest1_13<=(OTHERS=>'0');
      -- smaller_temp1_13:=(OTHERS=>'0');
   END IF; 
END IF;
END PROCESS;

PROCESS(clk,rst)
VARIABLE smaller_temp1_14 : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   smallest_index1_14<=(OTHERS=>'0');
   smallest1_14<=(OTHERS=>'0');
   smaller_temp1_14:=(OTHERS=>'0');
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_in_start='1')THEN
      smallest_index1_14<=(OTHERS=>'0');
      smallest1_14<=(OTHERS=>'0');
      smaller_temp1_14:=(OTHERS=>'0');
   END IF;
   IF(smaller1_en='1')THEN
      smaller_temp1_14:=smaller(currentAccumulateDistance56,currentAccumulateDistance57,currentAccumulateDistance58,currentAccumulateDistance59,56,57,58,59);
      smallest1_14<=smaller_temp1_14(13 DOWNTO 6);
	  smallest_index1_14<=smaller_temp1_14(5 DOWNTO 0);
   -- ELSE
      -- smallest_index1_14<=(OTHERS=>'0');
      -- smallest1_14<=(OTHERS=>'0');
      -- smaller_temp1_14:=(OTHERS=>'0');
   END IF; 
END IF;
END PROCESS;

PROCESS(clk,rst)
VARIABLE smaller_temp1_15 : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   smallest_index1_15<=(OTHERS=>'0');
   smallest1_15<=(OTHERS=>'0');
   smaller_temp1_15:=(OTHERS=>'0');
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_in_start='1')THEN
      smallest_index1_15<=(OTHERS=>'0');
      smallest1_15<=(OTHERS=>'0');
      smaller_temp1_15:=(OTHERS=>'0');
   END IF;
   IF(smaller1_en='1')THEN
      smaller_temp1_15:=smaller(currentAccumulateDistance60,currentAccumulateDistance61,currentAccumulateDistance62,currentAccumulateDistance63,60,61,62,63);
      smallest1_15<=smaller_temp1_15(13 DOWNTO 6);
	  smallest_index1_15<=smaller_temp1_15(5 DOWNTO 0);
   -- ELSE
      -- smallest_index1_15<=(OTHERS=>'0');
      -- smallest1_15<=(OTHERS=>'0');
      -- smaller_temp1_15:=(OTHERS=>'0');
   END IF; 
END IF;
END PROCESS;

--------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------第2级的16选4比较，每个进程4选一，有4个进程的比较------------------------------------------------


PROCESS(clk,rst)
VARIABLE smaller_temp2_0 : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   smallest_index2_0<=(OTHERS=>'0');
   smallest2_0<=(OTHERS=>'0');
   smaller_temp2_0:=(OTHERS=>'0');
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_in_start='1')THEN
      smallest_index2_0<=(OTHERS=>'0');
      smallest2_0<=(OTHERS=>'0');
      smaller_temp2_0:=(OTHERS=>'0');
   END IF;
   IF(smaller2_en='1')THEN
      smaller_temp2_0:=smaller(smallest1_0,smallest1_1,smallest1_2,smallest1_3,conv_integer(smallest_index1_0),conv_integer(smallest_index1_1),conv_integer(smallest_index1_2),conv_integer(smallest_index1_3));
      smallest2_0<=smaller_temp2_0(13 DOWNTO 6);
	  smallest_index2_0<=smaller_temp2_0(5 DOWNTO 0);
   -- ELSE
      -- smaller_temp2_0:=(OTHERS=>'0');
	  -- smallest2_0<=(OTHERS=>'0');
	  -- smallest_index2_0<=(OTHERS=>'0');
   END IF; 
END IF;
END PROCESS;

PROCESS(clk,rst)
VARIABLE smaller_temp2_1 : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   smaller_temp2_1:=(OTHERS=>'0');
   smallest2_1<=(OTHERS=>'0');
   smallest_index2_1<=(OTHERS=>'0');
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_in_start='1')THEN
      smaller_temp2_1:=(OTHERS=>'0');
      smallest2_1<=(OTHERS=>'0');
      smallest_index2_1<=(OTHERS=>'0');
   END IF;
   IF(smaller2_en='1')THEN
      smaller_temp2_1:=smaller(smallest1_4,smallest1_5,smallest1_6,smallest1_7,conv_integer(smallest_index1_4),conv_integer(smallest_index1_5),conv_integer(smallest_index1_6),conv_integer(smallest_index1_7));
      smallest2_1<=smaller_temp2_1(13 DOWNTO 6);
	  smallest_index2_1<=smaller_temp2_1(5 DOWNTO 0);
   -- ELSE
      -- smaller_temp2_1:=(OTHERS=>'0');
	  -- smallest2_1<=(OTHERS=>'0');
	  -- smallest_index2_1<=(OTHERS=>'0');
   END IF; 
END IF;
END PROCESS;

PROCESS(clk,rst)
VARIABLE smaller_temp2_2 : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   smaller_temp2_2:=(OTHERS=>'0');
   smallest2_2<=(OTHERS=>'0');
   smallest_index2_2<=(OTHERS=>'0');
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_in_start='1')THEN
      smaller_temp2_2:=(OTHERS=>'0');
      smallest2_2<=(OTHERS=>'0');
      smallest_index2_2<=(OTHERS=>'0');
   END IF;
   IF(smaller2_en='1')THEN
      smaller_temp2_2:=smaller(smallest1_8,smallest1_9,smallest1_10,smallest1_11,conv_integer(smallest_index1_8 ),conv_integer(smallest_index1_9 ),conv_integer(smallest_index1_10),conv_integer(smallest_index1_11));
      smallest2_2<=smaller_temp2_2(13 DOWNTO 6);
	  smallest_index2_2<=smaller_temp2_2(5 DOWNTO 0);
   -- ELSE
      -- smaller_temp2_2:=(OTHERS=>'0');
	  -- smallest2_2<=(OTHERS=>'0');
	  -- smallest_index2_2<=(OTHERS=>'0');
   END IF; 
END IF;
END PROCESS;

PROCESS(clk,rst)
VARIABLE smaller_temp2_3 : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   smallest_index2_3<=(OTHERS=>'0');
   smallest2_3<=(OTHERS=>'0');
   smaller_temp2_3:=(OTHERS=>'0');
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_in_start='1')THEN
      smallest_index2_3<=(OTHERS=>'0');
      smallest2_3<=(OTHERS=>'0');
      smaller_temp2_3:=(OTHERS=>'0');
   END IF;
   IF(smaller2_en='1')THEN
      smaller_temp2_3:=smaller(smallest1_12,smallest1_13,smallest1_14,smallest1_15,conv_integer(smallest_index1_12),conv_integer(smallest_index1_13),conv_integer(smallest_index1_14),conv_integer(smallest_index1_15));
      smallest2_3<=smaller_temp2_3(13 DOWNTO 6);
	  smallest_index2_3<=smaller_temp2_3(5 DOWNTO 0);
   -- ELSE
      -- smallest_index2_3<=(OTHERS=>'0');
      -- smallest2_3<=(OTHERS=>'0');
      -- smaller_temp2_3:=(OTHERS=>'0');
   END IF; 
END IF;
END PROCESS;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------第3级4选1的比较，1个进程-------------------------------------------------------------------------------------------------
PROCESS(clk,rst)
VARIABLE smaller_temp : STD_LOGIC_VECTOR(13 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   smallest_index_r<=(OTHERS=>'0');
   smallest<=(OTHERS=>'0');
   smaller_temp:=(OTHERS=>'0');
   smallest_index_r_valid<='0';
ELSIF(clk 'EVENT AND clk='1')THEN
   IF(viterbi_in_start='1')THEN
	  smallest_index_r<=(OTHERS=>'0');
	  smallest<=(OTHERS=>'0');
	  smaller_temp:=(OTHERS=>'0');
	  smallest_index_r_valid<='0';
   END IF;
   
   IF(smaller_en='1')THEN
      smaller_temp:=smaller(smallest2_0,smallest2_1,smallest2_2,smallest2_3,conv_integer(smallest_index2_0),conv_integer(smallest_index2_1),conv_integer(smallest_index2_2),conv_integer(smallest_index2_3));
      smallest<=smaller_temp(13 DOWNTO 6);
	  smallest_index_r<=smaller_temp(5 DOWNTO 0);
	  smallest_index_r_valid<='1';
   ELSE
      -- smallest_index_r<=(OTHERS=>'0');
      -- smallest<=(OTHERS=>'0');
      -- smaller_temp:=(OTHERS=>'0');
	  smallest_index_r_valid<='0';
   END IF; 
END IF;
END PROCESS;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

END arch_compare;