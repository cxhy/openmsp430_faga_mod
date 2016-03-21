LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
ENTITY acsunit IS
PORT(
    acs_en     : IN STD_LOGIC;
	metric_in0 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	metric_in1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);   
	state_distance_in0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);	  
	state_distance_in1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);	
	smaller_distance_out: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	survivor_path: OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE arch_acs OF acsunit IS

SIGNAL out_temp : STD_LOGIC_VECTOR(8 DOWNTO 0);
 
FUNCTION acs(	state0 : STD_LOGIC_VECTOR;--branch_metric0
				branch0 : STD_LOGIC_VECTOR;--s_paststate(paststate)
				state1 : STD_LOGIC_VECTOR; --branch_metric1
				branch1 : STD_LOGIC_VECTOR --s_paststate(paststate_32)
                 )
RETURN STD_LOGIC_VECTOR IS
VARIABLE temp0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
VARIABLE temp1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
VARIABLE value_1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
VARIABLE u_or_l : STD_LOGIC;
VARIABLE temp_out : STD_LOGIC_VECTOR(8 DOWNTO 0);

BEGIN
temp0 := state0+branch0;
temp1 := state1+branch1;
IF(temp0 <= temp1) THEN
	value_1 := temp0;
    u_or_l := '0';
ELSE
    value_1 := temp1;
    u_or_l := '1';
END IF;
temp_out := value_1&u_or_l;
RETURN temp_out;
END FUNCTION;
 
BEGIN
   WITH acs_en SELECT
	out_temp<=acs(state_distance_in0,metric_in0,state_distance_in1,metric_in1) WHEN '1',
	UNAFFECTED                                                                 WHEN OTHERS;
	
   WITH acs_en SELECT
	smaller_distance_out<=out_temp(8 DOWNTO 1) WHEN '1',
	UNAFFECTED   	                           WHEN OTHERS;
	
   WITH acs_en SELECT
	survivor_path<=out_temp(0) WHEN '1',
	UNAFFECTED                 WHEN OTHERS;                                                
	
END arch_acs;