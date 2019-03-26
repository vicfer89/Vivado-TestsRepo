--Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2014.4 (win64) Build 1071353 Tue Nov 18 18:29:27 MST 2014
--Date        : Mon Mar 25 16:23:31 2019
--Host        : Aertec-PC896 running 64-bit major release  (build 9200)
--Command     : generate_target PWM_Manager_6CH_wrapper.bd
--Design      : PWM_Manager_6CH_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity PWM_Manager_6CH_wrapper is
  port (
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    gpio_out_tri_o : out STD_LOGIC_VECTOR ( 3 downto 0 );
    pwm_CH01_out_L : out STD_LOGIC;
    pwm_CH01_out_R : out STD_LOGIC;
    pwm_CH02_out_L : out STD_LOGIC;
    pwm_CH02_out_R : out STD_LOGIC;
    pwm_CH03_out_L : out STD_LOGIC;
    pwm_CH03_out_R : out STD_LOGIC;
    pwm_CH04_out_L : out STD_LOGIC;
    pwm_CH04_out_R : out STD_LOGIC;
    pwm_CH04_out_T : out STD_LOGIC;
    pwm_CH06_out_L : out STD_LOGIC;
    pwm_CH06_out_R : out STD_LOGIC;
    J905_09 : in STD_LOGIC;
    J905_10 : in STD_LOGIC;
    J905_11 : in STD_LOGIC;
    J905_12 : in STD_LOGIC;
    J905_15 : in STD_LOGIC;
    J905_16 : in STD_LOGIC;
    uart_DBG0_rxd : in STD_LOGIC;
    uart_DBG0_txd : out STD_LOGIC
  );
end PWM_Manager_6CH_wrapper;

architecture STRUCTURE of PWM_Manager_6CH_wrapper is
  component PWM_Manager_6CH is
  port (
    pwm_in_ch02 : in STD_LOGIC;
    pwm_in_ch03 : in STD_LOGIC;
    pwm_in_ch04 : in STD_LOGIC;
    pwm_in_ch06 : in STD_LOGIC;
    pwm_CH02_out_L : out STD_LOGIC;
    pwm_CH02_out_R : out STD_LOGIC;
    pwm_CH03_out_L : out STD_LOGIC;
    pwm_CH03_out_R : out STD_LOGIC;
    pwm_CH04_out_L : out STD_LOGIC;
    pwm_CH04_out_R : out STD_LOGIC;
    pwm_CH06_out_L : out STD_LOGIC;
    pwm_CH06_out_R : out STD_LOGIC;
    pwm_CH01_out_R : out STD_LOGIC;
    pwm_CH01_out_L : out STD_LOGIC;
    pwm_CH04_out_T : out STD_LOGIC;
    pwm_in_ch01 : in STD_LOGIC;
    pwm_in_ch05 : in STD_LOGIC;
    DDR_cas_n : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    GPIO_OUT_tri_o : out STD_LOGIC_VECTOR ( 3 downto 0 );
    uart_DBG0_rxd : in STD_LOGIC;
    uart_DBG0_txd : out STD_LOGIC
  );
  end component PWM_Manager_6CH;
begin
PWM_Manager_6CH_i: component PWM_Manager_6CH
    port map (
      DDR_addr(14 downto 0) => DDR_addr(14 downto 0),
      DDR_ba(2 downto 0) => DDR_ba(2 downto 0),
      DDR_cas_n => DDR_cas_n,
      DDR_ck_n => DDR_ck_n,
      DDR_ck_p => DDR_ck_p,
      DDR_cke => DDR_cke,
      DDR_cs_n => DDR_cs_n,
      DDR_dm(3 downto 0) => DDR_dm(3 downto 0),
      DDR_dq(31 downto 0) => DDR_dq(31 downto 0),
      DDR_dqs_n(3 downto 0) => DDR_dqs_n(3 downto 0),
      DDR_dqs_p(3 downto 0) => DDR_dqs_p(3 downto 0),
      DDR_odt => DDR_odt,
      DDR_ras_n => DDR_ras_n,
      DDR_reset_n => DDR_reset_n,
      DDR_we_n => DDR_we_n,
      FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
      FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
      FIXED_IO_mio(53 downto 0) => FIXED_IO_mio(53 downto 0),
      FIXED_IO_ps_clk => FIXED_IO_ps_clk,
      FIXED_IO_ps_porb => FIXED_IO_ps_porb,
      FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
      GPIO_OUT_tri_o(3 downto 0) => gpio_out_tri_o(3 downto 0),
      pwm_CH01_out_L => pwm_CH01_out_L,
      pwm_CH01_out_R => pwm_CH01_out_R,
      pwm_CH02_out_L => pwm_CH02_out_L,
      pwm_CH02_out_R => pwm_CH02_out_R,
      pwm_CH03_out_L => pwm_CH03_out_L,
      pwm_CH03_out_R => pwm_CH03_out_R,
      pwm_CH04_out_L => pwm_CH04_out_L,
      pwm_CH04_out_R => pwm_CH04_out_R,
      pwm_CH04_out_T => pwm_CH04_out_T,
      pwm_CH06_out_L => pwm_CH06_out_L,
      pwm_CH06_out_R => pwm_CH06_out_R,
      pwm_in_ch01 => J905_09,
      pwm_in_ch02 => J905_10,
      pwm_in_ch03 => J905_11,
      pwm_in_ch04 => J905_12,
      pwm_in_ch05 => J905_15,
      pwm_in_ch06 => J905_16,
      uart_DBG0_rxd => uart_DBG0_rxd,
      uart_DBG0_txd => uart_DBG0_txd
    );
end STRUCTURE;
