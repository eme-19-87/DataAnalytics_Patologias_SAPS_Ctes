/*
Procedimiento almacenado que carga los datos en la dimensión calendario usando como fuente las fechas en consultas
e inmunizaciones. Si se agrega alguna nueva fuente de datos, se debe modificar este procedimiento para que tenga en 
cuenta esas fechas también.
*/
CREATE OR REPLACE PROCEDURE gold.sp_load_dim_calendario()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time      TIMESTAMP;
    v_truncate_time   TIMESTAMP;
    v_insert_time     TIMESTAMP;
    v_end_time        TIMESTAMP;
BEGIN
    v_start_time := clock_timestamp();

    TRUNCATE TABLE gold.dim_calendario;
    v_truncate_time := clock_timestamp();

    INSERT INTO gold.dim_calendario (
    calendario_key,
    fecha,
    dia,
    mes,
    anio,
    nombre_dia,
    nombre_mes,
    dia_mes,
    mes_anio,
    anio_mes,
    semana_anio,
    trimestre,
    es_fin_semana,
    es_fin_mes,
    es_fin_anio
)
SELECT DISTINCT
    (EXTRACT(YEAR FROM fecha)::INT * 10000 +
     EXTRACT(MONTH FROM fecha)::INT * 100 +
     EXTRACT(DAY FROM fecha)::INT)            AS calendario_key,
    fecha,
    EXTRACT(DAY FROM fecha)::INT              AS dia,
    EXTRACT(MONTH FROM fecha)::INT            AS mes,
    EXTRACT(YEAR FROM fecha)::INT             AS anio,
    TO_CHAR(fecha, 'Day')                     AS nombre_dia,
    TO_CHAR(fecha, 'Month')                   AS nombre_mes,
    TO_CHAR(fecha, 'DD-MM')                   AS dia_mes,
    TO_CHAR(fecha, 'MM-YYYY')                 AS mes_anio,
    TO_CHAR(fecha, 'YYYY-MM')                 AS anio_mes,
    EXTRACT(WEEK FROM fecha)::INT             AS semana_anio,
    EXTRACT(QUARTER FROM fecha)::INT          AS trimestre,
    EXTRACT(DOW FROM fecha) IN (0,6)           AS es_fin_semana,
    fecha = (DATE_TRUNC('month', fecha) 
             + INTERVAL '1 month - 1 day')::DATE AS es_fin_mes,
    fecha = (DATE_TRUNC('year', fecha) 
             + INTERVAL '1 year - 1 day')::DATE  AS es_fin_anio
FROM (
    SELECT fecha FROM silver.datosctes_consultas_patologia
    UNION
    SELECT fecha FROM silver.datosctes_inmunizacion
) f;

    v_insert_time := clock_timestamp();
    v_end_time := v_insert_time;

    RAISE NOTICE 'Inserción de datos en gold.dim_calendario';
    RAISE NOTICE '  TRUNCATE: % ms', EXTRACT(MILLISECOND FROM v_truncate_time - v_start_time);
    RAISE NOTICE '  INSERT:   % ms', EXTRACT(MILLISECOND FROM v_insert_time - v_truncate_time);
    RAISE NOTICE '  TOTAL:    % ms', EXTRACT(MILLISECOND FROM v_end_time - v_start_time);

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'ERROR al cargar los datos de la dimensión calendario: %', SQLERRM;
END;
$$;

/*
Procedimiento almacenado que carga los datos de la dimension de los saps
*/
CREATE OR REPLACE PROCEDURE gold.sp_load_dim_saps()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time      TIMESTAMP;
    v_truncate_time   TIMESTAMP;
    v_insert_time     TIMESTAMP;
    v_end_time        TIMESTAMP;
BEGIN
    v_start_time := clock_timestamp();

    TRUNCATE TABLE gold.dim_saps;
    v_truncate_time := clock_timestamp();

    INSERT INTO gold.dim_saps (
    id_saps,
    saps,
    barrio,
    ubicacion,
    contacto_telefono,
    responsable,
    cargo,
    tiv,
    tfv
)
SELECT DISTINCT
    id_saps,
    saps,
    barrio,
    ubicacion,
    contacto_telefono,
    responsable,
    cargo,
    tiv,
    tfv
