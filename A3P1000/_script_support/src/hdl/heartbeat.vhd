-- HeartBeat.vhd
-- ---------------------------------------------
--   LED Flasher "Heart Beat" (c) ALSE
-- ---------------------------------------------
--  Version  : 1.3
--  Date     : July 2004 - 2009
--  Author   : Bert CUZEAU
--  Contact  : info@alse-fr.com
--  Web      : http://www.alse-fr.com
-- ---------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- ---------------------------------------------
entity heartbeat is
-- ---------------------------------------------
  generic(
    g_clk_frequency : positive := 40e6  -- 40 MHz
    );
  port (clk   : in  std_logic;          -- clock
        rst_n : in  std_logic;          -- async rst_n
        led   : out std_logic);         -- led output beating at ~1 hz
end heartbeat;

-- ---------------------------------------------
architecture rtl of heartbeat is
-- ---------------------------------------------
  constant divby : integer := g_clk_frequency / 2**17;  -- -> 1 hz after pwm*lum divisions
  signal pwm     : unsigned(7 downto 0);                -- 8 bits
  signal lum     : unsigned(7 downto 0);
  signal updir   : boolean;
  signal tick    : std_logic;
  signal div     : integer range 0 to divby -1;

begin

-- generate ticks at the right rate
  process (clk, rst_n)
  begin
    if rst_n = '0' then
      div  <= 0;
      tick <= '0';
    elsif rising_edge (clk) then
      tick <= '0';
      if div = 0 then
        tick <= '1';
        div  <= divby - 1;
      else
        div <= div - 1;
      end if;
    end if;
  end process;

-- pwm modulation and triangle brightness
  process (clk, rst_n)
  begin
    if rst_n = '0' then
      pwm   <= (others => '0');
      lum   <= (others => '0');
      led   <= '0';
      updir <= true;
    elsif rising_edge (clk) then
      if tick = '1' then
        pwm <= pwm + 1;
        if pwm = 0 then
          led <= '1';
          if lum = 0 and not updir then
            updir <= true;
          elsif lum = 255 and updir then
            updir <= false;
          elsif updir then
            lum <= lum + 1;
          else
            lum <= lum - 1;
          end if;
        elsif pwm >= lum then
          led <= '0';
        end if;
      end if;
    end if;
  end process;


end architecture rtl;
