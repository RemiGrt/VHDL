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
Library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

-- ---------------------------------------------
    Entity HeartBeat is
-- ---------------------------------------------
  generic( Fosc  : positive := 50E6 );
  port   ( Clock     : in  std_logic;    -- Clock
           Reset     : in  std_logic;    -- async Reset
           LED       : out std_logic );  -- LED output beating at ~1 Hz
end HeartBeat;

-- ---------------------------------------------
    Architecture RTL of HeartBeat is
-- ---------------------------------------------
  constant DivBy : integer := Fosc / 2**17;  -- -> 1 Hz after PWM*Lum divisions
  signal PWM   : unsigned(7 downto 0); -- 8 bits
  signal Lum   : unsigned(7 downto 0);
  signal UPdir : boolean;
  signal Tick  : std_logic;
  signal Div   : integer range 0 to DivBy -1;

Begin

-- Generate Ticks at the right rate
process (Clock, Reset)
begin
  if Reset='1' then
     Div  <= 0;
     Tick <= '0';
  elsif rising_edge (Clock) then
    Tick <= '0';
    if Div = 0 then
       Tick <= '1';
       Div <= DivBy - 1;
     else
       Div <= Div - 1;
     end if;
  end if;
end process;

-- PWM modulation and triangle Brightness
process (Clock, Reset)
begin
  if Reset='1' then
     PWM <= (others=>'0');
     Lum <= (others=>'0');
     LED <= '0';
     UPdir <= true;
  elsif rising_edge (Clock) then
    if Tick='1' then
      PWM <= PWM + 1;
      if PWM = 0 then
        LED <= '1';
        if Lum = 0 and not Updir then
          UPdir <= true;
        elsif Lum = 255 and UPdir then
          UPdir <= false;
        elsif UPdir then
          Lum <= Lum + 1;
        else
          Lum <= Lum - 1;
        end if;
      elsif PWM >= Lum then
        LED <= '0';
      end if;
    end if;
  end if;
end process;


end architecture RTL;
