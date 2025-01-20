----------------------------------------------------------------------------------
-- Company: EFREI Paris
-- Engineer: 
-- 
-- Create Date:    16:19:05 01/24/2019 
-- Design Name: 
-- Module Name:    top - Behavioral 
-- Project Name:  TP1 Logique programmable
-- Target Devices: xc7a200tsbg484
-- Tool versions: 
-- Description:
-- UART Slave
-- Set Generic g_CLKS_PER_BIT as follows:
-- g_CLKS_PER_BIT = (Frequency of i_Clk)/(Frequency of UART)
-- Example: 100 MHz Clock, 115200 baud UART
-- (100000000)/(115200) = 868

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



entity uart is
  generic(
--    g_CLKS_PER_BIT : integer := 868  -- Define the number of Clock tick when sampling
      g_CLKS_PER_BIT : integer := 10416  -- Define the number of Clock tick when sampling

    );
  port (
    clk         : in  std_logic;        -- Clock
    rst         : in  std_logic;        -- Reset
    uart_rx_out : out std_logic;        -- UART Out (to receiver) 
    uart_tx_in  : in  std_logic;        -- UART In (From Receiver)
    data_out    : out std_logic_vector(7 downto 0);  -- Data receive on UART In
    dv          : out std_logic);  -- Data Valid, goes high for one clk period
  -- when after receiving a data

end entity uart;

architecture arch of uart is



  type state_t is (idle_state, start_bit_state, data_bit_state, stop_bit_state, data_out_state);
  signal state : state_t;

  signal rx_d       : std_logic;
  signal rx_dd      : std_logic;
  signal clk_Count  : integer range 0 to g_CLKS_PER_BIT-1 := 0;
  signal data_Count : integer range 0 to 8                := 0;
  signal data       : std_logic_vector(7 downto 0);

begin  -- architecture arch

  -- Avoid metastability on rx line
  rx_d  <= uart_tx_in when rising_edge(clk);
  rx_dd <= rx_d       when rising_edge(clk);



  -- purpose: Final State Machine
  -- type   : sequential
  -- inputs : clk, rst
  -- outputs: 
  fsm_p : process (clk, rst) is
  begin  -- process fsm_p
    if rst = '1' then

      clk_count  <= 0;
      data_count <= 0;
      state      <= idle_state;
      data_out   <= (others => '0');
      data       <= (others => '0');
      dv         <= '0';

    elsif rising_edge(clk) then

      dv <= '0';

      case state is

        when idle_state =>
          if rx_dd = '0' then
            data_out <= (others => '0');
            data     <= (others => '0');
            state    <= start_bit_state;
          end if;

        when start_bit_state =>
          if clk_Count = (g_CLKS_PER_BIT-1)/2 then
            if rx_dd = '0' then
              clk_Count <= 0;  -- reset counter since we found the middle
              state     <= data_bit_state;
            else
              state <= idle_state;
            end if;
          else
            Clk_Count <= Clk_Count + 1;

          end if;

        when data_bit_state =>
          if clk_Count = (g_CLKS_PER_BIT-1) then
            data(7 downto 0) <= rx_dd & data(7 downto 1);  -- LSB First
            data_count       <= data_count + 1;
            clk_Count        <= 0;
            if data_count = 7 then
              state      <= stop_bit_state;
              clk_Count  <= 0;
              data_count <= 0;
            end if;
          else
            clk_Count <= clk_Count + 1;
          end if;


        when stop_bit_state =>
          if clk_Count < (g_CLKS_PER_BIT-1) then
            Clk_Count <= Clk_Count + 1;
          else
            if rx_dd = '1' then -- Bug fixed: Pierre Loup Guerrieri
              Clk_Count <= 0;
              state     <= data_out_state;
            else
              state <= idle_state;
            end if;
          end if;

        when data_out_state =>
          data_out <= data;
          dv       <= '1';
          state    <= idle_state;


        when others =>
          state <= idle_state;

      end case;



    end if;
  end process fsm_p;

end architecture arch;
