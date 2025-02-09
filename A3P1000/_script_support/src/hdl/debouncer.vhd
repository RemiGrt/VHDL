-------------------------------------------------------------------------------
-- Title      : dbounce
-- Project    : 
-------------------------------------------------------------------------------
-- File       : debounce.vhd

-- Created    : 2024-05-23
-- Last update: 2025-02-05
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Debouncer of push button
-- sync must be high for one clock period. Its period should be ~1ms
-- debouncer_in have to maintain value for two rising edge of sync, then
-- debouncer_out will recopy debouncer_in
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2024-05-23  1.0      griotr  Created
-------------------------------------------------------------------------------
library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity debouncer is
  generic (
    g_nb_button : positive := 2);
  port(
    clk           : in  std_logic;
    rst_n         : in  std_logic;
    sync          : in  std_logic;
    debouncer_in  : in  std_logic_vector(g_nb_button-1 downto 0);
    debouncer_out : out std_logic_vector(g_nb_button-1 downto 0)
    );
end entity debouncer;

architecture debouncer_arch of debouncer is

  signal sig_debouncer_d  : std_logic_vector(g_nb_button-1 downto 0);
  signal sig_debouncer_dd : std_logic_vector(g_nb_button-1 downto 0);

begin

  debounce_p : process (clk, rst_n)
  begin
    if rst_n = '0' then
      sig_debouncer_d  <= (others => '0');
      sig_debouncer_dd <= (others => '0');
      debouncer_out    <= (others => '0');
    elsif rising_edge(clk) then
      if sync = '1' then
        sig_debouncer_d  <= debouncer_in;
        sig_debouncer_dd <= sig_debouncer_d;
        if(debouncer_in = sig_debouncer_dd) then
          debouncer_out <= sig_debouncer_dd;
        end if;
      end if;
    end if;
  end process;

end architecture debouncer_arch;
