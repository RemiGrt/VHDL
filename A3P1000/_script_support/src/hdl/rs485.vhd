--------------------------------------------------------------------------------
--
-- File: rs485.vhd
-- File history:

--
-- Description: 
--
-- <Description here>
--


--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rs485 is
  port(
    clk               : in  std_logic;
    rst_n             : in  std_logic;
    rs485_r           : in  std_logic;  -- Logic output RS485 THVD1424 Data
    rs485_d           : out std_logic;  -- Logic input RS485 THVD1424 Data
    rs485_r_enable_n  : out std_logic;  -- Receive enable_n. 1 = Receive disable
    rs485_d_enable    : out std_logic;  -- Driver enable. 1 = Driver enable
    rs485_half_full_n : out std_logic;  -- Half to Full duplex ctrl. 0=full
    rs485_term_tx     : out std_logic;  -- Enable 120 Ohm on-chip. 1 = enable
    rs485_term_rx     : out std_logic;  -- Enable 120 Ohm on-chip. 1 = enable
    rs485_slew_rate   : out std_logic);  -- 1 = 500 kbps / 0 = 20 Mbps
end rs485;

architecture rtl of rs485 is

begin

  process(clk, rst_n)
  begin
    if rst_n = '0' then
      rs485_d           <= '0';
      rs485_r_enable_n  <= '0';
      rs485_d_enable    <= '0';
      rs485_half_full_n <= '0';
      rs485_term_tx     <= '0';
      rs485_term_rx     <= '0';
      rs485_slew_rate   <= '0';
    elsif rising_edge (clk) then
      rs485_d           <= rs485_r;
      rs485_r_enable_n  <= rs485_r;
      rs485_d_enable    <= rs485_r;
      rs485_half_full_n <= rs485_r;
      rs485_term_tx     <= rs485_r;
      rs485_term_rx     <= rs485_r;
      rs485_slew_rate   <= rs485_r;
    end if;
  end process;

end rtl;



