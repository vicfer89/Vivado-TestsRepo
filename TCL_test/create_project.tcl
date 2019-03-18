# ################################################## #
#	Vivado Generador de eHW.						 #
#	Autor: VFF										 #
#													 #
#	Introducir fichero settings.tcl para uso.		 #
#													 #
# ################################################## #

#Comprobacion de version de vivado
set VivadoVersion 2014.4

# Carga fichero de configuracion:
source settings.tcl

# Generacion de variables a emplear:
	# Marca para directorio de referencia
	set origin_dir "."
	# Nombre base del proyecto:
	set project_base_name ${hw_base_platform}${module_name}
	# Nombre del proyecto:
	set project_name ${project_base_name}_${hw_platform}
	#Directorio de ejecucion de script:
	set run_dir "VIVADO_tmp"
	# Directorio de origen del scrpit a ejecutar
	set orig_proj_dir "[file normalize "$origin_dir/${run_dir}"]"

# Nombres de variables para definición de Constraints y HW:
	set constraint_file_name	"Const_PWM_Test"
	set HW_block_file_name		"Test_PWM"
	
# Creamos proyecto en el directorio determinado:
create_project ${project_name} ./${run_dir}

# Se selecciona el directorio del proyecto para proyecto creado:
set proj_dir [get_property directory [current_project]]

# Se escriben las propiedades del proyecto a generar
set obj [get_projects ${project_name}]
set_property "part" "${fpga_part}" $obj
set_property "target_language" "VHDL" $obj
set_property "simulator_language" "VHDL" $obj

# Carga y actualiza librerías generadas por el usuario
set_property ip_repo_paths   ./ip_repo [current_fileset]
update_ip_catalog

# Creo proyecto a partir de HW generado por medio de Vivado (bloques)
source ${HW_block_file_name}.tcl

#Create top wrapper file
make_wrapper -files [get_files $proj_dir/$project_name.srcs/sources_1/bd/$design_name/$design_name.bd] -top
add_files -norecurse $proj_dir/$project_name.srcs/sources_1/bd/$design_name/hdl/${design_name}_wrapper.vhd

# Add constraints al modelo para generación de eHW
add_files -fileset constrs_1 -norecurse ./${constraint_file_name}.xdc
import_files -fileset constrs_1 ./${constraint_file_name}.xdc

#implement the design and create bit file
launch_runs impl_1 -to_step write_bitstream
wait_on_run -timeout 60 impl_1

#Export design to SDK
file mkdir $proj_dir/$project_name.sdk
if [file isdirectory ./hw_outputs] { 
	puts "Dir hw_Platforms exists. Updating platforms..."
} else {
	file mkdir ./hw_Platforms
	puts "Dir hw_outputs has been created."
}

file copy -force $proj_dir/$project_name.runs/impl_1/${design_name}_wrapper.sysdef ./hw_Platforms/${constraint_file_name}_hw.hdf

#close the project
close_project
# Erase $run_dir directory and .Xil metadata
file delete -force ./$run_dir
file delete -force ./.Xil