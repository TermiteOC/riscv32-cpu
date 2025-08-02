-------------------------------------------------------------------------------
-- Module: tb_RegFile
-- Description: 
--   - Testbench for RegFile.
--   - Simulates basic write and read operations.
-- Author: Levy Elmescany
-- Date: 2025-08-02
-- License: MIT
-- Tool Compatibility: Intel ModelSim 2020.1 or compatible simulation tools
-- Simulation:
--   - Stimuli generated for register write and read operations.
--   - Output verified via assertions.
--   - Simulated in Intel ModelSim 2024 with waveform inspection.
-- Revision History:
--   Rev 1.0 - 2025-08-02 - Initial testbench implementation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_RegFile is
end tb_RegFile;

architecture behavioral of tb_RegFile is

    component RegFile is
        port (
            read_addr_1 : in  std_logic_vector(4 downto 0);  -- 1st read register address
            read_addr_2 : in  std_logic_vector(4 downto 0);  -- 2nd read register address
            write_addr  : in  std_logic_vector(4 downto 0);  -- write register address
            write_data  : in  std_logic_vector(31 downto 0); -- data input
            reg_write   : in  std_logic;                     -- write control flag
            clk         : in  std_logic;                     -- clock
            read_data_1 : out std_logic_vector(31 downto 0); -- 1st data output
            read_data_2 : out std_logic_vector(31 downto 0)  -- 2nd data output
        );
    end component;

    -- DUT signals
    signal w_read_addr_1 : std_logic_vector(4 downto 0) := (others => '0');
    signal w_read_addr_2 : std_logic_vector(4 downto 0) := (others => '0');
    signal w_write_addr  : std_logic_vector(4 downto 0) := (others => '0');
    signal w_write_data  : std_logic_vector(31 downto 0) := (others => '0');
    signal w_reg_write   : std_logic := '0';
    signal w_read_data_1 : std_logic_vector(31 downto 0);
    signal w_read_data_2 : std_logic_vector(31 downto 0);

    -- Initialize clock
    signal w_clk : std_logic := '0';

    -- Clock period definition
    constant CLK_PERIOD : time := 1 ns;

begin
    -- DUT connection
    dut : RegFile
    port map (
        read_addr_1 => w_read_addr_1,
        read_addr_2 => w_read_addr_2,
        write_addr  => w_write_addr,
        write_data  => w_write_data,
        reg_write   => w_reg_write,
        clk         => w_clk,
        read_data_1 => w_read_data_1,
        read_data_2 => w_read_data_2
    );

    -- Clock process definition
    w_clk <= not w_clk after CLK_PERIOD/2;

    -- Stimulus process
    process
    begin
        -- Test case 1:
        -- Write value 10 to register 1
        w_reg_write   <= '1';
        w_write_data  <= std_logic_vector(to_unsigned(10, 32));
        w_write_addr  <= "00001"; -- Register 1
        wait for CLK_PERIOD;

        -- Read from register 1 and 0
        w_reg_write   <= '0';
        w_read_addr_1 <= "00001"; -- Should read 10
        w_read_addr_2 <= "00000"; -- Should read 0
        wait for CLK_PERIOD;
        assert (w_read_data_1 = std_logic_vector(to_unsigned(10, 32)) AND
                w_read_data_2 = std_logic_vector(to_unsigned(0, 32)))
        report "Error: Test case 1 - Expected read data 1 = 10 and read data 2 = 0" severity error;

        -- Test case 2:
        -- Write value 3 to register 0 (cannot write)
        w_reg_write  <= '1';
        w_write_data <= std_logic_vector(to_unsigned(3, 32));
        w_write_addr <= "00000"; -- Register 0
        wait for CLK_PERIOD;

        -- Write value 15 to register 31
        w_reg_write  <= '1';
        w_write_data <= std_logic_vector(to_unsigned(15, 32));
        w_write_addr <= "11111"; -- Register 31
        wait for CLK_PERIOD;

        -- Read from register 0 and 31
        w_reg_write   <= '0';
        w_read_addr_1 <= "00000"; -- Should read 0
        w_read_addr_2 <= "11111"; -- Should read 15
        wait for CLK_PERIOD;
        assert (w_read_data_1 = std_logic_vector(to_unsigned(0, 32)) AND
                w_read_data_2 = std_logic_vector(to_unsigned(15, 32)))
        report "Error: Test case 2 - Expected read data 1 = 0 and read data 2 = 15" severity error;

        -- Test case 3:
        -- Write value 255 to register 1 (is storing value 10)
        w_reg_write  <= '1';
        w_write_data <= std_logic_vector(to_unsigned(255, 32));
        w_write_addr <= "00001"; -- Register 1
        wait for CLK_PERIOD;

        -- Read from register 1 and 31
        w_reg_write   <= '0';
        w_read_addr_1 <= "00001"; -- Should read 255
        w_read_addr_2 <= "11111"; -- Should read 15;
        wait for CLK_PERIOD;

        -- Write value 60 to register 31 
        w_reg_write  <= '1';
        w_write_data <= std_logic_vector(to_unsigned(60, 32));
        w_write_addr <= "11111"; -- Register 31
        wait for CLK_PERIOD/2;

        wait for CLK_PERIOD*0.1;
        -- Check if register 31 updates right after writing to register 31
        assert (w_read_data_1 = std_logic_vector(to_unsigned(255, 32)) AND
                w_read_data_2 = std_logic_vector(to_unsigned(60, 32)))
        report "Error: Test case 3 - Expected read data 1 = 255 and read data 2 = 60" severity error;
        wait for  CLK_PERIOD/2;

        -- Clear inputs
        w_read_addr_1 <= (others => '0');
        w_read_addr_2 <= (others => '0');
        w_write_addr  <= (others => '0');
        w_write_data  <= (others => '0');
        w_reg_write   <= '0';
        assert false report "Successful test." severity note;
        wait;
    end process;
end behavioral;