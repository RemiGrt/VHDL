----------------------------------------------------------------------------------
-- Company: EFREI Paris
-- Engineer: 
-- 
-- Create Date:    16:19:05 01/24/2019 
-- Design Name: 
-- Module Name:    fsm - Behavioral 
-- Project Name:  TP1 Logique programmable
-- Target Devices: xc7a200tsbg484
-- Tool versions: 
-- Description: Compteur 8 bits  basé sur une machine d'état.
-- La sortie count_out compte à chaque tick de sync_1s si count_up est actif, sinon décompte
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



entity fsm is

  port (
    clk       : in  std_logic;
    rst       : in  std_logic;
    sync_1s   : in  std_logic;
    count_out : out std_logic_vector(2 downto 0);
    count_up  : in  std_logic);

end entity fsm;

architecture arch of fsm is

  signal count : std_logic_vector(count_out'left downto 0);

  type state_t is (idle_state, count_up_state, count_down_state);
  signal state : state_t;


begin  -- architecture arch


  count_out <= count;

  -- purpose: Final State Machine
  -- type   : sequential
  -- inputs : clk, rst
  -- outputs: count, state
  fsm_p : process (clk, rst) is
  begin  -- process fsm_p
    if rst = '1' then
      count <= (others => '0');
      state <= idle_state;

    elsif rising_edge(clk) then

      if sync_1s = '1' then
        case state is

          when idle_state =>
            count <= (others => '0');
            if count_up = '1' then
              state <= count_up_state;
            else
              state <= count_down_state;
            end if;



          when count_up_state =>
            if count_up = '1' then
              count <= count + '1';
            else
              state <= count_down_state;
            end if;

          when count_down_state =>
            if count_up = '0' then
              count <= count - '1';
            else
              state <= count_up_state;
            end if;


          when others =>
            state <= idle_state;

        end case;
      end if;


    end if;
  end process fsm_p;

end architecture arch;
