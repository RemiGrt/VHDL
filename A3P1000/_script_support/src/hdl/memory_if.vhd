-------------------------------------------------------------------------------
-- Title      : Memory Interface for MR10Q010
-- Project    : 
-------------------------------------------------------------------------------
-- File       : memory_if.vhd
-- Created    : 2025-01-29
-- Last update: 2025-02-05
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Memory Interface for MR10Q010
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2025-01-29  1.0      griotr  Created
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity memory_if is
  generic(
    g_clk_frequency : positive := 40e6;  -- 40 MHz
    );
  port(
    clk   : in std_logic;
    rst_n : in std_logic;

    -- MR10Q010 Interface               -- SPI             QSPI
    cs_b       : out   std_logic;       -- chip select     chip select
    sck        : out   std_logic;       -- clock           clock
    so         : inout std_logic;       -- serial output   I/O1
    wp_b       : inout std_logic;       -- write protect   I/O2
    si         : inout std_logic;       -- Serial input    I/O0
    hold_b     : out   std_logic;       -- Hold            I/O3w
    -- Data to master
    data_out   : out   std_logic_vector(7 downto 0);
    data_out_v : out   std_logic;
    data_in    : in    std_logic_vector(7 downto 0);
    address    : in    std_logic_vector(23 downto 0);
    data_in_v : in std_logic
    );
end memory_if;



architecture memory_if_arch of sync is


begin

end memory_if_arch;
