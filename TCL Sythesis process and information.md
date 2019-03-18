# Vivado TCL Scripts

Documento de información acerca de generación, carga y manejo de lenguaje TCL para vivado.

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

## Añadir repositorio desde TCL

Se puede añadir un repositorio desde TCL, para lo cual se empleará el siguiente código:

```tcl
#[custom_repo_path]: repositorio de IP custom a incluir
#[current_project]: indica que será para el proyecto actual
set_property ip_repo_paths {[custom_repo_path]} [current_project]
update_ip_catalog
```

Con esto se añadirá al repositorio del proyecto abierto los IP contenidos en `[custom_repo_path]`para poder usarlos y cargar el TCL con el diseño de alto nivel.

## Proceso para importación de fuentes y script de ejecución:

Para poder ejecutar un script de comandos TCL para la generación automática de HW se realiza lo siguiente:

### Apuntar a directorio de trabajo:

Para apuntar al directorio de trabajo se empleará el comando:

```tcl
# [dir]: Directorio de trabajo
cd [dir]
```

Una vez ejecutado esto, podremos realizar la carga del fichero de creación de proyecto por medio del comando:

```tcl
# [source_file]: nombre del fichero fuente
source [source_file].tcl
```

### Ejecutar script de creación de proyecto

Una vez que está presente en la carpeta el fichero `create_project.tcl`, se ejecuta el siguiente código en línea de comandos:

```tcl
cd C:/Vivado_TestsRepo/TCL_test
source create_project.tcl
```

Una vez ejecutado, se deberá generar el fichero .hdf y guardarlo en la carpeta `hw_platforms` con el nombre correspondiente.

## ToDO: Crear fichero de ejecución por lotes para compilación de diseño eHW de forma automática.





