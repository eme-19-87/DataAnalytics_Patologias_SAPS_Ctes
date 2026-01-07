/*
===============================================================================
Stored Procedure: sp_load_data(Source -> Bronze)
===============================================================================
Propósito del script:
	Este procedimiento almacenado carga en el esquema 'bronze' desde archivo CSV
	externos.
	Realiza las siguientes acciones:
	-Aplica TRUNCATE a las tablas en la capa 'bronze' que fueron cargadas previamente.
	-Mediante el comando COPY FROM carga los datos desde archivos CSV externos a las tablas
	en la capa 'bronze'.
  

Parametros:
    Ninguno. 

Retorno
	Ninguno

Ejemplo de uso:
    CALL bronze.sp_load_data();
===============================================================================
*/
CREATE OR REPLACE PROCEDURE bronze.sp_load_data()
LANGUAGE plpgsql
AS $$
DECLARE
    start_total TIMESTAMP;
    start_truncate TIMESTAMP;
    start_copy TIMESTAMP;
    end_copy TIMESTAMP;
    total_duration INTERVAL;
    truncate_duration INTERVAL;
    copy_duration INTERVAL;
    load_duration INTERVAL;
    record_count INTEGER;
BEGIN
    -- Inicio medición tiempo total
    start_total := clock_timestamp();
    RAISE NOTICE '🚀 INICIANDO CARGA DE DATOS - %', start_total;
    
    -- Bloque TRY-CATCH
    BEGIN
        -- Fase 1: TRUNCATE para olist_customers
        start_truncate := clock_timestamp();
        RAISE NOTICE '🗑️  Ejecutando TRUNCATE...';
        
        TRUNCATE TABLE bronze.datosctes_consultas_patologia;
        
        truncate_duration := clock_timestamp() - start_truncate;
        RAISE NOTICE '✅ TRUNCATE completado en: %', truncate_duration;
        
        -- Fase 2: COPY para olist_customers
        start_copy := clock_timestamp();
        RAISE NOTICE '📥 Ejecutando COPY desde CSV...';
        
        COPY bronze.datosctes_consultas_patologia(
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
 FROM '/import_data/ctes_consultas/consultas_por_patologia_limpio.csv' 
        DELIMITER E',' 
        CSV HEADER;
        
        end_copy := clock_timestamp();
        copy_duration := end_copy - start_copy;
        
        
        -- Cálculos finales de tiempos para olist_customers
        total_duration := end_copy - start_total;
        load_duration := end_copy - start_truncate;  -- truncate + copy
        
        -- REPORTE FINAL
        RAISE NOTICE '========================================';
        RAISE NOTICE '🎉 CARGA COMPLETADA EXITOSAMENTE PARA para bronze.datosctes_consultas_patologia';
        RAISE NOTICE '========================================';
        RAISE NOTICE '📊 ESTADÍSTICAS:';
        RAISE NOTICE '   Registros cargados: %', record_count;
        RAISE NOTICE '⏱️  TIEMPOS:';
        RAISE NOTICE '   • TRUNCATE: %', truncate_duration;
        RAISE NOTICE '   • COPY: %', copy_duration;
        RAISE NOTICE '   • CARGA TOTAL (truncate + copy): %', load_duration;
        RAISE NOTICE '   • TRANSACCIÓN COMPLETA: %', total_duration;
        RAISE NOTICE '========================================';

		 -- Fase 1: TRUNCATE para olist_geolocation
        start_truncate := clock_timestamp();
        RAISE NOTICE '🗑️  Ejecutando TRUNCATE...';
        
        TRUNCATE TABLE bronze.datosctes_saps;
        
        truncate_duration := clock_timestamp() - start_truncate;
        RAISE NOTICE '✅ TRUNCATE completado en: %', truncate_duration;
        
        -- Fase 2: COPY para olist_geolocation
        start_copy := clock_timestamp();
        RAISE NOTICE '📥 Ejecutando COPY desde CSV...';
        
        COPY bronze.datosctes_saps FROM '/import_data/ctes_consultas/listado_saps_limpio.csv' 
        DELIMITER E',' 
        CSV HEADER;
        
        end_copy := clock_timestamp();
        copy_duration := end_copy - start_copy;
        
        
        -- Cálculos finales de tiempos
        total_duration := end_copy - start_total;
        load_duration := end_copy - start_truncate;  -- truncate + copy
        
        -- REPORTE FINAL
        RAISE NOTICE '========================================';
        RAISE NOTICE '🎉 CARGA COMPLETADA EXITOSAMENTE para bronze.datosctes_saps';
        RAISE NOTICE '========================================';
        RAISE NOTICE '📊 ESTADÍSTICAS:';
        RAISE NOTICE '   Registros cargados: %', record_count;
        RAISE NOTICE '⏱️  TIEMPOS:';
        RAISE NOTICE '   • TRUNCATE: %', truncate_duration;
        RAISE NOTICE '   • COPY: %', copy_duration;
        RAISE NOTICE '   • CARGA TOTAL (truncate + copy): %', load_duration;
        RAISE NOTICE '   • TRANSACCIÓN COMPLETA: %', total_duration;
        RAISE NOTICE '========================================';

		 -- Fase 1: TRUNCATE para olist_order_items
        start_truncate := clock_timestamp();
        RAISE NOTICE '🗑️  Ejecutando TRUNCATE...';
        
        TRUNCATE TABLE bronze.datosctes_inmunizacion;
        
        truncate_duration := clock_timestamp() - start_truncate;
        RAISE NOTICE '✅ TRUNCATE completado en: %', truncate_duration;
        
        -- Fase 2: COPY para olist_order_items
        start_copy := clock_timestamp();
        RAISE NOTICE '📥 Ejecutando COPY desde CSV...';
        
        COPY bronze.datosctes_inmunizacion(id_saps,saps,fecha,vacunas_tipo,vacunas_cantidad) 
		FROM '/import_data/ctes_consultas/inmunizaciones_limpio.csv'  
        DELIMITER E',' 
        CSV HEADER;
        
        end_copy := clock_timestamp();
        copy_duration := end_copy - start_copy;
    
        
        -- Cálculos finales de tiempos
        total_duration := end_copy - start_total;
        load_duration := end_copy - start_truncate;  -- truncate + copy
        
        -- REPORTE FINAL
        RAISE NOTICE '========================================';
        RAISE NOTICE '🎉 CARGA COMPLETADA EXITOSAMENTE para bronze.datosctes_saps';
        RAISE NOTICE '========================================';
        RAISE NOTICE '📊 ESTADÍSTICAS:';
        RAISE NOTICE '   Registros cargados: %', record_count;
        RAISE NOTICE '⏱️  TIEMPOS:';
        RAISE NOTICE '   • TRUNCATE: %', truncate_duration;
        RAISE NOTICE '   • COPY: %', copy_duration;
        RAISE NOTICE '   • CARGA TOTAL (truncate + copy): %', load_duration;
        RAISE NOTICE '   • TRANSACCIÓN COMPLETA: %', total_duration;
        RAISE NOTICE '========================================';
        
    EXCEPTION
        WHEN OTHERS THEN
            -- En caso de error, mostrar tiempos hasta el fallo
            DECLARE
                error_time TIMESTAMP := clock_timestamp();
            BEGIN
                RAISE NOTICE '========================================';
                RAISE NOTICE '❌ ERROR DURANTE LA CARGA';
                RAISE NOTICE '========================================';
                RAISE NOTICE 'Mensaje de error: %', SQLERRM;
                RAISE NOTICE 'Tiempo transcurrido: %', (error_time - start_total);
                RAISE NOTICE '========================================';
                RAISE;
            END;
    END;
END $$;