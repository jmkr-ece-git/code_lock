library ieee;
use ieee.std_logic_1164.all;

entity code_lock_fsm is
	port(
		clk : in std_logic;
		reset : in std_logic;
		enter : in std_logic;
		code : in std_logic_vector (3 downto 0);
		failed : in std_logic;
		lock : out std_logic;
		indicators : out std_logic_vector (2 downto 0); --indicator til at signalere korrekt input
		err_event : out std_logic
		);
end code_lock_fsm;

architecture three_processes of code_lock_fsm is
	type state is (idle, Ev_code1, get_code2, Ev_code2, Unlocked, wrong_code, permanently_locked);
	signal present_state : state := idle; 
	signal next_state : state := idle;
	
	-- constants for the lock code values
constant code1 : std_logic_vector(3 downto 0) := "1010"; --Første korrekte input
constant code2 : std_logic_vector(3 downto 0) := "0101"; --Andet korrekte input


begin

state_reg: process (clk, reset)
begin
	if rising_edge(clk) then
		if reset = '0' then
			present_state <= idle;
		else
			present_state <= next_state;
		end if;
	end if;
end process;

outputs: process (present_state)
begin
	case present_state is
	when Unlocked =>
		lock <= '0';
		err_event <= '0';
		indicators <= "111";
	when wrong_code =>
		err_event <= '1';
		lock <= '1';
		indicators <= "000";
	when idle =>
		lock <= '1';
		err_event <= '0';
		indicators <= "100";
	when get_code2 =>
		lock <= '1';
		err_event <= '0';
		indicators <= "110";
	when permanently_locked =>
		lock <= '1';
		err_event <= '0';
		indicators <= "000";
	when others =>
		lock <= '1';
		err_event <= '0';
		indicators <= "000";
	end case;
end process;

nxt_state: process (present_state, code, enter, failed)
begin
	next_state <= idle;  -- default value
	case present_state is
		when idle =>
			if enter = '1' then
				next_state <= Ev_code1;
			end if;
		when Ev_code1 =>
			if code = code1 then
				next_state <= get_code2;
			else
				next_state <= wrong_code;
			end if;
		when get_code2 =>
			if enter = '1' then
				next_state <= Ev_code2;
			else
				next_state <= get_code2;
			end if;
		when Ev_code2 => 
			if code=code2 then
				next_state <= Unlocked;
			else
				next_state <= wrong_code;
			end if;
		when Unlocked =>
			if enter = '1' then
				next_state <= idle;
			else
				next_state <= Unlocked;
			end if;
		when wrong_code =>
			--if err_event = '1'
			if failed = '1' then
				next_state <= permanently_locked;
			else 
				next_state <= idle;
			end if;
		when permanently_locked =>
			next_state <= permanently_locked;
		when others =>
			next_state <= idle;
	end case;
end process;

end three_processes;