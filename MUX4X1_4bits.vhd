library ieee;
use ieee.std_logic_1164.all;
entity  MUX4X1_4bits is PORT(
    SEL: IN std_logic_vector(1 DOWNTO 0);
    ENT0, ENT1, ENT2, ENT3: IN std_logic_VECTOR(3 DOWNTO 0);
    output: OUT std_logic_vector(3 downto 0));
end MUX4X1_4bits;

architecture multiplex of MUX4X1_4bits is

begin
output <= ENT0 when SEL = "00" else
         ENT1 when SEL = "01" else
         ENT2 when SEL = "10" else
         ENT3 when SEL = "11";
end multiplex;