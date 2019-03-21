# ################################## #
# 
# Módulo de características para generación TCL de plataformas HW
# Autor: VFF
# 
# ################################## #
set hw_base_platform       MARS
set module_name            ZX3
set fpga_part              xc7z020clg484-2
set part_specific_text     _
set hw_platform            AAP04

# Borrado de ficheros fuente (1 para borrar, 0 para no borrar)
set eraseVar	1

# Selección de plataforma y fichero de restricciones
set constraint_file_name	"Const_PWM_Tester_6CH"
set HW_block_file_name		"PWM_Manager_6CH"
