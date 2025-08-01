-------------------------------------------------------------------------------
-- Module: PCReg
-- Description: 32-bit rising-edge-triggered program counter register.
-- Author: Levy Elmescany
-- Date: 2025-08-01
-- License: MIT
-- Inputs: d, rst, clk
-- Outputs: q
-- Tool Compatibility: Quartus Prime 24.x or compatible synthesis tools
-- Notes: 
--   - Includes synchronous reset for initialization.
--   - Reset sets output to 0.
--   - Reset is active high
-- Simulation: Verified via tb_PCReg testbench
-- Revision History:
--   Rev 1.0 - 2025-08-01 - Initial implementation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PCReg is
    port (
        d   : in  std_logic_vector(31 downto 0); -- data input
        rst : in  std_logic;                     -- reset
        clk : in  std_logic;                     -- clock
        q   : out std_logic_vector(31 downto 0)  -- data output
    );
end PCReg;

architecture rtl of PCReg is
begin
    process(clk) 
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                q <= (others => '0');
            else
                q <= d;
            end if;
        end if;
    end process;
end rtl;