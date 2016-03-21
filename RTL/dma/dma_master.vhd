LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY dma_master IS
PORT(
	mclk : IN STD_LOGIC;
	puc_rst : IN STD_LOGIC;
	dma_ready : IN STD_LOGIC;
	dma_resp  : IN STD_LOGIC;
	dma_dout  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	--per input-----------------------------
    per_addr    :  IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    per_din     :  IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    per_en      :  IN STD_LOGIC;
    per_we      :  IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	
	code_sel_tri :  IN STD_LOGIC;
-- OUTPUTs
    per_dout    :  OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	trigger0   : OUT STD_LOGIC;
	trigger1   : OUT STD_LOGIC;
	trigger2   : OUT STD_LOGIC;
	-------------------------------------------
	--------------dma_interface----------------
	dma_wkup : OUT STD_LOGIC;
	dma_addr : OUT STD_LOGIC_VECTOR(14 DOWNTO 0);
	dma_din  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	dma_en   : OUT STD_LOGIC;
	dma_we   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
	dma_priority : OUT STD_LOGIC
	
);
END ENTITY;

ARCHITECTURE arch_master OF dma_master IS
SIGNAL dma_ctl0    :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL dma_ctl1    :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL dma0_ctl    :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL dma0_sa     :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL dma0_da     :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL dma0_sz     :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL dma1_ctl    :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL dma1_sa     :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL dma1_da     :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL dma1_sz     :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL dma2_ctl    :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL dma2_sa     :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL dma2_da     :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL dma2_sz     :  STD_LOGIC_VECTOR(15 DOWNTO 0);

SIGNAL dma2_tsel  :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL dma1_tsel  :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL dma0_tsel  :  STD_LOGIC_VECTOR(3 DOWNTO 0);

SIGNAL trigger_0 : STD_LOGIC;
SIGNAL trigger_1 : STD_LOGIC;
SIGNAL trigger_2 : STD_LOGIC;
SIGNAL transfer_done0 : STD_LOGIC;
SIGNAL transfer_done1 : STD_LOGIC;
SIGNAL transfer_done2 : STD_LOGIC;



SIGNAL dma_wkup_0 : STD_LOGIC;
SIGNAL dma_addr_0 : STD_LOGIC_VECTOR(14 DOWNTO 0);
SIGNAL dma_din_0  : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL dma_en_0   : STD_LOGIC;
SIGNAL dma_we_0   : STD_LOGIC_VECTOR(1 DOWNTO 0);

SIGNAL dma_wkup_1 : STD_LOGIC;
SIGNAL dma_addr_1 : STD_LOGIC_VECTOR(14 DOWNTO 0);
SIGNAL dma_din_1  : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL dma_en_1  : STD_LOGIC;
SIGNAL dma_we_1   : STD_LOGIC_VECTOR(1 DOWNTO 0);

SIGNAL dma_wkup_2 : STD_LOGIC;
SIGNAL dma_addr_2 : STD_LOGIC_VECTOR(14 DOWNTO 0);
SIGNAL dma_din_2  : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL dma_en_2   : STD_LOGIC;
SIGNAL dma_we_2   : STD_LOGIC_VECTOR(1 DOWNTO 0);

SIGNAL dma0_ctl_en : STD_LOGIC;
SIGNAL dma1_ctl_en : STD_LOGIC;
SIGNAL dma2_ctl_en : STD_LOGIC;

SIGNAL tf_done    : STD_LOGIC;

