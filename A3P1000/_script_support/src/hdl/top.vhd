--------------------------------------------------------------------------------
--
-- File: top.vhd
-- File history:

--
-- Description: 
--
-- <Description here>
--

-- Version: 2025_02_04
--------------------------------------------------------------------------------

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
  generic(
    g_clk_frequency     : positive := 40e6;  -- Main clock frequency Hz
    g_nb_button         : positive := 2;  -- Button number
    g_nb_fpga_diag      : positive := 6;  -- Diagnostic FPGA for debug purpose
    g_bus_width_acc_gyr : positive := 32; -- Largeur bus du bloc acc_gyr
    g_nb_save_mem       : positive := 3   -- Nombre de plan MS
    );
  port (
    -- Clock en Reset
    clk               : in  std_logic;
    clk_ext           : in  std_logic;  -- synthesis syn_keep = 1 --
    rst_n             : in  std_logic;
    -- Accelerometer and Gyroscope Signals
    acc_0             : in  std_logic;
    gyr_0             : in  std_logic;
    -- RS232
    rs232_rx          : in  std_logic;
    rs232_tx          : out std_logic;
    -- RS485
    rs485_r           : in  std_logic;  -- Logic output RS485 THVD1424 Data
    rs485_d           : out std_logic;  -- Logic input RS485 THVD1424 Data
    rs485_r_enable_n  : out std_logic;  -- Receive enable_n. 1 = Receive disable
    rs485_d_enable    : out std_logic;  -- Driver enable. 1 = Driver enable
    rs485_half_full_n : out std_logic;  -- Half to Full duplex ctrl. 0=full
    rs485_term_tx     : out std_logic;  -- Enable 120 Ohm on-chip. 1 = enable
    rs485_term_rx     : out std_logic;  -- Enable 120 Ohm on-chip. 1 = enable
    rs485_slew_rate   : out std_logic;  -- 1 = 500 kbps / 0 = 20 Mbps
    -- NVM
    nvm_clk           : out std_logic;
    nvm_mosi          : out std_logic;
    nvm_miso          : in  std_logic;
    nvm_write_protect : out std_logic;
    nvm_hold          : out std_logic;
    nvm_cs            : out std_logic_vector(g_nb_save_mem-1 downto 0);
    nvm_indic_ms      : out std_logic_vector(1 downto 0);
    nvm_spare         : out std_logic_vector(4 downto 0);
    -- Debug Ports
    btn               : in  std_logic_vector(g_nb_button-1 downto 0);
    fpga_diag         : out std_logic_vector(g_nb_fpga_diag-1 downto 0);
    led_green         : out std_logic;
    led_red           : out std_logic
    );
end top;
architecture architecture_top of top is

  signal sig_btn           : std_logic_vector(g_nb_button-1 downto 0);
  signal sig_btn_debounced : std_logic_vector(g_nb_button-1 downto 0);
  signal sig_debouncer_out : std_logic_vector(g_nb_button-1 downto 0);
  signal sig_debouncer_in  : std_logic_vector(g_nb_button-1 downto 0);

  signal sig_rst_n    : std_logic;
  signal sig_acc_0    : std_logic;
  signal sig_gyr_0    : std_logic;
  signal sig_rs232_rx : std_logic;

  signal sig_sync_us : std_logic;
  signal sig_sync_ms : std_logic;

  constant c_nb_input_to_resync : positive := 6;
  signal sig_resync_in          : std_logic_vector(c_nb_input_to_resync-1 downto 0);
  signal sig_resync_out         : std_logic_vector(c_nb_input_to_resync-1 downto 0);

  signal sig_led_heartbeat : std_logic;

  signal sig_rs485_r : std_logic;



  signal sig_captur_period     : std_logic;
  signal sig_period_acc        : std_logic_vector (g_bus_width_acc_gyr-1 downto 0);
  signal sig_period_gyr        : std_logic_vector (g_bus_width_acc_gyr-1 downto 0);
  signal sig_period_etat_h_acc : std_logic_vector (g_bus_width_acc_gyr-1 downto 0);
  signal sig_period_etat_h_gyr : std_logic_vector (g_bus_width_acc_gyr-1 downto 0);



  component resync is
    generic (
      g_nb_port : positive);
    port (
      clk        : in  std_logic;
      resync_in  : in  std_logic_vector(g_nb_port-1 downto 0);
      resync_out : out std_logic_vector(g_nb_port-1 downto 0));
  end component resync;


  component sync is
    generic (
      g_clk_frequency : positive);
    port (
      clk     : in  std_logic;
      rst_n   : in  std_logic;
      sync_us : out std_logic;
      sync_ms : out std_logic);
  end component sync;

  component debouncer is
    generic (
      g_nb_button : positive);
    port (
      clk           : in  std_logic;
      rst_n         : in  std_logic;
      sync          : in  std_logic;
      debouncer_in  : in  std_logic_vector(g_nb_button-1 downto 0);
      debouncer_out : out std_logic_vector(g_nb_button-1 downto 0));
  end component debouncer;

  component heartbeat is
    generic (
      g_clk_frequency : positive);
    port (
      clk   : in  std_logic;
      rst_n : in  std_logic;
      led   : out std_logic);
  end component heartbeat;

  component rs485 is
    port (
      clk               : in  std_logic;
      rst_n             : in  std_logic;
      rs485_r           : in  std_logic;
      rs485_d           : out std_logic;
      rs485_r_enable_n  : out std_logic;
      rs485_d_enable    : out std_logic;
      rs485_half_full_n : out std_logic;
      rs485_term_tx     : out std_logic;
      rs485_term_rx     : out std_logic;
      rs485_slew_rate   : out std_logic);
  end component rs485;

  component acc_gyr is
    generic (
      n : natural);
    port (
      acc               : in  std_logic;
      gyr               : in  std_logic;
      clk               : in  std_logic;
      rst_n             : in  std_logic;
      captur_period     : in  std_logic;
      period_acc        : out std_logic_vector (n-1 downto 0);
      period_gyr        : out std_logic_vector (n-1 downto 0);
      period_etat_h_acc : out std_logic_vector (n-1 downto 0);
      period_etat_h_gyr : out std_logic_vector (n-1 downto 0));
  end component acc_gyr;

