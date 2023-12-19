library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Counter is port (
	data: in std_logic_vector(3 downto 0);
	CLK, R, E: in std_logic;
	saida: out std_logic_vector(3 downto 0);
	tc: out std_logic);
end Counter;


architecture contador of Counter is
signal cont: std_logic_vector(3 downto 0);
begin
	process(CLK,R,E, data)
	begin
		if (R = '1') then
			cont <= "0000";
			tc <= '0';
			
		elsif (CLK'event and CLK = '1') then
			if (E = '1') then
			    cont <= cont + '1';
			    if cont = data then
			        tc <= '1';
			        cont <= "0000";
			    else
			        tc <= '0';
			    end if;
			end if;
		end if;
	end process;
saida <= cont;

end contador;