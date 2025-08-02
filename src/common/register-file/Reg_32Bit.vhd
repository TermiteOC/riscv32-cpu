-------------------------------------------------------------------------------
-- Module: Reg_32Bit
-- Description: 32-bit rising-edge-triggered register.
-- Author: Levy Elmescany
-- Date: 2025-08-02
-- License: MIT
-- Inputs: d, we, clk
-- Outputs: q
-- Tool Compatibility: Quartus Prime 24.x or compatible synthesis tools
-- Notes: 
--   - No reset.
--   - Includes write enable control signal.
-- Simulation: Verified via tb_RegFile
-- Revision History:
--   Rev 1.0 - 2025-08-02 - Initial implementation
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Reg_32Bit is
    port (
        d   : in  std_logic_vector(31 downto 0); -- data input
        we  : in  std_logic;                     -- write enable
        clk : in  std_logic;                     -- clock
        q   : out std_logic_vector(31 downto 0)  -- data output
    );
end Reg_32Bit;

architecture rtl of Reg_32Bit is
begin
    process(clk) 
    begin
        if (rising_edge(clk)) then
            if we = '1' then
                q <= d;
            end if;
        end if;
    end process;
end rtl;