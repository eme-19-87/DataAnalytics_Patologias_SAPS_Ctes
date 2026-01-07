# Dataware House Para Servicios De Salud CAPS-Corrientes, Capital

## Contenido

## 1-Introducción Del Proyecto
   ## 1.1-Breve Explicación
   ## 1.2-Objetivo Del Proyecto

 ## 2-Herramientas Utilizadas

 ## 3-Estructura Inicial De Los Datos
 
 ## 4-KPI y Preguntas A Responder

 ## 5-Estructura de las Capas
   ## 5.1-Capa De Bronce
   ## 5.1.2-Prelimpieza De Datos Mediante Python
   ## 5.2-Capa De Plata
   ## 5.3-Capa De Oro


 ---

 ## 1-Introducción Del Proyecto

 El proyecto se centra en tomar los datos que se encuentran en el sitio de datos abiertos
 de la provincia de Corrientes, Argentina con la finalidad de crear un dataware house para la posterior consulta con herramientas BI para el análisis estadístico de la misma.

 ## 1.1-Breve Explicación

 Tomaremos los datos de las atenciones médicas por patologías e inmunizaciones realizadas en los SAPS de Corrientes Capital. De esta forma, podremos obtener datos estadísticos sobre la cantidad de patologías atendidas, los tipos de patologías, los centros donde se realizaron estas atenciones, el sexo de los pacientes y la evolución de las atenciones a través del tiempo.

 # 1.2-Objetivo Del Proyecto

 El objetivo del proyecto es lograr un Dataware House con una capa que contenga un modelo en estrella de los datos para realizar una consulta eficiente de los datos. De esa manera,
 se podrán obtener información significativa sobre las diferentes patologías atendidas en cada centro y servirá para tomar decisiones informadas que pueda ayudar a la mejora de los servicios.

 ---

 ## 2-Herramientas Utilizadas

 Para el desarrollo del proyecto se emplearán las siguientes herramientas

 <ul>
    <li>Python: Empleado para la extracción y limpieza de datos. Empleado también para la visualización de los datos</li>
    <li>PostgreSQL: Empleado para la extracción, limpieza de datos y carga de datos. Servirá para la creación de las capas del dataware house</li>
    <li>PlantUML: Herramienta online empleada para el modelado de los datos.</li>
    <li>Draw.io: Herramienta online empleada para el modelado de las capas y de los flujos de datos.</li>
    <li>Trello: Herramienta empleada para el diseño de las tareas y la planificación del proyecto.</li>
    <li>Metabase: Herramienta empleada para la visualización de los datos</li>
 </ul>

 ---

# 3-Estructura inicial de los datos 

Tabla: Consultas Según Palogía Médica. Datos Abiertos Ciudad De Corrientes

<table style="width:100%; border-collapse:collapse; font-family:Arial, Helvetica, sans-serif;">
    <thead>
        <tr>
            <th style="background:#00a3e0; color:#fff; border:3px solid #000; padding:12px;">
                Título de la columna
            </th>
            <th style="background:#00a3e0; color:#fff; border:3px solid #000; padding:12px;">
                Tipo de dato
            </th>
            <th style="background:#00a3e0; color:#fff; border:3px solid #000; padding:12px;">
                Descripción
            </th>
        </tr>
    </thead>
    <tbody>
        <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">saps</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Nombre del SAPS</td>
        </tr>
        <tr>
            <td style="border:3px solid #000; padding:10px; text-align:center;">fecha</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Fecha ISO-8601 (date)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Periodo de la consulta médica</td>
        </tr>
        <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">patologia_desc</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Descripción de la patología</td>
        </tr>
        <tr>
            <td style="border:3px solid #000; padding:10px; text-align:center;">agrupacion_cie10</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Grupo según nomenclador CIE-10</td>
        </tr>
        <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">patologia_cod</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Código CIE-10</td>
        </tr>
        <tr>
            <td style="border:3px solid #000; padding:10px; text-align:center;">consulta_cantidad</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Número entero (integer)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Cantidad de consultas médicas</td>
        </tr>
        <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">rango_etario</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Rango etario de pacientes</td>
        </tr>
        <tr>
            <td style="border:3px solid #000; padding:10px; text-align:center;">sexo</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Sexo del paciente</td>
        </tr>
    </tbody>
