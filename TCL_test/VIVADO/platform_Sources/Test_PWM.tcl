
################################################################
# This is a generated script based on design: Test_PWM
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2014.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source Test_PWM_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg484-2


# CHANGE DESIGN NAME HERE
set design_name Test_PWM

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}


# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: MODE_MANAGER
proc create_hier_cell_MODE_MANAGER { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_MODE_MANAGER() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  # Create pins
  create_bd_pin -dir I CLK_IN
  create_bd_pin -dir I PWM
  create_bd_pin -dir O -from 1 -to 0 mode
  create_bd_pin -dir I -type clk s00_axi_aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst s00_axi_aresetn

  # Create instance: FrequencyDivider_0, and set properties
  set FrequencyDivider_0 [ create_bd_cell -type ip -vlnv aertec.local:user:FrequencyDivider:1.0 FrequencyDivider_0 ]

  # Create instance: ModeManager_0, and set properties
  set ModeManager_0 [ create_bd_cell -type ip -vlnv aertec.local:user:ModeManager:1.0 ModeManager_0 ]

  # Create instance: PWM_Sampler_MODE, and set properties
  set PWM_Sampler_MODE [ create_bd_cell -type ip -vlnv aertec.local:user:PWM_Sampler:1.0 PWM_Sampler_MODE ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S00_AXI] [get_bd_intf_pins ModeManager_0/S00_AXI]

  # Create port connections
  connect_bd_net -net CLK_IN_1 [get_bd_pins CLK_IN] [get_bd_pins FrequencyDivider_0/CLK_IN] [get_bd_pins PWM_Sampler_MODE/CLK]
  connect_bd_net -net FrequencyDivider_0_CLK_OUT [get_bd_pins FrequencyDivider_0/CLK_OUT] [get_bd_pins ModeManager_0/clk_state_machine]
  connect_bd_net -net ModeManager_0_mode [get_bd_pins mode] [get_bd_pins ModeManager_0/mode]
  connect_bd_net -net PWM1_1 [get_bd_pins PWM] [get_bd_pins PWM_Sampler_MODE/PWM]
  connect_bd_net -net PWM_Sampler_1_PWM_Val [get_bd_pins ModeManager_0/value] [get_bd_pins PWM_Sampler_MODE/PWM_Val]
  connect_bd_net -net s00_axi_aclk_1 [get_bd_pins s00_axi_aclk] [get_bd_pins ModeManager_0/s00_axi_aclk]
  connect_bd_net -net s00_axi_aresetn_1 [get_bd_pins s00_axi_aresetn] [get_bd_pins ModeManager_0/s00_axi_aresetn]
  
  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Channel_CH04
proc create_hier_cell_Channel_CH04 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_Channel_CH04() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI_CH04

  # Create pins
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I PWM_CH04
  create_bd_pin -dir I -from 1 -to 0 mode
  create_bd_pin -dir O pwm_CH04_L
  create_bd_pin -dir O pwm_CH04_R
  create_bd_pin -dir I -type clk s00_axi_aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst s00_axi_aresetn

  # Create instance: PWMReconstructor_CH04_L, and set properties
  set PWMReconstructor_CH04_L [ create_bd_cell -type ip -vlnv aertec.local:user:PWMReconstructor:1.0 PWMReconstructor_CH04_L ]

  # Create instance: PWMReconstructor_CH04_R, and set properties
  set PWMReconstructor_CH04_R [ create_bd_cell -type ip -vlnv aertec.local:user:PWMReconstructor:1.0 PWMReconstructor_CH04_R ]

  # Create instance: PWM_Manager_CH04, and set properties
  set PWM_Manager_CH04 [ create_bd_cell -type ip -vlnv aertec.local:user:PWM_Manager:1.0 PWM_Manager_CH04 ]

  # Create instance: PWM_Sampler_CH04, and set properties
  set PWM_Sampler_CH04 [ create_bd_cell -type ip -vlnv aertec.local:user:PWM_Sampler:1.0 PWM_Sampler_CH04 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S00_AXI_CH04] [get_bd_intf_pins PWM_Manager_CH04/S00_AXI]

  # Create port connections
  connect_bd_net -net CLK_IN_1 [get_bd_pins CLK] [get_bd_pins PWMReconstructor_CH04_L/clk_in] [get_bd_pins PWMReconstructor_CH04_R/clk_in] [get_bd_pins PWM_Sampler_CH04/CLK]
  connect_bd_net -net ModeManager_0_mode [get_bd_pins mode] [get_bd_pins PWM_Manager_CH04/mode]
  connect_bd_net -net PWMReconstructor_0_pwm_signal [get_bd_pins pwm_CH04_R] [get_bd_pins PWMReconstructor_CH04_R/pwm_signal]
  connect_bd_net -net PWMReconstructor_1_pwm_signal [get_bd_pins pwm_CH04_L] [get_bd_pins PWMReconstructor_CH04_L/pwm_signal]
  connect_bd_net -net PWM_1 [get_bd_pins PWM_CH04] [get_bd_pins PWM_Sampler_CH04/PWM]
  connect_bd_net -net PWM_Manager_0_pwm_l [get_bd_pins PWMReconstructor_CH04_L/value] [get_bd_pins PWM_Manager_CH04/pwm_l]
  connect_bd_net -net PWM_Manager_0_pwm_r [get_bd_pins PWMReconstructor_CH04_R/value] [get_bd_pins PWM_Manager_CH04/pwm_r]
  connect_bd_net -net PWM_Sampler_0_PWM_Val [get_bd_pins PWM_Manager_CH04/pwm_rc] [get_bd_pins PWM_Sampler_CH04/PWM_Val]
  connect_bd_net -net s00_axi_aclk_1 [get_bd_pins s00_axi_aclk] [get_bd_pins PWM_Manager_CH04/s00_axi_aclk]
  connect_bd_net -net s00_axi_aresetn_1 [get_bd_pins s00_axi_aresetn] [get_bd_pins PWM_Manager_CH04/s00_axi_aresetn]
  
  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Channel_CH03
proc create_hier_cell_Channel_CH03 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_Channel_CH03() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI_CH03

  # Create pins
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I PWM_CH03
  create_bd_pin -dir I -from 1 -to 0 mode
  create_bd_pin -dir O pwm_CH03_L
  create_bd_pin -dir O pwm_CH03_R
  create_bd_pin -dir I -type clk s00_axi_aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst s00_axi_aresetn

  # Create instance: PWMReconstructor_CH03_L, and set properties
  set PWMReconstructor_CH03_L [ create_bd_cell -type ip -vlnv aertec.local:user:PWMReconstructor:1.0 PWMReconstructor_CH03_L ]

  # Create instance: PWMReconstructor_CH03_R, and set properties
  set PWMReconstructor_CH03_R [ create_bd_cell -type ip -vlnv aertec.local:user:PWMReconstructor:1.0 PWMReconstructor_CH03_R ]

  # Create instance: PWM_Manager_CH03, and set properties
  set PWM_Manager_CH03 [ create_bd_cell -type ip -vlnv aertec.local:user:PWM_Manager:1.0 PWM_Manager_CH03 ]

  # Create instance: PWM_Sampler_CH03, and set properties
  set PWM_Sampler_CH03 [ create_bd_cell -type ip -vlnv aertec.local:user:PWM_Sampler:1.0 PWM_Sampler_CH03 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S00_AXI_CH03] [get_bd_intf_pins PWM_Manager_CH03/S00_AXI]

  # Create port connections
  connect_bd_net -net CLK_IN_1 [get_bd_pins CLK] [get_bd_pins PWMReconstructor_CH03_L/clk_in] [get_bd_pins PWMReconstructor_CH03_R/clk_in] [get_bd_pins PWM_Sampler_CH03/CLK]
  connect_bd_net -net ModeManager_0_mode [get_bd_pins mode] [get_bd_pins PWM_Manager_CH03/mode]
  connect_bd_net -net PWMReconstructor_0_pwm_signal [get_bd_pins pwm_CH03_R] [get_bd_pins PWMReconstructor_CH03_R/pwm_signal]
  connect_bd_net -net PWMReconstructor_1_pwm_signal [get_bd_pins pwm_CH03_L] [get_bd_pins PWMReconstructor_CH03_L/pwm_signal]
  connect_bd_net -net PWM_1 [get_bd_pins PWM_CH03] [get_bd_pins PWM_Sampler_CH03/PWM]
  connect_bd_net -net PWM_Manager_0_pwm_l [get_bd_pins PWMReconstructor_CH03_L/value] [get_bd_pins PWM_Manager_CH03/pwm_l]
  connect_bd_net -net PWM_Manager_0_pwm_r [get_bd_pins PWMReconstructor_CH03_R/value] [get_bd_pins PWM_Manager_CH03/pwm_r]
  connect_bd_net -net PWM_Sampler_0_PWM_Val [get_bd_pins PWM_Manager_CH03/pwm_rc] [get_bd_pins PWM_Sampler_CH03/PWM_Val]
  connect_bd_net -net s00_axi_aclk_1 [get_bd_pins s00_axi_aclk] [get_bd_pins PWM_Manager_CH03/s00_axi_aclk]
  connect_bd_net -net s00_axi_aresetn_1 [get_bd_pins s00_axi_aresetn] [get_bd_pins PWM_Manager_CH03/s00_axi_aresetn]
  
  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Channel_CH02
proc create_hier_cell_Channel_CH02 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_Channel_CH02() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI_CH02

  # Create pins
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I PWM_CH02
  create_bd_pin -dir I -from 1 -to 0 mode
  create_bd_pin -dir O pwm_CH02_L
  create_bd_pin -dir O pwm_CH02_R
  create_bd_pin -dir I -type clk s00_axi_aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst s00_axi_aresetn

  # Create instance: PWMReconstructor_CH02_L, and set properties
  set PWMReconstructor_CH02_L [ create_bd_cell -type ip -vlnv aertec.local:user:PWMReconstructor:1.0 PWMReconstructor_CH02_L ]

  # Create instance: PWMReconstructor_CH02_R, and set properties
  set PWMReconstructor_CH02_R [ create_bd_cell -type ip -vlnv aertec.local:user:PWMReconstructor:1.0 PWMReconstructor_CH02_R ]

  # Create instance: PWM_Manager_CH02, and set properties
  set PWM_Manager_CH02 [ create_bd_cell -type ip -vlnv aertec.local:user:PWM_Manager:1.0 PWM_Manager_CH02 ]

  # Create instance: PWM_Sampler_CH02, and set properties
  set PWM_Sampler_CH02 [ create_bd_cell -type ip -vlnv aertec.local:user:PWM_Sampler:1.0 PWM_Sampler_CH02 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S00_AXI_CH02] [get_bd_intf_pins PWM_Manager_CH02/S00_AXI]

  # Create port connections
  connect_bd_net -net CLK_IN_1 [get_bd_pins CLK] [get_bd_pins PWMReconstructor_CH02_L/clk_in] [get_bd_pins PWMReconstructor_CH02_R/clk_in] [get_bd_pins PWM_Sampler_CH02/CLK]
  connect_bd_net -net ModeManager_0_mode [get_bd_pins mode] [get_bd_pins PWM_Manager_CH02/mode]
  connect_bd_net -net PWMReconstructor_0_pwm_signal [get_bd_pins pwm_CH02_R] [get_bd_pins PWMReconstructor_CH02_R/pwm_signal]
  connect_bd_net -net PWMReconstructor_1_pwm_signal [get_bd_pins pwm_CH02_L] [get_bd_pins PWMReconstructor_CH02_L/pwm_signal]
  connect_bd_net -net PWM_1 [get_bd_pins PWM_CH02] [get_bd_pins PWM_Sampler_CH02/PWM]
  connect_bd_net -net PWM_Manager_0_pwm_l [get_bd_pins PWMReconstructor_CH02_L/value] [get_bd_pins PWM_Manager_CH02/pwm_l]
  connect_bd_net -net PWM_Manager_0_pwm_r [get_bd_pins PWMReconstructor_CH02_R/value] [get_bd_pins PWM_Manager_CH02/pwm_r]
  connect_bd_net -net PWM_Sampler_0_PWM_Val [get_bd_pins PWM_Manager_CH02/pwm_rc] [get_bd_pins PWM_Sampler_CH02/PWM_Val]
  connect_bd_net -net s00_axi_aclk_1 [get_bd_pins s00_axi_aclk] [get_bd_pins PWM_Manager_CH02/s00_axi_aclk]
  connect_bd_net -net s00_axi_aresetn_1 [get_bd_pins s00_axi_aresetn] [get_bd_pins PWM_Manager_CH02/s00_axi_aresetn]
  
  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Channel_CH01
proc create_hier_cell_Channel_CH01 { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_Channel_CH01() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  # Create pins
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I PWM_CH01
  create_bd_pin -dir I -from 1 -to 0 mode
  create_bd_pin -dir O pwm_CH01_L
  create_bd_pin -dir O pwm_CH01_R
  create_bd_pin -dir I -type clk s00_axi_aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst s00_axi_aresetn

  # Create instance: PWMReconstructor_CH01_L, and set properties
  set PWMReconstructor_CH01_L [ create_bd_cell -type ip -vlnv aertec.local:user:PWMReconstructor:1.0 PWMReconstructor_CH01_L ]

  # Create instance: PWMReconstructor_CH01_R, and set properties
  set PWMReconstructor_CH01_R [ create_bd_cell -type ip -vlnv aertec.local:user:PWMReconstructor:1.0 PWMReconstructor_CH01_R ]

  # Create instance: PWM_Manager_CH01, and set properties
  set PWM_Manager_CH01 [ create_bd_cell -type ip -vlnv aertec.local:user:PWM_Manager:1.0 PWM_Manager_CH01 ]

  # Create instance: PWM_Sampler_CH01, and set properties
  set PWM_Sampler_CH01 [ create_bd_cell -type ip -vlnv aertec.local:user:PWM_Sampler:1.0 PWM_Sampler_CH01 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S00_AXI] [get_bd_intf_pins PWM_Manager_CH01/S00_AXI]

  # Create port connections
  connect_bd_net -net CLK_IN_1 [get_bd_pins CLK] [get_bd_pins PWMReconstructor_CH01_L/clk_in] [get_bd_pins PWMReconstructor_CH01_R/clk_in] [get_bd_pins PWM_Sampler_CH01/CLK]
  connect_bd_net -net ModeManager_0_mode [get_bd_pins mode] [get_bd_pins PWM_Manager_CH01/mode]
  connect_bd_net -net PWMReconstructor_0_pwm_signal [get_bd_pins pwm_CH01_R] [get_bd_pins PWMReconstructor_CH01_R/pwm_signal]
  connect_bd_net -net PWMReconstructor_1_pwm_signal [get_bd_pins pwm_CH01_L] [get_bd_pins PWMReconstructor_CH01_L/pwm_signal]
  connect_bd_net -net PWM_1 [get_bd_pins PWM_CH01] [get_bd_pins PWM_Sampler_CH01/PWM]
  connect_bd_net -net PWM_Manager_0_pwm_l [get_bd_pins PWMReconstructor_CH01_L/value] [get_bd_pins PWM_Manager_CH01/pwm_l]
  connect_bd_net -net PWM_Manager_0_pwm_r [get_bd_pins PWMReconstructor_CH01_R/value] [get_bd_pins PWM_Manager_CH01/pwm_r]
  connect_bd_net -net PWM_Sampler_0_PWM_Val [get_bd_pins PWM_Manager_CH01/pwm_rc] [get_bd_pins PWM_Sampler_CH01/PWM_Val]
  connect_bd_net -net s00_axi_aclk_1 [get_bd_pins s00_axi_aclk] [get_bd_pins PWM_Manager_CH01/s00_axi_aclk]
  connect_bd_net -net s00_axi_aresetn_1 [get_bd_pins s00_axi_aresetn] [get_bd_pins PWM_Manager_CH01/s00_axi_aresetn]
  
  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Zynq_Systems
proc create_hier_cell_Zynq_Systems { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_Zynq_Systems() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR
  create_bd_intf_pin -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M02_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M03_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M04_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M05_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M06_AXI
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART

  # Create pins
  create_bd_pin -dir O -type clk FCLK_CLK0
  create_bd_pin -dir O -type clk FCLK_CLK1
  create_bd_pin -dir O -type clk FCLK_CLK2
  create_bd_pin -dir O -type clk FCLK_CLK3
  create_bd_pin -dir O WDT_RST_OUT
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn

  # Create instance: axi_gpio_OUTS, and set properties
  set axi_gpio_OUTS [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_OUTS ]
  set_property -dict [ list CONFIG.C_ALL_OUTPUTS {1} CONFIG.C_GPIO_WIDTH {4}  ] $axi_gpio_OUTS

  # Create instance: axi_uartlite_DBG0, and set properties
  set axi_uartlite_DBG0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_DBG0 ]
  set_property -dict [ list CONFIG.C_BAUDRATE {921600}  ] $axi_uartlite_DBG0

  # Create instance: fit_timer_10Hz, and set properties
  set fit_timer_10Hz [ create_bd_cell -type ip -vlnv xilinx.com:ip:fit_timer:2.0 fit_timer_10Hz ]
  set_property -dict [ list CONFIG.C_INACCURACY {999} CONFIG.C_NO_CLOCKS {10000}  ] $fit_timer_10Hz

  # Create instance: proc_sys_reset_0_1M, and set properties
  set proc_sys_reset_0_1M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0_1M ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
CONFIG.PCW_ACT_CAN0_PERIPHERAL_FREQMHZ {23.8095} CONFIG.PCW_ACT_CAN1_PERIPHERAL_FREQMHZ {23.8095} \
CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {100.000000} CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158731} \
CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {10.000000} CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {125.000000} \
CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {100.000000} CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {1.000000} \
CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {4.000000} CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_I2C_PERIPHERAL_FREQMHZ {50} CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {125.000000} CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {25.000000} \
CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {166.666672} \
CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} CONFIG.PCW_ACT_TTC_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {10.000000} CONFIG.PCW_ACT_USB0_PERIPHERAL_FREQMHZ {60} \
CONFIG.PCW_ACT_USB1_PERIPHERAL_FREQMHZ {60} CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {666.666666} \
CONFIG.PCW_CAN0_BASEADDR {0xE0008000} CONFIG.PCW_CAN0_CAN0_IO {MIO 50 .. 51} \
CONFIG.PCW_CAN0_GRP_CLK_ENABLE {0} CONFIG.PCW_CAN0_HIGHADDR {0xE0008FFF} \
CONFIG.PCW_CAN0_PERIPHERAL_CLKSRC {External} CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_CAN1_PERIPHERAL_CLKSRC {External} CONFIG.PCW_CAN1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_CAN_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_CAN_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_CAN_PERIPHERAL_VALID {1} CONFIG.PCW_CLK0_FREQ {100000000} \
CONFIG.PCW_CLK1_FREQ {1000000} CONFIG.PCW_CLK2_FREQ {4000000} \
CONFIG.PCW_CLK3_FREQ {10000000} CONFIG.PCW_CORE0_FIQ_INTR {0} \
CONFIG.PCW_CORE0_IRQ_INTR {0} CONFIG.PCW_CORE1_FIQ_INTR {0} \
CONFIG.PCW_CORE1_IRQ_INTR {1} CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {767} \
CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
CONFIG.PCW_DCI_PERIPHERAL_CLKSRC {DDR PLL} CONFIG.PCW_DCI_PERIPHERAL_FREQMHZ {10.159} \
CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} CONFIG.PCW_DDR_RAM_BASEADDR {0x00100000} \
CONFIG.PCW_DDR_RAM_HIGHADDR {0x3FFFFFFF} CONFIG.PCW_DM_WIDTH {4} \
CONFIG.PCW_DQS_WIDTH {4} CONFIG.PCW_DQ_WIDTH {32} \
CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC {External} CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_ENET_RESET_POLARITY {Active Low} CONFIG.PCW_EN_4K_TIMER {0} \
CONFIG.PCW_EN_CAN0 {1} CONFIG.PCW_EN_CAN1 {0} \
CONFIG.PCW_EN_CLK0_PORT {1} CONFIG.PCW_EN_CLK1_PORT {1} \
CONFIG.PCW_EN_CLK2_PORT {1} CONFIG.PCW_EN_CLK3_PORT {1} \
CONFIG.PCW_EN_CLKTRIG0_PORT {0} CONFIG.PCW_EN_CLKTRIG1_PORT {0} \
CONFIG.PCW_EN_CLKTRIG2_PORT {0} CONFIG.PCW_EN_CLKTRIG3_PORT {0} \
CONFIG.PCW_EN_DDR {1} CONFIG.PCW_EN_EMIO_CAN0 {0} \
CONFIG.PCW_EN_EMIO_CAN1 {0} CONFIG.PCW_EN_EMIO_CD_SDIO0 {0} \
CONFIG.PCW_EN_EMIO_CD_SDIO1 {0} CONFIG.PCW_EN_EMIO_ENET0 {0} \
CONFIG.PCW_EN_EMIO_ENET1 {0} CONFIG.PCW_EN_EMIO_GPIO {0} \
CONFIG.PCW_EN_EMIO_I2C0 {0} CONFIG.PCW_EN_EMIO_I2C1 {0} \
CONFIG.PCW_EN_EMIO_MODEM_UART0 {0} CONFIG.PCW_EN_EMIO_MODEM_UART1 {0} \
CONFIG.PCW_EN_EMIO_PJTAG {0} CONFIG.PCW_EN_EMIO_SDIO0 {0} \
CONFIG.PCW_EN_EMIO_SDIO1 {0} CONFIG.PCW_EN_EMIO_SPI0 {0} \
CONFIG.PCW_EN_EMIO_SPI1 {0} CONFIG.PCW_EN_EMIO_SRAM_INT {0} \
CONFIG.PCW_EN_EMIO_TRACE {0} CONFIG.PCW_EN_EMIO_TTC0 {0} \
CONFIG.PCW_EN_EMIO_TTC1 {0} CONFIG.PCW_EN_EMIO_UART0 {0} \
CONFIG.PCW_EN_EMIO_UART1 {0} CONFIG.PCW_EN_EMIO_WDT {1} \
CONFIG.PCW_EN_EMIO_WP_SDIO0 {0} CONFIG.PCW_EN_EMIO_WP_SDIO1 {0} \
CONFIG.PCW_EN_ENET0 {0} CONFIG.PCW_EN_ENET1 {0} \
CONFIG.PCW_EN_GPIO {1} CONFIG.PCW_EN_I2C0 {0} \
CONFIG.PCW_EN_I2C1 {1} CONFIG.PCW_EN_MODEM_UART0 {0} \
CONFIG.PCW_EN_MODEM_UART1 {0} CONFIG.PCW_EN_PJTAG {0} \
CONFIG.PCW_EN_QSPI {1} CONFIG.PCW_EN_RST0_PORT {1} \
CONFIG.PCW_EN_RST1_PORT {0} CONFIG.PCW_EN_RST2_PORT {0} \
CONFIG.PCW_EN_RST3_PORT {0} CONFIG.PCW_EN_SDIO0 {1} \
CONFIG.PCW_EN_SDIO1 {0} CONFIG.PCW_EN_SMC {0} \
CONFIG.PCW_EN_SPI0 {0} CONFIG.PCW_EN_SPI1 {1} \
CONFIG.PCW_EN_TRACE {0} CONFIG.PCW_EN_TTC0 {0} \
CONFIG.PCW_EN_TTC1 {0} CONFIG.PCW_EN_UART0 {0} \
CONFIG.PCW_EN_UART1 {0} CONFIG.PCW_EN_USB0 {0} \
CONFIG.PCW_EN_USB1 {0} CONFIG.PCW_EN_WDT {1} \
CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK_CLK0_BUF {true} CONFIG.PCW_FCLK_CLK1_BUF {true} \
CONFIG.PCW_FCLK_CLK2_BUF {true} CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {1} CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {4} \
CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {10} CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
CONFIG.PCW_FPGA_FCLK1_ENABLE {1} CONFIG.PCW_FPGA_FCLK2_ENABLE {1} \
CONFIG.PCW_GPIO_BASEADDR {0xE000A000} CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
CONFIG.PCW_GPIO_HIGHADDR {0xE000AFFF} CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {0} CONFIG.PCW_I2C0_RESET_ENABLE {0} \
CONFIG.PCW_I2C1_BASEADDR {0xE0005000} CONFIG.PCW_I2C1_GRP_INT_ENABLE {0} \
CONFIG.PCW_I2C1_HIGHADDR {0xE0005FFF} CONFIG.PCW_I2C1_I2C1_IO {MIO 52 .. 53} \
CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {1} CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {111.111115} \
CONFIG.PCW_I2C_RESET_ENABLE {1} CONFIG.PCW_I2C_RESET_POLARITY {Active Low} \
CONFIG.PCW_I2C_RESET_SELECT {Share reset pin} CONFIG.PCW_IMPORT_BOARD_PRESET {None} \
CONFIG.PCW_INCLUDE_ACP_TRANS_CHECK {0} CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_IRQ_F2P_MODE {DIRECT} CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_0_PULLUP {enabled} CONFIG.PCW_MIO_0_SLEW {slow} \
CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} CONFIG.PCW_MIO_10_PULLUP {enabled} \
CONFIG.PCW_MIO_10_SLEW {slow} CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_11_PULLUP {enabled} CONFIG.PCW_MIO_11_SLEW {slow} \
CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} CONFIG.PCW_MIO_12_PULLUP {enabled} \
CONFIG.PCW_MIO_12_SLEW {slow} CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_13_PULLUP {enabled} CONFIG.PCW_MIO_13_SLEW {slow} \
CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} CONFIG.PCW_MIO_14_PULLUP {enabled} \
CONFIG.PCW_MIO_14_SLEW {slow} CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_15_PULLUP {enabled} CONFIG.PCW_MIO_15_SLEW {slow} \
CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 2.5V} CONFIG.PCW_MIO_16_PULLUP {enabled} \
CONFIG.PCW_MIO_16_SLEW {slow} CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_17_PULLUP {enabled} CONFIG.PCW_MIO_17_SLEW {slow} \
CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 2.5V} CONFIG.PCW_MIO_18_PULLUP {enabled} \
CONFIG.PCW_MIO_18_SLEW {slow} CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_19_PULLUP {enabled} CONFIG.PCW_MIO_19_SLEW {slow} \
CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} CONFIG.PCW_MIO_1_PULLUP {enabled} \
CONFIG.PCW_MIO_1_SLEW {slow} CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_20_PULLUP {enabled} CONFIG.PCW_MIO_20_SLEW {slow} \
CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 2.5V} CONFIG.PCW_MIO_21_PULLUP {enabled} \
CONFIG.PCW_MIO_21_SLEW {slow} CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_22_PULLUP {enabled} CONFIG.PCW_MIO_22_SLEW {slow} \
CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 2.5V} CONFIG.PCW_MIO_23_PULLUP {enabled} \
CONFIG.PCW_MIO_23_SLEW {slow} CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_24_PULLUP {enabled} CONFIG.PCW_MIO_24_SLEW {slow} \
CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 2.5V} CONFIG.PCW_MIO_25_PULLUP {enabled} \
CONFIG.PCW_MIO_25_SLEW {slow} CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_26_PULLUP {enabled} CONFIG.PCW_MIO_26_SLEW {slow} \
CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 2.5V} CONFIG.PCW_MIO_27_PULLUP {enabled} \
CONFIG.PCW_MIO_27_SLEW {slow} CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_28_PULLUP {enabled} CONFIG.PCW_MIO_28_SLEW {slow} \
CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 2.5V} CONFIG.PCW_MIO_29_PULLUP {enabled} \
CONFIG.PCW_MIO_29_SLEW {slow} CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_2_SLEW {slow} CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_30_PULLUP {enabled} CONFIG.PCW_MIO_30_SLEW {slow} \
CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 2.5V} CONFIG.PCW_MIO_31_PULLUP {enabled} \
CONFIG.PCW_MIO_31_SLEW {slow} CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_32_PULLUP {enabled} CONFIG.PCW_MIO_32_SLEW {slow} \
CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 2.5V} CONFIG.PCW_MIO_33_PULLUP {enabled} \
CONFIG.PCW_MIO_33_SLEW {slow} CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_34_PULLUP {enabled} CONFIG.PCW_MIO_34_SLEW {slow} \
CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 2.5V} CONFIG.PCW_MIO_35_PULLUP {enabled} \
CONFIG.PCW_MIO_35_SLEW {slow} CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_36_PULLUP {enabled} CONFIG.PCW_MIO_36_SLEW {slow} \
CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 2.5V} CONFIG.PCW_MIO_37_PULLUP {enabled} \
CONFIG.PCW_MIO_37_SLEW {slow} CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_38_PULLUP {enabled} CONFIG.PCW_MIO_38_SLEW {slow} \
CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 2.5V} CONFIG.PCW_MIO_39_PULLUP {enabled} \
CONFIG.PCW_MIO_39_SLEW {slow} CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_3_SLEW {slow} CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_40_PULLUP {enabled} CONFIG.PCW_MIO_40_SLEW {fast} \
CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 2.5V} CONFIG.PCW_MIO_41_PULLUP {enabled} \
CONFIG.PCW_MIO_41_SLEW {fast} CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_42_PULLUP {enabled} CONFIG.PCW_MIO_42_SLEW {fast} \
CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 2.5V} CONFIG.PCW_MIO_43_PULLUP {enabled} \
CONFIG.PCW_MIO_43_SLEW {fast} CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_44_PULLUP {enabled} CONFIG.PCW_MIO_44_SLEW {fast} \
CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 2.5V} CONFIG.PCW_MIO_45_PULLUP {enabled} \
CONFIG.PCW_MIO_45_SLEW {fast} CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_46_PULLUP {enabled} CONFIG.PCW_MIO_46_SLEW {slow} \
CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 2.5V} CONFIG.PCW_MIO_47_PULLUP {enabled} \
CONFIG.PCW_MIO_47_SLEW {slow} CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_48_PULLUP {enabled} CONFIG.PCW_MIO_48_SLEW {slow} \
CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 2.5V} CONFIG.PCW_MIO_49_PULLUP {enabled} \
CONFIG.PCW_MIO_49_SLEW {slow} CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_4_SLEW {slow} CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_50_PULLUP {enabled} CONFIG.PCW_MIO_50_SLEW {slow} \
CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 2.5V} CONFIG.PCW_MIO_51_PULLUP {enabled} \
CONFIG.PCW_MIO_51_SLEW {slow} CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_52_PULLUP {enabled} CONFIG.PCW_MIO_52_SLEW {slow} \
CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 2.5V} CONFIG.PCW_MIO_53_PULLUP {enabled} \
CONFIG.PCW_MIO_53_SLEW {slow} CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_5_SLEW {slow} CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_6_SLEW {slow} CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_7_SLEW {slow} CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_8_SLEW {slow} CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_9_PULLUP {enabled} CONFIG.PCW_MIO_9_SLEW {slow} \
CONFIG.PCW_MIO_PRIMITIVE {54} CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#GPIO#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SPI 1#SPI 1#SPI 1#SPI 1#CAN 0#CAN 0#I2C 1#I2C 1} \
CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]#qspi0_sclk#gpio[7]#gpio[8]#gpio[9]#gpio[10]#gpio[11]#gpio[12]#gpio[13]#gpio[14]#gpio[15]#gpio[16]#gpio[17]#gpio[18]#gpio[19]#gpio[20]#gpio[21]#gpio[22]#gpio[23]#gpio[24]#gpio[25]#gpio[26]#gpio[27]#gpio[28]#gpio[29]#gpio[30]#gpio[31]#gpio[32]#gpio[33]#gpio[34]#gpio[35]#gpio[36]#gpio[37]#gpio[38]#gpio[39]#clk#cmd#data[0]#data[1]#data[2]#data[3]#mosi#miso#sclk#ss[0]#rx#tx#scl#sda} CONFIG.PCW_M_AXI_GP0_ENABLE_STATIC_REMAP {0} \
CONFIG.PCW_M_AXI_GP0_FREQMHZ {100} CONFIG.PCW_M_AXI_GP0_ID_WIDTH {12} \
CONFIG.PCW_M_AXI_GP0_SUPPORT_NARROW_BURST {0} CONFIG.PCW_M_AXI_GP0_THREAD_ID_WIDTH {12} \
CONFIG.PCW_NAND_CYCLES_T_AR {1} CONFIG.PCW_NAND_CYCLES_T_CLR {1} \
CONFIG.PCW_NAND_CYCLES_T_RC {2} CONFIG.PCW_NAND_CYCLES_T_REA {1} \
CONFIG.PCW_NAND_CYCLES_T_RR {1} CONFIG.PCW_NAND_CYCLES_T_WC {2} \
CONFIG.PCW_NAND_CYCLES_T_WP {1} CONFIG.PCW_NOR_CS0_T_CEOE {1} \
CONFIG.PCW_NOR_CS0_T_PC {1} CONFIG.PCW_NOR_CS0_T_RC {2} \
CONFIG.PCW_NOR_CS0_T_TR {1} CONFIG.PCW_NOR_CS0_T_WC {2} \
CONFIG.PCW_NOR_CS0_T_WP {1} CONFIG.PCW_NOR_CS0_WE_TIME {0} \
CONFIG.PCW_NOR_CS1_T_CEOE {1} CONFIG.PCW_NOR_CS1_T_PC {1} \
CONFIG.PCW_NOR_CS1_T_RC {2} CONFIG.PCW_NOR_CS1_T_TR {1} \
CONFIG.PCW_NOR_CS1_T_WC {2} CONFIG.PCW_NOR_CS1_T_WP {1} \
CONFIG.PCW_NOR_CS1_WE_TIME {0} CONFIG.PCW_NOR_SRAM_CS0_T_CEOE {1} \
CONFIG.PCW_NOR_SRAM_CS0_T_PC {1} CONFIG.PCW_NOR_SRAM_CS0_T_RC {2} \
CONFIG.PCW_NOR_SRAM_CS0_T_TR {1} CONFIG.PCW_NOR_SRAM_CS0_T_WC {2} \
CONFIG.PCW_NOR_SRAM_CS0_T_WP {1} CONFIG.PCW_NOR_SRAM_CS0_WE_TIME {0} \
CONFIG.PCW_NOR_SRAM_CS1_T_CEOE {1} CONFIG.PCW_NOR_SRAM_CS1_T_PC {1} \
CONFIG.PCW_NOR_SRAM_CS1_T_RC {2} CONFIG.PCW_NOR_SRAM_CS1_T_TR {1} \
CONFIG.PCW_NOR_SRAM_CS1_T_WC {2} CONFIG.PCW_NOR_SRAM_CS1_T_WP {1} \
CONFIG.PCW_NOR_SRAM_CS1_WE_TIME {0} CONFIG.PCW_OVERRIDE_BASIC_CLOCK {0} \
CONFIG.PCW_P2F_CAN0_INTR {0} CONFIG.PCW_P2F_GPIO_INTR {0} \
CONFIG.PCW_P2F_I2C1_INTR {0} CONFIG.PCW_P2F_QSPI_INTR {0} \
CONFIG.PCW_P2F_SDIO0_INTR {0} CONFIG.PCW_P2F_SPI1_INTR {0} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.010} CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.010} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.010} CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.013} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {-0.001} CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {-0.002} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {-0.001} CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {-0.008} \
CONFIG.PCW_PACKAGE_NAME {clg484} CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_PCAP_PERIPHERAL_FREQMHZ {200} CONFIG.PCW_PERIPHERAL_BOARD_PRESET {None} \
CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE {0} CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 2.5V} CONFIG.PCW_PS7_SI_REV {PRODUCTION} \
CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {0} CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} CONFIG.PCW_QSPI_INTERNAL_HIGHADDRESS {0xFCFFFFFF} \
CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {125} CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
CONFIG.PCW_SD0_GRP_CD_ENABLE {0} CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
CONFIG.PCW_SD0_GRP_WP_ENABLE {0} CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} CONFIG.PCW_SD1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_SDIO0_BASEADDR {0xE0100000} CONFIG.PCW_SDIO0_HIGHADDR {0xE0100FFF} \
CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {25} \
CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} CONFIG.PCW_SMC_CYCLE_T0 {NA} \
CONFIG.PCW_SMC_CYCLE_T1 {NA} CONFIG.PCW_SMC_CYCLE_T2 {NA} \
CONFIG.PCW_SMC_CYCLE_T3 {NA} CONFIG.PCW_SMC_CYCLE_T4 {NA} \
CONFIG.PCW_SMC_CYCLE_T5 {NA} CONFIG.PCW_SMC_CYCLE_T6 {NA} \
CONFIG.PCW_SMC_PERIPHERAL_CLKSRC {IO PLL} CONFIG.PCW_SMC_PERIPHERAL_VALID {0} \
CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {0} CONFIG.PCW_SPI1_BASEADDR {0xE0007000} \
CONFIG.PCW_SPI1_GRP_SS1_ENABLE {0} CONFIG.PCW_SPI1_GRP_SS2_ENABLE {0} \
CONFIG.PCW_SPI1_HIGHADDR {0xE0007FFF} CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SPI1_SPI1_IO {MIO 46 .. 51} CONFIG.PCW_SPI_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_SPI_PERIPHERAL_FREQMHZ {166.666666} CONFIG.PCW_SPI_PERIPHERAL_VALID {1} \
CONFIG.PCW_TPIU_PERIPHERAL_CLKSRC {External} CONFIG.PCW_TRACE_INTERNAL_WIDTH {2} \
CONFIG.PCW_TRACE_PERIPHERAL_ENABLE {0} CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_DIVISOR0 {1} CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_DIVISOR0 {1} CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_DIVISOR0 {1} CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_CLKSRC {CPU_1X} CONFIG.PCW_TTC1_CLK0_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_CLKSRC {CPU_1X} CONFIG.PCW_TTC1_CLK1_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_CLKSRC {CPU_1X} CONFIG.PCW_TTC1_CLK2_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC1_PERIPHERAL_ENABLE {0} CONFIG.PCW_UART0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_UART1_PERIPHERAL_ENABLE {0} CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} CONFIG.PCW_UIPARAM_DDR_ADV_ENABLE {0} \
CONFIG.PCW_UIPARAM_DDR_AL {0} CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
CONFIG.PCW_UIPARAM_DDR_BL {8} CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.238} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.241} CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.248} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.285} CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {32 Bit} \
CONFIG.PCW_UIPARAM_DDR_CL {7} CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH {61.0905} CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {0} CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH {61.0905} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY {160} CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH {61.0905} CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {0} CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH {61.0905} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY {160} CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN {0} \
CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} CONFIG.PCW_UIPARAM_DDR_CWL {6} \
CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {4096 MBits} CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH {68.4725} CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {0} CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH {71.086} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY {160} CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH {66.794} CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {0} CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH {108.7385} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY {160} CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.0} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.012} CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.0} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.0} CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH {64.1705} CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {0} CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH {63.686} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY {160} CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH {68.46} CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {0} CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH {105.4895} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY {160} CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
CONFIG.PCW_UIPARAM_DDR_ENABLE {1} CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {533} \
CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP {Normal (0-85)} CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3 (Low Voltage)} \
CONFIG.PCW_UIPARAM_DDR_PARTNO {Custom} CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {14} \
CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {0} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {0} CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {0} \
CONFIG.PCW_UIPARAM_DDR_T_FAW {40.0} CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {35} \
CONFIG.PCW_UIPARAM_DDR_T_RC {48.75} CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
CONFIG.PCW_UIPARAM_DDR_T_RP {7} CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0} \
CONFIG.PCW_UIPARAM_GENERATE_SUMMARY {NA} CONFIG.PCW_USB0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_USB1_PERIPHERAL_ENABLE {0} CONFIG.PCW_USB_RESET_ENABLE {0} \
CONFIG.PCW_USB_RESET_POLARITY {Active Low} CONFIG.PCW_USE_AXI_FABRIC_IDLE {0} \
CONFIG.PCW_USE_CORESIGHT {0} CONFIG.PCW_USE_CROSS_TRIGGER {0} \
CONFIG.PCW_USE_CR_FABRIC {1} CONFIG.PCW_USE_DDR_BYPASS {0} \
CONFIG.PCW_USE_DEBUG {0} CONFIG.PCW_USE_DMA0 {0} \
CONFIG.PCW_USE_DMA1 {0} CONFIG.PCW_USE_DMA2 {0} \
CONFIG.PCW_USE_DMA3 {0} CONFIG.PCW_USE_EXPANDED_IOP {0} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.PCW_USE_HIGH_OCM {0} \
CONFIG.PCW_USE_M_AXI_GP0 {1} CONFIG.PCW_USE_M_AXI_GP1 {0} \
CONFIG.PCW_USE_PROC_EVENT_BUS {0} CONFIG.PCW_USE_PS_SLCR_REGISTERS {0} \
CONFIG.PCW_USE_S_AXI_ACP {0} CONFIG.PCW_USE_S_AXI_GP0 {0} \
CONFIG.PCW_USE_S_AXI_GP1 {0} CONFIG.PCW_USE_S_AXI_HP0 {0} \
CONFIG.PCW_USE_S_AXI_HP1 {0} CONFIG.PCW_USE_S_AXI_HP2 {0} \
CONFIG.PCW_USE_S_AXI_HP3 {0} CONFIG.PCW_USE_TRACE {0} \
CONFIG.PCW_VALUE_SILVERSION {3} CONFIG.PCW_WDT_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_WDT_PERIPHERAL_DIVISOR0 {1} CONFIG.PCW_WDT_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_WDT_WDT_IO {EMIO}  ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list CONFIG.NUM_MI {7}  ] $processing_system7_0_axi_periph

  # Create instance: rst_processing_system7_0_100M, and set properties
  set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

  # Create instance: xlconcat_IRQ_CPU0, and set properties
  set xlconcat_IRQ_CPU0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_IRQ_CPU0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins GPIO] [get_bd_intf_pins axi_gpio_OUTS/GPIO]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins M04_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins UART] [get_bd_intf_pins axi_uartlite_DBG0/UART]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M05_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins M06_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins axi_gpio_OUTS/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins axi_uartlite_DBG0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M02_AXI [get_bd_intf_pins M02_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M03_AXI [get_bd_intf_pins M03_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M03_AXI]

  # Create port connections
  connect_bd_net -net axi_uartlite_DBG0_interrupt [get_bd_pins axi_uartlite_DBG0/interrupt] [get_bd_pins xlconcat_IRQ_CPU0/In1]
  connect_bd_net -net fit_timer_100Hz_Interrupt [get_bd_pins fit_timer_10Hz/Interrupt] [get_bd_pins xlconcat_IRQ_CPU0/In0]
  connect_bd_net -net proc_sys_reset_0_1M_peripheral_aresetn [get_bd_pins fit_timer_10Hz/Rst] [get_bd_pins proc_sys_reset_0_1M/peripheral_aresetn]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins FCLK_CLK0] [get_bd_pins axi_gpio_OUTS/s_axi_aclk] [get_bd_pins axi_uartlite_DBG0/s_axi_aclk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/M02_ACLK] [get_bd_pins processing_system7_0_axi_periph/M03_ACLK] [get_bd_pins processing_system7_0_axi_periph/M04_ACLK] [get_bd_pins processing_system7_0_axi_periph/M05_ACLK] [get_bd_pins processing_system7_0_axi_periph/M06_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins FCLK_CLK1] [get_bd_pins fit_timer_10Hz/Clk] [get_bd_pins proc_sys_reset_0_1M/slowest_sync_clk] [get_bd_pins processing_system7_0/FCLK_CLK1]
  connect_bd_net -net processing_system7_0_FCLK_CLK2 [get_bd_pins FCLK_CLK2] [get_bd_pins processing_system7_0/FCLK_CLK2]
  connect_bd_net -net processing_system7_0_FCLK_CLK3 [get_bd_pins FCLK_CLK3] [get_bd_pins processing_system7_0/FCLK_CLK3]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in]
  connect_bd_net -net processing_system7_0_WDT_RST_OUT [get_bd_pins WDT_RST_OUT] [get_bd_pins processing_system7_0/WDT_RST_OUT]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins axi_gpio_OUTS/s_axi_aresetn] [get_bd_pins axi_uartlite_DBG0/s_axi_aresetn] [get_bd_pins proc_sys_reset_0_1M/ext_reset_in] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M02_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M03_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M04_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M05_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M06_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn]
  connect_bd_net -net xlconcat_IRQ_CPU0_dout [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_IRQ_CPU0/dout]
  
  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: PWM_MANAGER
