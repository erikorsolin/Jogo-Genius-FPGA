LIBRARY IEEE;
USE IEEE.std_logic_1164.all; 
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY Datapath IS
PORT(
	-- Entradas de dados
	CLOCK: IN std_logic;
	KEY: IN std_logic_vector(3 DOWNTO 0);
	SWITCH: IN std_logic_vector(7 DOWNTO 0);

	-- Entradas de controle
	R1, R2, E1, E2, E3, E4: IN std_logic;
	SEL: IN std_logic;

	-- Saídas de dados
	hex0, hex1, hex2, hex3, hex4, hex5: OUT std_logic_vector(6 DOWNTO 0);
	leds: OUT std_logic_vector(3 DOWNTO 0);
	ledg: out std_logic_vector(3 downto 0);
	
	-- Saídas de status
	end_FPGA, end_User, end_time, win, match: OUT std_logic
);
END ENTITY;

ARCHITECTURE arc OF Datapath IS
---------------------------SIGNALS-----------------------------------------------------------

--ButtonSync-----------------------------------------------------------
	SIGNAL BTN0: std_logic;
	SIGNAL BTN1: std_logic;
	SIGNAL BTN2: std_logic;
	SIGNAL BTN3: std_logic;
	SIGNAL NBTN, NOTKEYS: std_logic_vector(3 DOWNTO 0);

--Operações booleanas--------------------------------------------------
	SIGNAL E_Counter_User: std_logic;
	SIGNAL data_REG_FPGA: std_logic_vector(63 DOWNTO 0);
	SIGNAL data_REG_User: std_logic_vector(63 DOWNTO 0);
	SIGNAL c1aux, c2aux: std_logic;

--REG_Setup-------------------------------------------------------------
	SIGNAL SETUP: std_logic_vector(7 downto 0);

--div_freq--------------------------------------------------------------
	SIGNAL C05Hz, C07Hz, C09Hz, C1Hz, C11Hz, C12Hz, C13Hz, C14Hz, C15Hz, C16Hz, C17Hz, C18Hz, C19Hz: std_logic;
	SIGNAL C2Hz, C21Hz, C22Hz, C23Hz, C24Hz, C25Hz, C26Hz, C27Hz, C28Hz, C29Hz, C3Hz, C31Hz, C32Hz: std_logic;
	SIGNAL C33Hz, C34Hz, C35Hz, C36Hz, C38Hz, C4Hz, C42Hz, C44Hz, C46Hz, C48Hz, C5Hz: std_logic;
	SIGNAL C52Hz, C54Hz, C56Hz, C58Hz, C6Hz: std_logic;

--Counter_Round--------------------------------------------------------
	SIGNAL win_internal: std_logic;
	SIGNAL ROUND: std_logic_vector(3 DOWNTO 0);

--Counter_time---------------------------------------------------------
	SIGNAL TEMPO: std_logic_vector(3 DOWNTO 0);

--Counter_FPGA---------------------------------------------------------
	SIGNAL SEQFPGA: std_logic_vector(3 DOWNTO 0);

--ROM------------------------------------------------------------------
	SIGNAL SEQ_FPGA: std_logic_vector(3 DOWNTO 0);

--Counter_User---------------------------------------------------------
	SIGNAL end_User_internal: std_logic;

--REG_FPGA-------------------------------------------------------------
	SIGNAL OUT_FPGA: std_logic_vector(63 DOWNTO 0);

--REG_User-------------------------------------------------------------
	SIGNAL OUT_User: std_logic_vector(63 DOWNTO 0);	
    SIGNAL SEQUSER: std_logic_vector(3 downto 0);
--COMP-----------------------------------------------------------------
	SIGNAL is_equal: std_logic;

--LOGICA---------------------------------------------------------------
	SIGNAL POINTS: std_logic_vector(7 DOWNTO 0);

--DECODIFICADORES------------------------------------------------------
--Externos-------------------------------------------------------------
	SIGNAL G_dec7segHEX4: std_logic_vector(3 DOWNTO 0);

--DecBCD---------------------------------------------------------------
	SIGNAL POINTS_BCD: std_logic_vector(7 DOWNTO 0);

