--consultar la cantidad de registros en cada tabla
--Resultado: OK
select count(*) from bronze.datosctes_consultas_patologia;
select count(*) from bronze.datosctes_saps;
select count(*) from bronze.datosctes_inmunizacion;
select count(*) from bronze.datosctes_cie10;

--Reviso los valores distintos para algunos campos
select distinct id_saps from bronze.datosctes_consultas_patologia;
select distinct id_saps from bronze.datosctes_inmunizacion;
select distinct sexo from bronze.datosctes_consultas_patologia;
select distinct patologia_cod from bronze.datosctes_consultas_patologia;

--Reviso si existen nulos
select 
(select count(*) from bronze.datosctes_consultas_patologia where patologia_desc='#N/A') AS Patologia_Desc_NULL,
(select count(*) from bronze.datosctes_consultas_patologia where agrupacion_cie10='#N/A') AS agrupacion_cie10_NULL,
(select count(*) from bronze.datosctes_consultas_patologia where patologia_cod IS NULL) AS Patologia_cod_NULL,
(select count(*) from bronze.datosctes_consultas_patologia where saps IS NULL) AS saps_null,
(select count(*) from bronze.datosctes_consultas_patologia where rango_etario='#N/A') AS Rango_Etario_NULL,
(select count(*) from bronze.datosctes_consultas_patologia where sexo='#N/A') AS sexo_NULL,
(select count(*) from bronze.datosctes_consultas_patologia where consulta_cantidad IS NULL) AS consultas_NULL;

--Compruebo que existen registros donde hay más de un campo a la vez que son nulos
select 
    count(*) 
from bronze.datosctes_consultas_patologia 
where 
    patologia_desc='#N/A' AND
    sexo='#N/A'





--Control de rango de valores que los id para las inmunizaciones y para las consultas sean los mismos
--Es decir, que no haya ids que aparecen en uno y no en el otro.
WITH  saps_clean AS
(select distinct id_saps::INTEGER from bronze.datosctes_consultas_patologia	
where id_saps!='#REF!' and id_saps IS NOT NULL
Order  BY id_saps::INTEGER) 

select distinct id_saps from saps_clean where id_saps not in (
    select distinct id_saps::INTEGER from bronze.datosctes_inmunizacion
    where id_saps!='#REF!' and id_saps is not NULL and id_saps!='#N/A'
    order by id_saps::INTEGER
)

/*Este código controla los repetidos. Como se han eliminado directamente desde python, no debería
devolver algún registro.*/



SELECT count(*)
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
            ORDER BY id_saps
        ) AS rn
    FROM bronze.datosctes_consultas_patologia
) t
WHERE rn > 1;


SELECT count(*)
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY
                id_saps,
                saps,
                fecha,
                vacunas_tipo,
                vacunas_cantidad
            ORDER BY id_saps
        ) AS rn
    FROM bronze.datosctes_inmunizacion
) t
WHERE rn > 1;