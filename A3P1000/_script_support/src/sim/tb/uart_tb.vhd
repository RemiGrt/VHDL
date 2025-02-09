-------------------------------------------------------------------------------
-- Title      : Testbench for design "uart"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : uart_tb.vhd
-- Created    : 2025-02-05
-- Last update: 2025-02-09
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2025-02-05  1.0      griotr  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;
-------------------------------------------------------------------------------

entity uart_tb is
  generic(
    gFileNameInputRx  : string := "./tb/uart_tb_dataInRx.txt";
    gFileNameOutputRx : string := "./tb/uart_tb_dataOutRx.txt";

    gFilenameInput  : string := "./tb/uart_tb_dataIn.txt";
    gFilenameOutput : string := "./tb/uart_tb_dataOut.txt"
    );
end entity uart_tb;

-------------------------------------------------------------------------------

architecture sim of uart_tb is

  -- component generics
  constant g_baudrate      : positive := 115200;
  constant g_clk_frequency : positive := 40e6;
  -- constant g_clks_per_bit  : positive := g_clk_frequency / g_baudrate;
  constant clk_period      : time     := 25 ns;
  constant half_clk_period : time     := clk_period /2;

  constant baud_period : time := (1e9 / g_baudrate) * 1 ns;

  -- component ports
  signal rst_n         : std_logic                    := '0';
  signal uart_rx_out   : std_logic;
  signal uart_tx_in    : std_logic                    := '1';
  signal data_in       : std_logic_vector(7 downto 0) := (others => '0');
  signal data_in_v     : std_logic                    := '0';
  signal data_out      : std_logic_vector(7 downto 0);
  signal tx_data_check : std_logic_vector(7 downto 0) := (others => '0');
  signal data_out_v    : std_logic;
  signal data_in_sent  : std_logic;

  -- clock
  signal clk     : std_logic := '1';
  signal run_sim : boolean   := true;

  -- File content mgmt
  -- Path relative to where .do is located
  file data2uart : text open read_mode is gFilenameInput;
  file uart2data : text open write_mode is gFilenameOutput;

  procedure proc_dataValid (signal data_in_v : out std_logic) is
  begin
    data_in_v <= '1';
    wait for clk_period;
    data_in_v <= '0';
    wait for clk_period;
  end procedure proc_dataValid;

begin  -- architecture sim

  -- component instantiation
  DUT : entity work.uart
    generic map (
      g_baudrate      => g_baudrate,
      g_clk_frequency => g_clk_frequency)
    port map (
      clk          => clk,
      rst_n        => rst_n,
      uart_rx_out  => uart_rx_out,      -- UART Out (to receiver) 
      uart_tx_in   => uart_tx_in,       -- UART In (From Receiver)
      data_in      => data_in,
      data_in_v    => data_in_v,
      data_in_sent => data_in_sent,
      data_out     => data_out,
      data_out_v   => data_out_v);

  -- clock generation
  clk <= not clk after half_clk_period when run_sim else
         '0';

  -- waveform generation
  WaveGen_Proc : process
    variable row                : line;
    variable v_data_row_counter : integer := 0;
    variable data_from_file     : std_logic_vector(7 downto 0);
  begin
    wait for 3*clk_period;
    rst_n <= '1';
    wait for 100 ns;
    while (not endfile(data2uart)) loop
      -- read from input file in "row" variable
      if(not endfile(data2uart)) then
        report "hread WaveGenProc";
        v_data_row_counter := v_data_row_counter + 1;  -- sert à quelquechose?
        readline(data2uart, row);
        hread(row, data_from_file);
        writeline(output, row);
        data_in            <= data_from_file;
        proc_dataValid(data_in_v);
        wait until data_in_sent = '1';

      end if;
      wait for 1 us;

    end loop;

    wait for 1 us;

    -- End simulation
    report "End of simulation";
    run_sim <= false;
    wait;
  end process WaveGen_Proc;


  tx_process_check : process
    variable cnt_bit_data : integer range 0 to 8 := 0;
    variable row          : line;
  begin

    while(run_sim) loop
      wait until falling_edge(uart_rx_out);
      wait for baud_period/2;
      assert uart_rx_out = '0' report "Assertion violation: bit start error" severity error;

      while(cnt_bit_data < 8) loop
        wait for baud_period;
        tx_data_check <= uart_rx_out & tx_data_check(7 downto 1);
        cnt_bit_data  := cnt_bit_data+1;
      end loop;

      wait for baud_period;
      cnt_bit_data := 0;
      assert uart_rx_out = '1' report "Assertion violation: bit stop error" severity error;
      -- Write in file
      hwrite(row, tx_data_check, left);
      writeline(uart2data, row);
    end loop;
  end process tx_process_check;


  rx_process : process
    file data2uartRx            : text open read_mode is gFileNameInputRx;
    variable row                : line;
    variable v_data_row_counter : integer := 0;
    variable data_from_file     : std_logic_vector(7 downto 0);
    variable cnt_bit_data       : integer := 0;
  begin

    while(run_sim) loop
      uart_tx_in <= '1';
      wait until rising_edge(rst_n);
      wait for 3*clk_period;

      while (not endfile(data2uartRx)) loop
        report "hread RxProcess";
        readline(data2uartRx, row);
        hread(row, data_from_file);
        uart_tx_in <= '0';
        wait for baud_period;

        while(cnt_bit_data < 8) loop
          uart_tx_in                 <= data_from_file(0);
          data_from_file(6 downto 0) := data_from_file(7 downto 1);
          cnt_bit_data               := cnt_bit_data+1;
          wait for baud_period;
        end loop;

        uart_tx_in <= '1';
        cnt_bit_data := 0;
        wait for baud_period;

      end loop;
    end loop;

  end process rx_process;

end architecture sim;

