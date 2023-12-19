LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Controle IS
PORT(
	-- Entradas de controle
	CLOCK: IN std_logic;
	enter: IN std_logic; --- (sw0)
	reset: IN std_logic;
	-- Entradas de status
	end_FPGA, end_User, end_time, win, match: IN std_logic;
	-- Saídas de comandos
	R1, R2, E1, E2, E3, E4: OUT std_logic;
	SEL: OUT std_logic
	-- Saídas de controle
);
END Controle;

ARCHITECTURE arc OF Controle IS
	TYPE STATES IS (Init, Setup, Play_FPGA, Play_User, Check, Next_Round, Result);
	SIGNAL EA, PE: STATES;
BEGIN
process(clock, reset)
  begin
    if (reset = '1') then
      EA <= Init;
    elsif (clock'event AND clock = '1') then 
        EA <= PE;
    end if;
  end process;

--- agora é a lógica para determinar o proximo estado

process(enter, EA, end_FPGA, end_User, end_time, win, match)   --- entradas de status para transições 
  begin
    case EA is
      when Init =>
         R1 <= '1';
         R2 <= '1';
         E1 <= '0';
         E2 <= '0';
         E3 <= '0';
         E4 <= '0';
         SEL <= '0';
         PE <= Setup;
         
        
      when Setup =>
        R1 <= '0';
        R2 <= '0';
        E1 <= '1';
        E2 <= '0';
        E3 <= '0';
        E4 <= '0';
        SEL <= '0';
        if enter = '1' then
            PE <= Play_FPGA;
        else
          PE <= Setup;
        end if;
         
      
      when Play_FPGA =>
        R1 <= '0';
        R2 <= '0';
        E1 <= '0';
        E2 <= '0';
        E3 <= '1';
        E4 <= '0';
        SEL <= '0';
        if end_FPGA = '1' then
          PE <= Play_User;
        else
          PE <= Play_FPGA;
        end if;
         
         
      when Play_User =>
         R1 <= '0';
         R2 <= '0';
         E1 <= '0';
         E2 <= '1';
         E3 <= '0';
         E4 <= '0';
         SEL <= '0';
         
         if end_time = '1' then
            PE <= Result;
         elsif end_User = '1' and end_time = '0' then
            PE <= Check;
         else
            PE <= Play_User;         
         end if;
         
     
     when Check =>
         R1 <= '0';
         R2 <= '0';
         E1 <= '0';
         E2 <= '0';
         E3 <= '0';
         E4 <= '1'; -- se algo der errado mexer aqui
         SEL <= '0';
         if match = '1' then
            PE <= Next_Round;
         else
            PE <= Result;
         end if;
        
     when Next_Round =>
        R1 <= '0';
        R2 <= '1';
        E1 <= '0';
        E2 <= '0';
        E3 <= '0';
        E4 <= '0';
        SEL <= '0';
        if win = '1' then
            PE <= Result;
        else
            PE <= Play_FPGA;
        end if;

     when Result =>
        R1 <= '0';
        R2 <= '0';
        E1 <= '0';
        E2 <= '0';
        E3 <= '0';
        E4 <= '0';
        SEL <= '1';               
       
    end case;
  end process;
END arc;