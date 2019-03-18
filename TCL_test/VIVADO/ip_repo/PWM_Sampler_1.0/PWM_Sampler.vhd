----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.04.2018 16:12:18
-- Design Name: 
-- Module Name: PWM_Sampler - Behavioral
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PWM_Sampler is
    Generic(
        TON_MAX : integer := 2500
    );
    Port ( PWM : in STD_LOGIC;
           CLK : in STD_LOGIC;          
           PWM_Val : out STD_LOGIC_VECTOR (15 downto 0));           
end PWM_Sampler;

architecture Behavioral of PWM_Sampler is

    signal p_input                 : std_logic_vector(0 to 2);
    
    signal r_rise                  : std_logic := '0';
    signal r_fall                  : std_logic := '0';
    
    signal r_count_hi_ena          : std_logic := '0';
    signal r_count_hi              : unsigned(15 downto 0) := (others => '0');
    

 
begin

-- Detector de flancos
edge_detector: process(CLK)--, PWM) 
begin

    if(rising_edge(CLK)) then
        r_rise <= not p_input(2) and p_input(1);
        r_fall <= not p_input(1) and p_input(2);
        p_input <= PWM & p_input(0 to p_input'length-2);
    end if;
    
end process EDGE_DETECTOR;

-- Procesado de cuenta
  
p_count_logic: process(CLK, r_rise, r_fall)
begin

      if(rising_edge(CLK)) then      
        if    (r_rise = '1') then
          r_count_hi_ena  <= '1';
        elsif (r_fall = '1') then
          r_count_hi_ena  <= '0';         
          PWM_Val <= std_logic_vector(r_count_hi);   
        else
            NULL;
        end if;              
      end if;
      
end process p_count_logic;

-- Proceso de cuenta

p_counter: process(CLK, r_count_hi_ena)
begin

    if( rising_edge(CLK) ) then
        if(r_count_hi_ena = '1') then
            if(r_count_hi < TON_MAX) then
             r_count_hi      <= r_count_hi + 1;
            end if;
        else
            r_count_hi <= to_unsigned(1,16);    
        end if;
    end if;
    
end process p_counter;  
    
end Behavioral;
