# -------------------------------------------------------------------------------------------------
# -- Project             : Mars ZX3 Reference Design
# -- File description    : Pin assignment and timing constraints file for Mars Starter
# -- File name           : Const_PWM_Tester_6CH.xdc
# -- Authors             : VFF
# -------------------------------------------------------------------------------------------------
# --
# -------------------------------------------------------------------------------------------------
# -- Notes:
# -- The IO standards might need to be adapted to your design
# -------------------------------------------------------------------------------------------------
# -- File history:
# --
# -- Version | Date       | Author             | Remarks
# -- ----------------------------------------------------------------------------------------------
# -- 1.0     | 21.01.2014 | VFF                | First released version
# --
# -------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------
# Important! Do not remove this constraint!
# This property ensures that all unused pins are set to high impedance.
# If the constraint is removed, all unused pins have to be set to HiZ in the top level file.
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLNONE [current_design]
# ----------------------------------------------------------------------------------

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 2.5 [current_design]

# ----------------------------------------------------------------------------------
# -- eth I/Os connected in parallel with MIO pins, set to high impedance if not used
# ----------------------------------------------------------------------------------

set_property PACKAGE_PIN U12 [get_ports ETH_Link]
set_property IOSTANDARD LVCMOS25 [get_ports ETH_Link]

set_property PACKAGE_PIN AA12 [get_ports ETH_MDC]
set_property IOSTANDARD LVCMOS25 [get_ports ETH_MDC]

set_property PACKAGE_PIN AB12 [get_ports ETH_MDIO]
set_property IOSTANDARD LVCMOS25 [get_ports ETH_MDIO]
set_property PULLUP TRUE [get_ports ETH_MDIO]

set_property PACKAGE_PIN Y9 [get_ports ETH_RX_CLK]
set_property IOSTANDARD LVCMOS25 [get_ports ETH_RX_CLK]

set_property PACKAGE_PIN Y8 [get_ports ETH_RX_CTL]
set_property IOSTANDARD LVCMOS25 [get_ports ETH_RX_CTL]

set_property PACKAGE_PIN U10 [get_ports {ETH_RXD[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {ETH_RXD[0]}]

set_property PACKAGE_PIN Y11 [get_ports {ETH_RXD[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {ETH_RXD[1]}]

set_property PACKAGE_PIN W11 [get_ports {ETH_RXD[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {ETH_RXD[2]}]

set_property PACKAGE_PIN U11 [get_ports {ETH_RXD[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {ETH_RXD[3]}]

set_property PACKAGE_PIN W10 [get_ports ETH_TX_CLK]
set_property IOSTANDARD LVCMOS25 [get_ports ETH_TX_CLK]

set_property PACKAGE_PIN V10 [get_ports ETH_TX_CTL]
set_property IOSTANDARD LVCMOS25 [get_ports ETH_TX_CTL]

set_property PACKAGE_PIN V8 [get_ports {ETH_TXD[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {ETH_TXD[0]}]

set_property PACKAGE_PIN W8 [get_ports {ETH_TXD[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {ETH_TXD[1]}]

set_property PACKAGE_PIN U6 [get_ports {ETH_TXD[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {ETH_TXD[2]}]

set_property PACKAGE_PIN V9 [get_ports {ETH_TXD[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports {ETH_TXD[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports uart_DBG0_rxd]
set_property PACKAGE_PIN D20 [get_ports uart_DBG0_rxd]

set_property IOSTANDARD LVCMOS33 [get_ports uart_DBG0_txd]
set_property PACKAGE_PIN C20 [get_ports uart_DBG0_txd]

set_property IOSTANDARD LVCMOS33 [get_ports {gpio_out_tri_o[0]}]
set_property PACKAGE_PIN AB15 [get_ports {gpio_out_tri_o[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {gpio_out_tri_o[1]}]
set_property PACKAGE_PIN AA13 [get_ports {gpio_out_tri_o[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {gpio_out_tri_o[2]}]
set_property PACKAGE_PIN AA14 [get_ports {gpio_out_tri_o[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {gpio_out_tri_o[3]}]
set_property PACKAGE_PIN H18 [get_ports {gpio_out_tri_o[3]}]

# ----------------------------------------------------------------------------------
# -- eth I/Os connected in parallel with MIO pins, set to high impedance if not used
# ----------------------------------------------------------------------------------

set_property PACKAGE_PIN E21 [get_ports J905_09]
set_property IOSTANDARD LVCMOS33 [get_ports J905_09]

set_property IOSTANDARD LVCMOS33 [get_ports J905_10]
set_property PACKAGE_PIN D21 [get_ports J905_10]

set_property IOSTANDARD LVCMOS33 [get_ports J905_11]
set_property PACKAGE_PIN F21 [get_ports J905_11]

set_property IOSTANDARD LVCMOS33 [get_ports J905_12]
set_property PACKAGE_PIN F22 [get_ports J905_12]

set_property IOSTANDARD LVCMOS33 [get_ports J905_15]
set_property PACKAGE_PIN H22 [get_ports J905_15]

set_property IOSTANDARD LVCMOS33 [get_ports J905_16]
set_property PACKAGE_PIN G22 [get_ports J905_16]

set_property IOSTANDARD LVCMOS33 [get_ports pwm_CH01_out_L]
set_property PACKAGE_PIN W17 [get_ports pwm_CH01_out_L]

set_property IOSTANDARD LVCMOS33 [get_ports pwm_CH01_out_R]
set_property PACKAGE_PIN W18 [get_ports pwm_CH01_out_R]

set_property IOSTANDARD LVCMOS33 [get_ports pwm_CH02_out_L]
set_property PACKAGE_PIN U15 [get_ports pwm_CH02_out_L]

set_property IOSTANDARD LVCMOS33 [get_ports pwm_CH02_out_R]
set_property PACKAGE_PIN U16 [get_ports pwm_CH02_out_R]

set_property IOSTANDARD LVCMOS33 [get_ports pwm_CH03_out_L]
set_property PACKAGE_PIN W16 [get_ports pwm_CH03_out_L]

set_property IOSTANDARD LVCMOS33 [get_ports pwm_CH03_out_R]
set_property PACKAGE_PIN Y16 [get_ports pwm_CH03_out_R]

set_property IOSTANDARD LVCMOS33 [get_ports pwm_CH04_out_L]
set_property PACKAGE_PIN AA17 [get_ports pwm_CH04_out_L]

set_property IOSTANDARD LVCMOS33 [get_ports pwm_CH04_out_R]
set_property PACKAGE_PIN AB17 [get_ports pwm_CH04_out_R]

set_property IOSTANDARD LVCMOS33 [get_ports pwm_CH04_out_T]
set_property PACKAGE_PIN A16 [get_ports pwm_CH04_out_T]

set_property PACKAGE_PIN Y18 [get_ports pwm_CH06_out_L]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_CH06_out_L]

set_property PACKAGE_PIN AA18 [get_ports pwm_CH06_out_R]
set_property IOSTANDARD LVCMOS33 [get_ports pwm_CH06_out_R]

