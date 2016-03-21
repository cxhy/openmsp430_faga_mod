------------------------------------------------------------------------------
--
-- *File Name: dma_channel.vhd
--
-- *Module Description:
--                       这个模块是通道代码，这个通道可以进行单一传输、块传输、重复单一传输和重复块传输，由于dma_interface
--                    接口的部分已经有ready信号什么时候挂起cpu已经由430决定了，所以就不存在挂起总线和释放总线的问题了，所以
--                    就不存在突发块传输时连续传输4个byte、word之后release cpu的问题了，由于interface决定了什么时候dma开始
--					  传送，所以突发块传送的代码没有加入，其实块传送就是突发块传输，所以就避免了长期挂起cpu会导致的问题，
--					  由于430的ready决定了，我们通道该干的事情就是把数据、地址，使能信号，读写信号放上该有的数据，这样数据
--					  就能够传送到memory里面。
--                       本模块是单一传输和块传输两种传输模式合成一个状态机来写，在modify状态下判断dma_dt的传输模式，进而
--                    跳转到jump_single 或者 jump_block，之后跳转各自的状态。在进入单一模式下，再判断是否是重复单一模式，在
--                    块传送模式在判断是否重复块传送。
--                        本模块的状态机参照430x1xx手册上single transfer state diagram 和block transfer state diagram。
--                    如果为软件触发，硬件将dma_req自动清零。若transfer_done为高的时候为一帧数据完整的传输完成，供优先级模块
--                    使用。

-- *Author(s):
--              - Qiu Feifei,    994607592@qq.com
--
------------------------------------------------------------------------------
-- $Rev: 1 $
-- $LastChangedBy: Qiu Feifei $
-- $LastChangedDate: 2015-10-23 16:46:48  Fri $
------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY dma_channel IS
PORT(
    mclk       : IN STD_LOGIC;
	puc_rst    : IN STD_LOGIC;--高电平有效
    --dma reg input
	---------------------------------------------
	dmax_ctl   : IN STD_LOGIC_VECTOR(15 DOWNTO 0); --dma通道x控制寄存器
	dmax_sa    : IN STD_LOGIC_VECTOR(15 DOWNTO 0); --dma源地址寄存器
	dmax_da    : IN STD_LOGIC_VECTOR(15 DOWNTO 0); --dma目的地址寄存器
	dmax_sz    : IN STD_LOGIC_VECTOR(15 DOWNTO 0); --dma传输大小寄存器
	dmax_tsel   : IN STD_LOGIC_VECTOR(3 DOWNTO 0);--dma触发模式选择
    ---------------------------------------------
	trigger    : IN STD_LOGIC;--触发信号
	transfer_done : OUT STD_LOGIC;--一帧数据传输完成
	--------dma_interface 与430通信接口-----------------
	dma_ready : IN STD_LOGIC;
	dma_resp  : IN STD_LOGIC;
	dma_dout  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	dma_wkup  : OUT STD_LOGIC;
	dma_en    : OUT STD_LOGIC;
	dma_addr  : OUT STD_LOGIC_VECTOR(14 DOWNTO 0);
	dma_din   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    dma_we    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	
	
);
END ENTITY;

ARCHITECTURE arch_channel OF dma_channel IS

--------------------------------------------
SIGNAL dma_dt : STD_LOGIC_VECTOR(2 DOWNTO 0);--dma传输模式选择，single transfer  and  block transfer
SIGNAL dma_dst_incr : STD_LOGIC_VECTOR(1 DOWNTO 0);--dma目的地址修改，高电平加，低电平减
SIGNAL dma_src_incr : STD_LOGIC_VECTOR(1 DOWNTO 0);--dma源地址增量，高电平加，低电平减
SIGNAL dma_dst_byte : STD_LOGIC;--dma目的地址byte增量或者word增量，高电平byte
SIGNAL dma_src_byte : STD_LOGIC;--dma源地址byte增量或者word增量，高电平byte
SIGNAL dma_level : STD_LOGIC;--dma电平触发或者脉冲触发，高电平脉冲触发
SIGNAL transfer_en : STD_LOGIC;--dma传输使能
SIGNAL dma_ifg : STD_LOGIC;
SIGNAL dma_ie  : STD_LOGIC;
SIGNAL dma_abort : STD_LOGIC;
SIGNAL dma_req : STD_LOGIC;--dma软件触发
--------------------------------------------------

TYPE ISTATE IS(reset,load,idle,wft,rd_mem,wr_mem,modify,jump_single,jump_block,reload_rst,reload,rst_req,rst);
SIGNAL state : ISTATE;

SIGNAL T_size : INTEGER;--传输大小临时寄存器
SIGNAL T_sourceADD : STD_LOGIC_VECTOR(15 DOWNTO 0);--dma源地址临时寄存器
SIGNAL T_destADD : STD_LOGIC_VECTOR(15 DOWNTO 0);--dma目的地址临时寄存器