</table>

Tabla: Nomenclador CIE-10. Datos Abiertos Ciudad De Corrientes

<table style="width:100%; border-collapse:collapse; font-family:Arial, Helvetica, sans-serif;">
    <thead>
        <tr>
            <th style="background:#00a3e0; color:#fff; border:3px solid #000; padding:12px;">
                Título de la columna
            </th>
            <th style="background:#00a3e0; color:#fff; border:3px solid #000; padding:12px;">
                Tipo de dato
            </th>
            <th style="background:#00a3e0; color:#fff; border:3px solid #000; padding:12px;">
                Descripción
            </th>
        </tr>
    </thead>
    <tbody>
        <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">ID_Patologia</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">El código de identificación de la patología</td>
        </tr>
        <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">tipo_patología</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">El nombre o descripción con el que se identifica a la patología</td>
        </tr>
        <tr>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Descripción</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Descripción más detallada de la patología</td>
        </tr>
    </tbody>
</table>


Tabla: Inmunizaciones. Datos Abiertos Ciudad De Corrientes

<table style="width:100%; border-collapse:collapse; font-family:Arial, Helvetica, sans-serif;">
    <thead>
        <tr>
            <th style="background:#00a3e0; color:#fff; border:3px solid #000; padding:12px;">
                Título de la columna
            </th>
            <th style="background:#00a3e0; color:#fff; border:3px solid #000; padding:12px;">
                Tipo de dato
            </th>
            <th style="background:#00a3e0; color:#fff; border:3px solid #000; padding:12px;">
                Descripción
            </th>
        </tr>
    </thead>
    <tbody>
        <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">saps</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Nombre del saps donde se administró la vacuna</td>
        </tr>
        <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">periodo</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Fecha ISO-8601 (date)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Periodo de la consulta médica.</td>
        </tr>
        <tr>
            <td style="border:3px solid #000; padding:10px; text-align:center;">vacunas_tipo </td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Tipo de vacuna aplicada</td>
        </tr>
          <tr>
            <td style="border:3px solid #000; padding:10px; text-align:center;">vacunas_cantidad </td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Número entero (integer)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Cantidad de vacunas efectuadas </td>
        </tr>
    </tbody>
</table>

Tabla: Listado De SAPS. Datos Abiertos Ciudad De Corrientes

<table style="width:100%; border-collapse:collapse; font-family:Arial, Helvetica, sans-serif;">
    <thead>
        <tr>
            <th style="background:#00a3e0; color:#fff; border:3px solid #000; padding:12px;">
                Título de la columna
            </th>
            <th style="background:#00a3e0; color:#fff; border:3px solid #000; padding:12px;">
                Tipo de dato
            </th>
            <th style="background:#00a3e0; color:#fff; border:3px solid #000; padding:12px;">
                Descripción
            </th>
        </tr>
    </thead>
    <tbody>
        <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">SAPS</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">El nombre del SAPS</td>
        </tr>
        <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">Barrio</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">El nombre del barrio donde se encuentra ubicado el SAPS</td>
        </tr>
        <tr>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Ubicación</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">El nombre de las calles donde se encuentra el SAPS</td>
        </tr>
         <tr>
            <td style="border:3px solid #000; padding:10px; text-align:center;">contacto_telefono</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">El teléfono para comunicarse con el SAPS</td>
        </tr>
          <tr>
            <td style="border:3px solid #000; padding:10px; text-align:center;">responsable</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Nombre y apellido de la persona responsable del SAPS</td>
        </tr>
          <tr>
            <td style="border:3px solid #000; padding:10px; text-align:center;">cargo</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">El cargo de la persona responsable</td>
        </tr>
    </tbody>
</table>

---

<figure role="group" id="ilust-32">
    <img src="assets/img/draw-io/primer_esquema_SAPS.png">
    <figcaption style="text-align:center">
        Imagen 1. Esquema de los archivos csv
    </figcaption>
</figure>



---

## 4-KPI y Preguntas

Las siguiente métricas pueden ser analizadas con los datos que tenemos