FROM silver.datosctes_saps;

    v_insert_time := clock_timestamp();
    v_end_time := v_insert_time;

    RAISE NOTICE 'Inserción de datos en gold.dim_saps';
    RAISE NOTICE '  TRUNCATE: % ms', EXTRACT(MILLISECOND FROM v_truncate_time - v_start_time);
    RAISE NOTICE '  INSERT:   % ms', EXTRACT(MILLISECOND FROM v_insert_time - v_truncate_time);
    RAISE NOTICE '  TOTAL:    % ms', EXTRACT(MILLISECOND FROM v_end_time - v_start_time);

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'ERROR al cargar los datos de la dimensión saps: %', SQLERRM;
END;
$$;

/*
Procedimiento para cargar los datos de la dimensión patologias
*/
CREATE OR REPLACE PROCEDURE gold.sp_load_dim_patologia()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time      TIMESTAMP;
    v_truncate_time   TIMESTAMP;
    v_insert_time     TIMESTAMP;
    v_end_time        TIMESTAMP;
BEGIN
    v_start_time := clock_timestamp();

    TRUNCATE TABLE gold.dim_patologia;
    v_truncate_time := clock_timestamp();

    INSERT INTO gold.dim_patologia (
    patologia_cod,
    agrupacion_cie10,
    patologia_desc
)
SELECT DISTINCT
    patologia_cod,
    agrupacion_cie10,
    patologia_desc
FROM silver.datosctes_consultas_patologia;

    v_insert_time := clock_timestamp();
    v_end_time := v_insert_time;

    RAISE NOTICE 'Inserción de datos en gold.dim_patologia';
    RAISE NOTICE '  TRUNCATE: % ms', EXTRACT(MILLISECOND FROM v_truncate_time - v_start_time);
    RAISE NOTICE '  INSERT:   % ms', EXTRACT(MILLISECOND FROM v_insert_time - v_truncate_time);
    RAISE NOTICE '  TOTAL:    % ms', EXTRACT(MILLISECOND FROM v_end_time - v_start_time);

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'ERROR al cargar los datos de la dimensión patologia: %', SQLERRM;
END;
$$;

/*
Procedimiento para cargar los datos de la dimensión de rango etario
*/
CREATE OR REPLACE PROCEDURE gold.sp_load_dim_rango_etario()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time      TIMESTAMP;
    v_truncate_time   TIMESTAMP;
    v_insert_time     TIMESTAMP;
    v_end_time        TIMESTAMP;
BEGIN
    v_start_time := clock_timestamp();

    TRUNCATE TABLE gold.dim_rango_etario;
    v_truncate_time := clock_timestamp();

   INSERT INTO gold.dim_rango_etario (
    id_rango_etario,
    rango_etario,
    sexo
)
SELECT DISTINCT
    id_rango_etario,
    rango_etario,
    sexo
FROM silver.datosctes_consultas_patologia;

    v_insert_time := clock_timestamp();
    v_end_time := v_insert_time;

    RAISE NOTICE 'Inserción de datos en gold.dim_rango_etario';
    RAISE NOTICE '  TRUNCATE: % ms', EXTRACT(MILLISECOND FROM v_truncate_time - v_start_time);
    RAISE NOTICE '  INSERT:   % ms', EXTRACT(MILLISECOND FROM v_insert_time - v_truncate_time);
    RAISE NOTICE '  TOTAL:    % ms', EXTRACT(MILLISECOND FROM v_end_time - v_start_time);

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'ERROR al cargar los datos de la dimensión rango etario: %', SQLERRM;
END;
$$;

/*
Procedimiento para cargar los datos de la dimensión de los tipos de vacunas
*/
CREATE OR REPLACE PROCEDURE gold.sp_load_dim_vacuna()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time      TIMESTAMP;
    v_truncate_time   TIMESTAMP;
    v_insert_time     TIMESTAMP;
    v_end_time        TIMESTAMP;
BEGIN
    v_start_time := clock_timestamp();

    TRUNCATE TABLE gold.dim_vacuna;
    v_truncate_time := clock_timestamp();

  INSERT INTO gold.dim_vacuna (
    tipo_vacuna
)
SELECT DISTINCT
    vacunas_tipo
FROM silver.datosctes_inmunizacion;

    v_insert_time := clock_timestamp();
    v_end_time := v_insert_time;

    RAISE NOTICE 'Inserción de datos en gold.dim_vacuna';
    RAISE NOTICE '  TRUNCATE: % ms', EXTRACT(MILLISECOND FROM v_truncate_time - v_start_time);
    RAISE NOTICE '  INSERT:   % ms', EXTRACT(MILLISECOND FROM v_insert_time - v_truncate_time);
    RAISE NOTICE '  TOTAL:    % ms', EXTRACT(MILLISECOND FROM v_end_time - v_start_time);

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'ERROR al cargar los datos de la dimensión para las vacunas: %', SQLERRM;
END;
$$;

