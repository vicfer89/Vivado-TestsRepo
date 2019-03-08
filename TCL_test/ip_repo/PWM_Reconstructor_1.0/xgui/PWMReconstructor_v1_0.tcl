# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "period" -parent ${Page_0}


}

proc update_PARAM_VALUE.period { PARAM_VALUE.period } {
	# Procedure called to update period when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.period { PARAM_VALUE.period } {
	# Procedure called to validate period
	return true
}


proc update_MODELPARAM_VALUE.period { MODELPARAM_VALUE.period PARAM_VALUE.period } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.period}] ${MODELPARAM_VALUE.period}
}