--dec7segHEX4----------------------------------------------------------
	SIGNAL dec7segHEX4: std_logic_vector(6 DOWNTO 0);

--dec7segHEX2----------------------------------------------------------
	SIGNAL dec7segHEX2: std_logic_vector(6 DOWNTO 0);

--dec7segHEX1----------------------------------------------------------
	SIGNAL dec7segHEX1: std_logic_vector(6 DOWNTO 0);

--dec7segHEX00---------------------------------------------------------
	SIGNAL dec7segHEX00: std_logic_vector(6 DOWNTO 0);

--dec7segHEX01---------------------------------------------------------
	SIGNAL dec7segHEX01: std_logic_vector(6 DOWNTO 0);
	
--MULTIPLEXADORES----------------------------------------------------------------------------

--Mux0HEX5-------------------------------------------------------------
	SIGNAL output_Mux0HEX5: std_logic_vector(6 DOWNTO 0);

--Mux16_1--------------------------------------------------------------
	SIGNAL saida0mux16_1, saida1mux16_1, saida2mux16_1, saida3mux16_1: std_logic;
	
--Mux0HEX2-------------------------------------------------------------
	SIGNAL output_Mux0HEX2: std_logic_vector(6 DOWNTO 0);
	
--Mux0HEX3-------------------------------------------------------------
	SIGNAL output_Mux0HEX3: std_logic_vector(6 DOWNTO 0);

--Mux0HEX4-------------------------------------------------------------
	SIGNAL output_Mux0HEX4: std_logic_vector(6 DOWNTO 0);

--Mux4:1_4bits---------------------------------------------------------
	SIGNAL MUX4X1_4bits00: std_logic_vector(3 DOWNTO 0);
	SIGNAL MUX4X1_4bits01: std_logic_vector(3 DOWNTO 0);
	SIGNAL MUX4X1_4bits10: std_logic_vector(3 DOWNTO 0);
	SIGNAL MUX4X1_4bits11: std_logic_vector(3 DOWNTO 0);

--MUXdiv_freq_de2-------------------------------------------------------
	SIGNAL CLKHZ: std_logic;	
	
---------------------------COMPONENTS-----------------------------------------------------------

--------------------------MUX4X1_4bits----------------------------------
COMPONENT MUX4X1_4bits IS
PORT(
	 SEL: IN std_logic_vector(1 DOWNTO 0);
    ENT0, ENT1, ENT2, ENT3: IN std_logic_vector(3 DOWNTO 0);
    output: OUT std_logic_vector(3 DOWNTO 0)
);
END COMPONENT;
-------------------------MUX2X1_7bits-------------------------------------
COMPONENT MUX2X1_4bits IS
PORT(
	 SEL: IN std_logic;
    ENT0, ENT1: IN std_logic_vector(3 DOWNTO 0);
    output: OUT std_logic_vector(3 DOWNTO 0)
);
END COMPONENT;
-------------------------MUX2X1_7bits-------------------------------------
COMPONENT MUX2X1_7bits IS
PORT(
	 SEL: IN std_logic;
    ENT0, ENT1: IN std_logic_vector(6 DOWNTO 0);
    output: OUT std_logic_vector(6 DOWNTO 0)
);
END COMPONENT;
----------------------------MUX4X1_1bit-----------------------------------
COMPONENT MUX4X1 IS
PORT(level: IN std_logic_vector(1 DOWNTO 0);
    CL1, CL2, CL3, CL4: IN std_logic;
    CLKHZ: OUT std_logic
);
END COMPONENT;
-------------------------MUX16X1_clock------------------------------------
COMPONENT MUX16X1 IS
PORT(sel: IN std_logic_vector(3 DOWNTO 0);
    F1,F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F12,F13,F14,F15,F16: IN std_logic;
    CLKHZ: OUT std_logic
);
END COMPONENT;
---------------------------dec7seg----------------------------------------
COMPONENT dec7seg IS
PORT(entrada: IN std_logic_vector(3 DOWNTO 0);
	output: OUT std_logic_vector(6 DOWNTO 0)
);
END COMPONENT;
---------------------------REG_Setup--------------------------------------
COMPONENT REG_Setup IS 
PORT(CLK, R, E: IN std_logic;
	SW: IN std_logic_vector(7 DOWNTO 0);
	setup: OUT std_logic_vector(7 DOWNTO 0)
 );
