library ieee;
use ieee.std_logic_1164.all;
entity REG_FPGA is PORT (
    CLK, R, E: IN std_logic;
	data: IN std_logic_vector(63 DOWNTO 0);
	q: OUT std_logic_vector(63 DOWNTO 0));
end REG_FPGA;

architecture registrador of REG_FPGA is
	
begin
	process(CLK,R,E)
	begin
		if (R = '1') then
			q <= "0000000000000000000000000000000000000000000000000000000000000000";
		elsif (CLK'event and CLK = '1') then
			if (E = '1') then
				q <= data;
			end if;
		end if;
	end process;
end registrador;