LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY wrong_code IS
  PORT
  (
    err_event : IN  Std_logic;
    clk       : IN  Std_logic;
    reset     : IN  Std_logic;
    failed    : OUT Std_logic
  );
END wrong_code;

ARCHITECTURE wrong_code_impl OF wrong_code IS
  TYPE state IS (err_0, err_1, err_2, err_3);
  SIGNAL present_state, next_state : state; --"ps" refererer til "Present State"
BEGIN

  state_reg : PROCESS (clk, reset)
  BEGIN
    IF reset = '0' THEN
      present_state <= err_0;
    ELSIF rising_edge(clk) THEN
      present_state <= next_state;
    END IF;
  END PROCESS;

  nxt_state : PROCESS (present_state, err_event)
  BEGIN
    CASE present_state IS
      WHEN err_0 =>
        IF err_event = '1' THEN
          next_state <= err_1;
        ELSE
          next_state <= err_0;
        END IF;
      WHEN err_1 =>
        IF err_event = '1' THEN
          next_state <= err_2;
        ELSE
          next_state <= err_1;
        END IF;
      WHEN err_2 =>
        IF err_event = '1' THEN
          next_state <= err_3;
        ELSE
          next_state <= err_2;
        END IF;
      WHEN err_3 =>
        next_state <= err_3;
      WHEN OTHERS =>
        next_state <= err_0;
    END CASE;
  END PROCESS;

  outputs : PROCESS (present_state)
  BEGIN
    CASE present_state IS
      WHEN err_3 =>
        failed <= '1';

      WHEN err_2 =>
        failed <= '0';

      WHEN err_1 =>
        failed <= '0';

      WHEN err_0 =>
        failed <= '0';

    END CASE;
  END PROCESS;

END wrong_code_impl;