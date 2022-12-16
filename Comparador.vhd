library ieee;
use ieee.std_logic_1164.all;
entity Comparador is port (
	seq_FPGA: in std_logic_vector(63 downto 0);
	seq_Usuario: in std_logic_vector(63 downto 0);
	eq: out std_logic);
end Comparador;

architecture comp of Comparador is

begin

eq <= '1' when (seq_FPGA = seq_Usuario) else
             '0';
end comp;