proc create_hier_cell_PWM_MANAGER { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     puts "ERROR: create_hier_cell_PWM_MANAGER() - Empty argument(s)!"
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI1
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI_CH01
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI_CH02
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI_CH03
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI_CH04

  # Create pins
  create_bd_pin -dir I CLK_IN
  create_bd_pin -dir I PWM_CH01
  create_bd_pin -dir I PWM_CH02
  create_bd_pin -dir I PWM_CH03
  create_bd_pin -dir I PWM_CH04
  create_bd_pin -dir I PWM_MODE
  create_bd_pin -dir O pwm_CH01_L
  create_bd_pin -dir O pwm_CH01_R
  create_bd_pin -dir O pwm_CH02_L
  create_bd_pin -dir O pwm_CH02_R
  create_bd_pin -dir O pwm_CH03_L
  create_bd_pin -dir O pwm_CH03_R
  create_bd_pin -dir O pwm_CH04_L
  create_bd_pin -dir O pwm_CH04_R
  create_bd_pin -dir I -type clk s00_axi_aclk
  create_bd_pin -dir I -from 0 -to 0 -type rst s00_axi_aresetn

  # Create instance: Channel_CH01
  create_hier_cell_Channel_CH01 $hier_obj Channel_CH01

  # Create instance: Channel_CH02
  create_hier_cell_Channel_CH02 $hier_obj Channel_CH02

  # Create instance: Channel_CH03
  create_hier_cell_Channel_CH03 $hier_obj Channel_CH03

  # Create instance: Channel_CH04
  create_hier_cell_Channel_CH04 $hier_obj Channel_CH04

  # Create instance: MODE_MANAGER
  create_hier_cell_MODE_MANAGER $hier_obj MODE_MANAGER

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S00_AXI_CH01] [get_bd_intf_pins Channel_CH01/S00_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S00_AXI1] [get_bd_intf_pins MODE_MANAGER/S00_AXI]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S00_AXI_CH02] [get_bd_intf_pins Channel_CH02/S00_AXI_CH02]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S00_AXI_CH03] [get_bd_intf_pins Channel_CH03/S00_AXI_CH03]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S00_AXI_CH04] [get_bd_intf_pins Channel_CH04/S00_AXI_CH04]

  # Create port connections
  connect_bd_net -net CLK_IN_1 [get_bd_pins CLK_IN] [get_bd_pins Channel_CH01/CLK] [get_bd_pins Channel_CH02/CLK] [get_bd_pins Channel_CH03/CLK] [get_bd_pins Channel_CH04/CLK] [get_bd_pins MODE_MANAGER/CLK_IN]
  connect_bd_net -net Channel_CH02_pwm_CH02_L [get_bd_pins pwm_CH02_L] [get_bd_pins Channel_CH02/pwm_CH02_L]
  connect_bd_net -net Channel_CH02_pwm_CH02_R [get_bd_pins pwm_CH02_R] [get_bd_pins Channel_CH02/pwm_CH02_R]
  connect_bd_net -net Channel_CH03_pwm_CH03_L [get_bd_pins pwm_CH03_L] [get_bd_pins Channel_CH03/pwm_CH03_L]
  connect_bd_net -net Channel_CH03_pwm_CH03_R [get_bd_pins pwm_CH03_R] [get_bd_pins Channel_CH03/pwm_CH03_R]
  connect_bd_net -net Channel_CH04_pwm_CH04_L [get_bd_pins pwm_CH04_L] [get_bd_pins Channel_CH04/pwm_CH04_L]
  connect_bd_net -net Channel_CH04_pwm_CH04_R [get_bd_pins pwm_CH04_R] [get_bd_pins Channel_CH04/pwm_CH04_R]
  connect_bd_net -net ModeManager_0_mode [get_bd_pins Channel_CH01/mode] [get_bd_pins Channel_CH02/mode] [get_bd_pins Channel_CH03/mode] [get_bd_pins Channel_CH04/mode] [get_bd_pins MODE_MANAGER/mode]
  connect_bd_net -net PWM1_1 [get_bd_pins PWM_MODE] [get_bd_pins MODE_MANAGER/PWM]
  connect_bd_net -net PWMReconstructor_0_pwm_signal [get_bd_pins pwm_CH01_R] [get_bd_pins Channel_CH01/pwm_CH01_R]
  connect_bd_net -net PWMReconstructor_1_pwm_signal [get_bd_pins pwm_CH01_L] [get_bd_pins Channel_CH01/pwm_CH01_L]
  connect_bd_net -net PWM_1 [get_bd_pins PWM_CH01] [get_bd_pins Channel_CH01/PWM_CH01]
  connect_bd_net -net PWM_CH02_1 [get_bd_pins PWM_CH02] [get_bd_pins Channel_CH02/PWM_CH02]
  connect_bd_net -net PWM_CH03_1 [get_bd_pins PWM_CH03] [get_bd_pins Channel_CH03/PWM_CH03]
  connect_bd_net -net PWM_CH04_1 [get_bd_pins PWM_CH04] [get_bd_pins Channel_CH04/PWM_CH04]
  connect_bd_net -net s00_axi_aclk_1 [get_bd_pins s00_axi_aclk] [get_bd_pins Channel_CH01/s00_axi_aclk] [get_bd_pins Channel_CH02/s00_axi_aclk] [get_bd_pins Channel_CH03/s00_axi_aclk] [get_bd_pins Channel_CH04/s00_axi_aclk] [get_bd_pins MODE_MANAGER/s00_axi_aclk]
  connect_bd_net -net s00_axi_aresetn_1 [get_bd_pins s00_axi_aresetn] [get_bd_pins Channel_CH01/s00_axi_aresetn] [get_bd_pins Channel_CH02/s00_axi_aresetn] [get_bd_pins Channel_CH03/s00_axi_aresetn] [get_bd_pins Channel_CH04/s00_axi_aresetn] [get_bd_pins MODE_MANAGER/s00_axi_aresetn]
  
  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set GPIO_OUT [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO_OUT ]
  set uart_DBG0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 uart_DBG0 ]

  # Create ports
  set pwm_CH01_out_L [ create_bd_port -dir O pwm_CH01_out_L ]
  set pwm_CH01_out_R [ create_bd_port -dir O pwm_CH01_out_R ]
  set pwm_CH02_out_L [ create_bd_port -dir O pwm_CH02_out_L ]
  set pwm_CH02_out_R [ create_bd_port -dir O pwm_CH02_out_R ]
  set pwm_CH03_out_L [ create_bd_port -dir O pwm_CH03_out_L ]
  set pwm_CH03_out_R [ create_bd_port -dir O pwm_CH03_out_R ]
  set pwm_CH04_out_L [ create_bd_port -dir O pwm_CH04_out_L ]
  set pwm_CH04_out_R [ create_bd_port -dir O pwm_CH04_out_R ]
  set pwm_in_ch01 [ create_bd_port -dir I pwm_in_ch01 ]
  set pwm_in_ch02 [ create_bd_port -dir I pwm_in_ch02 ]
  set pwm_in_ch03 [ create_bd_port -dir I pwm_in_ch03 ]
  set pwm_in_ch04 [ create_bd_port -dir I pwm_in_ch04 ]
  set pwm_in_mode [ create_bd_port -dir I pwm_in_mode ]

  # Create instance: PWM_MANAGER
  create_hier_cell_PWM_MANAGER [current_bd_instance .] PWM_MANAGER

  # Create instance: Zynq_Systems
  create_hier_cell_Zynq_Systems [current_bd_instance .] Zynq_Systems

  # Create interface connections
  connect_bd_intf_net -intf_net Reset_Systems_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins Zynq_Systems/DDR]
  connect_bd_intf_net -intf_net Reset_Systems_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins Zynq_Systems/FIXED_IO]
  connect_bd_intf_net -intf_net Zynq_Systems_GPIO [get_bd_intf_ports GPIO_OUT] [get_bd_intf_pins Zynq_Systems/GPIO]
  connect_bd_intf_net -intf_net Zynq_Systems_M02_AXI [get_bd_intf_pins PWM_MANAGER/S00_AXI_CH01] [get_bd_intf_pins Zynq_Systems/M02_AXI]
  connect_bd_intf_net -intf_net Zynq_Systems_M03_AXI [get_bd_intf_pins PWM_MANAGER/S00_AXI1] [get_bd_intf_pins Zynq_Systems/M03_AXI]
  connect_bd_intf_net -intf_net Zynq_Systems_M04_AXI [get_bd_intf_pins PWM_MANAGER/S00_AXI_CH02] [get_bd_intf_pins Zynq_Systems/M04_AXI]
  connect_bd_intf_net -intf_net Zynq_Systems_M05_AXI [get_bd_intf_pins PWM_MANAGER/S00_AXI_CH03] [get_bd_intf_pins Zynq_Systems/M05_AXI]
  connect_bd_intf_net -intf_net Zynq_Systems_M06_AXI [get_bd_intf_pins PWM_MANAGER/S00_AXI_CH04] [get_bd_intf_pins Zynq_Systems/M06_AXI]
  connect_bd_intf_net -intf_net Zynq_Systems_UART [get_bd_intf_ports uart_DBG0] [get_bd_intf_pins Zynq_Systems/UART]

  # Create port connections
  connect_bd_net -net PWM_CH02_1 [get_bd_ports pwm_in_ch02] [get_bd_pins PWM_MANAGER/PWM_CH02]
  connect_bd_net -net PWM_CH03_1 [get_bd_ports pwm_in_ch03] [get_bd_pins PWM_MANAGER/PWM_CH03]
  connect_bd_net -net PWM_CH04_1 [get_bd_ports pwm_in_ch04] [get_bd_pins PWM_MANAGER/PWM_CH04]
  connect_bd_net -net PWM_MANAGER_pwm_CH02_L [get_bd_ports pwm_CH02_out_L] [get_bd_pins PWM_MANAGER/pwm_CH02_L]
  connect_bd_net -net PWM_MANAGER_pwm_CH02_R [get_bd_ports pwm_CH02_out_R] [get_bd_pins PWM_MANAGER/pwm_CH02_R]
  connect_bd_net -net PWM_MANAGER_pwm_CH03_L [get_bd_ports pwm_CH03_out_L] [get_bd_pins PWM_MANAGER/pwm_CH03_L]
  connect_bd_net -net PWM_MANAGER_pwm_CH03_R [get_bd_ports pwm_CH03_out_R] [get_bd_pins PWM_MANAGER/pwm_CH03_R]
  connect_bd_net -net PWM_MANAGER_pwm_CH04_L [get_bd_ports pwm_CH04_out_L] [get_bd_pins PWM_MANAGER/pwm_CH04_L]
  connect_bd_net -net PWM_MANAGER_pwm_CH04_R [get_bd_ports pwm_CH04_out_R] [get_bd_pins PWM_MANAGER/pwm_CH04_R]
  connect_bd_net -net PWM_MANAGER_pwm_signal [get_bd_ports pwm_CH01_out_R] [get_bd_pins PWM_MANAGER/pwm_CH01_R]
  connect_bd_net -net PWM_MANAGER_pwm_signal1 [get_bd_ports pwm_CH01_out_L] [get_bd_pins PWM_MANAGER/pwm_CH01_L]
  connect_bd_net -net Zynq_Systems_FCLK_CLK0 [get_bd_pins PWM_MANAGER/s00_axi_aclk] [get_bd_pins Zynq_Systems/FCLK_CLK0]
  connect_bd_net -net Zynq_Systems_FCLK_CLK1 [get_bd_pins PWM_MANAGER/CLK_IN] [get_bd_pins Zynq_Systems/FCLK_CLK1]
  connect_bd_net -net Zynq_Systems_peripheral_aresetn [get_bd_pins PWM_MANAGER/s00_axi_aresetn] [get_bd_pins Zynq_Systems/peripheral_aresetn]
  connect_bd_net -net pwm_in_ch1_1 [get_bd_ports pwm_in_ch01] [get_bd_pins PWM_MANAGER/PWM_CH01]
  connect_bd_net -net pwm_in_mode_1 [get_bd_ports pwm_in_mode] [get_bd_pins PWM_MANAGER/PWM_MODE]

  # Create address segments
  create_bd_addr_seg -range 0x10000 -offset 0x43C10000 [get_bd_addr_spaces Zynq_Systems/processing_system7_0/Data] [get_bd_addr_segs PWM_MANAGER/MODE_MANAGER/ModeManager_0/S00_AXI/S00_AXI_reg] SEG_ModeManager_0_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C00000 [get_bd_addr_spaces Zynq_Systems/processing_system7_0/Data] [get_bd_addr_segs PWM_MANAGER/Channel_CH01/PWM_Manager_CH01/S00_AXI/S00_AXI_reg] SEG_PWM_Manager_0_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C20000 [get_bd_addr_spaces Zynq_Systems/processing_system7_0/Data] [get_bd_addr_segs PWM_MANAGER/Channel_CH02/PWM_Manager_CH02/S00_AXI/S00_AXI_reg] SEG_PWM_Manager_CH02_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C30000 [get_bd_addr_spaces Zynq_Systems/processing_system7_0/Data] [get_bd_addr_segs PWM_MANAGER/Channel_CH03/PWM_Manager_CH03/S00_AXI/S00_AXI_reg] SEG_PWM_Manager_CH03_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x43C40000 [get_bd_addr_spaces Zynq_Systems/processing_system7_0/Data] [get_bd_addr_segs PWM_MANAGER/Channel_CH04/PWM_Manager_CH04/S00_AXI/S00_AXI_reg] SEG_PWM_Manager_CH04_S00_AXI_reg
  create_bd_addr_seg -range 0x10000 -offset 0x41200000 [get_bd_addr_spaces Zynq_Systems/processing_system7_0/Data] [get_bd_addr_segs Zynq_Systems/axi_gpio_OUTS/S_AXI/Reg] SEG_axi_gpio_OUTS_Reg
  create_bd_addr_seg -range 0x10000 -offset 0x42C00000 [get_bd_addr_spaces Zynq_Systems/processing_system7_0/Data] [get_bd_addr_segs Zynq_Systems/axi_uartlite_DBG0/S_AXI/Reg] SEG_axi_uartlite_DBG0_Reg
  

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


