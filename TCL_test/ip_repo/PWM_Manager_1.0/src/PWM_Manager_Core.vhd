----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.02.2019 09:47:35
-- Design Name: 
-- Module Name: PWM_Manager_Core - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PWM_Manager_Core is
    Port ( PWM_RC : in STD_LOGIC_VECTOR (15 downto 0);
           r_PWM_ARM : in STD_LOGIC_VECTOR (15 downto 0);
           MODE : in STD_LOGIC_VECTOR (1 downto 0);           
           
           v_PWM_INV : out STD_LOGIC_VECTOR (15 downto 0);
           
           r_sel_L_inv : in STD_LOGIC;
           r_sel_R_inv : in STD_LOGIC;
                     
           r_PWM_ARM_L : in STD_LOGIC_VECTOR (15 downto 0);
           r_PWM_ARM_R : in STD_LOGIC_VECTOR (15 downto 0);
           r_sel_L_direct : in STD_LOGIC;
           r_sel_R_direct : in STD_LOGIC;
           
           PWM_L : out STD_LOGIC_VECTOR (15 downto 0);
           PWM_R : out STD_LOGIC_VECTOR (15 downto 0);
           
           r_min_PWM_D : in STD_LOGIC_VECTOR (15 downto 0);
           r_max_PWM_D : in STD_LOGIC_VECTOR (15 downto 0));
end PWM_Manager_Core;

architecture Behavioral of PWM_Manager_Core is
    signal s_pwm_input      : std_logic_vector(15 downto 0);
    signal s_pwm_inverted   : std_logic_vector(15 downto 0);
    signal s_pwm_satured    : std_logic_vector(15 downto 0);
    signal s_pwm_proc_L     : std_logic_vector(15 downto 0);
    signal s_pwm_proc_R     : std_logic_vector(15 downto 0);
    signal inverted_value   : std_logic_vector(15 downto 0);
    
    signal sel_L_dir : std_logic_vector(1 downto 0);
    signal sel_R_dir : std_logic_vector(1 downto 0);
begin

    -- Etapa de selección de entrada
    s_pwm_input <= PWM_RC    when (MODE = "00" or MODE = "01") else -- Manual para none
                   r_PWM_ARM when (MODE = "10" or MODE = "11"); -- Auto para invalid
                   
    -- Etapa de procesado
    
    inverted_value <= r_max_PWM_D + r_min_PWM_D - s_pwm_input;
    v_PWM_INV <= s_pwm_inverted;
        
    s_pwm_inverted <= inverted_value when ( (s_pwm_input >= r_min_PWM_D) and (s_pwm_input <= r_max_PWM_D) ) else
                      r_max_PWM_D when s_pwm_input < r_min_PWM_D else
                      r_min_PWM_D when s_pwm_input > r_max_PWM_D;
                       
    s_pwm_satured <= s_pwm_input when ((s_pwm_input >= r_min_PWM_D) and (s_pwm_input <= r_max_PWM_D) ) else
                     r_min_PWM_D when s_pwm_input < r_min_PWM_D else
                     r_max_PWM_D when s_pwm_input > r_max_PWM_D;                 
   
                     
    -- Etapa de inversión
    s_pwm_proc_L <= s_pwm_satured  when r_sel_L_inv = '0' else
                    s_pwm_inverted when r_sel_L_inv = '1';
                    
    s_pwm_proc_R <= s_pwm_satured  when r_sel_R_inv = '0' else
                    s_pwm_inverted when r_sel_R_inv = '1';
                    
    -- Etapa de salida
    PWM_L <= (others => '0') when sel_L_dir = "00" else
             s_pwm_proc_L    when sel_L_dir = "01" else
             s_pwm_proc_L    when sel_L_dir = "10" else
             r_PWM_ARM_L     when sel_L_dir = "11";
             
    PWM_R <= (others => '0') when sel_R_dir = "00" else
             s_pwm_proc_R    when sel_R_dir = "01" else
             s_pwm_proc_R    when sel_R_dir = "10" else
             r_PWM_ARM_R     when sel_R_dir = "11";
 
    sel_L_dir <= "00" when MODE = "00" else
                 "01" when MODE = "01" else
                 "10" when ( (MODE = "10" or MODE = "11") and r_sel_L_direct = '0') else
                 "11" when ( (MODE = "10" or MODE = "11") and r_sel_L_direct = '1');
             
    sel_R_dir <= "00" when MODE = "00" else
                 "01" when MODE = "01" else
                 "10" when ( (MODE = "10" or MODE = "11") and r_sel_R_direct = '0') else
                 "11" when ( (MODE = "10" or MODE = "11") and r_sel_R_direct = '1');
 end Behavioral;