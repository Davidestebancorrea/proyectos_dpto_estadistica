library(readxl) #para leer archivos excel
library(writexl) #para exportar data a excel
library(dplyr) #para manejar tablas
library(stringr) # para manejar cadenas de texto

#leemos los archivos en excel con la funcion read_excel del paquete readxl, sheet se refiere al nombre de la hoja de excel que deseas leer
radiografia_JUL <- read_excel("C:/Users/Usuario/Desktop/DAVID CORREA/DATOS PARA REM/IMAGENOLOGIA/2023/ESTADISTICA IMAGENOLOGIA JULIO 2023.xlsx", sheet = "Radiografias")
tac_JUL <- read_excel("C:/Users/Usuario/Desktop/DAVID CORREA/DATOS PARA REM/IMAGENOLOGIA/2023/ESTADISTICA IMAGENOLOGIA JULIO 2023.xlsx", sheet = "TAC")
ecografia_JUL <- read_excel("C:/Users/Usuario/Desktop/DAVID CORREA/DATOS PARA REM/IMAGENOLOGIA/2023/ESTADISTICA IMAGENOLOGIA JULIO 2023.xlsx", sheet = "Ecografia")
mamografia_JUL <- read_excel("C:/Users/Usuario/Desktop/DAVID CORREA/DATOS PARA REM/IMAGENOLOGIA/2023/ESTADISTICA IMAGENOLOGIA JULIO 2023.xlsx", sheet = "Mamografia")
rm_JUL <- read_excel("C:/Users/Usuario/Desktop/DAVID CORREA/DATOS PARA REM/IMAGENOLOGIA/2023/ESTADISTICA IMAGENOLOGIA JULIO 2023.xlsx", sheet = "RM")


#la funcion names nos sirve para conocer los nombres de las columnas
# names(radiografia_JUL)
# names(tac_JUL)
# names(ecografia_JUL)
# names(mamografia_JUL)
# names(rm_JUL)


#esto nos permite cambiar el nombre de la columna MODALIDAD  a NOMBRE_EXAMEN deL objeto o tabla radiografia_jul

radiografia_JUL <-  radiografia_JUL %>%
  rename(NOMBRE_EXAMEN = MODALIDAD)

#la funcion rbin nos permite consolidar las filas de las tablas radiografia, tac, ecografia, mamografia y rm, quedando todo en una sola tabla

consolidado_jul <- rbind(radiografia_JUL, 
                         tac_JUL, 
                         ecografia_JUL, 
                         mamografia_JUL, 
                         rm_JUL)




#para saber cuantos registros hay por cada codigo de examen

cantidad_por_cod <- consolidado_jul %>% 
  group_by(CODIGO_EXAMEN) %>% 
  count(CODIGO_EXAMEN)


# Eliminar todo después del guión "-" incluyendo este
consolidado_jul$CODIGO_EXAMEN <- sub("-.*", "", consolidado_jul$CODIGO_EXAMEN)

# Eliminar ceros al principio
consolidado_jul$CODIGO_EXAMEN <- str_replace(consolidado_jul$CODIGO_EXAMEN, "^[0]+", "")



#cambiar tipo de dato a numerico
consolidado_jul$CODIGO_EXAMEN <- as.numeric(consolidado_jul$CODIGO_EXAMEN)



# esto permite asignar una nueva columna de acuerdo a los datos de otra columna
consolidado_jul <- consolidado_jul %>% 
  mutate(PROCEDENCIA = case_when(TIPO_ADMISION == "URGENCIAS" ~ "EMERGENCIA",
                                 TIPO_ADMISION == "AMBULATORIO" ~ "ABIERTA",
                                 TIPO_ADMISION == "HOSPITALIZADOS" ~ "CERRADA",
                                 TIPO_ADMISION == "CONSULTORIO" ~ "ABIERTA",
                                 TIPO_ADMISION == "CONVENIOS" ~ "ABIERTA",
                                 TIPO_ADMISION == "SAR/OTROS" ~ "EMERGENCIA",
  ))


#esta linea nos permite guardar la tabla recien consolidada en un archivo excel. la funcion write_xlsx nos permite hacer esto, pertenece al paquete writexl

write_xlsx(consolidado_jul, "CONSOLIDADO JULIO 2023.xlsx")

#getwd() 
#esta funcion sirve par conocer en que carpeta esta uardado el proyecto 
