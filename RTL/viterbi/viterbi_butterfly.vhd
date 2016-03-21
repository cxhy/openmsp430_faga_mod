LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;
ENTITY viterbi_butterfly IS
PORT(
     clk : IN STD_LOGIC;
	  rst : IN STD_LOGIC;
	  viterbi_in_start : IN STD_LOGIC;
	  viterbi_in_end : IN STD_LOGIC;
	  butiflies_en : IN STD_LOGIC;--使能
      Distance0 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);--00
	  Distance1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);--01
	  Distance2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);--10
	  Distance3 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);--11
	  luckPath_begin : OUT STD_LOGIC;
	  luckPath : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);--幸存路径
	  luckPath_valid : OUT STD_LOGIC;--幸存路径有效
	  luckPath_end : OUT STD_LOGIC;
	  smallest_index : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);--最小状态
	  smallest_index_valid : OUT STD_LOGIC--最小状态使能
    );
END ENTITY;

ARCHITECTURE arch_butiflies OF viterbi_butterfly IS

------------------------------------------------------------------------------------------
-------------------过去状态对应的累加值-------------------------------------------------
SIGNAL preAccumulateDistance0   : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance1   : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance2   : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance3   : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance4   : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance5   : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance6   : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance7   : STD_LOGIC_VECTOR(7 DOWNTO 0);
                                                   
SIGNAL preAccumulateDistance8   : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance9   : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance10  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance11  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance12  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance13  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance14  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance15  : STD_LOGIC_VECTOR(7 DOWNTO 0);
                                                   
SIGNAL preAccumulateDistance16  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance17  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance18  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance19  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance20  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance21  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance22  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance23  : STD_LOGIC_VECTOR(7 DOWNTO 0);
                                                   
SIGNAL preAccumulateDistance24  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance25  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance26  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance27  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance28  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance29  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance30  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance31  : STD_LOGIC_VECTOR(7 DOWNTO 0);
                                                   
SIGNAL preAccumulateDistance32  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance33  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance34  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance35  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance36  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance37  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance38  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance39  : STD_LOGIC_VECTOR(7 DOWNTO 0);
                                                   
SIGNAL preAccumulateDistance40  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance41  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance42  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance43  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance44  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance45  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance46  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance47  : STD_LOGIC_VECTOR(7 DOWNTO 0);
                                                   
SIGNAL preAccumulateDistance48  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance49  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance50  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance51  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance52  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance53  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance54  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance55  : STD_LOGIC_VECTOR(7 DOWNTO 0);
                                                   
SIGNAL preAccumulateDistance56  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance57  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance58  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance59  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance60  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance61  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance62  : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL preAccumulateDistance63  : STD_LOGIC_VECTOR(7 DOWNTO 0);
--------------------------------------------------------------------------------------------
---由于最小状态输出落后于幸存路径输出三个周期，所以把幸存路径的值打上三拍，和最小状态的值同时输出-------
SIGNAL luckPath_t : STD_LOGIC_VECTOR(63 DOWNTO 0);
signal luckpath_r:STD_LOGIC_VECTOR(63 DOWNTO 0);
signal luckpath_rr:STD_LOGIC_VECTOR(63 DOWNTO 0);
signal luckpath_rrr:STD_LOGIC_VECTOR(63 DOWNTO 0);

signal luckpath_valid_r:std_logic;
signal luckpath_valid_rr:std_logic;
signal luckpath_valid_rrr:std_logic;
--------------------------------------------------------------------------------------------
-----------------当前状态对应的累加值-----------------------------------------------------						
SIGNAL currentAccumulateDistance0  :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance1  :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance2  :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance3  :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance4  :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance5  :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance6  :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance7  :  STD_LOGIC_VECTOR(7 DOWNTO 0);                                        
SIGNAL currentAccumulateDistance8  :  STD_LOGIC_VECTOR(7 DOWNTO 0);
                                                       
SIGNAL currentAccumulateDistance9  :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance10 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance11 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance12 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance13 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance14 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance15 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
                                                       
SIGNAL currentAccumulateDistance16 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance17 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance18 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance19 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance20 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance21 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance22 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance23 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
                                                       
SIGNAL currentAccumulateDistance24 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance25 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance26 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance27 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance28 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance29 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance30 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance31 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
                                                       
SIGNAL currentAccumulateDistance32 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance33 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance34 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance35 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance36 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance37 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance38 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance39 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
                                                       
SIGNAL currentAccumulateDistance40 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance41 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance42 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance43 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance44 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance45 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance46 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance47 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
                                                       
SIGNAL currentAccumulateDistance48 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance49 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance50 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance51 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance52 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance53 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance54 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance55 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
                                                       
SIGNAL currentAccumulateDistance56 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance57 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance58 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance59 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance60 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance61 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance62 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL currentAccumulateDistance63 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
-----------------------------------------------------------------------
-------供最小状态比较模块的使能信号---------------------------------------
SIGNAl smallest : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL smallest_index_r : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL smallest_index_r_valid : STD_LOGIC;
SIGNAl smaller1_en : STD_LOGIC;
SIGNAL smaller2_en : STD_LOGIC;
SIGNAL smaller_en  : STD_LOGIC;
-----------------------------------------------------------------------
--------判断在不同的情况下，选择输出最小状态值需要的信号---------------------
SIGNAL acscounter : INTEGER RANGE 0 TO 2047;
SIGNAL counter : INTEGER RANGE 0 TO 2047;
SIGNAL state_out_en : STD_LOGIC;
SIGNAL flag : STD_LOGIC;
SIGNAL flag_r : STD_LOGIC;
SIGNAL flag_rr : STD_LOGIC;
SIGNAL s : STD_LOGIC;
SIGNAL s_r : STD_LOGIC;
SIGNAL s_rr : STD_LOGIC;

SIGNAL luckPath_begin_r1 : STD_LOGIC;
SIGNAL luckPath_begin_r2 : STD_LOGIC;
SIGNAL luckPath_begin_r3 : STD_LOGIC;
SIGNAL luckPath_begin_r4 : STD_LOGIC;
SIGNAL luckPath_end_r1 : STD_LOGIC;
SIGNAL luckPath_end_r2 : STD_LOGIC;
SIGNAL luckPath_end_r3 : STD_LOGIC;
SIGNAL luckPath_end_r4 :STD_LOGIC;
--------------------------------------------------------------------------------------------------
------------基二模块的较小值和幸存路径的输出---------------------------------------------------------- 

COMPONENT acsunit
PORT(
      acs_en     : IN STD_LOGIC;
	  metric_in0 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);--对应的软距离的值
	  metric_in1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);--对应的软距离的值   
     state_distance_in0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);--s状态的累加值	  
	  state_distance_in1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);--s+32状态的累加值	
	  smaller_distance_out: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);--较小累加状态值输出
	  survivor_path: OUT STD_LOGIC--幸存路径输出
    );
END COMPONENT;

