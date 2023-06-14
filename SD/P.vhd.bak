library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;
entity P is
Port (
	--relojes 
	clk	: in STD_LOGIC;
	Qclk	: buffer std_logic;   -- Señal de reloj simulada más rapida
	sclk	: buffer std_logic;   -- Señal de reloj simulada más lenta
-- botones:
		b1: in STD_LOGIC;
		b2: in STD_LOGIC;
		b3: in STD_LOGIC;
		b4: in STD_LOGIC;
		b5: in STD_LOGIC;
		b6: in STD_LOGIC;
		b7: in STD_LOGIC;
		b8: in STD_LOGIC;
		b9: in STD_LOGIC;
		b10: in STD_LOGIC;
		b11: in STD_LOGIC;
		b12: in STD_LOGIC;
--leds:
		l1: buffer STD_LOGIC:='0';
		l2: buffer STD_LOGIC:='0';
		l3: buffer STD_LOGIC:='0';
		l4: buffer STD_LOGIC:='0';
		l5: buffer STD_LOGIC:='0';
		l6: buffer STD_LOGIC:='0';
		l7: buffer STD_LOGIC:='0';
		l8: buffer STD_LOGIC:='0';
		l9: buffer STD_LOGIC:='0';
		l10: buffer STD_LOGIC:='0';
		l11: buffer STD_LOGIC:='0';
		l12: buffer STD_LOGIC:='0';
--pruebas
		r: in STD_LOGIC;--Boton reset
		c : out STD_LOGIC_VECTOR (3 downto 0);--ls de DE10Lite
		n : out STD_LOGIC_VECTOR (6 downto 0);--7Seg1  de DE10Lite
		m: out STD_LOGIC_VECTOR (6 downto 0));--7Seg0 de DE10Lite
end p;

architecture Behavioral of P is
--juego
type estados is (start, stage1, stage2, starth, ran, sec, s1, h1, s2, h2, s3, h3, s4, h4, s5, h5, s6, h6, s7, h7, s8, h8, s9, h9, s10, h10, s11, h11, s12, h12);
signal epresente, esiguiente : estados;
-- mostrar ls 
type EstadoAnidado is (O,D, H, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, ah1, ah2, ah3, ah4, ah5, ah6, ah7, ah8, ah9, ah10, ah11, ah12 );
signal eapresente, easiguiente : EstadoAnidado;
--señales
signal segundo		  : std_logic;
signal count_i      : std_logic_vector (3 downto 0);
signal feedback     : std_logic;
signal v		     	: std_logic;
signal w		     	: std_logic:='0';
signal slclk: std_logic := '0';  -- Señal interna para la señal de reloj simulada
signal Qlclk: std_logic := '0';  -- Señal interna para la señal de reloj simulada
signal button_state : std_logic := '0';  -- Estado estable del botón
signal button_temp : std_logic;         -- Variable temporal para filtrar el rebote
signal sr 			:std_logic_vector (3 downto 0);
signal si		     	:integer;
signal s20 				:integer;
signal i		     	: integer:=0;
signal j : integer:=0;
signal k : integer:=0;
--Memoria RAM
type memory_t is array (0 to 63) of std_logic_vector(0 to 3);--memoria RAM
  signal ram       : memory_t;

begin
debounce_process: process (clk)
    variable delay_count : integer := 0;
    variable button_read : std_logic;
  begin
    if rising_edge(clk) then
      -- Leer el valor del botón
      button_read := b1;

      -- Realizar el debouncing
      if delay_count > 0 then
        -- Si el contador de retardo es mayor a cero, seguir esperando
        delay_count := delay_count - 1;
      elsif button_read = button_temp then
        -- Si la lectura del botón es igual a la lectura anterior,
        -- actualizar el estado estable del botón
        button_state <= button_read;
      end if;

      -- Actualizar la variable temporal para la siguiente iteración
      button_temp <= button_read;

      -- Configurar el contador de retardo según tus necesidades
      delay_count := 100;  -- Ajusta este valor para filtrar el rebote adecuadamente
    end if;
  end process;



   feedback <= not(count_i(3) xor count_i(2));              -- LFSR size 4

   lfsr: process (b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, Qclk) 
        begin
        if (b1='0' or b2='0' or b3='0' or b4='0' or b5='0' or b6='0' or b7='0' or b8='0' or b9='0' or b10='0' or b11='0' or b12='0') then
            count_i <= (others=>'0');
        elsif (rising_edge(clk)) then
            count_i <= count_i(2 downto 0) & feedback;
				
				if k<63 then
					if count_i="0000" then 
						ram(k)<="1001";
					--	c<=ram(i);
					elsif count_i="1101"then
						ram(k)<="1010";
					--	c<=ram(i);
					elsif  count_i="1110" then
						ram(k)<="0100";
					--	c<=ram(i);
					elsif count_i="1111" then
						ram(k)<="0011";
					--	c<=ram(i);
					else
						ram(k)<=count_i;
					--	c<= ram(i);
					k<=k+1;
					end if;
				end if;
        end if;
		  
    end process;
	 
