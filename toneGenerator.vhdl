LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity toneGenerator is
port (toneOut : out std_logic; --this pin will give your tones output
		clk : in std_logic;
		LED : out std_logic_vector(7 downto 0);
		switch : in std_logic_vector(7 downto 0)
		);
end entity toneGenerator;

architecture tone_bhv of toneGenerator is
begin
process(clk, switch)

variable count_tone : integer := 0;
variable tone : std_logic := '0';

begin
if (clk = '1' and clk' event) then

if (switch(0) = '1') then
if (count_tone = 104167) then--240Hz 
count_tone := 1;
tone := not tone;
else
count_tone := count_tone + 1;
end if;
toneOut <= tone;
LED <= (0 => '1', others => '0');
				
elsif (switch(1) = '1') then
if (count_tone = 92593) then--270Hz
count_tone := 1;
				
tone := not tone;
else
count_tone := count_tone + 1;
end if;
toneOut <= tone;
LED <= (1 => '1', others => '0');

elsif (switch(2) = '1') then
if (count_tone = 83333) then--300Hz
count_tone := 1;
tone := not tone;
else
count_tone := count_tone + 1;
end if;
toneOut <= tone;
LED <= (2 => '1', others => '0');
				
elsif (switch(3) = '1') then
if (count_tone = 78125) then--320Hz
count_tone := 1;
tone := not tone;
else
count_tone := count_tone + 1;
end if;
toneOut <= tone;
LED <= (3 => '1', others => '0');
				
elsif (switch(4) = '1') then
if (count_tone = 69444) then--360Hz
count_tone := 1;

tone := not tone;
else
count_tone := count_tone + 1;
end if;
toneOut <= tone;
LED <= (4 => '1', others => '0');
				
elsif (switch(5) = '1') then
if (count_tone = 62500) then--400Hz
count_tone := 1;
tone := not tone;
else
count_tone := count_tone + 1;
end if;
toneOut <= tone;
LED <= (5 => '1', others => '0');
				
elsif (switch(6) = '1') then
if (count_tone = 111112) then--225Hz
count_tone := 1;
tone := not tone;
else
count_tone := count_tone + 1;
end if;
toneOut <= tone;
LED <= (6 => '1', others => '0');


				
else
toneOut <= '0';
LED <= (others => '0');

end if;
			
end if;	

end process;
end tone_bhv;
