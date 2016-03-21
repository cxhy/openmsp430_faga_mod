LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY fifo IS
  GENERIC(
       wide : INTEGER;
	   long : INTEGER
  );
  PORT(
       clk : IN STD_LOGIC;
	   rst : IN STD_LOGIC;
	   wr  : IN STD_LOGIC;
	   rd  : IN STD_LOGIC;
	   data_in : IN STD_LOGIC_VECTOR(wide DOWNTO 0);
	   empty : OUT STD_LOGIC;
	   full  : OUT STD_LOGIC;
	   data_out : OUT STD_LOGIC_VECTOR(wide DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE one OF fifo IS

TYPE fifo_type IS ARRAY (long DOWNTO 0) OF STD_LOGIC_VECTOR(wide DOWNTO 0);
SIGNAL fifo_mem : fifo_type;
SIGNAL rd_ptr :  INTEGER RANGE 0 TO long;
SIGNAL wr_ptr :  INTEGER RANGE 0 TO long;
BEGIN
PROCESS(clk,rst)
VARIABLE cnt : INTEGER RANGE 0 TO long+1;
BEGIN
IF(rst='0')THEN
  FOR i IN long DOWNTO 0 LOOP
     fifo_mem(i)<=(OTHERS=>'0');
  END LOOP;
  wr_ptr<=0;
  rd_ptr<=0;
  cnt:=0;
  empty<='1';
  full<='0';
  data_out<=(OTHERS=>'0');
ELSIF(clk 'EVENT AND clk ='1')THEN
   IF(wr='1')THEN
     IF(cnt<=long)THEN
	   fifo_mem(wr_ptr)<=data_in;
       cnt:=cnt+1;
	   IF(wr_ptr<long)THEN
	     wr_ptr<=wr_ptr+1;
	   ELSE
	     wr_ptr<=0;
	   END IF;
	 END IF;
   ELSIF(rd='1')THEN
     IF(cnt>0)THEN
	    data_out<=fifo_mem(rd_ptr);
	    cnt:=cnt-1;
	   IF(rd_ptr<long)THEN
	      rd_ptr<=rd_ptr+1;
	   ELSE
	      rd_ptr<=0;
	   END IF;
	 END IF;
   END IF;
	
	IF(cnt=0)THEN
     empty<='1';
   ELSE 
     empty<='0';
   END IF;
   IF(cnt=long+1)THEN
     full<='1';
   ELSE
     full<='0';
   END IF;
END IF;
END PROCESS;

-- data_out<=fifo_mem(rd_ptr) WHEN rd='1' ELSE
		      -- (OTHERS=>'0'); 
			
--PROCESS(clk,rst)
--BEGIN
--IF(rst='1')THEN
--   data_out<=(OTHERS=>'0'); 
--ELSIF(clk 'EVENT AND clk='1')THEN
--   IF(rd='1')THEN
--	   data_out<=fifo_mem(rd_ptr);
--	ELSE 
--	   data_out<=(OTHERS=>'0'); 
--	END IF;
--END IF;
--END PROCESS;

END one;