SIGNAL trigger_pos : STD_LOGIC;--踩到的上升沿
SIGNAL trigger_r : STD_LOGIC;
SIGNAL trigger_sel : STD_LOGIC;--触发选择

SIGNAL read_done : STD_LOGIC;--读430完成
SIGNAL write_done : STD_LOGIC;--写430完成
SIGNAL transfer_data : STD_LOGIC_VECTOR(15 DOWNTO 0);--读写传输的数据中转信号

SIGNAL dma_we_r : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL rdout_valid : STD_LOGIC;--读到的有效数据使能


BEGIN
-------------祥见文档---------------------------------------------------
dma_dt<=dmax_ctl(14 DOWNTO 12);
dma_dst_incr<=dmax_ctl(11 DOWNTO 10);
dma_src_incr<=dmax_ctl(9 DOWNTO 8);
dma_dst_byte<=dmax_ctl(7);
dma_src_byte<=dmax_ctl(6);
dma_level<=dmax_ctl(5);
dma_ifg<=dmax_ctl(3);
dma_ie<=dmax_ctl(2);
dma_abort<=dmax_ctl(1);
------------------------------------------------------------------------
WITH dmax_tsel SELECT--触发模式选择
     trigger_sel<= dma_req WHEN "0000",
	               trigger WHEN OTHERS;

dma_we<=dma_we_r;--dma读写使能
PROCESS(mclk,puc_rst)
BEGIN
IF(puc_rst='1')THEN
    rdout_valid<='0';
