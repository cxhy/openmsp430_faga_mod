LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
ENTITY viterbi_mmu IS
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
END ENTITY;

ARCHITECTURE Behavioral OF viterbi_mmu IS 
--------------------------------------------------------
--
--------------------------------------------------------
COMPONENT  controller_ram 
PORT(
clk:IN STD_LOGIC;
rst:IN STD_LOGIC;
mmu_begin : IN STD_LOGIC;
mmu_en:IN STD_LOGIC;--模块的使能信号以及acs输入的有效数据位
mmu_in:IN STD_LOGIC_VECTOR(63 DOWNTO 0);---acs模块数据的额输入端
mmu_end:IN STD_LOGIC;
mmu_ram_1:OUT STD_LOGIC_VECTOR(63 DOWNTO 0);--RAM数据的数据输出端
mmu_ram_2:OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
mmu_ram_3:OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
mmu_ram_4:OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
mmu_addr_1_in:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);--RAM写操作的地址
mmu_addr_2_in:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
mmu_addr_3_in:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
mmu_addr_4_in:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
mmu_addr_1_out:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);--RAM读操作的地址
mmu_addr_2_out:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
mmu_addr_3_out:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
mmu_addr_4_out:OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
mmu_ram_wr_1:OUT STD_LOGIC;--RAM的读写控制位
mmu_ram_wr_2:OUT STD_LOGIC;
mmu_ram_wr_3:OUT STD_LOGIC;
mmu_ram_wr_4:OUT STD_LOGIC;
mmu_out_begin : OUT STD_LOGIC;
mmu_out_end : OUT STD_LOGIC;
mmu_out_1_valid: OUT STD_LOGIC;--RAM的数据输出的有效位
mmu_out_2_valid: OUT STD_LOGIC;
mmu_out_3_valid: OUT STD_LOGIC;
mmu_out_4_valid: OUT STD_LOGIC
); 
END COMPONENT;
----------------------------------------------------
COMPONENT ram_32_64
PORT(
clk:IN STD_LOGIC;
wr:IN STD_LOGIC;
addr_in:IN STD_LOGIC_VECTOR(4 DOWNTO 0);
addr_out:IN STD_LOGIC_VECTOR(4 DOWNTO 0);
ram_in:IN STD_LOGIC_VECTOR(63 DOWNTO 0);
ram_out:OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
);
END COMPONENT;
-----------------------------------------------------

-----------------------------------------------------==
SIGNAL mmu_ram_1:STD_LOGIC_VECTOR(63 DOWNTO 0);
SIGNAL mmu_ram_2:STD_LOGIC_VECTOR(63 DOWNTO 0);
SIGNAL mmu_ram_3:STD_LOGIC_VECTOR(63 DOWNTO 0);
SIGNAL mmu_ram_4:STD_LOGIC_VECTOR(63 DOWNTO 0);
SIGNAL mmu_addr_1_in:STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL mmu_addr_2_in:STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL mmu_addr_3_in:STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL mmu_addr_4_in:STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL mmu_addr_1_out:STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL mmu_addr_2_out:STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL mmu_addr_3_out:STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL mmu_addr_4_out:STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL mmu_ram_wr_1:STD_LOGIC;
SIGNAL mmu_ram_wr_2:STD_LOGIC;
SIGNAL mmu_ram_wr_3:STD_LOGIC;
SIGNAL mmu_ram_wr_4:STD_LOGIC;

-------------------------------------------------------
BEGIN
U:controller_ram PORT MAP
(
  clk=>clk,
  rst=>rst,
  mmu_begin=>luckPath_begin,
  mmu_en=>valid_in,
  mmu_in=>input,
  mmu_end=>luckPath_end,
  mmu_ram_1=>mmu_ram_1,
  mmu_ram_2=>mmu_ram_2,
  mmu_ram_3=>mmu_ram_3,
  mmu_ram_4=>mmu_ram_4,
  mmu_addr_1_in=>mmu_addr_1_in,
  mmu_addr_2_in=>mmu_addr_2_in,
  mmu_addr_3_in=>mmu_addr_3_in,
  mmu_addr_4_in=>mmu_addr_4_in,
  mmu_addr_1_out=>mmu_addr_1_out,
  mmu_addr_2_out=>mmu_addr_2_out,
  mmu_addr_3_out=>mmu_addr_3_out,
  mmu_addr_4_out=>mmu_addr_4_out,
  mmu_ram_wr_1=>mmu_ram_wr_1,
  mmu_ram_wr_2=>mmu_ram_wr_2,
  mmu_ram_wr_3=>mmu_ram_wr_3,
  mmu_ram_wr_4=>mmu_ram_wr_4,
  mmu_out_begin =>out_begin,
  mmu_out_end =>out_end,
  mmu_out_1_valid=>valid_out_1,
  mmu_out_2_valid=>valid_out_2,
  mmu_out_3_valid=>valid_out_3,
  mmu_out_4_valid=>valid_out_4
);

------------------------------------------------------
U1_RAM_1: ram_32_64 PORT MAP
(
clk=>clk,
wr=>mmu_ram_wr_1,
addr_in=>mmu_addr_1_in,
addr_out=>mmu_addr_1_out,
ram_in=>mmu_ram_1,
ram_out=>output_1
);
---
U2_RAM_2: ram_32_64 PORT MAP
(
clk=>clk,
wr=>mmu_ram_wr_2,
addr_in=>mmu_addr_2_in,
addr_out=>mmu_addr_2_out,
ram_in=>mmu_ram_2,
ram_out=>output_2
);
---
U3_RAM_3: ram_32_64 PORT MAP
(
clk=>clk,
wr=>mmu_ram_wr_3,
addr_in=>mmu_addr_3_in,
addr_out=>mmu_addr_3_out,
ram_in=>mmu_ram_3,
ram_out=>output_3
);
---
U4_RAM_4: ram_32_64 PORT MAP
(
clk=>clk,
wr=>mmu_ram_wr_4,
addr_in=>mmu_addr_4_in,
addr_out=>mmu_addr_4_out,
ram_in=>mmu_ram_4,
ram_out=>output_4
);


END Behavioral;
