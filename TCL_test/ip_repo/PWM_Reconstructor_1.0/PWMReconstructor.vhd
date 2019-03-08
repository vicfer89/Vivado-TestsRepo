----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.02.2019 12:16:26
-- Design Name: 
-- Module Name: PWMReconstructor - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PWMReconstructor is
generic (
    period : integer := 20000
    );
    Port ( value : in STD_LOGIC_VECTOR (15 downto 0);
           clk_in : in STD_LOGIC;
           pwm_signal : out STD_LOGIC);
end PWMReconstructor;

architecture Behavioral of PWMReconstructor is

signal cuenta, p_cuenta : std_logic_vector (15  downto 0) := (others => '0');

begin

    process(clk_in)
    begin
    if (rising_edge (clk_in)) then
        cuenta <= p_cuenta;
        end if;
    end process;
    
    process (cuenta)
    begin
        if cuenta = period then
            p_cuenta <= (others=>'0');
        else
            p_cuenta <= cuenta + 1;
        end if;
    end process;
    
    pwm_signal <= '1' when cuenta < value else '0';

end Behavioral;