---------------------------------------------------------------------------------------------------
----------------对每个周期的64个当前状态的累加值做流水线最小状态的比较----------------------------------------------
COMPONENT compare 
PORT(
     clk : IN STD_LOGIC;
	  rst : IN STD_LOGIC;
	  viterbi_in_start : IN STD_LOGIC;
	  smaller1_en  : IN STD_LOGIC;--第一次64选16的比较使能
	  smaller2_en  : IN STD_LOGIC;--第二次16选4的比较使能
	  smaller_en   : IN STD_LOGIC;--第三次4选1的比较使能
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
	  
	  smallest         : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);--最小状态值
	  smallest_index_r : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);--最小状态值对应的状态
	  smallest_index_r_valid : OUT STD_LOGIC--最小状态的有效
    );
END COMPONENT;
-------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
BEGIN
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------（2,1,7）译码的核心单元，64个基二加比选组成，根据（2,1,7）蝶形单元图可以看出每一级都有64条幸存路径，128条路径，在过去两条累加值s，S+32比较出较小累加值重新赋值给当前状态累加值----------------------------------------------------------------------------------------------------------
 
 acsunit0   :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance0 ,  metric_in1 => Distance3,   state_distance_in0 =>preAccumulateDistance0,	 state_distance_in1 =>preAccumulateDistance32,   smaller_distance_out => currentAccumulateDistance0,   survivor_path => luckPath_t(0));                                              
 acsunit1   :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance3 ,  metric_in1 => Distance0,   state_distance_in0 =>preAccumulateDistance0,	 state_distance_in1 =>preAccumulateDistance32,   smaller_distance_out => currentAccumulateDistance1,   survivor_path => luckPath_t(1));
 acsunit2   :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance2 ,  metric_in1 => Distance1,   state_distance_in0 =>preAccumulateDistance1,	 state_distance_in1 =>preAccumulateDistance33,   smaller_distance_out => currentAccumulateDistance2,   survivor_path => luckPath_t(2));
 acsunit3   :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance1 ,  metric_in1 => Distance2,   state_distance_in0 =>preAccumulateDistance1,	 state_distance_in1 =>preAccumulateDistance33,   smaller_distance_out => currentAccumulateDistance3,   survivor_path => luckPath_t(3));
 acsunit4   :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance3 ,  metric_in1 => Distance0,   state_distance_in0 =>preAccumulateDistance2,	 state_distance_in1 =>preAccumulateDistance34,   smaller_distance_out => currentAccumulateDistance4,   survivor_path => luckPath_t(4));
 acsunit5   :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance0 ,  metric_in1 => Distance3,   state_distance_in0 =>preAccumulateDistance2,   state_distance_in1 =>preAccumulateDistance34,   smaller_distance_out => currentAccumulateDistance5,   survivor_path => luckPath_t(5));
 acsunit6   :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance1 ,  metric_in1 => Distance2,   state_distance_in0 =>preAccumulateDistance3,   state_distance_in1 =>preAccumulateDistance35,   smaller_distance_out => currentAccumulateDistance6,   survivor_path => luckPath_t(6));
 acsunit7   :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance2 ,  metric_in1 => Distance1,   state_distance_in0 =>preAccumulateDistance3,   state_distance_in1 =>preAccumulateDistance35,   smaller_distance_out => currentAccumulateDistance7,   survivor_path => luckPath_t(7));
                                                                                                                                                                                                                                                   
 acsunit8   :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance3 ,  metric_in1 => Distance0,   state_distance_in0 =>preAccumulateDistance4,   state_distance_in1 =>preAccumulateDistance36,   smaller_distance_out => currentAccumulateDistance8,   survivor_path => luckPath_t(8));
 acsunit9   :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance0 ,  metric_in1 => Distance3,   state_distance_in0 =>preAccumulateDistance4,   state_distance_in1 =>preAccumulateDistance36,   smaller_distance_out => currentAccumulateDistance9,   survivor_path => luckPath_t(9));
 acsunit10  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance1 ,  metric_in1 => Distance2,   state_distance_in0 =>preAccumulateDistance5,   state_distance_in1 =>preAccumulateDistance37,   smaller_distance_out => currentAccumulateDistance10,  survivor_path => luckPath_t(10));
 acsunit11  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance2 ,  metric_in1 => Distance1,   state_distance_in0 =>preAccumulateDistance5,   state_distance_in1 =>preAccumulateDistance37,   smaller_distance_out => currentAccumulateDistance11,  survivor_path => luckPath_t(11));
 acsunit12  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance0 ,  metric_in1 => Distance3,   state_distance_in0 =>preAccumulateDistance6,   state_distance_in1 =>preAccumulateDistance38,   smaller_distance_out => currentAccumulateDistance12,  survivor_path => luckPath_t(12));
 acsunit13  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance3 ,  metric_in1 => Distance0,   state_distance_in0 =>preAccumulateDistance6,   state_distance_in1 =>preAccumulateDistance38,   smaller_distance_out => currentAccumulateDistance13,  survivor_path => luckPath_t(13));
 acsunit14  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance2 ,  metric_in1 => Distance1,   state_distance_in0 =>preAccumulateDistance7,   state_distance_in1 =>preAccumulateDistance39,   smaller_distance_out => currentAccumulateDistance14,  survivor_path => luckPath_t(14));
 acsunit15  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance1 ,  metric_in1 => Distance2,   state_distance_in0 =>preAccumulateDistance7,   state_distance_in1 =>preAccumulateDistance39,   smaller_distance_out => currentAccumulateDistance15,  survivor_path => luckPath_t(15));
                                                                                                                                                                                                                                                  
 acsunit16  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance0 ,  metric_in1 => Distance3,   state_distance_in0 =>preAccumulateDistance8,   state_distance_in1 =>preAccumulateDistance40,   smaller_distance_out => currentAccumulateDistance16,  survivor_path => luckPath_t(16));
 acsunit17  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance3 ,  metric_in1 => Distance0,   state_distance_in0 =>preAccumulateDistance8,   state_distance_in1 =>preAccumulateDistance40,   smaller_distance_out => currentAccumulateDistance17,  survivor_path => luckPath_t(17));
 acsunit18  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance2 ,  metric_in1 => Distance1,   state_distance_in0 =>preAccumulateDistance9,   state_distance_in1 =>preAccumulateDistance41,   smaller_distance_out => currentAccumulateDistance18,  survivor_path => luckPath_t(18));
 acsunit19  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance1 ,  metric_in1 => Distance2,   state_distance_in0 =>preAccumulateDistance9,   state_distance_in1 =>preAccumulateDistance41,   smaller_distance_out => currentAccumulateDistance19,  survivor_path => luckPath_t(19));
 acsunit20  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance3 ,  metric_in1 => Distance0,   state_distance_in0 =>preAccumulateDistance10,  state_distance_in1 =>preAccumulateDistance42,   smaller_distance_out => currentAccumulateDistance20,  survivor_path => luckPath_t(20));
 acsunit21  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance0 ,  metric_in1 => Distance3,   state_distance_in0 =>preAccumulateDistance10,  state_distance_in1 =>preAccumulateDistance42,   smaller_distance_out => currentAccumulateDistance21,  survivor_path => luckPath_t(21));
 acsunit22  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance1 ,  metric_in1 => Distance2,   state_distance_in0 =>preAccumulateDistance11,  state_distance_in1 =>preAccumulateDistance43,   smaller_distance_out => currentAccumulateDistance22,  survivor_path => luckPath_t(22));
 acsunit23  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance2 ,  metric_in1 => Distance1,   state_distance_in0 =>preAccumulateDistance11,  state_distance_in1 =>preAccumulateDistance43,   smaller_distance_out => currentAccumulateDistance23,  survivor_path => luckPath_t(23));
                                                                                                                                                                                                                                              
 acsunit24  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance3 ,  metric_in1 => Distance0,   state_distance_in0 =>preAccumulateDistance12,  state_distance_in1 =>preAccumulateDistance44,   smaller_distance_out => currentAccumulateDistance24,  survivor_path => luckPath_t(24));
 acsunit25  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance0 ,  metric_in1 => Distance3,   state_distance_in0 =>preAccumulateDistance12,  state_distance_in1 =>preAccumulateDistance44,   smaller_distance_out => currentAccumulateDistance25,  survivor_path => luckPath_t(25));
 acsunit26  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance1 ,  metric_in1 => Distance2,   state_distance_in0 =>preAccumulateDistance13,  state_distance_in1 =>preAccumulateDistance45,   smaller_distance_out => currentAccumulateDistance26,  survivor_path => luckPath_t(26));
 acsunit27  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance2 ,  metric_in1 => Distance1,   state_distance_in0 =>preAccumulateDistance13,  state_distance_in1 =>preAccumulateDistance45,   smaller_distance_out => currentAccumulateDistance27,  survivor_path => luckPath_t(27));
 acsunit28  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance0 ,  metric_in1 => Distance3,   state_distance_in0 =>preAccumulateDistance14,  state_distance_in1 =>preAccumulateDistance46,   smaller_distance_out => currentAccumulateDistance28,  survivor_path => luckPath_t(28));
 acsunit29  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance3 ,  metric_in1 => Distance0,   state_distance_in0 =>preAccumulateDistance14,  state_distance_in1 =>preAccumulateDistance46,   smaller_distance_out => currentAccumulateDistance29,  survivor_path => luckPath_t(29));
 acsunit30  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance2 ,  metric_in1 => Distance1,   state_distance_in0 =>preAccumulateDistance15,  state_distance_in1 =>preAccumulateDistance47,   smaller_distance_out => currentAccumulateDistance30,  survivor_path => luckPath_t(30));
 acsunit31  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance1 ,  metric_in1 => Distance2,   state_distance_in0 =>preAccumulateDistance15,  state_distance_in1 =>preAccumulateDistance47,   smaller_distance_out => currentAccumulateDistance31,  survivor_path => luckPath_t(31));
                                                                                                                                                                                                                                                      
 acsunit32  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance1 ,  metric_in1 => Distance2,   state_distance_in0 =>preAccumulateDistance16,  state_distance_in1 =>preAccumulateDistance48,   smaller_distance_out => currentAccumulateDistance32,  survivor_path => luckPath_t(32));
 acsunit33  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance2 ,  metric_in1 => Distance1,   state_distance_in0 =>preAccumulateDistance16,  state_distance_in1 =>preAccumulateDistance48,   smaller_distance_out => currentAccumulateDistance33,  survivor_path => luckPath_t(33));
 acsunit34  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance3 ,  metric_in1 => Distance0,   state_distance_in0 =>preAccumulateDistance17,  state_distance_in1 =>preAccumulateDistance49,   smaller_distance_out => currentAccumulateDistance34,  survivor_path => luckPath_t(34));
 acsunit35  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance0 ,  metric_in1 => Distance3,   state_distance_in0 =>preAccumulateDistance17,  state_distance_in1 =>preAccumulateDistance49,   smaller_distance_out => currentAccumulateDistance35,  survivor_path => luckPath_t(35));
 acsunit36  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance2 ,  metric_in1 => Distance1,   state_distance_in0 =>preAccumulateDistance18,  state_distance_in1 =>preAccumulateDistance50,   smaller_distance_out => currentAccumulateDistance36,  survivor_path => luckPath_t(36));
 acsunit37  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance1 ,  metric_in1 => Distance2,   state_distance_in0 =>preAccumulateDistance18,  state_distance_in1 =>preAccumulateDistance50,   smaller_distance_out => currentAccumulateDistance37,  survivor_path => luckPath_t(37));
 acsunit38  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance0 ,  metric_in1 => Distance3,   state_distance_in0 =>preAccumulateDistance19,  state_distance_in1 =>preAccumulateDistance51,   smaller_distance_out => currentAccumulateDistance38,  survivor_path => luckPath_t(38));
 acsunit39  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance3 ,  metric_in1 => Distance0,   state_distance_in0 =>preAccumulateDistance19,  state_distance_in1 =>preAccumulateDistance51,   smaller_distance_out => currentAccumulateDistance39,  survivor_path => luckPath_t(39));
                                                                                                                                                                                                                                                          
 acsunit40  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance2 ,  metric_in1 => Distance1,   state_distance_in0 =>preAccumulateDistance20,  state_distance_in1 =>preAccumulateDistance52,   smaller_distance_out => currentAccumulateDistance40,  survivor_path => luckPath_t(40));
 acsunit41  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance1 ,  metric_in1 => Distance2,   state_distance_in0 =>preAccumulateDistance20,  state_distance_in1 =>preAccumulateDistance52,   smaller_distance_out => currentAccumulateDistance41,  survivor_path => luckPath_t(41));
 acsunit42  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance0 ,  metric_in1 => Distance3,   state_distance_in0 =>preAccumulateDistance21,  state_distance_in1 =>preAccumulateDistance53,   smaller_distance_out => currentAccumulateDistance42,  survivor_path => luckPath_t(42));
 acsunit43  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance3 ,  metric_in1 => Distance0,   state_distance_in0 =>preAccumulateDistance21,  state_distance_in1 =>preAccumulateDistance53,   smaller_distance_out => currentAccumulateDistance43,  survivor_path => luckPath_t(43));
 acsunit44  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance1 ,  metric_in1 => Distance2,   state_distance_in0 =>preAccumulateDistance22,  state_distance_in1 =>preAccumulateDistance54,   smaller_distance_out => currentAccumulateDistance44,  survivor_path => luckPath_t(44));
 acsunit45  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance2 ,  metric_in1 => Distance1,   state_distance_in0 =>preAccumulateDistance22,  state_distance_in1 =>preAccumulateDistance54,   smaller_distance_out => currentAccumulateDistance45,  survivor_path => luckPath_t(45));
 acsunit46  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance3 ,  metric_in1 => Distance0,   state_distance_in0 =>preAccumulateDistance23,  state_distance_in1 =>preAccumulateDistance55,   smaller_distance_out => currentAccumulateDistance46,  survivor_path => luckPath_t(46));
 acsunit47  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance0 ,  metric_in1 => Distance3,   state_distance_in0 =>preAccumulateDistance23,  state_distance_in1 =>preAccumulateDistance55,   smaller_distance_out => currentAccumulateDistance47,  survivor_path => luckPath_t(47));
                                                                                                                                                                                                                                                     
 acsunit48  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance1 ,  metric_in1 => Distance2,   state_distance_in0 =>preAccumulateDistance24,  state_distance_in1 =>preAccumulateDistance56,   smaller_distance_out => currentAccumulateDistance48,  survivor_path => luckPath_t(48));
 acsunit49  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance2 ,  metric_in1 => Distance1,   state_distance_in0 =>preAccumulateDistance24,  state_distance_in1 =>preAccumulateDistance56,   smaller_distance_out => currentAccumulateDistance49,  survivor_path => luckPath_t(49));
 acsunit50  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance3 ,  metric_in1 => Distance0,   state_distance_in0 =>preAccumulateDistance25,  state_distance_in1 =>preAccumulateDistance57,   smaller_distance_out => currentAccumulateDistance50,  survivor_path => luckPath_t(50));
 acsunit51  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance0 ,  metric_in1 => Distance3,   state_distance_in0 =>preAccumulateDistance25,  state_distance_in1 =>preAccumulateDistance57,   smaller_distance_out => currentAccumulateDistance51,  survivor_path => luckPath_t(51));
 acsunit52  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance2 ,  metric_in1 => Distance1,   state_distance_in0 =>preAccumulateDistance26,  state_distance_in1 =>preAccumulateDistance58,   smaller_distance_out => currentAccumulateDistance52,  survivor_path => luckPath_t(52));
 acsunit53  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance1 ,  metric_in1 => Distance2,   state_distance_in0 =>preAccumulateDistance26,  state_distance_in1 =>preAccumulateDistance58,   smaller_distance_out => currentAccumulateDistance53,  survivor_path => luckPath_t(53));
 acsunit54  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance0 ,  metric_in1 => Distance3,   state_distance_in0 =>preAccumulateDistance27,  state_distance_in1 =>preAccumulateDistance59,   smaller_distance_out => currentAccumulateDistance54,  survivor_path => luckPath_t(54));
 acsunit55  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance3 ,  metric_in1 => Distance0,   state_distance_in0 =>preAccumulateDistance27,  state_distance_in1 =>preAccumulateDistance59,   smaller_distance_out => currentAccumulateDistance55,  survivor_path => luckPath_t(55));
                                                                                                                                                                                                                                                    
 acsunit56  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance2 ,  metric_in1 => Distance1,   state_distance_in0 =>preAccumulateDistance28,  state_distance_in1 =>preAccumulateDistance60,   smaller_distance_out => currentAccumulateDistance56,  survivor_path => luckPath_t(56));
 acsunit57  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance1 ,  metric_in1 => Distance2,   state_distance_in0 =>preAccumulateDistance28,  state_distance_in1 =>preAccumulateDistance60,   smaller_distance_out => currentAccumulateDistance57,  survivor_path => luckPath_t(57));
 acsunit58  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance0 ,  metric_in1 => Distance3,   state_distance_in0 =>preAccumulateDistance29,  state_distance_in1 =>preAccumulateDistance61,   smaller_distance_out => currentAccumulateDistance58,  survivor_path => luckPath_t(58));
 acsunit59  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance3 ,  metric_in1 => Distance0,   state_distance_in0 =>preAccumulateDistance29,  state_distance_in1 =>preAccumulateDistance61,   smaller_distance_out => currentAccumulateDistance59,  survivor_path => luckPath_t(59));
 acsunit60  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance1 ,  metric_in1 => Distance2,   state_distance_in0 =>preAccumulateDistance30,  state_distance_in1 =>preAccumulateDistance62,   smaller_distance_out => currentAccumulateDistance60,  survivor_path => luckPath_t(60));
 acsunit61  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance2 ,  metric_in1 => Distance1,   state_distance_in0 =>preAccumulateDistance30,  state_distance_in1 =>preAccumulateDistance62,   smaller_distance_out => currentAccumulateDistance61,  survivor_path => luckPath_t(61));
 acsunit62  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance3 ,  metric_in1 => Distance0,   state_distance_in0 =>preAccumulateDistance31,  state_distance_in1 =>preAccumulateDistance63,   smaller_distance_out => currentAccumulateDistance62,  survivor_path => luckPath_t(62));
 acsunit63  :  acsunit PORT MAP(acs_en => butiflies_en , metric_in0 => Distance0 ,  metric_in1 => Distance3,   state_distance_in0 =>preAccumulateDistance31,  state_distance_in1 =>preAccumulateDistance63,   smaller_distance_out => currentAccumulateDistance63,  survivor_path => luckPath_t(63));
 

 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------
