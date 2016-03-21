LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ram_trace_top IS
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
END ENTITY;

ARCHITECTURE Behavioral OF ram_trace_top IS

COMPONENT viterbi_mmu
PORT(
clk:IN STD_LOGIC;
rst:IN STD_LOGIC;
luckPath_begin : IN STD_LOGIC;
valid_in:IN STD_LOGIC;
input:IN STD_LOGIC_VECTOR(63 DOWNTO 0);
luckPath_end : IN STD_LOGIC;
output_1:OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
output_2:OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
output_3:OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
output_4:OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
out_begin : OUT STD_LOGIC;
out_end : OUT STD_LOGIC;
valid_out_1:OUT STD_LOGIC;
valid_out_2:OUT STD_LOGIC;
valid_out_3:OUT STD_LOGIC;
valid_out_4:OUT STD_LOGIC
);
END COMPONENT;

COMPONENT trace_controller
PORT(
clk:IN STD_LOGIC;
rst:IN STD_LOGIC;
data_in_1:IN STD_LOGIC_VECTOR(63 DOWNTO 0);
data_in_2:IN STD_LOGIC_VECTOR(63 DOWNTO 0);
data_in_3:IN STD_LOGIC_VECTOR(63 DOWNTO 0);
data_in_4:IN STD_LOGIC_VECTOR(63 DOWNTO 0);
data_valid_1:IN STD_LOGIC;
data_valid_2:IN STD_LOGIC;
data_valid_3:IN STD_LOGIC;
data_valid_4:IN STD_LOGIC;
min_state_in:IN STD_LOGIC_VECTOR(5 DOWNTO 0);
state_in_valid:IN STD_LOGIC;
min_state_out_1:OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
min_state_out_2:OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
state_valid_1:OUT STD_LOGIC;
state_valid_2:OUT STD_LOGIC;
data_out_1:OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
data_out_2:OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
data_1_valid:OUT STD_LOGIC;
data_2_valid:OUT STD_LOGIC
);
END COMPONENT;
COMPONENT trace
PORT(
clk:IN STD_LOGIC;
rst:IN STD_LOGIC;
trace_begin : IN STD_LOGIC;
trace_end : IN STD_LOGIC;
trace_en_1:IN STD_LOGIC;
trace_en_2:IN STD_LOGIC;
trace_in_1:IN STD_LOGIC_VECTOR(63 DOWNTO 0);
trace_in_2:IN STD_LOGIC_VECTOR(63 DOWNTO 0);
min_state_1:IN STD_LOGIC_VECTOR(5 DOWNTO 0);
min_state_2:IN STD_LOGIC_VECTOR(5 DOWNTO 0);
state_valid_1:IN STD_LOGIC;
state_valid_2:IN STD_LOGIC;
viterbi_out_begin:OUT STD_LOGIC;
viterbi_out:OUT STD_LOGIC;
viterbi_out_valid:OUT STD_LOGIC;
viterbi_out_end:OUT STD_LOGIC
);
END COMPONENT;
----------------------------------------------
SIGNAL data_in_1:STD_LOGIC_VECTOR(63 DOWNTO 0);
SIGNAL data_in_2:STD_LOGIC_VECTOR(63 DOWNTO 0);
SIGNAL data_in_3:STD_LOGIC_VECTOR(63 DOWNTO 0);
SIGNAL data_in_4:STD_LOGIC_VECTOR(63 DOWNTO 0);
SIGNAL data_valid_1:STD_LOGIC;
SIGNAL data_valid_2:STD_LOGIC;
SIGNAL data_valid_3:STD_LOGIC;
SIGNAL data_valid_4:STD_LOGIC;
SIGNAL trace_en_1:STD_LOGIC;
SIGNAL trace_en_2:STD_LOGIC;
SIGNAL trace_in_1:STD_LOGIC_VECTOR(63 DOWNTO 0);
SIGNAL trace_in_2:STD_LOGIC_VECTOR(63 DOWNTO 0);
SIGNAL min_state_1:STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL min_state_2:STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL state_valid_1:STD_LOGIC;
SIGNAL state_valid_2:STD_LOGIC;

SIGNAL trace_begin : STD_LOGIC;
SIGNAL trace_end : STD_LOGIC;
----------------------------------------------
BEGIN

U_ram_mmu:viterbi_mmu PORT MAP
(
 clk=>clk,
 rst=>rst,
 luckPath_begin=>luckPath_begin,
 valid_in=>valid_in,
 input=>mmu_input,
 luckPath_end => luckPath_end,
 output_1=>data_in_1,
 output_2=>data_in_2,
 output_3=>data_in_3,
 output_4=>data_in_4,
 out_begin =>trace_begin,
 out_end   =>trace_end,
 valid_out_1=>data_valid_1,
 valid_out_2=>data_valid_2,
 valid_out_3=>data_valid_3,
 valid_out_4=>data_valid_4
);

U_trace_controller:trace_controller PORT MAP
(
 clk=>clk,
 rst=>rst,
 data_in_1=>data_in_1,
 data_in_2=>data_in_2,
 data_in_3=>data_in_3,
 data_in_4=>data_in_4,
 data_valid_1=>data_valid_1,
 data_valid_2=>data_valid_2,
 data_valid_3=>data_valid_3,
 data_valid_4=>data_valid_4,
 min_state_in=>min_state_in,
 state_in_valid=>state_in_valid,
 min_state_out_1=>min_state_1,
 min_state_out_2=>min_state_2,
 state_valid_1=>state_valid_1,
 state_valid_2=>state_valid_2,
 data_out_1=>trace_in_1,
 data_out_2=>trace_in_2,
 data_1_valid=>trace_en_1,
 data_2_valid=>trace_en_2
);
U_trace:trace  PORT MAP
(
clk=>clk,
rst=>rst,
trace_begin =>trace_begin,
trace_end =>trace_end,
trace_en_1=>trace_en_1,
trace_en_2=>trace_en_2,
trace_in_1=>trace_in_1,
trace_in_2=>trace_in_2,
min_state_1=>min_state_1,
min_state_2=>min_state_2,
state_valid_1=>state_valid_1,
state_valid_2=>state_valid_2,
viterbi_out_begin=>viterbi_out_begin,
viterbi_out=>viterbi_out,
viterbi_out_valid=>viterbi_out_valid,
viterbi_out_end=>viterbi_out_end
);
END Behavioral;