<ul>
    <li>Variación del total de consultas por año, año-mes y año-mes-día</li>
    <li>El código cie10 con más consultas. Esto servirá para saber la patología más consultada</li>
    <li>Distribucuón de las consultas según los SAPS</li>
    <li>Distribución de las patologías según los sexos</li>
    <li>El tipo de vacuna con mayor cantidad de administraciones</li>
    <li>La variación de las administraciones de las vacunas a través del tiempo</li>
    <li>Distribución del total de vacunaciones según el tipo de vacuna y los SAPS</li>
    <li>El SAPS que más vacuna administra</li>
</ul>

---

## 5-Estructura De Las Capas

## 5.1-Capa De Bronce

El esquema para las tablas en la capa de bronce será el siguiente

<figure>
    <img src="assets/img/draw-io/TablasCapaBronce.png">
    <figcaption style="text-align:center">
        Imagen 2. Esquema de tablas para la capa de bronce
    </figcaption>
</figure>


Tabla Con Los Datos De Las Consultas Por Patología

<table style="width:100%; border-collapse:collapse; font-family:Arial, Helvetica, sans-serif;">
    <thead>
        <tr>
            <th style="background:#00a3e0; color:#fff; border:3px solid #000; padding:12px;">
                Título de la columna
            </th>
            <th style="background:#00a3e0; color:#fff; border:3px solid #000; padding:12px;">
                Tipo de dato
            </th>
            <th style="background:#00a3e0; color:#fff; border:3px solid #000; padding:12px;">
                Descripción
            </th>
        </tr>
    </thead>
    <tbody>
        <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">id_consulta</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Número entero</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Un identificador entero único para cada consulta</td>
        </tr>
         <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">id_saps</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Número entero</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Un identificador entero para obtener vincular con la tabla de saps y obtener los datos adicionales para estos últimos.</td>
        </tr>
        <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">saps</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Nombre del SAPS</td>
        </tr>
        <tr>
            <td style="border:3px solid #000; padding:10px; text-align:center;">fecha</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Fecha ISO-8601 (date)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Periodo de la consulta médica</td>
        </tr>
        <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">patologia_desc</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Descripción de la patología</td>
        </tr>
        <tr>
            <td style="border:3px solid #000; padding:10px; text-align:center;">agrupacion_cie10</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Grupo según nomenclador CIE-10</td>
        </tr>
        <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">patologia_cod</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Código CIE-10</td>
        </tr>
        <tr>
            <td style="border:3px solid #000; padding:10px; text-align:center;">consulta_cantidad</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Número entero (integer)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Cantidad de consultas médicas</td>
        </tr>
        <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">rango_etario</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Rango etario de pacientes</td>
        </tr>
        <tr>
            <td style="border:3px solid #000; padding:10px; text-align:center;">sexo</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Sexo del paciente</td>
        </tr>
    </tbody>
</table>

Tabla Con Los Datos Para Las Inmunizaciones.

<table style="width:100%; border-collapse:collapse; font-family:Arial, Helvetica, sans-serif;">
    <thead>
        <tr>
            <th style="background:#00a3e0; color:#fff; border:3px solid #000; padding:12px;">
                Título de la columna
            </th>
            <th style="background:#00a3e0; color:#fff; border:3px solid #000; padding:12px;">
                Tipo de dato
            </th>
            <th style="background:#00a3e0; color:#fff; border:3px solid #000; padding:12px;">
                Descripción
            </th>
        </tr>
    </thead>
    <tbody>
        <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">id_inmunizacion</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Número entero</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Número de entero que identifica unívocamente a cada inmunización</td>
        </tr>
        <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">id_saps</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Número entero</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Número de entero que identifica en cuál saps se administró la vacuna</td>
        </tr>
        <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">fecha</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Fecha ISO-8601 (date)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Periodo en el cual se administró la inmunización.</td>
        </tr>
        <tr>
            <td style="border:3px solid #000; padding:10px; text-align:center;">vacunas_tipo </td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Tipo de vacuna aplicada</td>
        </tr>
          <tr>
            <td style="border:3px solid #000; padding:10px; text-align:center;">vacunas_cantidad </td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Número entero (integer)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Cantidad de vacunas efectuadas </td>
        </tr>
    </tbody>
</table>

Tabla: Listado De SAPS. Datos Abiertos Ciudad De Corrientes