-------------------------------------
u_compare : compare PORT MAP
  (
     clk => clk,
	  rst => rst,
	  viterbi_in_start => viterbi_in_start,
	  smaller1_en  => smaller1_en,
	  smaller2_en  => smaller2_en,
	  smaller_en   => smaller_en,
	  currentAccumulateDistance0  => currentAccumulateDistance0  ,
	  currentAccumulateDistance1  => currentAccumulateDistance1  ,
	  currentAccumulateDistance2  => currentAccumulateDistance2  ,
	  currentAccumulateDistance3  => currentAccumulateDistance3  ,
	  currentAccumulateDistance4  => currentAccumulateDistance4  ,
	  currentAccumulateDistance5  => currentAccumulateDistance5  ,
	  currentAccumulateDistance6  => currentAccumulateDistance6  ,
	  currentAccumulateDistance7  => currentAccumulateDistance7  ,
	                               
	  currentAccumulateDistance8  => currentAccumulateDistance8  ,                       
	  currentAccumulateDistance9  => currentAccumulateDistance9  ,
	  currentAccumulateDistance10 => currentAccumulateDistance10 ,
	  currentAccumulateDistance11 => currentAccumulateDistance11 ,
	  currentAccumulateDistance12 => currentAccumulateDistance12 ,
	  currentAccumulateDistance13 => currentAccumulateDistance13 ,
	  currentAccumulateDistance14 => currentAccumulateDistance14 ,
	  currentAccumulateDistance15 => currentAccumulateDistance15 ,
	                               
	  currentAccumulateDistance16 => currentAccumulateDistance16 ,
	  currentAccumulateDistance17 => currentAccumulateDistance17 ,
	  currentAccumulateDistance18 => currentAccumulateDistance18 ,
	  currentAccumulateDistance19 => currentAccumulateDistance19 ,
	  currentAccumulateDistance20 => currentAccumulateDistance20 ,
	  currentAccumulateDistance21 => currentAccumulateDistance21 ,
	  currentAccumulateDistance22 => currentAccumulateDistance22 ,
	  currentAccumulateDistance23 => currentAccumulateDistance23 ,
	                               
	  currentAccumulateDistance24 => currentAccumulateDistance24 ,
	  currentAccumulateDistance25 => currentAccumulateDistance25 ,
	  currentAccumulateDistance26 => currentAccumulateDistance26 ,
	  currentAccumulateDistance27 => currentAccumulateDistance27 ,
	  currentAccumulateDistance28 => currentAccumulateDistance28 ,
	  currentAccumulateDistance29 => currentAccumulateDistance29 ,
	  currentAccumulateDistance30 => currentAccumulateDistance30 ,
	  currentAccumulateDistance31 => currentAccumulateDistance31 ,
	                         
	  currentAccumulateDistance32 => currentAccumulateDistance32 ,
	  currentAccumulateDistance33 => currentAccumulateDistance33 ,
	  currentAccumulateDistance34 => currentAccumulateDistance34 ,
	  currentAccumulateDistance35 => currentAccumulateDistance35 ,
	  currentAccumulateDistance36 => currentAccumulateDistance36 ,
	  currentAccumulateDistance37 => currentAccumulateDistance37 ,
	  currentAccumulateDistance38 => currentAccumulateDistance38 ,
	  currentAccumulateDistance39 => currentAccumulateDistance39 ,
	                         
	  currentAccumulateDistance40 => currentAccumulateDistance40 ,
	  currentAccumulateDistance41 => currentAccumulateDistance41 ,
	  currentAccumulateDistance42 => currentAccumulateDistance42 ,
	  currentAccumulateDistance43 => currentAccumulateDistance43 ,
	  currentAccumulateDistance44 => currentAccumulateDistance44 ,
	  currentAccumulateDistance45 => currentAccumulateDistance45 ,
	  currentAccumulateDistance46 => currentAccumulateDistance46 ,
	  currentAccumulateDistance47 => currentAccumulateDistance47 ,
	                        
	  currentAccumulateDistance48 => currentAccumulateDistance48 ,
	  currentAccumulateDistance49 => currentAccumulateDistance49 ,
	  currentAccumulateDistance50 => currentAccumulateDistance50 ,
	  currentAccumulateDistance51 => currentAccumulateDistance51 ,
	  currentAccumulateDistance52 => currentAccumulateDistance52 ,
	  currentAccumulateDistance53 => currentAccumulateDistance53 ,
	  currentAccumulateDistance54 => currentAccumulateDistance54 ,
	  currentAccumulateDistance55 => currentAccumulateDistance55 ,
	                          
	  currentAccumulateDistance56 => currentAccumulateDistance56 ,
	  currentAccumulateDistance57 => currentAccumulateDistance57 ,
	  currentAccumulateDistance58 => currentAccumulateDistance58 ,
	  currentAccumulateDistance59 => currentAccumulateDistance59 ,
	  currentAccumulateDistance60 => currentAccumulateDistance60 ,
	  currentAccumulateDistance61 => currentAccumulateDistance61 ,
	  currentAccumulateDistance62 => currentAccumulateDistance62 ,
	  currentAccumulateDistance63 => currentAccumulateDistance63 ,
	  
	  smallest  =>smallest,
	  smallest_index_r => smallest_index_r,
	  smallest_index_r_valid => smallest_index_r_valid
    );
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
PROCESS(clk,rst)
BEGIN
IF(rst='0')THEN
  acscounter<=0;
  flag<='0';
  s<='0';
