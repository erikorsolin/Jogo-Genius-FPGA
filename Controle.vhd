LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY Controle IS
PORT(
	-- Entradas de controle
	CLOCK: IN std_logic;
	enter: IN std_logic;
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
        EAtual <= PEstado;
    end if;
  end process;

--- agora é a lógica para determinar o proximo estado

process(EAtual)   --- Logica a definir
  begin
    case EAtual is
      when E1 =>
         LED1 <= '1';
         LED2 <= '1';
         LED3<= '1';
         PEstado <= E2;
         
        
      when E2 =>
         LED1 <= '0';
         LED2 <= '1';
         LED3<= '1';
         PEstado <= E3;
         
      
      when E3 =>
         LED1 <= '0';
         LED2 <= '0';
         LED3<= '1';
         PEstado <= E4;
         
      when E4 =>
         LED1 <= '0';
         LED2 <= '0';
         LED3<= '0';
         PEstado <= E1;
    
    end case;
  end process;
END arc;