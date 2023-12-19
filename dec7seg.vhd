library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity dec7seg is
    port (
        entrada: in std_logic_vector (3 downto 0);
        output: out std_logic_vector (6 downto 0)
    );
end dec7seg;


architecture struct of dec7seg is
           
begin

    output <= "1000000" when entrada(3 downto 0) = "0000" else
              "1111001" when entrada(3 downto 0) = "0001" else
              "0100100" when entrada(3 downto 0) = "0010" else
              "0110000" when entrada(3 downto 0) = "0011" else
              "0011001" when entrada(3 downto 0) = "0100" else
              "0010010" when entrada(3 downto 0) = "0101" else
              "0000011" when entrada(3 downto 0) = "0110" else
              "1111000" when entrada(3 downto 0) = "0111" else
              "0000000" when entrada(3 downto 0) = "1000" else
              "0011000" when entrada(3 downto 0) = "1001" else
              "1111111";
end struct;