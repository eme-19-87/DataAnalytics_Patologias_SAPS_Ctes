--consultar la cantidad de registros en cada tabla
--Resultado: OK
select count(*) from bronze.datosctes_consultas_patologia;
select count(*) from bronze.datosctes_saps;
select count(*) from bronze.datosctes_inmunizacion;
select count(*) from bronze.datosctes_cie10;

select * from bronze.datosctes_saps;

--Revisamos los datos nulos para los campos principales
select count(*) from bronze.datosctes_consultas_patologia where id_saps IS NULL or saps IS NULL 
or patologia_desc IS NULL or agrupacion_cie10 IS NULL or patologia_cod IS NULL 
or id_rango_etario IS NULL or consulta_cantidad IS NULL or rango_etario IS NULL
or sexo IS NULL;

select count(*) from bronze.datosctes_saps where saps IS NULL or barrio IS NULL
or ubicacion IS NULL or contacto_telefono IS NULL or responsable IS NULL
or cargo IS NULL;

select count(*) from bronze.datosctes_inmunizacion where id_saps is NULL or fecha is NULL
or vacunas_tipo IS NULL or vacunas_cantidad IS NULL;

---Como no tengo los datos, los coloco a 'n/a' para indicar la ausencia de los mismos
--UPDATE bronze.datosctes_saps SET barrio='n/a' where barrio IS NULL;
--UPDATE bronze.datosctes_saps SET cargo='n/a' where cargo IS NULL;



--Comprobamos que hay nombres diferentes para saps en inmunizaciones y el listado de saps
select distinct saps from bronze.datosctes_inmunizacion where saps not in (
	select distinct saps from bronze.datosctes_saps
);

--Elimino los datos de los operativos territoriales en la tabla de inmunizaciones
--DELETE FROM bronze.datosctes_inmunizacion where id_saps=99;


--Nuevamente, tenemos datos de los operativos territoriales con el codigo id_saps=99
--Acción: Eliminar esos datos antes de pasar a la capa de plata.
select * from bronze.datosctes_consultas_patologia where id_saps not in (
	select distinct id_saps from bronze.datosctes_saps
);


--Elimino los operativos territoriales para las consultas por patologia
--DELETE FROM bronze.datosctes_consultas_patologia where id_saps=99;

--Analizamos los id de saps igual a -1 para ver a qué se refiere.
--Resultado: Hay sólamente 1 con el id_saps=-1
--Acción: Dejar ese resultado como está para indicar que no se sabe a qué saps corresponde
select *
from bronze.datosctes_consultas_patologia where id_saps=-1;

--Control de rango de valores
--Los rangos de valores de los saps en consultas_patologia deben ser los mismos que en la tabla
--de saps, exceptuando el valor -1 y el de operativos territoriales con id 99
--Resultado: aparecen el valor -1 y 99, así que está correcto
select distinct id_saps from bronze.datosctes_consultas_patologia where id_saps not in(
	select distinct id_saps from bronze.datosctes_saps
);

--Control de rango de valores
--Los rangos de valores de los saps en inmunizaciones deben ser los mismos que en la tabla
--de saps, exceptuando el valor -1 y el de operativos territoriales con id 99
--Resultado: aparecen el valor 99, así que está correcto. Que no aparezca -1, indica que
--se saben todos los saps donde se realizaron las vacunaciones
select distinct id_saps from bronze.datosctes_inmunizacion where id_saps not in(
	select distinct id_saps from bronze.datosctes_saps
);

--Control de rango de valores
--Los rangos de valores de los saps en consultas_patologia deben ser los mismos que en la tabla
--de inmunizacion, exceptuando el valor -1 y el de operativos territoriales con id 99
--Resultado: aparecen el valor -1, ya que ambos tienen para el id 99 que representa a los operativos
--territoriales.
select distinct id_saps from bronze.datosctes_consultas_patologia where id_saps not in(
	select distinct id_saps from bronze.datosctes_inmunizacion
);