COMPONENT dma_decode_16b
PORT(
-- INPUTs       
    mclk        :  IN STD_LOGIC;
	puc_rst     :  IN STD_LOGIC;
    per_addr    :  IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    per_din     :  IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    per_en      :  IN STD_LOGIC;
    per_we      :  IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	
-- OUTPUTs
    per_dout    :  OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	dma_ctl0    :  OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	dma_ctl1    :  OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	dma0_ctl    :  OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	dma0_ctl_en :  OUT STD_LOGIC;
	dma0_sa     :  OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	dma0_da     :  OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	dma0_sz     :  OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	dma1_ctl    :  OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	dma1_ctl_en :  OUT STD_LOGIC;
	dma1_sa     :  OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	dma1_da     :  OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	dma1_sz     :  OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	dma2_ctl    :  OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	dma2_ctl_en :  OUT STD_LOGIC;
	dma2_sa     :  OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	dma2_da     :  OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	dma2_sz     :  OUT STD_LOGIC_VECTOR(15 DOWNTO 0)


);               
END COMPONENT;
COMPONENT dma_channel
PORT(
    mclk       : IN STD_LOGIC;
	puc_rst    : IN STD_LOGIC;
    --dma reg input
	dmax_ctl   : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
	dmax_sa    : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
	dmax_da    : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
	dmax_sz    : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
	dmax_tsel   : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    ----
	trigger    : IN STD_LOGIC;
	transfer_done : OUT STD_LOGIC;
	--------dma_interface-----------------
	dma_ready : IN STD_LOGIC;
	dma_resp  : IN STD_LOGIC;
	dma_dout  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	dma_wkup  : OUT STD_LOGIC;
	dma_en    : OUT STD_LOGIC;
	dma_addr  : OUT STD_LOGIC_VECTOR(14 DOWNTO 0);
	dma_din   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    dma_we    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
);
END COMPONENT;

COMPONENT dma_pri 
PORT(
    mclk              : IN STD_LOGIC;        
    puc_rst           : IN STD_LOGIC;      
    dma_ctl0          : IN STD_LOGIC_VECTOR(15 DOWNTO 0);   
	dma_ctl1          : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
    dma0_ctl          : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
    dma0_ctl_en       : IN STD_LOGIC;	
	dma1_ctl          : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	dma1_ctl_en       : IN STD_LOGIC;	
	dma2_ctl          : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
    dma2_ctl_en       : IN STD_LOGIC;		
    cha0_tf_done      : IN STD_LOGIC;   
    cha1_tf_done      : IN STD_LOGIC;   
    cha2_tf_done      : IN STD_LOGIC;   
                     
    dma_priority      : OUT STD_LOGIC;   
    cha0_tri          : OUT STD_LOGIC;   
    cha1_tri          : OUT STD_LOGIC;   
    cha2_tri          : OUT STD_LOGIC

);
END COMPONENT;
BEGIN
dma2_tsel<=dma_ctl0(11 DOWNTO 8);
dma1_tsel<=dma_ctl0(7 DOWNTO 4);
dma0_tsel<=dma_ctl0(3 DOWNTO 0);

u_dma_decode_16b : dma_decode_16b
PORT MAP(
    mclk        => mclk,
	puc_rst     => puc_rst,
    per_addr    => per_addr,
    per_din     => per_din,
    per_en      => per_en,
    per_we      => per_we,
	
    per_dout    => per_dout,
	     
	dma_ctl0    => dma_ctl0,
	dma_ctl1    => dma_ctl1,
	dma0_ctl    => dma0_ctl,
	dma0_ctl_en => dma0_ctl_en,
	dma0_sa     => dma0_sa,
	dma0_da     => dma0_da,
	dma0_sz     => dma0_sz,
	dma1_ctl    => dma1_ctl,
	dma1_ctl_en => dma1_ctl_en,
	dma1_sa     => dma1_sa,
	dma1_da     => dma1_da,
	dma1_sz     => dma1_sz,
	dma2_ctl    => dma2_ctl,
	dma2_ctl_en => dma2_ctl_en,
	dma2_sa     => dma2_sa,
	dma2_da     => dma2_da,
	dma2_sz     => dma2_sz
);               