SCLKP: process (clk)
  begin
    if rising_edge(clk) then
      -- Generar un flanco ascendente para slow_clk_internal cada dos flancos ascendentes de clk
      slclk <= not slclk;
    end if;
  end process;

  sclk <= slclk;	 

QCLKP: process (clk)
    variable count: natural range 0 to 999_999 := 0;
  begin
    if rising_edge(clk) then
      count := count + 1;
      if count = 499_999 then  -- Mitad del periodo del reloj original
        count := 0;
        Qlclk <= not Qlclk;
      end if;
    end if;
  end process;
 Qclk <= Qlclk;
 
divisor : process (clk)
	variable cuenta: std_logic_vector(27 downto 0) := X"0000000";
	begin
		if rising_edge (clk) then
		if cuenta =X"48009E0" then
		cuenta := X"0000000";
		else
		cuenta := cuenta+1;
		end if; end if;
		segundo <= cuenta (24);
	end process;

MdE1: process (QCLK)
	variable cuenta: std_logic_vector(27 downto 0) := X"0000000";
	begin
		if rising_edge (QCLK) then
			if r='0' then 
				epresente<=start;
			else
			epresente<=esiguiente;
			end if;
		end if; 
	end process;

MdE2: process (epresente, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, i, j)
	begin
		case epresente is 
		when start=>
			--m<="0010010";  -- S 
			--n<="0010010";  -- S 
			j<=0;
			v<='0';
			--if i=0 then 
				esiguiente<= stage1;
			--end if;
				
		when stage1 => 
			--m<="0000000";  -- S 
				--i<=j+1;
					j<=i+1;	
					if i=0 then
						m<="1000000"; 
					elsif si=1 then
						m<="1111001";
					elsif si=2 then
						m<="0100100";
					elsif si=3 then
						m<="0110000";
					elsif si=4 then
						m<="0011001";
					elsif si=5 then
						m<="0010010";
					elsif si=6 then
						m<="0000010" ;
					elsif si=7 then
						m<="1111000" ;
					elsif si=8 then
						m<="0000000";
					elsif si=9 then
						m<="0010000";
					elsif si=10 then
						m<="0001000";
					end if;
			esiguiente<=stage2;
		when stage2 =>	
			if b1='0' or b2='0' or b3='0' or b4='0' or b5='0' or b6='0' or b7='0' or b8='0' or b9='0' or b10='0' or b11='0' or b12='0' then 
				esiguiente<= starth;
				--i20<=i;
			else
				esiguiente<=stage2;
			end if;
		when starth => 
			--m<="1000000";-- 0
			if b1='1' and b2='1' and b3='1' and b4='1' and b5='1' and b6='1' and b7='1' and b8='1' and b9='1' and b10='1' and b11='1' and b12='1' then
					i<=j;
					esiguiente<= ran;
			else
				esiguiente<=starth;
			end if;
		when ran => 
		--	m<="0101111"; -- r
			v<='1';
			esiguiente<=sec;
		when sec =>
			--m<="1000110"; -- C
			if w='1' then 
			--	m<="0110000"; -- 1
				esiguiente<=stage1;
				v<='0';
			else 
				esiguiente<=sec;
			end if;
			
		when others =>
		end case; 
	end process;

secu: process (segundo)
	variable cuenta: std_logic_vector(27 downto 0) := X"0000000";
	begin
		if rising_edge (segundo) then
		eapresente<=easiguiente;
		end if; 
	end process;

	
