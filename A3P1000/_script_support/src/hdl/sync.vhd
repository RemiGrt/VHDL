-------------------------------------------------------------------------------
-- Title      : Sync
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sync.vhd
-- Created    : 2024-02-14
-- Last update: 2025-02-05
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Generate synchronisation signals
-- sync_us period = 1us => high level for one clk period.
-- sync_ms period = 1ms => high level for one clk period.
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2024-02-14  1.0      griotr  Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity sync is

  generic (
    g_clk_frequency : positive := 40e6 -- 40 MHz
    );
  port (
    clk     : in  std_logic;
    rst_n   : in  std_logic;
    sync_us : out std_logic;
    sync_ms : out std_logic);

end entity sync;


architecture sync_arch of sync is

  constant c_us : unsigned(5 downto 0) := to_unsigned((g_clk_frequency/1e6)-1, 6);
  constant c_ms : unsigned(9 downto 0) := to_unsigned(1000-1, 10);

  signal sig_cnt_us : unsigned(c_us'high downto 0);
  signal sig_cnt_ms : unsigned(c_ms'high downto 0);

begin

  sync_us_p : process (clk, rst_n)
  begin
    if rst_n = '0' then
      sig_cnt_us <= (others => '0');
      sync_us    <= '0';
    elsif rising_edge(clk) then
      sig_cnt_us <= sig_cnt_us + 1;
      sync_us    <= '0';
      if sig_cnt_us = c_us then
        sig_cnt_us <= (others => '0');
        sync_us    <= '1';
      end if;
    end if;
  end process;

  sync_ms_p : process (clk, rst_n)
  begin
    if rst_n = '0' then
      sig_cnt_ms <= (others => '0');
      sync_ms    <= '0';
    elsif rising_edge(clk) then
      if sig_cnt_us = c_us then
        sig_cnt_ms <= sig_cnt_ms + 1;
        sync_ms    <= '0';
        if sig_cnt_ms = c_ms then
          sig_cnt_ms <= (others => '0');
          sync_ms    <= '1';
        end if;
      end if;
    end if;
  end process;

end sync_arch;
