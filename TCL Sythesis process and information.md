# Vivado TCL Scripts



## Importación de diseño HW por medio de TCL

Para importar un diseño HW por medio de un script TCL generado en Vivado será necesario seguir el siguiente conjunto de pasos:

1. Generar un proyecto vacío de Vivado en la carpeta dónde se desee crear el fichero.

2. Añadir al repositorio todas la IP empleadas que **NO** sean pertenecientes a Xilinx

3. Cargar el TCL a través del comando *source*:

   ```tcl
   # [path]: Carpeta dónde se encuentre el fichero tcl a ejecutar.
   # [file_name]: Nombre del script tcl a ejecutar
   source [path/file_name.tcl]
   ```
   Otra opción es emplear el comando desde la interfaz gráfica:
   ![Comando desde GUI de Vivado](.\md_images\TCL_Command_GUI.png)

4. Generar el fichero HDL correspondiente para el HW creado.

5. Cargar el fichero de restricciones.

6. Generar bitstream y exportar HDF.

Una vez realizado este proceso, se seguirán los pasos estándar para la compilación de SW.

## TODO: Añadir fichero de Constraints y script de enlace