/*
Procedimiento para cargar los datos de la tabla de hecho de consultas
*/
CREATE OR REPLACE PROCEDURE gold.sp_load_fact_consulta()
LANGUAGE plpgsql
AS $$
DECLARE t_start TIMESTAMP;
BEGIN
    t_start := clock_timestamp();
    RAISE NOTICE '▶ Cargando fact_consulta';

    TRUNCATE TABLE gold.fact_consulta;

    INSERT INTO gold.fact_consulta (
        saps_key, patologia_key, calendario_key,
        rango_etario_key, consultas_cantidad
    )
    SELECT
        ds.saps_key,
        dp.patologia_key,
        dc.calendario_key,
        dr.rango_etario_key,
        cp.consulta_cantidad
    FROM silver.datosctes_consultas_patologia cp
    LEFT JOIN gold.dim_saps ds
        ON cp.id_saps = ds.id_saps
       AND CURRENT_DATE BETWEEN ds.tiv AND ds.tfv
    LEFT JOIN gold.dim_patologia dp
        ON cp.patologia_cod = dp.patologia_cod
       AND cp.agrupacion_cie10 = dp.agrupacion_cie10
       AND cp.patologia_desc = dp.patologia_desc
    LEFT JOIN gold.dim_rango_etario dr
        ON cp.rango_etario = dr.rango_etario
       AND cp.sexo = dr.sexo
    LEFT JOIN gold.dim_calendario dc
        ON dc.fecha = cp.fecha;

    RAISE NOTICE '✔ fact_consulta cargada en %', clock_timestamp() - t_start;
END $$;

/*
Procedimiento para cargar los datos de la dimensión de inmunizacion
*/
CREATE OR REPLACE PROCEDURE gold.sp_load_fact_inmunizacion()
LANGUAGE plpgsql
AS $$
DECLARE t_start TIMESTAMP;
BEGIN
    t_start := clock_timestamp();
    RAISE NOTICE '▶ Cargando fact_inmunizacion';

    TRUNCATE TABLE gold.facts_inmunizacion;

    INSERT INTO gold.facts_inmunizacion (
        saps_key, calendario_key, vacuna_key, cantidad_vacuna
    )
    SELECT
        ds.saps_key,
        dc.calendario_key,
        dv.vacuna_key,
        im.vacunas_cantidad
    FROM silver.datosctes_inmunizacion im
    LEFT JOIN gold.dim_saps ds
        ON im.id_saps = ds.id_saps
       AND CURRENT_DATE BETWEEN ds.tiv AND ds.tfv
    LEFT JOIN gold.dim_vacuna dv
        ON im.vacunas_tipo = dv.tipo_vacuna
    LEFT JOIN gold.dim_calendario dc
        ON dc.fecha = im.fecha;

    RAISE NOTICE '✔ fact_inmunizacion cargada en %', clock_timestamp() - t_start;
END $$;

/*
Procedimiento central que llama a los demás procedimientos y se encarga de cargar los datos de las 
tablas de dimensiones y hechos.

Uso: call gold.sp_master_load_gold()
*/
CREATE OR REPLACE PROCEDURE gold.sp_master_load_gold()
LANGUAGE plpgsql
AS $$
DECLARE
    t_start TIMESTAMP;
BEGIN
    t_start := clock_timestamp();
    RAISE NOTICE '=== INICIO CARGA CAPA GOLD ===';

    BEGIN
        CALL gold.sp_load_dim_calendario();
        CALL gold.sp_load_dim_saps();
        CALL gold.sp_load_dim_patologia();
        CALL gold.sp_load_dim_rango_etario();
        CALL gold.sp_load_dim_vacuna();

        CALL gold.sp_load_fact_consulta();
        CALL gold.sp_load_fact_inmunizacion();

        RAISE NOTICE '=== CARGA GOLD COMPLETA ===';
        RAISE NOTICE 'TIEMPO TOTAL: %', clock_timestamp() - t_start;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE '❌ ERROR EN CARGA GOLD';
            RAISE NOTICE '%', SQLERRM;
            RAISE;
    END;
END $$;

call gold.sp_master_load_gold();