<table style="width:100%; border-collapse:collapse; font-family:Arial, Helvetica, sans-serif;">
    <thead>
        <tr>
            <th style="background:#00a3e0; color:#fff; border:3px solid #000; padding:12px;">
                Título de la columna
            </th>
            <th style="background:#00a3e0; color:#fff; border:3px solid #000; padding:12px;">
                Tipo de dato
            </th>
            <th style="background:#00a3e0; color:#fff; border:3px solid #000; padding:12px;">
                Descripción
            </th>
        </tr>
    </thead>
    <tbody>
         <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">id_saps</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Número entero</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Número entero que identifica unívocamente al saps</td>
        </tr>
        <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">SAPS</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">El nombre del SAPS</td>
        </tr>
        <tr style="background:#eaf7fd;">
            <td style="border:3px solid #000; padding:10px; text-align:center;">Barrio</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">El nombre del barrio donde se encuentra ubicado el SAPS</td>
        </tr>
        <tr>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Ubicación</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">El nombre de las calles donde se encuentra el SAPS</td>
        </tr>
         <tr>
            <td style="border:3px solid #000; padding:10px; text-align:center;">contacto_telefono</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">El teléfono para comunicarse con el SAPS</td>
        </tr>
          <tr>
            <td style="border:3px solid #000; padding:10px; text-align:center;">responsable</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Nombre y apellido de la persona responsable del SAPS</td>
        </tr>
          <tr>
            <td style="border:3px solid #000; padding:10px; text-align:center;">cargo</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">Texto (string)</td>
            <td style="border:3px solid #000; padding:10px; text-align:center;">El cargo de la persona responsable</td>
        </tr>
    </tbody>
</table>

<figure>
    <img src="assets/img/draw-io/FlujoDatosBronce.png">
    <figcaption style="text-align:center">
        Imagen 3. Flujo de datos para la capa de bronce
    </figcaption>
</figure>

Se realizó un conjunto de limpiezas previas a la carga de datos en la capa de bronce. Si bien esto no debería ser así, debido a que la transformaciones deberían venir antes de la extracción, se realizó de esta manera para practicar la limpieza en Python. Existen algunas transformaciones adicionales que se realizarán cuando se pase de la capa de bronce a la capa de plata.

---

# 5.1.1 Prelimpieza De Datos Con Python

En este apartado, listaremos la limpieza de datos que realizamos con Python previo a la carga de datos en la capa de bronce en PostgreSQL. Esto dará lugar a los tres archivos que se muestran en la imagen 3:

1. consultas_por_patologia_clean.csv
2. inmunizacion_clean.csv
3. listado_saps_clean.csv

Si se quiere conocer a detalles los procesos realizados, debe consultarse el archivo clean.ipyb que tendrá los detalles del mismo.

---
# 5.2. Capa De Plata


---
 ## Referencias

 <ol>
    <li>
        <a href="https://datos.ciudaddecorrientes.gov.ar/dataset/consultas-segun-patologias-medicas" target="_blank">
            Consultas Según Palogía Médica. Datos Abiertos Ciudad De Corrientes
        </a>
    </li>
    <li>
        <a href="https://datos.ciudaddecorrientes.gov.ar/dataset/inmunizaciones" target="_blank">
            Inmunizaciones. Datos Abiertos Ciudad De Corrientes
        </a>
    </li>
    <li>
        <a href="https://datos.ciudaddecorrientes.gov.ar/dataset/id_salud/archivo/2f0583e8-68ae-4714-973b-0fbcb4bac215" target="_blank">
            Nomenclador CIE-10. Datos Abiertos Ciudad De Corrientes
        </a>
    </li>
    <li>
        <a href="https://datos.ciudaddecorrientes.gov.ar/dataset/id_salud/archivo/9d4ccfa7-1936-482b-b4a4-bac9ff3de001" target="_blank">
            Listado De SAPS. Datos Abiertos Ciudad De Corrientes
        </a>
    </li>
     <li>
        <a href="https://github.com/verasativa/CIE-10?tab=readme-ov-file" target="_blank">
            Códigos CIE-10. Más Códigos. gitlab.com/veraSativa. Scrapping Desde  https://icdcode.info/espanol/cie-10/codigos.html 
        </a>
    </li>
      <li>
        <a href="https://www.appsmedical.com/pages/buscador-cie-10" target="_blank">
            AppsMedical-Buscador cie10. 
        </a>
    </li>
 </ol>