-------------------------------------------------------------------------------
-- Title      : Testbench for design "uart"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : uart_tb.vhd

-- Created    : 2025-02-05
-- Last update: 2025-02-05
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity uart_tb is

end entity uart_tb;

-------------------------------------------------------------------------------

architecture sim of uart_tb is

  -- component generics
  constant g_baudrate      : positive := 115200;
  constant g_clk_frequency : positive := 50e6;

  -- component ports
  signal clk         : std_logic;
  signal rst_n       : std_logic;
  signal uart_rx_out : std_logic;
  signal uart_tx_in  : std_logic;
  signal data_in     : std_logic_vector(7 downto 0);
  signal data_in_v   : std_logic;
  signal data_out    : std_logic_vector(7 downto 0);
  signal dv          : std_logic;

  -- clock
  signal Clk : std_logic := '1';

begin  -- architecture sim

  -- component instantiation
  DUT: entity work.uart
    generic map (
      g_baudrate      => g_baudrate,
      g_clk_frequency => g_clk_frequency)
    port map (
      clk         => clk,
      rst_n       => rst_n,
      uart_rx_out => uart_rx_out,
      uart_tx_in  => uart_tx_in,
      data_in     => data_in,
      data_in_v   => data_in_v,
      data_out    => data_out,
      dv          => dv);

  -- clock generation
  Clk <= not Clk after 10 ns;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- insert signal assignments here

    wait until Clk = '1';
  end process WaveGen_Proc;

  

end architecture sim;

-------------------------------------------------------------------------------

configuration uart_tb_sim_cfg of uart_tb is
  for sim
  end for;
end uart_tb_sim_cfg;

-------------------------------------------------------------------------------