ELSIF(mclk 'EVENT AND mclk='1')THEN
   IF(dma_ready='1')THEN--当430确认数据接收状态时，在当前周期立即发送高电平有效信号
    IF(dma_we_r="00")THEN
	   rdout_valid<='1';--当在读使能的后一个周期就是有效数据
	ELSE
	   rdout_valid<='0';
	END IF;
   ELSE
       rdout_valid<='0';
   END IF;
END IF;
END PROCESS;		 
		 	
PROCESS(mclk,puc_rst)
BEGIN
IF(puc_rst='1')THEN
   trigger_r<='0';
ELSIF(mclk 'EVENT AND mclk='1')THEN
   trigger_r<=trigger_sel;
END IF;
END PROCESS;
trigger_pos<=trigger_sel AND (NOT trigger_r);--边沿采样操作方式

----------------------------------
PROCESS(mclk,puc_rst)
BEGIN
IF(puc_rst='1')THEN
   state<=reset;
ELSIF(mclk 'EVENT AND mclk='1')THEN
  CASE(state)IS
  WHEN reset     => 
                   transfer_done<='0';
  
  	               transfer_en<=dmax_ctl(4);
	               T_size<=0;
				   T_sourceADD<=(OTHERS=>'0');
				   T_destADD<=(OTHERS=>'0');
				   dma_en<='0';
				   dma_we_r<="00";
				   dma_addr<=(OTHERS=>'0');
				   dma_din<=(OTHERS=>'0');
				   transfer_data<=(OTHERS=>'0');
				   read_done<='0';
				   write_done<='0';
				   dma_req<='0';
				   
                   IF(transfer_en='1')THEN
				      state<=load;
                   ELSE
				      state<=reset;
				   END IF;
				   
  WHEN load      =>
                   T_size<= conv_integer(dmax_sz);
                   T_sourceADD<=dmax_sa;
                   T_destADD<=dmax_da;
  
                   state<=idle;
  
  WHEN idle      =>
                   dma_en<='0';
				   dma_we_r<="00";
                   dma_addr<=(OTHERS=>'0');
				   dma_din<=(OTHERS=>'0');
                   transfer_data<=(OTHERS=>'0');
                   read_done<='0';
				   write_done<='0';
  
                   IF(dma_abort='0')THEN
				      state<=wft;
				   ELSE 
				      state<=idle;
				   END IF;
				   IF(transfer_en='0')THEN
				      state<=reset;
				   END IF;
				   
  WHEN wft       =>
                   -- dma_req<=dmax_ctl(0);
				   IF(dmax_tsel="0000")THEN
				      dma_req<=trigger;
				   END IF;
 
                   IF((trigger_pos='1' AND dma_level='0')OR(trigger='1' AND dma_level='1'))THEN
				      state<=rd_mem;
				   ELSE
				      state<=wft;
				   END IF;
                   IF(transfer_en='0')THEN
				      state<=reset;
				   END IF;

  
  WHEN rd_mem    =>
				   dma_en<='1';
				   dma_we_r<="00";
				   dma_addr<=T_sourceADD(15 DOWNTO 1);
				   IF(rdout_valid='1')THEN
				      transfer_data<=dma_dout;
					  read_done<='1';
				   END IF;
				   
				  IF(read_done='1')THEN
				      state<=wr_mem;
				   ELSE
				      state<=rd_mem;
				   END IF;
  
  WHEN wr_mem    =>
                   read_done<='0';
				   
				   IF(dma_dst_byte='1')THEN
				      IF(T_destADD(0)='1')THEN
					     dma_we_r<="10";
					  ELSE
					     dma_we_r<="01";
					  END IF;
				   ELSE
				      dma_we_r<="11";
				   END IF;
				   dma_en<='1';
				   dma_addr<=T_destADD(15 DOWNTO 1);
				   dma_din<=transfer_data;
				   write_done<='1';
				   
                   IF(write_done='1')THEN
				      IF(dma_ready='1')THEN------有可能这个周期写进去的数是无效的，所以还得继续在写状态下写数据，下一个周期再检测ready信号是否有效，有效才跳转
					     state<=modify;
					  ELSE
					     state<=wr_mem;
					  END IF;
				   END IF;				   
				   
  
  WHEN modify    =>  
                   write_done<='0';
				   IF(dma_src_byte='1')THEN
				      T_size<=T_size-1;
				      CASE(dma_src_incr)IS
				   	  WHEN "10" => T_sourceADD<=T_sourceADD-'1';
				   	  WHEN "11" => T_sourceADD<=T_sourceADD+'1';
				   	  WHEN OTHERS => NULL;
				      END CASE;
				   ELSE
				      T_size<=T_size-2;
				      CASE(dma_src_incr)IS
				   	  WHEN "10" => T_sourceADD<=T_sourceADD-"10";
				   	  WHEN "11" => T_sourceADD<=T_sourceADD+"10";
				   	  WHEN OTHERS => NULL;
				      END CASE;
				   END IF;
				   
				   IF(dma_dst_byte='1')THEN
				      CASE(dma_dst_incr)IS
				   	  WHEN "10" => T_destADD<=T_destADD-'1';
				   	  WHEN "11" => T_destADD<=T_destADD+'1';
				   	  WHEN OTHERS => NULL;
                      END CASE;
                   ELSE
                      CASE(dma_dst_incr)IS
                   	  WHEN "10" => T_destADD<=T_destADD-"10";
                   	  WHEN "11" => T_destADD<=T_destADD+"10";
                   	  WHEN OTHERS => NULL;
                      END CASE;
                   END IF;
  
				   CASE(dma_dt) IS---根据不同的传输模式跳转不同的状态
				      WHEN "000"   => state<=jump_single;
					  WHEN "100"   => state<=jump_single;
					  WHEN "001"   => state<=jump_block;
					  WHEN "101"   => state<=jump_block;
					  WHEN  OTHERS => NULL;
				   END CASE;

  WHEN jump_single	=>--signal transfer 
                 
				   IF(dma_level='1' AND trigger='0')THEN
                      state<=idle;
				   END IF;
				   IF((dma_dt="000" AND T_size=0) OR transfer_en='0')THEN
				      state<=rst;
				   END IF;
				   IF(dma_dt="100" AND transfer_en='1' AND T_size=0)THEN
				      state<=reload;
				   END IF;
				   IF(T_size>0 AND transfer_en='1')THEN
				      state<=rst_req;
				   END IF;
				   
				   
  WHEN jump_block  =>--block transfer
               	 IF(dma_level='1' AND trigger='0')THEN
                     state<=idle;
				 END IF;
				 IF((dma_dt="001" AND T_size=0) OR transfer_en='0')THEN
				      state<=rst;
				 END IF;
				 IF(dma_dt="101" AND T_size=0 AND transfer_en='1')THEN
                     state<=reload_rst;
                 END IF;	
			     IF(T_size>0)THEN
				    state<=rd_mem;
				 END IF;
                 
  WHEN reload_rst =>--对应的block transfer传输对软件触发的自动清零并且重载
                 
				  dma_req<='0';
				  T_size<= conv_integer(dmax_sz);
                  T_sourceADD<=dmax_sa;
                  T_destADD<=dmax_da;
				  
				  state<=wft;
  
  WHEN reload    =>
                  T_size<= conv_integer(dmax_sz);
                  T_sourceADD<=dmax_sa;
                  T_destADD<=dmax_da;
  
                   state<=rst_req;
  
  WHEN rst_req   =>--对应的signal transfer传输对软件触发的自动清零
                   dma_req<='0';
				   
                   state<=wft;
  
  WHEN rst      =>
                  transfer_en<='0';
                  dma_req<='0';
                  T_size<= conv_integer(dmax_sz);

                  state<=reset;
				  
				  transfer_done<='1';--一帧信号传输结束
				  

  
  WHEN OTHERS    => NULL;
  
  END CASE;
  
  END IF;
END PROCESS;


END arch_channel;