/*Este código controla los repetidos. Como se han eliminado directamente desde python, no debería
devolver algún registro.

Resultado Esperado: Ningún Registro.
Resultado Obtenido: OK*/
SELECT
    id_saps,
    saps,
    fecha,
    patologia_desc,
    agrupacion_cie10,
    patologia_cod,
    id_rango_etario,
    consulta_cantidad,
    rango_etario,
    sexo,
    COUNT(*) AS cantidad_registros
FROM bronze.datosctes_consultas_patologia
GROUP BY
    id_saps,
    saps,
    fecha,
    patologia_desc,
    agrupacion_cie10,
    patologia_cod,
    id_rango_etario,
    consulta_cantidad,
    rango_etario,
    sexo
HAVING COUNT(*) > 1
ORDER BY cantidad_registros DESC;

--Veo el total de registros que no tengan los siguientes datos
--Que estén sin cantidad de consultas
--Que estén sin saps
--Que estén sin código de patología
--Que estén sin rango etario
--Me da un total de 13+0+23+22=58
--Como en total tengo 164226 datos en total para las consultas, podemos
--eliminar estos 58 registros y no alterarían gravemente los datos.
select 
(select count(*) from bronze.datosctes_consultas_patologia where consulta_cantidad=-1) as "Sin_Consulta",
(select count(*) from bronze.datosctes_consultas_patologia where id_saps=-1) as "Sin_Saps",
(select count(*) from bronze.datosctes_consultas_patologia where patologia_cod='n/a') as "Sin_Cod_Pato",
(select count(*) from bronze.datosctes_consultas_patologia where id_rango_etario=-1) as "Sin_Rango_Etario"
;


/*Código para la eliminación de repetidos.
Básicamente, creo una nueva tabla con los datos no duplicados. Trunco la tabla original, cargo 
los datos hacia la tabla original desde la tabla sin duplicados, y elimino la tabla accesoria.*/

/*
CREATE TABLE bronze.datosctes_consultas_patologia_clean AS
SELECT DISTINCT ON (
    id_saps,
    saps,
    fecha,
    patologia_desc,
    agrupacion_cie10,
    patologia_cod,
    id_rango_etario,
    consulta_cantidad,
    rango_etario,
    sexo
)
*
FROM bronze.datosctes_consultas_patologia
ORDER BY
    id_saps,
    saps,
    fecha,
    patologia_desc,
    agrupacion_cie10,
    patologia_cod,
    id_rango_etario,
    consulta_cantidad,
    rango_etario,
    sexo,
    id_consulta;


TRUNCATE bronze.datosctes_consultas_patologia;
INSERT INTO bronze.datosctes_consultas_patologia
SELECT * FROM bronze.datosctes_consultas_patologia_clean;
drop table bronze.datosctes_consultas_patologia_clean;
*/

/*Otros códigos que pueden servir para detectar repetidos*/
/*SELECT *
FROM bronze.datosctes_consultas_patologia
WHERE (id_saps,
       saps,
       fecha,
       patologia_desc,
       agrupacion_cie10,
       patologia_cod,
       id_rango_etario,
       consulta_cantidad,
       rango_etario,
       sexo) IN (
    SELECT
        id_saps,
        saps,
        fecha,
        patologia_desc,
        agrupacion_cie10,
        patologia_cod,
        id_rango_etario,
        consulta_cantidad,
        rango_etario,
        sexo
    FROM bronze.datosctes_consultas_patologia
    GROUP BY
        id_saps,
        saps,
        fecha,
        patologia_desc,
        agrupacion_cie10,
        patologia_cod,
        id_rango_etario,
        consulta_cantidad,
        rango_etario,
        sexo
    HAVING COUNT(*) > 1
)
ORDER BY
    id_saps,
    fecha,
    patologia_cod;
*/

/*
SELECT *
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY
                id_saps,
                saps,
                fecha,
                patologia_desc,
                agrupacion_cie10,
                patologia_cod,
                id_rango_etario,
                consulta_cantidad,
                rango_etario,
                sexo
            ORDER BY id_consulta
        ) AS rn
    FROM bronze.datosctes_consultas_patologia
) t
WHERE rn > 1;*/