END COMPONENT;
---------------------------REG_FPGA---------------------------------------
COMPONENT REG_FPGA IS 
PORT(CLK, R, E: IN std_logic;
	data: IN std_logic_vector(63 DOWNTO 0);
	q: OUT std_logic_vector(63 DOWNTO 0)
 );
END COMPONENT;
---------------------------Reg_User---------------------------------------
COMPONENT Reg_User IS 
PORT(CLK, R, E: IN std_logic;
	data: IN std_logic_vector(63 DOWNTO 0);
	q: OUT std_logic_vector(63 DOWNTO 0)
 );
END COMPONENT;
-----------------------------decSeq00-------------------------------------
COMPONENT decSeq00 IS
PORT(
	address: IN std_logic_vector(3 DOWNTO 0);
	output: OUT std_logic_vector(3 DOWNTO 0)
);
END COMPONENT;
-----------------------------decSeq01-------------------------------------
COMPONENT decSeq01 IS
PORT(
	address: IN std_logic_vector(3 DOWNTO 0);
	output: OUT std_logic_vector(3 DOWNTO 0)
);
END COMPONENT;
-----------------------------decSeq10-------------------------------------
COMPONENT decSeq10 IS
PORT(
	address: IN std_logic_vector(3 DOWNTO 0);
	output: OUT std_logic_vector(3 DOWNTO 0)
);
END COMPONENT;
-----------------------------decSeq11-------------------------------------
COMPONENT decSeq11 IS
PORT(
	address: IN std_logic_vector(3 DOWNTO 0);
	output: OUT std_logic_vector(3 DOWNTO 0)
);
END COMPONENT;


-------------------------Contador Genérico-------------------------------------
COMPONENT Counter IS
PORT(data: in std_logic_vector(3 downto 0);
	CLK, R, E: in std_logic;
	saida: out std_logic_vector(3 downto 0);
	tc: out std_logic
);
END COMPONENT;

----------------------div_freq_de2----------------------------------------
COMPONENT div_freq_de2 IS
PORT(reset: IN std_logic;
	CLOCK: in std_logic;
	C05Hz, C07Hz, C09Hz, C1Hz, C11Hz, C12Hz, C13Hz, C14Hz, C15Hz, C16Hz, C17Hz, C18Hz, C19Hz: out std_logic;
	C2Hz, C21Hz, C22Hz, C23Hz, C24Hz, C25Hz, C26Hz, C27Hz, C28Hz, C29Hz, C3Hz, C31Hz, C32Hz: out std_logic; 
	C33Hz, C34Hz, C35Hz, C36Hz, C38Hz, C4Hz, C42Hz, C44Hz, C46Hz, C48Hz, C5Hz: out std_logic;
	C52Hz, C54Hz, C56Hz, C58Hz, C6Hz: out std_logic
);
END COMPONENT;
----------------------div_freq_emu----------------------------------------
COMPONENT div_freq_emu IS
PORT(reset: IN std_logic;
	CLOCK: in std_logic;
	C05Hz, C07Hz, C09Hz, C1Hz, C11Hz, C12Hz, C13Hz, C14Hz, C15Hz, C16Hz, C17Hz, C18Hz, C19Hz: out std_logic;
	C2Hz, C21Hz, C22Hz, C23Hz, C24Hz, C25Hz, C26Hz, C27Hz, C28Hz, C29Hz, C3Hz, C31Hz, C32Hz: out std_logic; 
	C33Hz, C34Hz, C35Hz, C36Hz, C38Hz, C4Hz, C42Hz, C44Hz, C46Hz, C48Hz, C5Hz: out std_logic;
	C52Hz, C54Hz, C56Hz, C58Hz, C6Hz: out std_logic
);
END COMPONENT;
---------------------------LOGICA-----------------------------------------
COMPONENT Logica IS
PORT(
    REG_SetupLEVEL: IN std_logic_vector(1 DOWNTO 0);
    ROUND: IN std_logic_vector(3 DOWNTO 0);
	 REG_SetupMAPA: IN std_logic_vector(1 DOWNTO 0);
	 POINTS: OUT std_logic_vector(7 DOWNTO 0)
);
END COMPONENT;
----------------------------COMP------------------------------------------
COMPONENT Comparador IS 
PORT(
	seq_FPGA, seq_Usuario: IN std_logic_vector(63 DOWNTO 0);
	eq: OUT std_logic
 );
