library ieee;
use ieee.std_logic_1164.all;

entity code_lock is
	port(
		clk : in std_logic;
		reset : in std_logic;
		enter : in std_logic;
		code : in std_logic_vector (3 downto 0);
		lock : out std_logic
		);
end code_lock;

architecture structural of code_lock is
signal synched_sig, err_event, failed : std_logic := '0';
begin
sy: entity work.synch port map
(
	clk => clk,
	async_sig => enter,
	rise => open,
	fall => synched_sig
);

cl_fsm: entity work.code_lock_fsm port map
(
	clk => clk,
	reset => reset,
	enter => synched_sig,
	code => code,
	lock => lock,
	err_event => err_event,
	failed => failed
);

wc: entity work.wrong_code port map
(
	clk => clk,
	reset => reset,
	err_event => err_event,
	failed => failed
);

end structural;