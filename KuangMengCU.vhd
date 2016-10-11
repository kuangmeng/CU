library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity KuangMengCU is
    Port ( EN : in  STD_LOGIC;
           IR : in  STD_LOGIC_VECTOR (4 downto 0);
           I : in  STD_LOGIC;
           A : in  STD_LOGIC;
           IND : out  STD_LOGIC;
           MICROS : out  STD_LOGIC_VECTOR (27 downto 0);
           MCLK : in  STD_LOGIC_VECTOR (2 downto 0);--机器周期
           CLK : in  STD_LOGIC_VECTOR (2 downto 0));
end KuangMengCU;

architecture Behavioral of KuangMengCU is
	signal TMP : std_logic_vector(9 downto 0);
	SIGNAL INDTMP:STD_LOGIC;
	component Decoder --用途是减少输入位数
	Port ( EN : in  STD_LOGIC;--工作使能端
	       IND : OUT STD_LOGIC;
          IR : in  STD_LOGIC_VECTOR (4 downto 0);--5个输入
          O : out  STD_LOGIC_VECTOR (9 downto 0));--10个输出
	end component;
	component CU
	Port (  MCLK : in  STD_LOGIC_VECTOR (2 downto 0);
           CLK : in  STD_LOGIC_VECTOR (2 downto 0);
           OP : in  STD_LOGIC_VECTOR (9 downto 0);
			  I : in  STD_LOGIC;
           A : in  STD_LOGIC;
           IND : in  STD_LOGIC;
           MICROS : out  STD_LOGIC_VECTOR (27 downto 0));
	end component;
begin
	d:Decoder port map(EN => EN,IR => IR,O => TMP,IND => INDTMP);
	c:CU port map(OP => TMP,CLK => CLK,MCLK => MCLK, MICROS => MICROS,IND => INDTMP,I => I,A => A);
	IND<= INDTMP;
end Behavioral;