END COMPONENT;
----------------------------buttonSync------------------------------------
component ButtonSync is
	port
	(
		KEY0, KEY1, KEY2, KEY3, CLK: in std_logic;
		BTN0, BTN1, BTN2, BTN3: out std_logic
	);
end component;


-- COMEÇO DO CODIGO ---------------------------------------------------------------------------------------


BEGIN	

-------------------------FREQUÊNCIAS--------------------------------------

	--freq_de2: div_freq_de2 PORT MAP(R1,CLOCK, C05Hz, C07Hz, C09Hz, C1Hz, C11Hz, C12Hz, C13Hz, C14Hz, C15Hz, C16Hz, C17Hz, C18Hz, C19Hz, C2Hz, C21Hz, C22Hz, C23Hz, C24Hz, C25Hz, C26Hz, C27Hz, C28Hz, C29Hz, C3Hz, C31Hz, C32Hz, C33Hz, C34Hz, C35Hz, C36Hz, C38Hz, C4Hz, C42Hz, C44Hz, C46Hz, C48Hz, C5Hz, C52Hz, C54Hz, C56Hz, C58Hz, C6Hz);

	freq_emu: div_freq_emu PORT MAP(R1,CLOCK, C05Hz, C07Hz, C09Hz, C1Hz, C11Hz, C12Hz, C13Hz, C14Hz, C15Hz, C16Hz, C17Hz, C18Hz, C19Hz, C2Hz, C21Hz, C22Hz, C23Hz, C24Hz, C25Hz, C26Hz, C27Hz, C28Hz, C29Hz, C3Hz, C31Hz, C32Hz, C33Hz, C34Hz, C35Hz, C36Hz, C38Hz, C4Hz, C42Hz, C44Hz, C46Hz, C48Hz, C5Hz, C52Hz, C54Hz, C56Hz, C58Hz, C6Hz);

------------------------------------------------------------------------------------------------------
-- operações booleanas
data_REG_FPGA <= SEQ_FPGA & OUT_FPGA(63 downto 4);
data_REG_User <= NBTN & OUT_User(63 downto 4);
E_Counter_User <= (NBTN(3) or  NBTN(2) or NBTN(1) or NBTN(0)) and E2;
match <= end_user_internal and is_equal;
c1aux <= E2 and C1Hz;
c2aux <= E3 and CLKHZ;
win <= win_internal;
end_User <= end_User_internal;
NBTN <= not(NOTKEYS);
leds <= OUT_FPGA(63 downto 60);
ledg <= not(key(3)) & not(key(2)) & not(key(1)) & not(key(0));



-- Botões 
botao: ButtonSync port map( CLK => CLOCK,
                            KEY0 => key(0),
                            KEY1 => key(1),
                            KEY2 => key(2),
                            KEY3 => key(3),
                            BTN0 => NOTKEYS(0),
                            BTN1 => NOTKEYS(1),
                            BTN2 => NOTKEYS(2),
                            BTN3 => NOTKEYS(3)
                                );


-- Comparador
Comp: Comparador port map(seq_FPGA => OUT_FPGA,
                          seq_Usuario => OUT_User,
                          eq => is_equal);



-- Lógica
LOG: Logica port map(REG_SetupLEVEL => SETUP(7 DOWNTO 6),
                    round => ROUND, -- Signal Round
                    REG_SetupMAPA => SETUP(5 DOWNTO 4),
                    points => POINTS); -- Signal points



-- instanciação dos registradores 
Registrador1: REG_Setup port map (CLK => CLOCK,
                                  R => R1,
                                  E  => E1,
                                  SW => SWITCH,
                                  setup => SETUP);  -- SAIDA "setup" do componente se conecta com o signal SETUP
                              

