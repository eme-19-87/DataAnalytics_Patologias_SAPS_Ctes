/*
Permite cargar los datos de los saps desde la capa bronce a la capa silver.
Aplica un full load mediante TRUNCATE+INSERT

Modo de uso: call silver.sp_load_saps

*/
CREATE OR REPLACE PROCEDURE silver.sp_load_saps()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time      TIMESTAMP;
    v_truncate_time   TIMESTAMP;
    v_insert_time     TIMESTAMP;
    v_end_time        TIMESTAMP;
BEGIN
    v_start_time := clock_timestamp();

    TRUNCATE TABLE silver.datosctes_saps;
    v_truncate_time := clock_timestamp();

    INSERT INTO silver.datosctes_saps (
        id_saps,
        saps,
        barrio,
        ubicacion,
        contacto_telefono,
        responsable,
        cargo
    )
    SELECT
        id_saps,
        COALESCE(saps, 'n/a'),
        COALESCE(barrio, 'n/a'),
        COALESCE(ubicacion, 'n/a'),
		COALESCE(contacto_telefono, 'n/a'),
        COALESCE(responsable, 'n/a'),
        COALESCE(cargo, 'n/a')
    FROM bronze.datosctes_saps;

    v_insert_time := clock_timestamp();
    v_end_time := v_insert_time;

    RAISE NOTICE 'SP SAPS';
    RAISE NOTICE '  TRUNCATE: % ms', EXTRACT(MILLISECOND FROM v_truncate_time - v_start_time);
    RAISE NOTICE '  INSERT:   % ms', EXTRACT(MILLISECOND FROM v_insert_time - v_truncate_time);
    RAISE NOTICE '  TOTAL:    % ms', EXTRACT(MILLISECOND FROM v_end_time - v_start_time);

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'ERROR en sp_load_saps(): %', SQLERRM;
END;
$$;

/*
Permite cargar los datos de las patologías desde la capa de bronce a la capa de plata.
Aplica full load mediante TRUNCATE+INSERT. Deja de lado a los registros con id_saps=99 que
representan a los operativos territoriales.

*/
CREATE OR REPLACE PROCEDURE silver.sp_load_consultas_patologia()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time      TIMESTAMP;
    v_truncate_time   TIMESTAMP;
    v_insert_time     TIMESTAMP;
    v_end_time        TIMESTAMP;
BEGIN
    v_start_time := clock_timestamp();

    -- TRUNCATE
    TRUNCATE TABLE silver.datosctes_consultas_patologia;
    v_truncate_time := clock_timestamp();

    -- INSERT
    INSERT INTO silver.datosctes_consultas_patologia (
        id_consulta,
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
    SELECT
        id_consulta,
        id_saps,
        TRIM(saps),
        fecha,
        TRIM(UPPER(patologia_desc)),
        TRIM(UPPER(agrupacion_cie10)),
        TRIM(UPPER(patologia_cod)),
        id_rango_etario,
        consulta_cantidad,
        TRIM(UPPER(rango_etario)),
        sexo
    FROM bronze.datosctes_consultas_patologia
    WHERE id_saps <> 99 and id_saps<>-1 and patologia_cod<>'n/a' and consulta_cantidad<>-1 
    and id_rango_etario<>-1;

    v_insert_time := clock_timestamp();
    v_end_time := v_insert_time;

    RAISE NOTICE 'SP Consultas Patología';
    RAISE NOTICE '  TRUNCATE: % ms', EXTRACT(MILLISECOND FROM v_truncate_time - v_start_time);
    RAISE NOTICE '  INSERT:   % ms', EXTRACT(MILLISECOND FROM v_insert_time - v_truncate_time);
    RAISE NOTICE '  TOTAL:    % ms', EXTRACT(MILLISECOND FROM v_end_time - v_start_time);

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'ERROR en sp_load_consultas_patologia(): %', SQLERRM;
END;
$$;


/*

Permite cargar los datos de las inmunizaciones desde la capa de bronce hacia la capa de plata.
Aplica full load mediante TRUNCATE+INSERT. Deja de lado a los registros con id_saps=99 que
representan a los operativos territoriales.
*/

CREATE OR REPLACE PROCEDURE silver.sp_load_inmunizacion()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time      TIMESTAMP;
    v_truncate_time   TIMESTAMP;
    v_insert_time     TIMESTAMP;
    v_end_time        TIMESTAMP;
BEGIN
    v_start_time := clock_timestamp();

    TRUNCATE TABLE silver.datosctes_inmunizacion;
    v_truncate_time := clock_timestamp();

    INSERT INTO silver.datosctes_inmunizacion (
        id_inmunizacion,
        id_saps,
        saps,
        fecha,
        vacunas_tipo,
        vacunas_cantidad
    )
    SELECT
        id_inmunizacion,
        id_saps,
        saps,
        fecha,
        TRIM(UPPER(vacunas_tipo)),
        vacunas_cantidad
    FROM bronze.datosctes_inmunizacion
    WHERE id_saps <> 99;

    v_insert_time := clock_timestamp();
    v_end_time := v_insert_time;

    RAISE NOTICE 'SP Inmunización';
    RAISE NOTICE '  TRUNCATE: % ms', EXTRACT(MILLISECOND FROM v_truncate_time - v_start_time);
    RAISE NOTICE '  INSERT:   % ms', EXTRACT(MILLISECOND FROM v_insert_time - v_truncate_time);
    RAISE NOTICE '  TOTAL:    % ms', EXTRACT(MILLISECOND FROM v_end_time - v_start_time);

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'ERROR en sp_load_inmunizacion(): %', SQLERRM;
END;
$$;


/*
Procedimiento almacenado principal que permite cargar los datos desde la capa de bronce hacia la
capa de plata.

Uso: call silver.sp_master_load_silver_layer()
*/
CREATE OR REPLACE PROCEDURE silver.sp_master_load_silver_layer()
LANGUAGE plpgsql
AS $$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time   TIMESTAMP;
BEGIN
    v_start_time := clock_timestamp();
    RAISE NOTICE '=== INICIO CARGA CAPA SILVER ===';

    -- Llamadas a SP hijos
    CALL silver.sp_load_saps();
    CALL silver.sp_load_consultas_patologia();
    CALL silver.sp_load_inmunizacion();

    v_end_time := clock_timestamp();

    RAISE NOTICE '=== CARGA SILVER COMPLETADA ===';
    RAISE NOTICE 'TIEMPO TOTAL: % ms',
        EXTRACT(MILLISECOND FROM v_end_time - v_start_time);

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '=== ERROR EN CARGA SILVER ===';
        RAISE NOTICE 'TRANSACCIÓN REVERTIDA AUTOMÁTICAMENTE';
        RAISE NOTICE 'ERROR: %', SQLERRM;
        RAISE; -- provoca rollback total del CALL
END;
$$;

call silver.sp_master_load_silver_layer();