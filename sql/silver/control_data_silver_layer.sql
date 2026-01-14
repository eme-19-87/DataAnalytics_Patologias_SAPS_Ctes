--Comparo la cantidad de registros en cada tabla análoga entre 
--las capas
--Resultado: OK
SELECT
    (SELECT COUNT(*) 
     FROM bronze.datosctes_consultas_patologia
     WHERE id_saps <> 99) AS bronze_count,

    (SELECT COUNT(*) 
     FROM silver.datosctes_consultas_patologia) AS silver_count;

SELECT
    (SELECT COUNT(*) 
     FROM bronze.datosctes_inmunizacion
     WHERE id_saps <> 99) AS bronze_count,

    (SELECT COUNT(*) 
     FROM silver.datosctes_inmunizacion) AS silver_count;

select (select count(*) from bronze.datosctes_saps) as bronze_count,
       (select count(*) from silver.datosctes_saps) as silver_count;

--Revisar que no haya valores nulos
--Resultado: Para consultas_patologias e inmunizacion está OK. Para saps, hay datos nulos
--en barrio y responsable.
--Acción: Rellenar esos datos a 'n/a' para cuando se pase a la capa de plata.
select * from silver.datosctes_consultas_patologia where id_saps IS NULL or saps IS NULL 
or patologia_desc IS NULL or agrupacion_cie10 IS NULL or patologia_cod IS NULL 
or id_rango_etario IS NULL or consulta_cantidad IS NULL or rango_etario IS NULL
or sexo IS NULL;

select * from silver.datosctes_saps where id_saps IS NULL or saps IS NULL or barrio IS NULL
or ubicacion IS NULL or contacto_telefono IS NULL or responsable IS NULL
or cargo IS NULL;

select * from silver.datosctes_inmunizacion where id_saps is NULL or fecha is NULL
or vacunas_tipo IS NULL or vacunas_cantidad IS NULL;


--Comprobar que los id de saps para consultas e inmunizaciones, figuran en la tabla de saps
--Resultado: Nos da que el código 99, operativos territoriales aparece en la tabla de inmunizaciones
--pero no aparece en los saps. Como no nos interesa esto, eliminaremos estos registros porque sólo
--analizaremos las inmunizaciones realizadas directamente en los saps.
--Acción: Eliminar los registros con id_saps=99 al pasar a la capa de plata.

select distinct id_saps from silver.datosctes_inmunizacion where id_saps not in (
	select distinct id_saps from silver.datosctes_saps
);


--Nuevamente, tenemos datos de los operativos territoriales con el codigo id_saps=99
--Acción: Eliminar esos datos antes de pasar a la capa de plata.
select * from silver.datosctes_consultas_patologia where id_saps not in (
	select distinct id_saps from silver.datosctes_saps
);


--Analizamos los id de saps igual a -1 para ver a qué se refiere.
--Resultado: Hay sólamente 1 con el id_saps=-1
--Acción: Dejar ese resultado como está para indicar que no se sabe a qué saps corresponde
select *
from silver.datosctes_consultas_patologia where id_saps=-1;

--Control de rango de valores
--Los rangos de valores de los saps en consultas_patologia deben ser los mismos que en la tabla
--de saps, exceptuando el valor -1 y el de operativos territoriales con id 99 ya no debe aparecer
--Resultado: aparecen el valor -1, así que está correcto
select distinct id_saps from silver.datosctes_consultas_patologia where id_saps not in(
	select distinct id_saps from silver.datosctes_saps
);

--Control de rango de valores
--Los rangos de valores de los saps en inmunizaciones deben ser los mismos que en la tabla
--de saps, exceptuando el valor -1 y el de operativos territoriales con id 99 ya no debe aparecer
--Resultado: No aparece el valor 99, así que está correcto. Que no aparezca -1, indica que
--se saben todos los saps donde se realizaron las vacunaciones
select distinct id_saps from silver.datosctes_inmunizacion where id_saps not in(
	select distinct id_saps from silver.datosctes_saps
);

--Control de rango de valores
--Los rangos de valores de los saps en consultas_patologia deben ser los mismos que en la tabla
--de inmunizacion, exceptuando el valor -1 y el de operativos territoriales con id 99 no debe aparecer
--Resultado: aparecen el valor -1, ya que ambos no tienen para el id 99 que representa a los operativos
--territoriales.
select distinct id_saps from silver.datosctes_consultas_patologia where id_saps not in(
	select distinct id_saps from silver.datosctes_inmunizacion
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
FROM silver.datosctes_consultas_patologia
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