LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity music is
port (toneOut : out std_logic;
	clk_50, resetn : in std_logic;
	LED : out std_logic_vector(7 downto 0));
end entity music;

architecture fsm of music is
-- Fill all the states
------------------Code here---------------------------

-- Declare state types here
type MyState is (Silent,SA,RE,GA,MA,PA,DHA,NI);

-- Declare all necessary signals here
signal sa_note, re_note, ga_note, ma_note, pa_note, dha_note, ni_note: std_logic;
signal LED_sa, LED_re, LED_ga, LED_ma, LED_pa, LED_dha, LED_ni: std_logic_vector(7 downto 0);
signal clock_music: std_logic;

-- Take the toneGenerator component
component toneGenerator is
port (toneOut : out std_logic; --this pin will give your tones output
		clk : in std_logic;
		LED : out std_logic_vector(7 downto 0);
		switch : in std_logic_vector(7 downto 0)
		);
end component;

begin

	process(clock_music,clk_50,resetn,sa_note, re_note, ga_note, ma_note, pa_note, dha_note, ni_note, LED_sa, LED_re, LED_ga, LED_ma, LED_pa, LED_dha, LED_ni)	-- Fill sensitivity list
	variable y_next_var : MyState;
	variable y_present : MyState;
	variable clk_c :std_logic := '1';
	variable count : integer;
	variable timecounter : integer range 0 to 1E8 := 0;
	
	begin
	
		y_next_var := y_present;

		case y_present is
		
-------------SILENT-----------------------------------
			when Silent=>
			if(count = 31) then
					y_next_var := Silent;
				elsif(count = 32) then
					y_next_var := pa;
				end if;					
			LED<="00000000";
			toneOut<= '0';
-------------------------------------------------------
				--assign the signal for switch which will be the input of toneGenerator component
				-----------------code here---------------------------
			WHEN sa =>	--if the machine in Sa state
				if(count = 24) then
				y_next_var := ni;
				elsif(count = 29) then
					y_next_var := sa;
				elsif(count = 30) then
					y_next_var := Silent;
				end if;
			LED<=LED_sa;
			toneOut<= sa_note;
				--assign the signal for switch which will be the input of toneGenerator
				
			WHEN re=>
			--if the machine in re state
				if(count = 16) then
					y_next_var := ga;
				elsif((count = 23) or (count=28)) then
					y_next_var := sa;
				elsif((count = 27)) then
					y_next_var := re;
				end if;
				
				LED<=LED_re;
				toneOut<= re_note;
				
				WHEN ga=>
			--if the machine in ga state
				if((count = 15) or (count = 22)) then
					y_next_var := re;
				elsif((count = 17) or (count = 18) or (count = 19)) then
					y_next_var := ga;
				elsif((count = 8) or (count = 20)) then
					y_next_var := ma;
				end if;
			LED<=LED_ga;
			toneOut<= ga_note;
			
				WHEN ma=>
			--if the machine in ma state
				if((count = 7) or (count = 14) or (count = 21)) then
					y_next_var := ga;
				elsif((count = 9) or (count = 10) or (count = 11)) then
					y_next_var := ma;
				elsif(count = 12) then
					y_next_var := pa;
				end if;
				LED<=LED_ma;
				toneOut<= ma_note;
				
				WHEN pa=>
			--if the machine in pa state
				if((count = 1) or (count = 2) or (count=3)) then
				y_next_var := pa;
				elsif((count = 6) or (count = 13)) then
					y_next_var := ma;
				elsif(count = 4) then
					y_next_var := dha;
				end if;
				LED<=LED_pa;
				toneOut<= pa_note;
					
				
				WHEN dha=>
			--if the machine in dha state
				if(count = 5) then
						y_next_var := pa;
				end if;
				LED<=LED_dha;
				toneOut<= dha_note;
					
				
				
				WHEN ni=>
			--if the machine in ni state
				if(count = 25) then
					y_next_var:=ni;
				elsif(count=26) then
				y_next_var := re;
				end if;
				LED<=LED_ni;
				toneOut<= ni_note;

----
			
				
				
		END CASE ;
	
--		generate 4Hz clock (0.25s time period) from 50MHz clock (clock_music)
		if (clk_50 = '1' and clk_50' event) then
				if timecounter = 6250000 then -- The cycles in which clk is 1 or 0
					timecounter := 1;			-- When it reaches max count i.e. 625x10^8 (One-Eighth of a second) it will be 0 again 
					clk_c := not clk_c;		-- this variable will toggle
				else
					timecounter := timecounter + 1;	-- Counter will be incremented till it reaches max count
					
				end if;
			clock_music<=clk_c;
		end if;	
		
--		state transition	
		if (clock_music = '1' and clock_music' event) then
			if (resetn = '1') then
				y_present := Silent;
				count := 32; --makes the speaker off 

			else 
					if(count = 32) then
						count := 1;
					else
						count := count+1;
					end if;
				y_present := y_next_var;
			end if;
		end if;
	end process;
	
	-- instantiate the component of toneGenerator 
	sa_1:  toneGenerator port map(sa_note, clk_50, LED_sa, "00000001");
	re_1:  toneGenerator port map(re_note, clk_50, LED_re, "00000010");
	ga_1:  toneGenerator port map(ga_note, clk_50, LED_ga, "00000100");
	ma_1:  toneGenerator port map(ma_note, clk_50, LED_ma, "00001000");
	pa_1:  toneGenerator port map(pa_note, clk_50, LED_pa, "00010000");
	dha_1: toneGenerator port map(dha_note,clk_50, LED_dha,"00100000");
	ni_1:  toneGenerator port map(ni_note, clk_50, LED_ni, "01000000"); 
end fsm;