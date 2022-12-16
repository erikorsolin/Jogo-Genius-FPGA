LIBRARY IEEE;
USE IEEE.Std_Logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY Topo IS
PORT(
	-- Entradas
	--CLOCK_50: IN std_logic; -- Ativar para FPGA
	CLK_500Hz: IN std_logic; --Ativar para o Emulador
	KEY: IN std_logic_vector(3 DOWNTO 0);
	SW: IN std_logic_vector(9 DOWNTO 0);
	-- Saí­das
	LEDR: OUT std_logic_vector(17 DOWNTO 0);
	LEDG: OUT std_logic_vector(3 DOWNTO 0);
	HEX0: OUT std_logic_vector(6 DOWNTO 0);
	HEX1: OUT std_logic_vector(6 DOWNTO 0);
	HEX2: OUT std_logic_vector(6 DOWNTO 0);
	HEX3: OUT std_logic_vector(6 DOWNTO 0);
	HEX4: OUT std_logic_vector(6 DOWNTO 0);
	HEX5: OUT std_logic_vector(6 DOWNTO 0);
	HEX6: OUT std_logic_vector(6 DOWNTO 0);
	HEX7: OUT std_logic_vector(6 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE arc OF Topo IS

	
---------------------------COMPONENTS------------------------------------

---------------------------Datapath--------------------------------------
COMPONENT Datapath IS
PORT(
	CLOCK: IN std_logic;
	KEY: IN std_logic_vector(3 DOWNTO 0);
	SWITCH: IN std_logic_vector(7 DOWNTO 0);
	R1, R2, E1, E2, E3, E4: IN std_logic;
	SEL: IN std_logic;
	hex0, hex1, hex2, hex3, hex4, hex5: OUT std_logic_vector(6 DOWNTO 0);
	leds: OUT std_logic_vector(3 DOWNTO 0);
	ledg: out std_logic_vector(3 downto 0);
	end_FPGA, end_User, end_time, win, match: OUT std_logic
);
END COMPONENT;
---------------------------Controle--------------------------------------
COMPONENT Controle IS
PORT(
	CLOCK: IN std_logic;
	enter: IN std_logic;
	reset: IN std_logic;
	end_FPGA, end_User, end_time, win, match: IN std_logic;
	R1, R2, E1, E2, E3, E4: OUT std_logic;
	SEL: OUT std_logic
);
END COMPONENT;
-----------------------------SIGNALS-------------------------------------
--CLOCK---------------------------------------------
	SIGNAL clock: std_logic;
	
--PMControle----------------------------------------
	SIGNAL R1: std_logic;
	SIGNAL R2: std_logic;
	SIGNAL E1: std_logic;
	SIGNAL E2: std_logic;
	SIGNAL E3: std_logic;
	SIGNAL E4: std_logic;
	SIGNAL end_FPGA: std_logic;
	SIGNAL end_User: std_logic;
	SIGNAL end_time: std_logic;
	SIGNAL win: std_logic;
	SIGNAL match: std_logic;
	SIGNAL SEL: std_logic;
    SIGNAL ledUser: std_logic_vector(3 DOWNTO 0);


BEGIN
	clock <= CLK_500Hz; --emulador
	--clock <= CLOCK_50; --FPGA
	LEDR(4) <= win;
    ledr(17 DOWNTO 14) <= ledUser;  --emulador
	--ledg <= ledUser; -- FPGA
	
	HEX6 <= "1111111"; --desliga o hex 6
	HEX7 <= "1111111"; --desliga o hex 7
	
instanciacao_dataph: Datapath port map(CLOCK => clock,
                                       KEY => KEY,
                                       SWITCH => SW(9 downto 2),
                                       SEL => SEL, 
                                       R1 => R1,
                                       R2 => R2,
                                       E1 => E1,
                                       E2 => E2,
                                       E3 => E3,
                                       E4 => E4,
                                       leds => LEDR(3 downto 0),
                                       ledg => ledUser,
                                       hex0 => HEX0,
                                       hex1 => HEX1,
                                       hex2 => HEX2,
                                       hex3 => HEX3,
                                       hex4 => HEX4,
                                       hex5 => HEX5,
                                       end_FPGA => end_FPGA,
                                       end_User => end_User,
                                       end_time => end_time,
                                       win => win,
                                       match => match);
                                       
                                       



instanciacao_controle: Controle port map(CLOCK => clock,
                                         enter => SW(0),
                                         reset => SW(1),
                                         R1 => R1,
                                         R2 => R2,
                                         E1 => E1,
                                         E2 => E2,
                                         E3 => E3,
                                         E4 => E4,
                                         SEL => SEL,
                                         end_FPGA => end_FPGA,
                                         end_User => end_User,
                                         end_time => end_time,
                                         win => win,
                                         match => match );




END ARCHITECTURE;