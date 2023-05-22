-- Importacion de librerias
library ieee;
use ieee.std_logic_1164.all;

-- entidad sumaSegmentos, define todas las entradas y las salidas
entity sumaSegmentos is
    port (
        a, b: in std_logic_vector(3 downto 0); -- Se definen las 2 entradas (4 bits)
        acarreoEntrada: in std_logic; -- Se define el acarreo de entrada
		  resultado: out std_logic_vector(4 downto 0); -- "resultado" obitne la salida en binario de la suma (5bits)
		  salidaSegmento0, salidaSegmento1, salidaSegmento3, salidaSegmento5: out std_logic_vector(6 downto 0); -- Salidas a 7 segmentos
		  salidaSigno, salidaSignoIgual: out std_logic_vector(2 downto 0); -- Salida a 7 segmnetos (signo '+' y '=')
		  modulo: out std_logic -- Salida de 1 bit para verificar si es divisor o no
    );
end entity sumaSegmentos;

-- Se uso una sola arquitectura para definir el desarrollo de todas entradas a sus respectivas salidas
architecture acarreo of sumaSegmentos is
	signal suma, a_adj, b_adj, g, p, c: std_logic_vector(3 downto 0);
	signal bcd0, bcd1: std_logic_vector(3 downto 0);
	signal digito, digito1, digito3, digito5: std_logic_vector(6 downto 0);
	signal acarreoSalida: std_logic;
begin
	a_adj <= a when a <= "1001" else "1001"; -- Indica que la entrada 'a' de 4 bits es mayor que 9. Usarla como 9.
	b_adj <= b when b <= "1001" else "1001"; -- Indica que la entrada 'b' de 4 bits es mayor que 9. Usarla como 9.
	g <= a_adj and b_adj; -- Se calcula G
	p <= a_adj xor b_adj; -- Se calcula P
	
	-- Se calculan los acarreos
	c(0) <= acarreoEntrada;
	c(1) <= g(0) or (p(0) and c(0));
	c(2) <= g(1) or (p(1) and c(1));
	c(3) <= g(2) or (p(2) and c(2));
	
	acarreoSalida <= g(3) or (p(3) and c(3)); -- Ultimo acarreo, en caso de un quinto bit de salida
	
	suma <= a_adj xor b_adj xor c; -- Calcula el resultado de las 4 primeros bits de la salida.
	
	
	-- BDC --
	resultado(0) <= suma(0);
	resultado(1) <= ((not acarreoSalida and not suma(3) and (suma(1))) or (suma(3) and suma(2) and (not suma(1))) or (acarreoSalida and (not suma(1))));
	resultado(2) <= ((not suma(3) and suma(2)) or (acarreoSalida and not suma(1)) or (suma(2) and suma(1)));
	resultado(3) <= ((suma(3) and (not suma(2) and not suma(1))) or (acarreoSalida and suma(1)));
	resultado(4) <= ((suma(3) and suma(1)) or (suma(3) and suma(2)) or (acarreoSalida));
	
	-- Modulo
	modulo <= ((not acarreoSalida and not suma(3) and suma(2) and suma(1) and suma(0)) or (suma(3) and suma(2) and suma(1) and not suma(0)));


	-- Se calculan los valores mediante compuertas logicas para obtener los valores de las salidas
	bcd0(0) <= suma(0);
	bcd0(1) <= ((not acarreoSalida and not suma(3) and (suma(1))) or (suma(3) and suma(2) and (not suma(1))) or (acarreoSalida and (not suma(1))));
	bcd0(2) <= ((not suma(3) and suma(2)) or (acarreoSalida and not suma(1)) or (suma(2) and suma(1)));
	bcd0(3) <= ((suma(3) and (not suma(2) and not suma(1))) or (acarreoSalida and suma(1)));
	
	with bcd0 select
        digito <=
            "1000000" when "0000", --
            "1111001" when "0001", --
            "0100100" when "0010", --
            "0110000" when "0011", --
            "0011001" when "0100", --
            "0010010" when "0101", -- 5
            "0000010" when "0110",
            "1111000" when "0111",
            "0000000" when "1000",
            "0011000" when "1001", -- 9
            "-------" when others; -- error caso
				
	SalidaSegmento0 <= digito;
	
	-- SEGMENTO 1 --------------------------------------------------------------
	bcd1(0) <= ((suma(3) and suma(1)) or (suma(3) and suma(2)) or (acarreoSalida));
	bcd1(1) <= suma(0) and not suma(0);
	bcd1(2) <= suma(0) and not suma(0);
	bcd1(3) <= suma(0) and not suma(0);
	
	with bcd1 select
        digito1 <=
            "1000000" when "0000", --
            "1111001" when "0001", --
            "-------" when others; -- error caso
				
	SalidaSegmento1 <= digito1;
	
	
	------------------- SEGMENTO 2 y 4 (SIGNOS) ------------------
	SalidaSigno <= "000";
	SalidaSignoIgual <= "001";
	
	------------------- SEGMENTO 3 ----------------------------
	with a_adj select
        digito3 <=
            "1000000" when "0000", --
            "1111001" when "0001", --
            "0100100" when "0010", --
            "0110000" when "0011", --
            "0011001" when "0100", --
            "0010010" when "0101", -- 5
            "0000010" when "0110",
            "1111000" when "0111",
            "0000000" when "1000",
            "0011000" when "1001", -- 9
            "-------" when others; -- error caso
				
	SalidaSegmento3 <= digito3;
	
	------------------- SEGMENTO 5 ----------------------------
	with b_adj select
        digito5 <=
            "1000000" when "0000", --
            "1111001" when "0001", --
            "0100100" when "0010", --
            "0110000" when "0011", --
            "0011001" when "0100", --
            "0010010" when "0101", -- 5
            "0000010" when "0110",
            "1111000" when "0111",
            "0000000" when "1000",
            "0011000" when "1001", -- 9
            "-------" when others; -- error caso
				
	SalidaSegmento5 <= digito5;
	
	
end acarreo;