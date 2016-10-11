library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity Decoder is
    Port ( EN : in  STD_LOGIC;--工作使能端
	        IND : out STD_LOGIC;
           IR : in  STD_LOGIC_VECTOR (4 downto 0);
           O : out  STD_LOGIC_VECTOR (9 downto 0));--10个输出
end Decoder;
architecture Behavioral of decoder is
begin
	process(EN,IR) 
	begin 
	case IR(4 downto 1) is
		when "0000" => O <= "0000000001";
		when "0001" => O <= "0000000010";
		when "0010" => O <= "0000000100";
		when "0011" => O <= "0000001000";
		when "0100" => O <= "0000010000";
		when "0101" => O <= "0000100000";
		when "0110" => O <= "0001000000";
		when "0111" => O <= "0010000000";
		when "1000" => O <= "0100000000";
		when "1001" => O <= "1000000000";
		when others => O <= "0000000000";
	end case;
	IND<=IR(0);
	end process;
end Behavioral;