u_dma_priority : dma_pri 
PORT MAP(
    mclk              =>   mclk,   
    puc_rst           =>   puc_rst,
    dma_ctl0          =>   dma_ctl0,    
    dma_ctl1          =>   dma_ctl1,
    dma0_ctl          =>   dma0_ctl,
	dma0_ctl_en       =>   dma0_ctl_en,
    dma1_ctl	      =>   dma1_ctl,
	dma1_ctl_en       =>   dma1_ctl_en,
	dma2_ctl          =>   dma2_ctl,
	dma2_ctl_en       =>   dma2_ctl_en,
    cha0_tf_done      =>   transfer_done0,
    cha1_tf_done      =>   transfer_done1,
    cha2_tf_done      =>   transfer_done2,
                     
    dma_priority      =>   dma_priority,
    cha0_tri          =>   trigger_0,
    cha1_tri          =>   trigger_1,
    cha2_tri          =>   trigger_2
	

);

channel_0 : dma_channel
PORT MAP(
    mclk       =>  mclk,
	puc_rst    =>  puc_rst,
    --dma reg input
	dmax_ctl   =>  dma0_ctl,
	dmax_sa    =>  dma0_sa,
	dmax_da    =>  dma0_da,
	dmax_sz    =>  dma0_sz,
	dmax_tsel   => dma0_tsel,
    ----
	trigger    =>  trigger_0,
	transfer_done => transfer_done0,
	--------dma_interface-----------------
	dma_ready  =>  dma_ready ,
	dma_resp   =>  dma_resp,
	dma_dout   =>  dma_dout,
	dma_wkup   =>  dma_wkup_0,
	dma_en     =>  dma_en_0,
	dma_addr   =>  dma_addr_0,
	dma_din    =>  dma_din_0,
    dma_we     =>  dma_we_0
);

channel_1 : dma_channel
PORT MAP(
    mclk       =>  mclk,
	puc_rst    =>  puc_rst,
  -- dma reg input
	dmax_ctl   =>  dma1_ctl,
	dmax_sa    =>  dma1_sa,
	dmax_da    =>  dma1_da,
	dmax_sz    =>  dma1_sz,
	dmax_tsel   => dma1_tsel,
    
	trigger    =>  code_sel_tri,
	transfer_done => transfer_done1,
	--dma_interface-----------------
	dma_ready  =>  dma_ready ,
	dma_resp   =>  dma_resp,
	dma_dout   =>  dma_dout,
	dma_wkup   =>  dma_wkup_1,
	dma_en     =>  dma_en_1,
	dma_addr   =>  dma_addr_1,
	dma_din    =>  dma_din_1,
    dma_we     =>  dma_we_1
);

channel_2 : dma_channel
PORT MAP(
    mclk       =>  mclk,
	puc_rst    =>  puc_rst,
  --- dma reg input
	dmax_ctl   =>  dma2_ctl,
	dmax_sa    =>  dma2_sa,
	dmax_da    =>  dma2_da,
	dmax_sz    =>  dma2_sz,
	dmax_tsel   => dma2_tsel,
    
	trigger    =>  trigger_2,
	transfer_done => transfer_done2,
	--dma_interface-----------------
	dma_ready  =>  dma_ready ,
	dma_resp   =>  dma_resp,
	dma_dout   =>  dma_dout,
	dma_wkup   =>  dma_wkup_2,
	dma_en     =>  dma_en_2,
	dma_addr   =>  dma_addr_2,
	dma_din    =>  dma_din_2,
    dma_we     =>  dma_we_2
);


dma_wkup     <=    dma_wkup_0     OR    dma_wkup_1     OR  dma_wkup_2;
dma_addr     <=    dma_addr_0     OR    dma_addr_1     OR  dma_addr_2;
dma_din      <=    dma_din_0      OR    dma_din_1      OR  dma_din_2 ;
dma_en       <=    dma_en_0       OR    dma_en_1       OR  dma_en_2  ;
dma_we       <=    dma_we_0       OR    dma_we_1       OR  dma_we_2  ;

			  
   trigger0<=trigger_0;
   trigger1<=trigger_1;
   trigger2<=trigger_2;
   

END arch_master;