ledsp: process (eapresente, i)
	begin
		w<='0';
		case eapresente is 
		when O => 
			si<=0;
			s20<=0;
			--n<="1000000";-- 0
			l1<='0'; 
			l2<='0'; 
			l3<='0'; 
			l4<='0'; 
			l5<='0'; 
			l6<='0'; 
			l7<='0'; 
			l8<='0'; 
			l9<='0'; 
			l10<='0'; 
			l11<='0'; 
			l12<='0'; 
			if v='1' then 
				easiguiente<= H;
			else
				easiguiente<=O;
			end if;
			when H=>
				
				if si =i  then 
						--n<="0001100";
					w<='1';
					--i<=j+1;
				end if;
				
				if si=0 then
						n<="1000000"; 
					elsif si=1 then
						n<="1111001";
					elsif si=2 then
						n<="0100100";
					elsif si=3 then
						n<="0110000";
					elsif si=4 then
						n<="0011001";
					elsif si=5 then
						n<="0010010";
					elsif si=6 then
						n<="0000010" ;
					elsif si=7 then
						n<="1111000" ;
					elsif si=8 then
						n<="0000000";
					elsif si=9 then
						n<="0010000";
					elsif si=10 then
						n<="0001000";
					end if;
				
				
				easiguiente<=D;
			when D => 
			c<= ram(si);
				
					case ram(si) is
						when "0001" =>
							easiguiente<=a1;
						when "0010" =>
							easiguiente<=a2;
						when "0011" =>
							easiguiente<=a3;
						when "0100" =>
							easiguiente<=a4;
						when "0101" =>
							easiguiente<=a5;
						when "0110" =>
							easiguiente<=a6;
						when "0111" =>
							easiguiente<=a7;
						when "1000" =>
							easiguiente<=a8;
						when "1001" =>
							easiguiente<=a9;
						when "1010" =>
							easiguiente<=a10;
						when "1011" =>
							easiguiente<=a11;
						when "1100" =>
							easiguiente<=a12;
						when others =>
							easiguiente<= O;
					end case;
			
		when a1 => 
			l1<='1';
			if v='1' then
				s20<=si;
				easiguiente<= ah1;
			else
				easiguiente<=O;
			end if;
		when a2 => 
			l2<='1';
			if v='1' then 
				s20<=si;
				easiguiente<= ah2;
			else
				easiguiente<=O;
			end if;
		when a3 => 
			l3<='1';
			if v='1' then 
				s20<=si;
				easiguiente<= ah3;
			else
				easiguiente<=O;
			end if;
		when a4 => 
			l4<='1';
			if v='1' then 
				s20<=si;
				easiguiente<= ah4;
			else
				easiguiente<=O;
			end if;
		when a5 => 
			l5<='1';
			if v='1' then 
				s20<=si;
				easiguiente<= ah5;
			else
				easiguiente<=O;
			end if;
		when a6 => 
			l6<='1';
			if v='1' then 
				s20<=si;
				easiguiente<= ah6;
			else
				easiguiente<=O;
			end if;
		when a7 => 
			l7<='1';
			if v='1' then 
				s20<=si;
				easiguiente<= ah7;
			else
				easiguiente<=O;
			end if;
		when a8 => 
			l8<='1';
			if v='1' then 
				s20<=si;
				easiguiente<= ah8;
			else
				easiguiente<=O;
			end if;
		when a9 => 
			l9<='1';
			if v='1' then 
				s20<=si;
				easiguiente<= ah9;
			else
				easiguiente<=O;
			end if;
		when a10 => 
			l10<='1';
			if v='1' then 
				s20<=si;
				easiguiente<= ah10;
			else
				easiguiente<=O;
			end if;
		when a11 => 
			l11<='1';
			if v='1' then 
				s20<=si;
				easiguiente<= ah11;
			else
				easiguiente<=O;
			end if;
		when a12 => 
			l12<='1';
			if v='1' then 
				s20<=si;
				easiguiente<= ah12;
			else
				easiguiente<=O;
			end if;
			
		when ah1 => 
			l1<='0';
			if v='1' then 
				si<=s20+1;
				if si=8 then 
					--n<="0000000";--p
				end if;
				easiguiente<= H;
			else
				easiguiente<=O;
			end if;
		when ah2 => 
			l2<='0';
			if v='1' then 
				si<=s20+1;
				easiguiente<= H;
			else
				easiguiente<=O;
			end if;
		when ah3 => 
			l3<='0';
			if v='1' then 
				si<=s20+1;
				easiguiente<= H;
			else
				easiguiente<=O;
			end if;
		when ah4 => 
			l4<='0';
			if v='1' then 
				si<=s20+1;
				easiguiente<= H;
			else
				easiguiente<=O;
			end if;
		when ah5 => 
			l5<='0';
			if v='1' then 
				si<=s20+1;
				easiguiente<= H;
			else
				easiguiente<=O;
			end if;
		when ah6 => 
			l6<='0';
			if v='1' then 
				si<=s20+1;
				easiguiente<= H;
			else
				easiguiente<=O;
			end if;
		when ah7 => 
			l7<='0';
			if v='1' then 
				si<=s20+1;
				easiguiente<= H;
			else
				easiguiente<=O;
			end if;
		when ah8 => 
			l8<='0';
			if v='1' then 
				si<=s20+1;
				easiguiente<= H;
			else
				easiguiente<=O;
			end if;
		when ah9 => 
			l9<='0';
			if v='1' then 
				si<=s20+1;
				easiguiente<= H;
			else
				easiguiente<=O;
			end if;
		when ah10 => 
			l10<='0';
			if v='1' then 
				si<=s20+1;
				easiguiente<= H;
			else
				easiguiente<=O;
			end if;
		when ah11 => 
			l11<='0';
			if v='1' then 
				si<=s20+1;
				easiguiente<= H;
			else
				easiguiente<=O;
			end if;
		when ah12 => 
			l12<='0';
			if v='1' then 
				si<=s20+1;
				easiguiente<= H;
			else
				easiguiente<=O;
			end if;
		
		
		when others =>
				easiguiente<=O;
		end case; 
	end process;
end Behavioral;