Registrador2: REG_FPGA port map (CLK => CLOCK,
                                 R => R2,
                                 E => c2aux,
                                 data => data_REG_FPGA,
                                 q => OUT_FPGA);


Registrador3: REG_User port map (CLK => CLOCK,
                                 R => R2,
                                 E => E_Counter_User,
                                 data => data_REG_User,
                                 q => OUT_User);
                   
                                 
-- contadores
Conter_time: Counter port map (clk => CLOCK,
                              R => R2,
                              E => c1aux,
                              data => "1010",
                              tc => end_time,
                              saida => TEMPO);
                              
Conter_round: Counter port map (clk => CLOCK,
                              R => R1,
                              E => E4,
                              data => SETUP(3 DOWNTO 0),
                              tc => win_internal,
                              saida => ROUND);
                              
Conter_User: Counter port map (clk => CLOCK,
                              R => R2,
                              E => E_Counter_User,
                              data => ROUND,
                              tc => end_User_internal,
                              saida => SEQUSER);  
                              
Conter_FPGA: Counter port map (clk => CLOCK,
                              R => R2,
                              E => c2aux,
                              data => ROUND,
                              tc => end_FPGA,
                              saida => SEQFPGA);
                
                
                              
-- sequencias
SEQ0: decSeq00 port map (address => SEQFPGA,
                        output => MUX4X1_4bits00);
                              
SEQ1: decSeq01 port map (address => SEQFPGA,
                        output => MUX4X1_4bits01);

SEQ2: decSeq10 port map (address => SEQFPGA,
                         output => MUX4X1_4bits10);

SEQ3: decSeq11 port map (address => SEQFPGA,
                         output => MUX4X1_4bits11 );



-- multiplexadores
Mux_SEQ: MUX4X1_4bits port map(SEL => SETUP(5 DOWNTO 4), -- Mux que escolhe qual sequencia sera mostrada nos leds
                               ENT0 => MUX4X1_4bits00,
                               ENT1 => MUX4X1_4bits01,
                               ENT2 => MUX4X1_4bits10,
                               ENT3 => MUX4X1_4bits11,
                               output => SEQ_FPGA);

-- Decodificadores
G_dec7segHEX4 <= "00"&SETUP(7 DOWNTO 6);
dec_HEX4: dec7seg port map(entrada => G_dec7segHEX4,
                           output => dec7segHEX4);

dec_HEX2: dec7seg port map(entrada => TEMPO,
                           output => dec7segHEX2);

dec_HEX1: dec7seg port map(entrada => POINTS(7 DOWNTO 4),
                           output => dec7segHEX1);

dec_HEX0: dec7seg port map(entrada => ROUND,
                           output => dec7segHEX00 );
                           
dec_HEX00: dec7seg port map(entrada => POINTS(3 DOWNTO 0),
                            output => dec7segHEX01);




Mux_HZ_0: MUX16X1 port map(sel => ROUND,
                           F1 => C05Hz,
                           F2 => C07Hz,
                           F3 => C09Hz,
                           F4 =>  C11Hz,
                           F5 => C13Hz,
                           F6 => C15Hz,
                           F7 => C17Hz,
                           F8 => C19Hz,
                           F9 => C21Hz,
                           F10 => C23Hz,
                           F11 => C25Hz,
                           F12 => C27Hz,
                           F13 => C29Hz,
                           F14 => C31Hz,
                           F15 => C33Hz,
                           F16 => C35Hz,
                           CLKHZ => saida0mux16_1 );


Mux_HZ_1: MUX16X1 port map(sel => ROUND,
                           F1 => C1Hz,
                           F2 => C12Hz,
                           F3 => C14Hz,
                           F4 =>  C16Hz,
                           F5 => C18Hz,
                           F6 => C2Hz,
                           F7 => C22Hz,
                           F8 => C24Hz,
                           F9 => C26Hz,
                           F10 => C28Hz,
                           F11 => C3Hz,
                           F12 => C32Hz,
                           F13 => C34Hz,
                           F14 => C36Hz,
                           F15 => C38Hz,
                           F16 => C4Hz,
                           CLKHZ => saida1mux16_1 );

                           
