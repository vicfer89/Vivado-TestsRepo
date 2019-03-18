#
# create_project.tcl: Tcl script for re-creating Vivado project
#
# Generated by Vivado on Fri Jun 26 14:29:32 +0200 2015
#
#    Modified by diana.ungureanu@enclustra.com


#Carga fichero de configuracion:
source settings.tcl
set project_base_name ${hw_base_platform}${module_name}

set VivadoVersion 2014.4

set run_dir "VIVADO"
set project_name ${project_base_name}_${hw_platform}

# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/${run_dir}"]"

# Create project
create_project ${project_name} ./${run_dir}

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [get_projects ${project_name}]
set_property "part" "${fpga_part}" $obj
set_property "target_language" "VHDL" $obj
set_property "simulator_language" "VHDL" $obj

# Carga y actualiza librerías generadads por el usuario
set_property ip_repo_paths   ./ip_repo [current_fileset]
update_ip_catalog

# Creo proyecto a partir de HW generado por medio de Vivado (bloques)
source Test_PWM.tcl

#Create top wrapper file
make_wrapper -files [get_files $proj_dir/$project_name.srcs/sources_1/bd/$design_name/$design_name.bd] -top
add_files -norecurse $proj_dir/$project_name.srcs/sources_1/bd/$design_name/hdl/${design_name}_wrapper.vhd

# Add constraints al modelo para generación de eHW
set constraint_file_name Const_PWM_Test
add_files -fileset constrs_1 -norecurse ./${constraint_file_name}.xdc
import_files -fileset constrs_1 ./${constraint_file_name}.xdc

#implement the design and create bit file
launch_runs impl_1 -to_step write_bitstream
wait_on_run -timeout 60 impl_1

#Export design to SDK
file mkdir $proj_dir/$project_name.sdk
file copy -force $proj_dir/$project_name.runs/impl_1/${design_name}_wrapper.sysdef ./hw_Platforms/hw_${constraint_file_name}.hdf

file delete -force ./$run_dir