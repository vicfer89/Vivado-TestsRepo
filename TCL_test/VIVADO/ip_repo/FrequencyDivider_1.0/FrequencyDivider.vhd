----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.03.2019 10:31:31
-- Design Name: 
-- Module Name: FrequencyDivider - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FrequencyDivider is
    generic (MAX_COUNTER: integer := 200000);
    port ( CLK_IN : in STD_LOGIC;
           CLK_OUT : out STD_LOGIC);
end FrequencyDivider;

architecture Behavioral of FrequencyDivider is

    signal temporal,cambio: std_logic;
    signal counter : integer range 0 to MAX_COUNTER := 0;
    
begin
    process (CLK_IN) is 
	   begin
        if rising_edge(CLK_IN) then
            if (counter = MAX_COUNTER) then
                counter <= 0;
                temporal <= not(temporal);
                --cambio <= '1';
            else
                counter <= counter + 1;
                temporal <= temporal;
            end if;
        end if;
    end process;
    
--    process(cambio)
--        begin
--            if(cambio = '1') then 
--                temporal <= not(temporal);
--            else
--                temporal <= temporal;
--            end if;                
        
--    end process;
    
    
    CLK_OUT <= temporal;

end Behavioral;