begin

  ---------------------** RESYNC **--------------------------------------------

  sig_resync_in(0) <= btn(0);
  sig_resync_in(1) <= btn(1);
  sig_resync_in(2) <= rst_n;
  sig_resync_in(3) <= acc_0;
  sig_resync_in(4) <= gyr_0;
  sig_resync_in(5) <= rs232_rx;

  resync_1 : resync
    generic map (
      g_nb_port => c_nb_input_to_resync)
    port map (
      clk        => clk,
      resync_in  => sig_resync_in,
      resync_out => sig_resync_out);

  sig_btn(0)   <= sig_resync_out(0);
  sig_btn(1)   <= sig_resync_out(1);
  sig_rst_n    <= sig_resync_out(2);
  sig_acc_0    <= sig_resync_out(3);
  sig_gyr_0    <= sig_resync_out(4);
  sig_rs232_rx <= sig_resync_out(5);

  ---------------------** SYNC_GEN **------------------------------------------

  sync_1 : sync
    generic map (
      g_clk_frequency => 40e6
      )
    port map (
      clk     => clk,
      rst_n   => sig_rst_n,
      sync_us => sig_sync_us,
      sync_ms => sig_sync_ms);


  ---------------------** BUTTON DEBOUNCER **----------------------------------

  sig_debouncer_in <= sig_btn;

  debouncer_1 : debouncer
    generic map (
      g_nb_button => g_nb_button)
    port map (
      clk           => clk,
      rst_n         => sig_rst_n,
      sync          => sig_sync_ms,
      debouncer_in  => sig_debouncer_in,
      debouncer_out => sig_debouncer_out);

  sig_btn_debounced <= sig_debouncer_out;

  ---------------------** Heartbeat **-----------------------------------------

  heartbeat_1 : entity work.heartbeat
    generic map (
      g_clk_frequency => g_clk_frequency
      )
    port map (
      clk   => clk,
      rst_n => sig_rst_n,
      led   => sig_led_heartbeat);


---------------------** RS485 **-----------------------------------------

  sig_rs485_r <= sig_led_heartbeat and rs485_r;

  rs485_1 : entity work.rs485
    port map (
      clk               => clk,
      rst_n             => rst_n,
      rs485_r           => sig_rs485_r,
      rs485_d           => rs485_d,
      rs485_r_enable_n  => rs485_r_enable_n,
      rs485_d_enable    => rs485_d_enable,
      rs485_half_full_n => rs485_half_full_n,
      rs485_term_tx     => rs485_term_tx,
      rs485_term_rx     => rs485_term_rx,
      rs485_slew_rate   => rs485_slew_rate);

---------------------** acc gyr **-----------------------------------------

  sig_captur_period <= sig_sync_ms;

  acc_gyr_1 : entity work.acc_gyr
    generic map (
      n => g_bus_width_acc_gyr)
    port map (
      clk               => clk,
      rst_n             => rst_n,
      acc               => sig_acc_0,
      gyr               => sig_gyr_0,
      captur_period     => sig_captur_period,
      period_acc        => sig_period_acc,
      period_gyr        => sig_period_gyr,
      period_etat_h_acc => sig_period_etat_h_acc,
      period_etat_h_gyr => sig_period_etat_h_gyr);



  ---------------------** TEMP OUT **-----------------------------------------

  rs232_tx <= sig_rs232_rx when sig_sync_ms = '1'
              else '0';
  led_green <= sig_btn_debounced(0) or sig_btn_debounced(1) when sig_sync_ms = '1'
               else '0';
  led_red <= sig_led_heartbeat;

  nvm_clk           <= sig_led_heartbeat and nvm_miso and clk_ext;
  nvm_mosi          <= sig_led_heartbeat and nvm_miso and clk_ext;
  nvm_write_protect <= sig_led_heartbeat;
  nvm_hold          <= sig_led_heartbeat;
  nvm_cs            <= "101";
  nvm_indic_ms      <= sig_btn_debounced;

  ---------------------** SPARE OUT **-----------------------------------------
  nvm_spare <= (others => '1') when sig_led_heartbeat = '1' and sig_acc_0 = '1' else
               (others => '0');
  fpga_diag <= (others => '1') when sig_led_heartbeat = '1' and sig_gyr_0 = '1' else
               (others => '0');



-- architecture body
end architecture_top;

