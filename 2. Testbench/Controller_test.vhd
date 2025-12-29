library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Controller_test is
--  Port ( );
end Controller_test;

architecture Behavioral of Controller_test is

component Conv32
 Port (
            clk : in std_logic;
            reset : in std_logic;
            end_process : out std_logic
  );
end component;
signal clk : std_logic;
signal reset : std_logic;
signal end_process : std_logic;

begin
AA  : Conv32 port map(
            clk => clk,
            reset => reset,
            end_process => end_process
);

clk_gen : process
begin
    clk <='0';
    wait for 10 ns;
    clk <='1';
    wait for 10 ns;
end process;
sim : process
begin
    reset <= '1';
    wait for 10 ns;
    reset <= '0';
    wait for 1000 ns;
 wait;
end process;
end Behavioral;
