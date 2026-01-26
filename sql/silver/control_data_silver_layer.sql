--Aquí se ve el total quitando los repetidos

SELECT
    (SELECT COUNT(*) 
     FROM bronze.datosctes_consultas_patologia
     ) AS bronze_count,

    (SELECT COUNT(*) 
     FROM silver.datosctes_consultas_patologia) AS silver_count;

SELECT
    (SELECT COUNT(*) 
     FROM bronze.datosctes_inmunizacion
     ) AS bronze_count,

    (SELECT COUNT(*) 
     FROM silver.datosctes_inmunizacion) AS silver_count;

select (select count(*) from bronze.datosctes_saps) as bronze_count,
       (select count(*) from silver.datosctes_saps) as silver_count;




--Revisar que no haya valores nulos
--Resultado: Para consultas_patologias e inmunizacion está OK. Para saps, hay datos nulos
--en barrio y responsable.
--Acción: Rellenar esos datos a 'n/a' para cuando se pase a la capa de plata.
select count(*) from silver.datosctes_consultas_patologia where id_saps IS NULL or saps IS NULL 
or patologia_desc IS NULL or agrupacion_cie10 IS NULL or patologia_cod IS NULL 
or id_rango_etario IS NULL or consulta_cantidad IS NULL or rango_etario IS NULL
or sexo IS NULL;

select count(*) from silver.datosctes_saps where id_saps IS NULL or saps IS NULL or barrio IS NULL
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
select distinct id_saps from silver.datosctes_consultas_patologia where id_saps not in (
	select distinct id_saps from silver.datosctes_saps
);


--Analizamos los id de saps igual a -1 para ver a qué se refiere.
--Resultado: Hay sólamente 1 con el id_saps=-1
--Acción: Dejar ese resultado como está para indicar que no se sabe a qué saps corresponde
select count(*)
from silver.datosctes_consultas_patologia where id_saps=-1;

select count(*)
from silver.datosctes_inmunizacion where id_saps=-1;





/*Este código controla los repetidos. Como se han eliminado directamente desde python, no debería
devolver algún registro.

Resultado Esperado: Ningún Registro.
Resultado Obtenido: OK*/
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
    FROM silver.datosctes_consultas_patologia
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
    FROM silver.datosctes_inmunizacion
) t
WHERE rn > 1;

