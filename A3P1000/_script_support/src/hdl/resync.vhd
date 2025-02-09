-------------------------------------------------------------------------------
-- Title      : resync module
-- Project    : 
-------------------------------------------------------------------------------
-- File       : resync.vhd
-- Created    : 2024-05-23
-- Last update: 2025-02-05
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Input signals go through double flip flop then out
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2024-05-23  1.0      griotr  Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity resync is
  generic(
    g_nb_port : positive := 8
    );
  port(
    clk        : in  std_logic;
    resync_in  : in  std_logic_vector(g_nb_port-1 downto 0);
    resync_out : out std_logic_vector(g_nb_port-1 downto 0)
    );
end resync;

architecture resync_arch of resync is

  signal sig_resync_d  : std_logic_vector(g_nb_port-1 downto 0);

begin

  process (clk)
  begin
    if rising_edge(clk) then

      sig_resync_d <= resync_in;
      resync_out   <= sig_resync_d;

    end if;
  end process;

end architecture resync_arch;

