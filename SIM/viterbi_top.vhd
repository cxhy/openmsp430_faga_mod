LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY viterbi_top IS
PORT(
clk:IN STD_LOGIC; ---系统的时钟信号
rst:IN STD_LOGIC; ---系统的复位信号
viterbi_in_start : IN STD_LOGIC;
viterbi_in_end : IN STD_LOGIC;
viterbi_in_0:IN STD_LOGIC_VECTOR(3 DOWNTO 0);---系统的数据输入端口1
viterbi_in_1:IN STD_LOGIC_VECTOR(3 DOWNTO 0);---系统的数据输入端口2
viterbi_in_valid:IN STD_LOGIC;---数据的有效信号
viterbi_out_begin:OUT STD_LOGIC;
viterbi_out: OUT STD_LOGIC;---viterbi的译码结果
viterbi_out_valid:OUT STD_LOGIC;---输出信号的有效信号
viterbi_out_end:OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE  Behavioral OF viterbi_top IS
SIGNAL Distance0:STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL Distance1:STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL Distance2:STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL Distance3:STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL dis_out_valid:STD_LOGIC;
-----------------------------------------------
SIGNAL survivor_smallest:STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL survivor_path:STD_LOGIC_VECTOR(63 DOWNTO 0);
SIGNAL path_valid:STD_LOGIC;
SIGNAL smallest_index : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL smallest_index_valid : STD_LOGIC;

SIGNAL luckPath_end : STD_LOGIC;
SIGNAL luckPath_begin : STD_LOGIC;
-----------------------------------------------
--分支路径的度量模块
-------------------------------------------------
COMPONENT viterbi_dis--DISģ��������
PORT(
 clk:IN STD_LOGIC;
 rst:IN STD_LOGIC;
 dis_en:IN STD_LOGIC;
 dis_in_1:IN STD_LOGIC_VECTOR(3 DOWNTO 0);
 dis_in_2:IN STD_LOGIC_VECTOR(3 DOWNTO 0);
 dis_out_0:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
 dis_out_1:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
 dis_out_2:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
 dis_out_3:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
 dis_out_valid:OUT STD_LOGIC
);
END COMPONENT;
----------------------------------------------------------
--
--viterbi译码的蝶形单元，幸存路径的累加，比较，选择模块
----------------------------------------------------------
COMPONENT viterbi_butterfly--ACSģ��������
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
END COMPONENT;
-------------------------------------------------------
--
--RAM模块、RAM的数据读取控制、回溯数据控制、回溯模块
-------------------------------------------------------
COMPONENT ram_trace_top
PORT(
clk:IN STD_LOGIC;
rst:IN STD_LOGIC;
luckPath_begin : IN STD_LOGIC;
valid_in:IN STD_LOGIC;
mmu_input:IN STD_LOGIC_VECTOR(63 DOWNTO 0);
luckPath_end : IN STD_LOGIC;
min_state_in:IN STD_LOGIC_VECTOR(5 DOWNTO 0);
state_in_valid:IN STD_LOGIC;
viterbi_out_begin:OUT STD_LOGIC;
viterbi_out:OUT STD_LOGIC;
viterbi_out_valid:OUT STD_LOGIC;
viterbi_out_end:OUT STD_LOGIC
);
END COMPONENT;
BEGIN
 u_dis:viterbi_dis PORT MAP--DISģ����ӳ��
  (
  clk=>clk,
  rst=>rst,
  dis_en=>viterbi_in_valid,
  dis_in_1=>viterbi_in_0,
  dis_in_2=>viterbi_in_1,
  dis_out_0=>Distance0,
  dis_out_1=>Distance1,
  dis_out_2=>Distance2,
  dis_out_3=>Distance3,
  dis_out_valid=>dis_out_valid
  );
 u_butterfly:viterbi_butterfly PORT MAP--ACSģ����ӳ��
   (
     clk => clk,
	  rst => rst,
	  viterbi_in_start => viterbi_in_start,
	  viterbi_in_end => viterbi_in_end,
	  butiflies_en => dis_out_valid,
     Distance0 => Distance0,--00
	  Distance1 => Distance1,--01
	  Distance2 => Distance2,--10
	  Distance3 => Distance3,--11
	  luckPath_begin => luckPath_begin,
	  luckPath => survivor_path,
	  luckPath_valid => path_valid,
	  luckPath_end => luckPath_end,
	  smallest_index => smallest_index,
	  smallest_index_valid => smallest_index_valid
    );
  u_ram_trace_top:ram_trace_top PORT MAP
  (
    clk=>clk,
	 rst=>rst,
	 luckPath_begin=>luckPath_begin,
	 valid_in=>path_valid,
	 mmu_input=>survivor_path,
	 luckPath_end => luckPath_end,
	 min_state_in=>smallest_index,
	 state_in_valid=>smallest_index_valid,
	 viterbi_out_begin=>viterbi_out_begin,
	 viterbi_out=>viterbi_out,
	 viterbi_out_valid=>viterbi_out_valid,
	 viterbi_out_end=>viterbi_out_end
  );

END Behavioral;