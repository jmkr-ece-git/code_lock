LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tt_um_example IS
  PORT (
    ui_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- Dedicated inputs
    uo_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- Dedicated outputs

    uio_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- IOs: Input path
    uio_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- IOs: Output path
    uio_oe : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- IOs: Enable (1=output)

    ena : IN STD_LOGIC; -- always '1' when powered (ignored)
    clk : IN STD_LOGIC; -- clock (unused here)
    rst_n : IN STD_LOGIC -- active-low reset (unused here)
  );
END ENTITY tt_um_example;

ARCHITECTURE rtl OF tt_um_example IS
  -- Local 'keep' signal to consume otherwise unused inputs
  SIGNAL unused_keep : STD_LOGIC;
BEGIN

  -- Instantiate the counter directly
  counter_inst : ENTITY work.counter
    PORT MAP(
      clk_i => clk, -- Clock input to the counter
      rst_ni => rst_n, -- Active-low reset input to the counter
      count_o => uo_out -- 8-bit counter output connected to dedicated outputs
    );

  -- Tie-offs for unused IO outputs and output enables
  uio_out <= (OTHERS => '0');
  uio_oe <= (OTHERS => '0');

  -- Consume unused inputs to prevent warnings
  -- (AND-reduction style similar to Verilog &{...})
  unused_keep <= ena AND '0';
END ARCHITECTURE rtl;