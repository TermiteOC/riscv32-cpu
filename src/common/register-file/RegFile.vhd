-------------------------------------------------------------------------------
-- Module: RegFile
-- Description: 32-bit 32-register register file.
-- Author: Levy Elmescany
-- Date: 2025-08-02
-- License: MIT
-- Inputs: read_addr_1, read_addr_2, write_addr, write_data, reg_write, clk
-- Outputs: read_data_1, read_data_2
-- Tool Compatibility: Quartus Prime 24.x or compatible synthesis tools
-- Notes: 
--   - No reset for registers.
--   - Register 0 cannot be written, only read; always stores value 0.
-- Simulation: Verified via tb_RegFile
-- Revision History:
--   Rev 1.0 - 2025-08-02 - Initial implementation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.CommonTypes.all; -- Import type WordArray_t (array(0 to 31) of std_logic_vector(31 downto 0))

entity RegFile is
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
end RegFile;

architecture rtl of RegFile is

    -- 5-to-32 decoder
    component RegDecoder is
        port (
            code   : in  std_logic_vector(4 downto 0);  -- selector
            decode : out std_logic_vector(31 downto 0)  -- one-hot output
        );
    end component;

    -- 32-bit register
    component Reg_32Bit is
        port (
            d   : in  std_logic_vector(31 downto 0); -- data input
            we  : in  std_logic;                     -- write enable
            clk : in  std_logic;                     -- clock
            q   : out std_logic_vector(31 downto 0)  -- data output
        );
    end component;

    -- 32-bit 32-to-1 multiplexer
    component Mux32x1_32Bit is
        port (
            inputs : in  WordArray_t;                   -- input array
            sel    : in  std_logic_vector(4 downto 0);  -- selector
            res    : out std_logic_vector(31 downto 0)  -- selected output
        );
    end component;

    -- Decoded signal
    signal w_write_decode : std_logic_vector(31 downto 0);

    -- Registers output signal, read ports input
    signal w_reg_out : WordArray_t;

    -- Write enable control signal
    signal w_write_enable : std_logic_vector(31 downto 0);

begin
    -- Combinational Logic
    -- Each register is written only if reg_write = '1' and the corresponding decoded bit is '1'
    write_enable_gen : for i in 1 to 31 generate
    begin
        w_write_enable(i) <= reg_write AND w_write_decode(i);
    end generate;

    -- Disable write to register 0
    w_write_enable(0) <= '0';

    -- Output of register 0 is always 0
    w_reg_out(0) <= (others => '0');

    -- Component Instantiations
    -- Decodes which register address to be written from binary value
    reg_decoder_inst : RegDecoder
    port map (
        code   => write_addr,
        decode => w_write_decode
    );

    -- Register generate loop
    reg_file_gen : for i in 1 to 31 generate
    begin
        reg_inst : Reg_32Bit
        port map (
            d   => write_data,
            we  => w_write_enable(i),
            clk => clk,
            q   => w_reg_out(i)
        );
    end generate;

    -- Read port 1
    read_1_mux_inst : Mux32x1_32Bit
    port map (
        inputs => w_reg_out,
        sel    => read_addr_1,
        res    => read_data_1
    );

    -- Read port 2
    read_2_mux_inst : Mux32x1_32Bit
    port map (
        inputs => w_reg_out,
        sel    => read_addr_2,
        res    => read_data_2
    );
end rtl;