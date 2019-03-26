# ################################################## #
# 													 #
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
	set platform_Constraints	"platform_Constraints"
	set platform_Sources		"platform_Sources"
	set platform_Wrappers		"platform_Wrappers"

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

 # Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
"[file normalize "./${platform_Wrappers}/${HW_block_file_name}_Top_Design.vhd"]"\
]
add_files -norecurse -fileset $obj $files


set file "./${platform_Wrappers}/${HW_block_file_name}_Top_Design.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj

# Creo proyecto a partir de HW generado por medio de Vivado (bloques)
source ./${platform_Sources}/${HW_block_file_name}.tcl

# Add constraints al modelo para generación de eHW
add_files -fileset constrs_1 -norecurse ./${platform_Constraints}/${constraint_file_name}.xdc
import_files -fileset constrs_1 ./${platform_Constraints}/${constraint_file_name}.xdc
