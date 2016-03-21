LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
ENTITY viterbi_dis IS

PORT(
 clk:IN STD_LOGIC;
 rst:IN STD_LOGIC;
 dis_en:IN STD_LOGIC;
 dis_in_1:IN STD_LOGIC_VECTOR(3 DOWNTO 0); 
 dis_in_2:IN STD_LOGIC_VECTOR(3 DOWNTO 0);
 dis_out_0:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);--00
 dis_out_1:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);--01
 dis_out_2:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);--10
 dis_out_3:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);--11
 dis_out_valid:OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE arch_viterbi_dis OF viterbi_dis IS
---------------------------------------------------------
BEGIN
 PROCESS(clk,rst)
  BEGIN
    IF(rst='0')THEN
	     dis_out_0<=(OTHERS=>'0');
		  dis_out_1<=(OTHERS=>'0');
		  dis_out_2<=(OTHERS=>'0');
		  dis_out_3<=(OTHERS=>'0');
		  dis_out_valid<='0';
	ELSIF(clk'EVENT AND clk='1')THEN
	    IF(dis_en='1')THEN
			dis_out_0 <= "01110"+dis_in_1+dis_in_2;--00
			dis_out_1 <= "01110"+dis_in_1-dis_in_2;--01
			dis_out_2 <= "01110"-dis_in_1+dis_in_2;--10
			dis_out_3 <= "01110"-dis_in_1-dis_in_2;--11
			dis_out_valid<='1';
		ELSE
			dis_out_0<=(OTHERS=>'0');
			dis_out_1<=(OTHERS=>'0');
			dis_out_2<=(OTHERS=>'0');
			dis_out_3<=(OTHERS=>'0');
			dis_out_valid<='0';
		END IF;
	END IF;
  END PROCESS;

END arch_viterbi_dis;