Mux_HZ_2: MUX16X1 port map(sel => ROUND,
                           F1 => C2Hz,
                           F2 => C22Hz,
                           F3 => C24Hz,
                           F4 =>  C26Hz,
                           F5 => C28Hz,
                           F6 => C3Hz,
                           F7 => C32Hz,
                           F8 => C34Hz,
                           F9 => C36Hz,
                           F10 => C38Hz,
                           F11 => C4Hz,
                           F12 => C42Hz,
                           F13 => C44Hz,
                           F14 => C46Hz,
                           F15 => C48Hz,
                           F16 => C5Hz,
                           CLKHZ => saida2mux16_1 );


Mux_HZ_3: MUX16X1 port map(sel => ROUND,
                           F1 => C3Hz,
                           F2 => C32Hz,
                           F3 => C34Hz,
                           F4 =>  C36Hz,
                           F5 => C38Hz,
                           F6 => C4Hz,
                           F7 => C42Hz,
                           F8 => C44Hz,
                           F9 => C46Hz,
                           F10 => C48Hz,
                           F11 => C5Hz,
                           F12 => C52Hz,
                           F13 => C54Hz,
                           F14 => C56Hz,
                           F15 => C58Hz,
                           F16 => C6Hz,
                           CLKHZ => saida3mux16_1);


Mux_4x1: MUX4X1 port map(level => SETUP(7 DOWNTO 6),
                         CL1 => saida0mux16_1,
                         CL2 => saida1mux16_1,
                         CL3 => saida2mux16_1,
                         CL4 => saida3mux16_1,
                         CLKHZ => CLKHZ);


-- MUX HEX5
Mux0_HEX5_2x1: MUX2X1_7bits port map(SEL => win_internal,
                                    ENT0 => "0001110",
                                    ENT1 => "1000001",
                                    output => output_Mux0HEX5);


Mux1_HEX5_2x1: MUX2X1_7bits port map(SEL => SEL,
                                    ENT0 => "1000111",
                                    ENT1 => output_Mux0HEX5,
                                    output => hex5 );



-- MUX HEX4 
Mux0_HEX4_2x1: MUX2X1_7bits port map(SEL => win_internal,
                                    ENT0 => "0001100",
                                    ENT1 => "0010010",
                                    output => output_Mux0HEX4 );
                                    

Mux1_HEX4_2x1: MUX2X1_7bits port map(SEL => SEL,
                                    ENT0 => dec7segHEX4,
                                    ENT1 => output_Mux0HEX4,
                                    output => hex4);

-- MUX HEX3
Mux0_HEX3_2x1: MUX2X1_7bits port map(SEL => win_internal,
                                    ENT0 => "0010000",
                                    ENT1 => "0000110",
                                    output => output_Mux0HEX3);
                                    
Mux1_HEX3_2x1: MUX2X1_7bits port map(SEL => SEL,
                                    ENT0 => "0000111",
                                    ENT1 => output_Mux0HEX3,
                                    output => hex3);

-- MUX HEX2
Mux0_HEX2_2x12: MUX2X1_7bits port map(SEL => win_internal,
                                    ENT0 => "0001000", 
                                    ENT1 => "0101111",
                                    output => output_Mux0HEX2);

Mux1_HEX2_2x1: MUX2X1_7bits port map(SEL => SEL,
                                    ENT0 => dec7segHEX2,
                                    ENT1 => output_Mux0HEX2,
                                    output => hex2);
                                    
                                    
-- MUX HEX1
Mux0_HEX1_2x11: MUX2X1_7bits port map(SEL => SEL,
                                    ENT0 => "0101111",
                                    ENT1 => dec7segHEX1,
                                    output => hex1);
                                    
                                    
-- MUX HEX0
Mux0_HEX1_2x10: MUX2X1_7bits port map(SEL => SEL,
                                    ENT0 => dec7segHEX00,
                                    ENT1 => dec7segHEX01,
                                    output => hex0);

end arc;