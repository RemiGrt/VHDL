-------------------------------------------------------------------------------
-- Title      : <title string>
-- Project    : 
-------------------------------------------------------------------------------
-- File       : uart.vhd
-- Created    : 2025-02-05
-- Last update: 2025-02-05
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: <cursor>
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2025-02-05  1.0      griotr  Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity uart is
  generic(
    g_baudrate      : positive := 115200;
    g_clk_frequency : positive := 50e6
    );
  port (
    clk          : in  std_logic;       -- Clock
    rst_n        : in  std_logic;       -- Reset
    uart_rx_out  : out std_logic;       -- UART Out (to receiver) 
    uart_tx_in   : in  std_logic;       -- UART In (From Receiver)
    data_in      : in  std_logic_vector(7 downto 0);
    data_in_v    : in  std_logic;
    data_in_sent : out std_logic;
    data_out     : out std_logic_vector(7 downto 0);  -- Data receive on UART In
    data_out_v   : out std_logic);  -- Data Valid, goes high for one clk period
  -- when after receiving a data

end entity uart;

architecture arch of uart is

  type state_t is (idle_state, start_bit_state, data_bit_state, stop_bit_state, data_out_state);
  signal state    : state_t;
  signal state_tx : state_t;

  constant g_clks_per_bit : positive := g_clk_frequency / g_baudrate;

  signal clk_Count     : integer range 0 to g_CLKS_PER_BIT-1 := 0;
  signal clk_count_tx  : integer range 0 to g_CLKS_PER_BIT   := 0;
  signal data_count    : integer range 0 to 8                := 0;
  signal data_count_tx : integer range 0 to 8                := 0;
  signal data          : std_logic_vector(7 downto 0);
  signal data_tx       : std_logic_vector(7 downto 0);
  signal rx_d          : std_logic;
  signal rx_dd         : std_logic;


begin  -- architecture arch

  -- Avoid metastability on rx line
  rx_d  <= uart_tx_in when rising_edge(clk);
  rx_dd <= rx_d       when rising_edge(clk);

  -- purpose: Final State Machine
  -- type   : sequential
  -- inputs : clk, rst_n
  -- outputs: 
  fsm_rx : process (clk, rst_n) is
  begin  -- process fsm_rx
    if rst_n = '0' then

      clk_count  <= 0;
      data_count <= 0;
      state      <= idle_state;
      data_out   <= (others => '0');
      data       <= (others => '0');
      data_out_v <= '0';

    elsif rising_edge(clk) then

      data_out_v <= '0';

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
            if rx_dd = '1' then
              Clk_Count <= 0;
              state     <= data_out_state;
            else
              state <= idle_state;
            end if;
          end if;

        when data_out_state =>
          data_out   <= data;
          data_out_v <= '1';
          state      <= idle_state;

        when others =>
          state <= idle_state;

      end case;
    end if;
  end process fsm_rx;


  -- purpose: Final State Machine
  -- type   : sequential
  -- inputs : clk, rst_n
  -- outputs: 
  fsm_tx : process (clk, rst_n) is
  begin
    if rst_n = '0' then
      uart_rx_out  <= '1';
      state_tx     <= idle_state;
      clk_count_tx <= 0;
      data_in_sent <= '0';

    elsif rising_edge(clk) then

      data_in_sent <= '0';

      case state_tx is

        when idle_state =>
          if data_in_v = '1' then
            data_tx  <= data_in;
            state_tx <= start_bit_state;
          end if;

        when start_bit_state =>
          uart_rx_out  <= '0';
          clk_count_tx <= clk_count_tx + 1;
          if clk_count_tx = (g_CLKS_PER_BIT-1) then
            clk_count_tx <= 0;
            state_tx     <= data_bit_state;
          end if;

        when data_bit_state =>
          clk_count_tx <= clk_count_tx + 1;
          uart_rx_out  <= data_tx(0);   -- LSB First  
          if clk_count_tx = (g_CLKS_PER_BIT-1) then
            data_tx(6 downto 0) <= data_tx(7 downto 1);
            data_count_tx       <= data_count_tx + 1;
            clk_count_tx        <= 0;
            if data_count_tx = 7 then
              state_tx      <= stop_bit_state;
              clk_count_tx  <= 0;
              data_count_tx <= 0;
            end if;
          end if;

        when stop_bit_state =>
          uart_rx_out  <= '1';
          clk_count_tx <= clk_count_tx + 1;
          if clk_count_tx = (g_clks_per_bit-1) then
            state_tx     <= data_out_state;
            clk_count_tx <= 0;
          end if;

        when data_out_state =>
          data_in_sent <= '1';
          state_tx     <= idle_state;

        when others =>
          state_tx <= idle_state;
      end case;

    end if;
  end process fsm_tx;

end architecture arch;
