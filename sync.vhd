----------------------------------------------------------------------------------
-- Company: EFREI Paris
-- Engineer: 
-- 
-- Create Date:    16:19:05 01/24/2019 
-- Design Name: 
-- Module Name:    sync - Behavioral 
-- Project Name:  TP1 Logique programmable
-- Target Devices: xc7a200tsbg484
-- Tool versions: 
-- Description: 
--  La sortie sync_1s est active pendant Tclk toute les secondes.
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- ---------------------------------------------
entity sync is
-- ---------------------------------------------
  generic(Fosc : positive := 100E6);  -- Frequence du quartz 100 MHz
  port (Clock   : in  std_logic;   -- Clock
        Reset   : in  std_logic;   -- async Reset
        sync_1s : out std_logic);  -- Active high every second for 1 clk period
end sync;

-- ---------------------------------------------
architecture RTL of sync is
-- ---------------------------------------------
  signal count : integer range 0 to Fosc-1;


  begin
  
  process(clock, reset)
  begin
    if reset = '1' then
      count   <= 0;
      sync_1s <= '0';

    elsif rising_edge(clock) then
      sync_1s <= '0';
      if count = Fosc-1 then
        sync_1s <= '1';
        count <= 0;
      else
        count   <= count + 1;     
      end if;

    end if;
  end process;

end architecture RTL;
