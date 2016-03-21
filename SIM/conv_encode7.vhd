LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY conv_encode7 IS
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
END ENTITY;

ARCHITECTURE arch_con OF conv_encode7 IS

SIGNAL data_flag : STD_LOGIC;
SIGNAL encode_data : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL encode_data_valid : STD_LOGIC;
SIGNAL encode_data_begin : STD_LOGIC;
SIGNAL encode_data_begin_r : STD_LOGIC;
SIGNAL encode_data_end : STD_LOGIC;

SIGNAL zero:std_logic;
FUNCTION conv (conv_reg : STD_LOGIC_VECTOR ; data : STD_LOGIC) RETURN STD_LOGIC_VECTOR IS--卷积函数
VARIABLE conv_out : STD_LOGIC_VECTOR(1 DOWNTO 0);
VARIABLE reg : STD_LOGIC_VECTOR(5 DOWNTO 0);
VARIABLE temp_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
   conv_out(0):=data XOR conv_reg(1) XOR conv_reg(2) XOR conv_reg(4) XOR conv_reg(5);----卷积后的低位数据
   conv_out(1):=data XOR conv_reg(0) XOR conv_reg(1) XOR conv_reg(2) XOR conv_reg(5);---卷积后的高位数据
   reg(5 DOWNTO 1):=conv_reg(4 DOWNTO 0);--卷积移位寄存�  
   reg(0):=data;
   temp_out := reg & conv_out;---移位寄存器和产生的输出一起输出，由调用者利用输出的寄存器的值，再做补零操作
RETURN temp_out;
END FUNCTION;

BEGIN
  PROCESS(clk,rst)
  VARIABLE encode_reg : STD_LOGIC_VECTOR(5 DOWNTO 0);
  VARIABLE cnt : INTEGER RANGE 0 TO 6 :=0;
  VARIABLE fill_zero_en : STD_LOGIC ;
  VARIABLE temp_0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
  VARIABLE temp : STD_LOGIC_VECTOR(7 DOWNTO 0); 
  BEGIN
   IF(rst='0') THEN
       encode_reg:=(OTHERS=>'0');
	   encode_data<=(OTHERS=>'0');
	   encode_data_valid<='0';
	   cnt:=0;
	   fill_zero_en:='0';
	   zero<='0';
	   temp:=(OTHERS=>'0');
	   temp_0:=(OTHERS=>'0');
   ELSIF(clk 'EVENT AND clk='1')THEN
      IF(encode_start='1')THEN
	     encode_reg:=(OTHERS=>'0');
		 encode_data<=(OTHERS=>'0');
		 encode_data_valid<='0';
		 cnt:=0;
		 zero<='0';
		 temp:=(OTHERS=>'0');
		 temp_0:=(OTHERS=>'0');
	     fill_zero_en:='0';
	  END IF;
	  IF(encode_end='1')THEN
	     fill_zero_en:='1';
	  END IF;
	  
	  IF(encode_in_en='1')THEN
         temp:=conv(encode_reg,encode_in);
		 encode_reg:=temp(7 DOWNTO 2);
		 encode_data<=temp(1 DOWNTO 0);
		 encode_data_valid<='1';
	  ELSE
	     encode_data<=(OTHERS=>'0');
	     encode_data_valid<='0';
	  END IF;
	  
     IF(fill_zero_en='1')THEN  
	   IF(cnt<6)THEN
 	      cnt:=cnt+1;
 	      temp_0:=conv(encode_reg,zero);
 	      encode_reg:=temp_0(7 DOWNTO 2);
 	      encode_data<=temp_0(1 DOWNTO 0);
	      encode_data_valid<='1';
 	   ELSE
 		  fill_zero_en:='0';
		  encode_data_end<='1';
		  cnt:=0;
		  encode_data<=(OTHERS=>'0');
		  encode_data_valid<='0';
 	   END IF;
	ELSE
	   encode_data_end<='0';
 	END IF;
  END IF;
END PROCESS;

PROCESS(clk,rst)
BEGIN
IF(rst='0')THEN
   data_flag<='0';
   encode_data_begin<='0';
ELSIF(clk 'EVENT AND clk='1')THEN
   encode_data_begin<=encode_data_valid;
   IF(encode_data_begin='1')THEN
      data_flag<='1';
   END IF;
   
   IF(encode_start='1')THEN
      data_flag<='0';
   END IF;
   
   encode_out<=encode_data;
   encode_out_valid<=encode_data_valid;
   encode_out_end<=encode_data_end;
END IF;
END PROCESS;

encode_out_begin<=encode_data_valid AND (NOT encode_data_begin) WHEN data_flag='0';
END arch_con;