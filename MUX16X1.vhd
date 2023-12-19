library ieee;
use ieee.std_logic_1164.all;
entity MUX16X1 is PORT(
    sel: IN std_logic_vector(3 DOWNTO 0);
    F1,F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F12,F13,F14,F15,F16: IN std_logic;
    CLKHZ: OUT std_logic
);
end MUX16X1;

architecture multiplex of MUX16X1 is

begin
CLKHZ <= F1 when sel = "0000" else
         F2 when sel = "0001" else
         F3 when sel = "0010" else
         F4 when sel = "0011" else
         F5 when sel = "0100" else
         F6 when sel = "0101" else
         F7 when sel = "0110" else
         F8 when sel = "0111" else
         F9 when sel = "1000" else
         F10 when sel = "1001" else
         F11 when sel = "1010" else
         F12 when sel = "1011" else
         F13 when sel = "1100" else
         F14 when sel = "1101" else
         F15 when sel = "1110" else
         F16 when sel = "1111";

end multiplex;