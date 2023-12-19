library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Logica is port (
	REG_SetupLEVEL: in std_logic_vector(1 downto 0);
    REG_SetupMAPA: in std_logic_vector(1 downto 0);
	round: in std_logic_vector(3 downto 0);
	points: out std_logic_vector(7 downto 0));
	
end Logica;

architecture logic of Logica is
begin
points <= REG_SetupLEVEL & round & REG_SetupMAPA;
end logic;