ELSIF(clk 'EVENT AND clk='1')THEN
  IF(viterbi_in_start='1')THEN
    acscounter<=0;
	flag<='1';
    s<='0';
  END IF;
  IF(viterbi_in_end='1')THEN
    s<='1';
	flag<='0';
  END IF;
  
  IF(flag='1' AND s='0')THEN
    IF(butiflies_en='1')THEN
      CASE acscounter IS
        WHEN 63 => acscounter<=0;
 	    WHEN OTHERS => acscounter<=acscounter + 1;
 	  END CASE;
    END IF;
  END IF;
END IF;
END PROCESS;

PROCESS(clk,rst)
VARIABLE acs_reduce : STD_LOGIC_VECTOR(11 DOWNTO 0);
BEGIN
IF(rst='0')THEN
   luckPath_valid_r<='0';	
   luckPath_r<=(OTHERS=>'0');
   preAccumulateDistance0    <= "00000000";  
   preAccumulateDistance1    <= "00111111";
   preAccumulateDistance2    <= "00111111";
   preAccumulateDistance3    <= "00111111";
   preAccumulateDistance4    <= "00111111";
   preAccumulateDistance5    <= "00111111";
   preAccumulateDistance6    <= "00111111";
   preAccumulateDistance7    <= "00111111";
   preAccumulateDistance8    <= "00111111";
   preAccumulateDistance9    <= "00111111";
   preAccumulateDistance10   <= "00111111";
   preAccumulateDistance11   <= "00111111";
   preAccumulateDistance12   <= "00111111";
   preAccumulateDistance13   <= "00111111";
   preAccumulateDistance14   <= "00111111";
   preAccumulateDistance15   <= "00111111";
   preAccumulateDistance16   <= "00111111";
   preAccumulateDistance17   <= "00111111";
   preAccumulateDistance18   <= "00111111";
   preAccumulateDistance19   <= "00111111";
   preAccumulateDistance20   <= "00111111";
   preAccumulateDistance21   <= "00111111";
   preAccumulateDistance22   <= "00111111";
   preAccumulateDistance23   <= "00111111";
   preAccumulateDistance24   <= "00111111";
   preAccumulateDistance25   <= "00111111";
   preAccumulateDistance26   <= "00111111";
   preAccumulateDistance27   <= "00111111";
   preAccumulateDistance28   <= "00111111";
   preAccumulateDistance29   <= "00111111";
   preAccumulateDistance30   <= "00111111";
   preAccumulateDistance31   <= "00111111";
   preAccumulateDistance32   <= "00111111";
   preAccumulateDistance33   <= "00111111";
   preAccumulateDistance34   <= "00111111";
   preAccumulateDistance35   <= "00111111";
   preAccumulateDistance36   <= "00111111";
   preAccumulateDistance37   <= "00111111";
   preAccumulateDistance38   <= "00111111";
   preAccumulateDistance39   <= "00111111";
   preAccumulateDistance40   <= "00111111";
   preAccumulateDistance41   <= "00111111";
   preAccumulateDistance42   <= "00111111";
   preAccumulateDistance43   <= "00111111";
   preAccumulateDistance44   <= "00111111";
   preAccumulateDistance45   <= "00111111";
   preAccumulateDistance46   <= "00111111";
   preAccumulateDistance47   <= "00111111";
   preAccumulateDistance48   <= "00111111";
   preAccumulateDistance49   <= "00111111";
   preAccumulateDistance50   <= "00111111";
   preAccumulateDistance51   <= "00111111";
   preAccumulateDistance52   <= "00111111";
   preAccumulateDistance53   <= "00111111";
   preAccumulateDistance54   <= "00111111";
   preAccumulateDistance55   <= "00111111";
   preAccumulateDistance56   <= "00111111";
   preAccumulateDistance57   <= "00111111";
   preAccumulateDistance58   <= "00111111";
   preAccumulateDistance59   <= "00111111";
   preAccumulateDistance60   <= "00111111";
   preAccumulateDistance61   <= "00111111";
   preAccumulateDistance62   <= "00111111";
   preAccumulateDistance63   <= "00111111";
ELSIF(clk 'EVENT AND clk='1')THEN
 IF(viterbi_in_start='1')THEN
    ----------------------------------------------------------------------------------------------------------
-------初始状态设置第一个状态值为0，后63个状态值都为63，为了第一次比较开始是从0状态开始的--------------------------	
          luckPath_valid_r<='0';	
		  luckPath_r<=(OTHERS=>'0');
	      preAccumulateDistance0    <= "00000000";  
          preAccumulateDistance1    <= "00111111";
	      preAccumulateDistance2    <= "00111111";
	      preAccumulateDistance3    <= "00111111";
          preAccumulateDistance4    <= "00111111";
	      preAccumulateDistance5    <= "00111111";
	      preAccumulateDistance6    <= "00111111";
          preAccumulateDistance7    <= "00111111";
	      preAccumulateDistance8    <= "00111111";
	      preAccumulateDistance9    <= "00111111";
          preAccumulateDistance10   <= "00111111";
          preAccumulateDistance11   <= "00111111";
	      preAccumulateDistance12   <= "00111111";
	      preAccumulateDistance13   <= "00111111";
          preAccumulateDistance14   <= "00111111";
	      preAccumulateDistance15   <= "00111111";
	      preAccumulateDistance16   <= "00111111";
          preAccumulateDistance17   <= "00111111";
	      preAccumulateDistance18   <= "00111111";
	      preAccumulateDistance19   <= "00111111";
	      preAccumulateDistance20   <= "00111111";
          preAccumulateDistance21   <= "00111111";
	      preAccumulateDistance22   <= "00111111";
	      preAccumulateDistance23   <= "00111111";
          preAccumulateDistance24   <= "00111111";
	      preAccumulateDistance25   <= "00111111";
	      preAccumulateDistance26   <= "00111111";
          preAccumulateDistance27   <= "00111111";
	      preAccumulateDistance28   <= "00111111";
	      preAccumulateDistance29   <= "00111111";
	      preAccumulateDistance30   <= "00111111";
          preAccumulateDistance31   <= "00111111";
	      preAccumulateDistance32   <= "00111111";
	      preAccumulateDistance33   <= "00111111";
          preAccumulateDistance34   <= "00111111";
	      preAccumulateDistance35   <= "00111111";
	      preAccumulateDistance36   <= "00111111";
          preAccumulateDistance37   <= "00111111";
	      preAccumulateDistance38   <= "00111111";
	      preAccumulateDistance39   <= "00111111";
	      preAccumulateDistance40   <= "00111111";
          preAccumulateDistance41   <= "00111111";
	      preAccumulateDistance42   <= "00111111";
	      preAccumulateDistance43   <= "00111111";
          preAccumulateDistance44   <= "00111111";
	      preAccumulateDistance45   <= "00111111";
	      preAccumulateDistance46   <= "00111111";
          preAccumulateDistance47   <= "00111111";
	      preAccumulateDistance48   <= "00111111";
	      preAccumulateDistance49   <= "00111111";
	      preAccumulateDistance50   <= "00111111";
          preAccumulateDistance51   <= "00111111";
	      preAccumulateDistance52   <= "00111111";
	      preAccumulateDistance53   <= "00111111";
          preAccumulateDistance54   <= "00111111";
	      preAccumulateDistance55   <= "00111111";
	      preAccumulateDistance56   <= "00111111";
          preAccumulateDistance57   <= "00111111";
	      preAccumulateDistance58   <= "00111111";
	      preAccumulateDistance59   <= "00111111";
	      preAccumulateDistance60   <= "00111111";
          preAccumulateDistance61   <= "00111111";
	      preAccumulateDistance62   <= "00111111";
	      preAccumulateDistance63   <= "00111111";
		  ---------------------------------------------------------------------------------
		  ---------------------------------------------------------------------------------
 END IF;

 IF(flag='1' AND s='0')THEN
   IF(butiflies_en='1')THEN
      luckPath_valid_r<='1';--幸存路径有效
      luckPath_r<=luckPath_t;--幸存路径
	  acs_reduce:=conv_std_logic_vector(acscounter,12);
      IF(acs_reduce(1 DOWNTO 0)="11")THEN    
      -----------------------------------------------------------------------------------------------
      -----为了避免寄存器的溢出，采用每4个周期减去最小状态值，所有的状态累加值控制在8个位宽以内---------------
     		preAccumulateDistance0    <= currentAccumulateDistance0   - smallest;	 
     		preAccumulateDistance1    <= currentAccumulateDistance1   - smallest;	
     		preAccumulateDistance2    <= currentAccumulateDistance2   - smallest;	
     		preAccumulateDistance3    <= currentAccumulateDistance3   - smallest;	
     		preAccumulateDistance4    <= currentAccumulateDistance4   - smallest;	
     		preAccumulateDistance5    <= currentAccumulateDistance5   - smallest;	
     		preAccumulateDistance6    <= currentAccumulateDistance6   - smallest;	
     		preAccumulateDistance7    <= currentAccumulateDistance7   - smallest;	
     		preAccumulateDistance8    <= currentAccumulateDistance8   - smallest;	
     		preAccumulateDistance9    <= currentAccumulateDistance9   - smallest;	
     		preAccumulateDistance10   <= currentAccumulateDistance10  - smallest;	
     		preAccumulateDistance11   <= currentAccumulateDistance11  - smallest;	
     		preAccumulateDistance12   <= currentAccumulateDistance12  - smallest;	
     		preAccumulateDistance13   <= currentAccumulateDistance13  - smallest;	
     		preAccumulateDistance14   <= currentAccumulateDistance14  - smallest;	
     		preAccumulateDistance15   <= currentAccumulateDistance15  - smallest;	
     		preAccumulateDistance16   <= currentAccumulateDistance16  - smallest;	
     		preAccumulateDistance17   <= currentAccumulateDistance17  - smallest;	
     		preAccumulateDistance18   <= currentAccumulateDistance18  - smallest;	
     		preAccumulateDistance19   <= currentAccumulateDistance19  - smallest;	
     		preAccumulateDistance20   <= currentAccumulateDistance20  - smallest;	
     		preAccumulateDistance21   <= currentAccumulateDistance21  - smallest;	
     		preAccumulateDistance22   <= currentAccumulateDistance22  - smallest;	
     		preAccumulateDistance23   <= currentAccumulateDistance23  - smallest;	
     		preAccumulateDistance24   <= currentAccumulateDistance24  - smallest;	
     		preAccumulateDistance25   <= currentAccumulateDistance25  - smallest;	
     		preAccumulateDistance26   <= currentAccumulateDistance26  - smallest;	
     		preAccumulateDistance27   <= currentAccumulateDistance27  - smallest;	
     		preAccumulateDistance28   <= currentAccumulateDistance28  - smallest;	
     		preAccumulateDistance29   <= currentAccumulateDistance29  - smallest;	
     		preAccumulateDistance30   <= currentAccumulateDistance30  - smallest;	
     		preAccumulateDistance31   <= currentAccumulateDistance31  - smallest;	
     		preAccumulateDistance32   <= currentAccumulateDistance32  - smallest;	
     		preAccumulateDistance33   <= currentAccumulateDistance33  - smallest;	
     		preAccumulateDistance34   <= currentAccumulateDistance34  - smallest;	
     		preAccumulateDistance35   <= currentAccumulateDistance35  - smallest;	
     		preAccumulateDistance36   <= currentAccumulateDistance36  - smallest;	
     		preAccumulateDistance37   <= currentAccumulateDistance37  - smallest;	
     		preAccumulateDistance38   <= currentAccumulateDistance38  - smallest;	
     		preAccumulateDistance39   <= currentAccumulateDistance39  - smallest;	
     		preAccumulateDistance40   <= currentAccumulateDistance40  - smallest;	
     		preAccumulateDistance41   <= currentAccumulateDistance41  - smallest;	
     		preAccumulateDistance42   <= currentAccumulateDistance42  - smallest;	
     		preAccumulateDistance43   <= currentAccumulateDistance43  - smallest;	
     		preAccumulateDistance44   <= currentAccumulateDistance44  - smallest;	
     		preAccumulateDistance45   <= currentAccumulateDistance45  - smallest;	
     		preAccumulateDistance46   <= currentAccumulateDistance46  - smallest;	
     		preAccumulateDistance47   <= currentAccumulateDistance47  - smallest;	
     		preAccumulateDistance48   <= currentAccumulateDistance48  - smallest;	
     		preAccumulateDistance49   <= currentAccumulateDistance49  - smallest;	
     		preAccumulateDistance50   <= currentAccumulateDistance50  - smallest;	
     		preAccumulateDistance51   <= currentAccumulateDistance51  - smallest;	
     		preAccumulateDistance52   <= currentAccumulateDistance52  - smallest;	
     		preAccumulateDistance53   <= currentAccumulateDistance53  - smallest;	
     		preAccumulateDistance54   <= currentAccumulateDistance54  - smallest;	
     		preAccumulateDistance55   <= currentAccumulateDistance55  - smallest;	
     		preAccumulateDistance56   <= currentAccumulateDistance56  - smallest;	
     		preAccumulateDistance57   <= currentAccumulateDistance57  - smallest;	
     		preAccumulateDistance58   <= currentAccumulateDistance58  - smallest;	
     		preAccumulateDistance59   <= currentAccumulateDistance59  - smallest;	
     		preAccumulateDistance60   <= currentAccumulateDistance60  - smallest;	
     		preAccumulateDistance61   <= currentAccumulateDistance61  - smallest;	
     		preAccumulateDistance62   <= currentAccumulateDistance62  - smallest;	
     		preAccumulateDistance63   <= currentAccumulateDistance63  - smallest;		
     	-----------------------------------------------------------------------------------------------------
     	-----------------------------------------------------------------------------------------------------
     	ELSE  
     	----------------------------------------------------------------------------------------------------
     	----------比较过后的当前状态累加值重新赋值给过去状态参与蝶形图的输入---------------------------------------
     	   preAccumulateDistance0    <= currentAccumulateDistance0  ;
     	   preAccumulateDistance1    <= currentAccumulateDistance1  ;
     	   preAccumulateDistance2    <= currentAccumulateDistance2  ;
     	   preAccumulateDistance3    <= currentAccumulateDistance3  ;
     	   preAccumulateDistance4    <= currentAccumulateDistance4  ;
     	   preAccumulateDistance5    <= currentAccumulateDistance5  ;
     	   preAccumulateDistance6    <= currentAccumulateDistance6  ;
     	   preAccumulateDistance7    <= currentAccumulateDistance7  ;
     	   preAccumulateDistance8    <= currentAccumulateDistance8  ;
     	   preAccumulateDistance9    <= currentAccumulateDistance9  ;
     	   preAccumulateDistance10   <= currentAccumulateDistance10 ;
     	   preAccumulateDistance11   <= currentAccumulateDistance11 ;
     	   preAccumulateDistance12   <= currentAccumulateDistance12 ;
     	   preAccumulateDistance13   <= currentAccumulateDistance13 ;
     	   preAccumulateDistance14   <= currentAccumulateDistance14 ;
     	   preAccumulateDistance15   <= currentAccumulateDistance15 ;
     	   preAccumulateDistance16   <= currentAccumulateDistance16 ;
     	   preAccumulateDistance17   <= currentAccumulateDistance17 ;
     	   preAccumulateDistance18   <= currentAccumulateDistance18 ;
     	   preAccumulateDistance19   <= currentAccumulateDistance19 ;
     	   preAccumulateDistance20   <= currentAccumulateDistance20 ;
     	   preAccumulateDistance21   <= currentAccumulateDistance21 ;
     	   preAccumulateDistance22   <= currentAccumulateDistance22 ;
     	   preAccumulateDistance23   <= currentAccumulateDistance23 ;
     	   preAccumulateDistance24   <= currentAccumulateDistance24 ;
     	   preAccumulateDistance25   <= currentAccumulateDistance25 ;
     	   preAccumulateDistance26   <= currentAccumulateDistance26 ;
     	   preAccumulateDistance27   <= currentAccumulateDistance27 ;
     	   preAccumulateDistance28   <= currentAccumulateDistance28 ;
     	   preAccumulateDistance29   <= currentAccumulateDistance29 ;
     	   preAccumulateDistance30   <= currentAccumulateDistance30 ;
     	   preAccumulateDistance31   <= currentAccumulateDistance31 ;
     	   preAccumulateDistance32   <= currentAccumulateDistance32 ;
     	   preAccumulateDistance33   <= currentAccumulateDistance33 ;
     	   preAccumulateDistance34   <= currentAccumulateDistance34 ;
     	   preAccumulateDistance35   <= currentAccumulateDistance35 ;
     	   preAccumulateDistance36   <= currentAccumulateDistance36 ;
     	   preAccumulateDistance37   <= currentAccumulateDistance37 ;
     	   preAccumulateDistance38   <= currentAccumulateDistance38 ;
     	   preAccumulateDistance39   <= currentAccumulateDistance39 ;
     	   preAccumulateDistance40   <= currentAccumulateDistance40 ;
     	   preAccumulateDistance41   <= currentAccumulateDistance41 ;
     	   preAccumulateDistance42   <= currentAccumulateDistance42 ;
     	   preAccumulateDistance43   <= currentAccumulateDistance43 ;
     	   preAccumulateDistance44   <= currentAccumulateDistance44 ;
     	   preAccumulateDistance45   <= currentAccumulateDistance45 ;
     	   preAccumulateDistance46   <= currentAccumulateDistance46 ;
     	   preAccumulateDistance47   <= currentAccumulateDistance47 ;
     	   preAccumulateDistance48   <= currentAccumulateDistance48 ;
     	   preAccumulateDistance49   <= currentAccumulateDistance49 ;
     	   preAccumulateDistance50   <= currentAccumulateDistance50 ;
     	   preAccumulateDistance51   <= currentAccumulateDistance51 ;
     	   preAccumulateDistance52   <= currentAccumulateDistance52 ;
     	   preAccumulateDistance53   <= currentAccumulateDistance53 ;
     	   preAccumulateDistance54   <= currentAccumulateDistance54 ;
     	   preAccumulateDistance55   <= currentAccumulateDistance55 ;
     	   preAccumulateDistance56   <= currentAccumulateDistance56 ;
     	   preAccumulateDistance57   <= currentAccumulateDistance57 ;
     	   preAccumulateDistance58   <= currentAccumulateDistance58 ;
     	   preAccumulateDistance59   <= currentAccumulateDistance59 ;
     	   preAccumulateDistance60   <= currentAccumulateDistance60 ;
     	   preAccumulateDistance61   <= currentAccumulateDistance61 ;
     	   preAccumulateDistance62   <= currentAccumulateDistance62 ;
     	   preAccumulateDistance63   <= currentAccumulateDistance63 ;
        END IF;   	  
   ELSE
       luckPath_valid_r<='0';
       luckPath_r<=(OTHERS=>'0');	   
   END IF;  
 ELSE 
    luckPath_valid_r<='0';
    luckPath_r<=(OTHERS=>'0');	
 END IF;
END IF;                                           
END PROCESS;

---------------------------------------------------------------------------------------------
------为了和最小状态同时输出，特地做了三个周期的延时-----------------------------------------------
PROCESS(clk,rst)
BEGIN
 IF(rst='0')THEN
	luckpath<=(OTHERS=>'0');
	luckpath_rr<=(OTHERS=>'0');
	luckpath_rrr<=(OTHERS=>'0');
	luckpath_valid<='0';
	luckpath_valid_rr<='0';
	luckpath_valid_rrr<='0';
 ELSIF(clk'EVENT AND  clk='1')THEN
	luckpath_rr<=luckpath_r;
	luckpath_rrr<=luckpath_rr;
	luckpath<=luckpath_rrr;
	luckpath_valid_rr<=luckpath_valid_r;
	luckpath_valid_rrr<=luckpath_valid_rr;
	luckpath_valid<=luckpath_valid_rrr;
 END IF;
END PROCESS;

PROCESS(clk,rst)
BEGIN
IF(rst='0')THEN
   luckPath_begin_r1<='0';
   luckPath_begin_r2<='0';
   luckPath_begin_r3<='0';
   luckPath_begin_r4<='0';
   luckPath_begin<='0';
   luckPath_end_r1<='0';
   luckPath_end_r2<='0';
   luckPath_end_r3<='0';
   luckPath_end_r4<='0';
   luckPath_end<='0';
ELSIF(clk 'EVENT AND clk='1')THEN
   luckPath_begin_r1<=viterbi_in_start;
   luckPath_begin_r2<=luckPath_begin_r1;
   luckPath_begin_r3<=luckPath_begin_r2;
   luckPath_begin_r4<=luckPath_begin_r3;
   luckPath_begin<=luckPath_begin_r4;
   luckPath_end_r1<=viterbi_in_end;
   luckPath_end_r2<=luckPath_end_r1;
   luckPath_end_r3<=luckPath_end_r2;
   luckPath_end_r4<=luckPath_end_r3;
   luckPath_end<=luckPath_end_r4;
END IF;
END PROCESS;

-------------------------------------------------------------------------------------------
---------------------采用流水线模式比较比较64的状态的最小值的一些使能信号处理--------------------
smaller1_en<=butiflies_en;--64选16使能信号
PROCESS(clk,rst)
BEGIN
IF(rst='0')THEN
  smaller2_en<='0';--16选4使能信号
  smaller_en<='0';--4选1的使能信号
ELSIF(clk 'EVENT AND clk='1')THEN
  smaller2_en<=smaller1_en;
  smaller_en<=smaller2_en;
END IF;
END PROCESS;
     
-----------------------------------------------------------------------------------------------------------------
----------为了满足回溯需要，当数据长度大于64的时候，第一次在64的时刻送状态值，而后每32个周期的时刻送状态值-------------------
PROCESS(clk,rst)
VARIABLE k : STD_LOGIC;
BEGIN
IF(rst='0')THEN
  counter<=0;
  k:='0';
ELSIF(clk 'EVENT AND clk='1')THEN
  IF(flag_rr='1' AND s_rr='0')THEN
    IF(smallest_index_r_valid='1')THEN
      CASE counter IS
        WHEN 63 => counter<=0;
 	    WHEN OTHERS => counter<=counter + 1;
 	  END CASE;
 	  IF(counter=63)THEN
 	     k:='1';
 	  END IF;
    END IF;
  END IF;
  
	IF(s_rr='1')THEN
 	    counter<=counter + 1;
 		IF(k='1')THEN
 		  IF(counter=31)THEN
 			 counter<=0;
 		  ELSIF(counter=63)THEN
 			 counter<=0;
 		  END IF;
 		ELSE
 		  IF(counter=63)THEN
 			 counter<=0;
 		  END IF;
 	    END IF;
    END IF;
END IF;
END PROCESS;
---------------------------------------------------------------------------------------------------------
--------------------这个进程主要就是控制最小状态开始输出的使能，当数据长度为64,96,128....的时候，踩到最小状态值----
PROCESS(clk,rst)
VARIABLE j : STD_LOGIC;
-- VARIABLE k : STD_LOGIC;
BEGIN
IF(rst='0')THEN
  j:='0';
  state_out_en<='0';
  -- k:='0';
ELSIF(clk 'EVENT AND clk='1')THEN
  IF(flag_rr='1' AND s_rr='0')THEN
    IF(smallest_index_r_valid='1')THEN
        IF(j='0')THEN
           -- IF(counter=63)THEN
   	        -- k:='1';
           -- END IF;
   	       -- IF(k='1')THEN
   	   	      IF(counter=62)THEN
   	   		     state_out_en<='1';
   	   		     j:='1';
              ELSE 
   	   		     state_out_en<='0';
              END IF;
   	   	   -- END IF;
        ELSE
           IF(counter=30 OR counter=62)THEN
   	         state_out_en<='1';
   	       ELSE 
   	         state_out_en<='0';
   	       END IF;
   	    END IF;
    END IF;
  END IF;
  
	IF(s_rr='1')THEN
       IF(counter=30 OR counter=62)THEN
   	     state_out_en<='1';
   	   ELSE 
   	     state_out_en<='0';
   	   END IF;
	   
	   -- IF(j='1')THEN
 	      -- IF(acscounter=33 OR acscounter=1)THEN
 	   	     -- state_out_en<='1';
 	      -- ELSE 
		     -- state_out_en<='0';
 	      -- END IF;
       -- ELSE
 	      -- IF(acscounter=1)THEN
 	   	    -- state_out_en<='1';
		  -- ELSE
		    -- state_out_en<='0';
 	      -- END IF;
 	   -- END IF;   	
	
    END IF;
END IF;
END PROCESS;

PROCESS(clk,rst)
BEGIN
IF(rst='0')THEN
   s_r<='0';
   s_rr<='0';
   flag_r<='0';
   flag_rr<='0';
ELSIF(clk 'EVENT AND clk='1')THEN
   s_r<=s;
   s_rr<=s_r;
   flag_r<=flag;
   flag_rr<=flag_r;
END IF;
END PROCESS;
----------------------------------------------------------------------------------
-----这个进程控制，当数据长度不满64的时候，在第64时刻送状态0，当到达状态采样时刻的时候，就送最小状态值，其余时刻都是0状态供给回溯模块使用----------
PROCESS(clk,rst)
VARIABLE k : STD_LOGIC;
BEGIN
IF(rst='0')THEN
  smallest_index<=(OTHERS=>'0');
  smallest_index_valid<='0';
ELSIF(clk 'EVENT AND clk='1')THEN		 
	IF(flag_rr='1' AND s_rr='0')THEN
	  IF(state_out_en='1')THEN
	    IF(smallest_index_r_valid='1')THEN
		 smallest_index<=smallest_index_r;
		 smallest_index_valid<='1';
		END IF;
	  ELSE
	     smallest_index<=(OTHERS=>'0');
	     smallest_index_valid<='0';
	  END IF;
	END IF;
	
	IF(s_rr='1')THEN
	  IF(state_out_en='1')THEN
        smallest_index_valid<='1';
	    smallest_index<=(OTHERS=>'0');  
      ELSE
        smallest_index<=(OTHERS=>'0');
	    smallest_index_valid<='0';	  
	  END IF;
	END IF;
	
END IF;
END PROCESS;

--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
	  
END arch_butiflies;