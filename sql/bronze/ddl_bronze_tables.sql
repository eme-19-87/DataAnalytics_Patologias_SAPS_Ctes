CREATE SCHEMA IF NOT EXISTS bronze;

/*
Tabla con los datos de las consultas por patología. Obtenida de los datos abiertos de Corrientes, Capital
Argentina

id_consulta: El id que identifica unívocamente a cada consulta
id_saps: El id que identifica al SAPS (entidad de asistencia primaria para la salud) donde se realizó la consulta
fecha: La fecha en la que se realizó la consulta. En caso de no poseer, tendrá la fecha 1900-01-01
patologia_desc: Descripción de la patología por la cual se consulta. En caso de no poseer, tendrá el valor 'n/a'
agrupacion_cie10: La descripción para la patología tratada según el código cie10. En caso de no poseer, tendrá el valor 'n/a'
patologia_cod: Código cie10 con el cual se clasifica a la patología. En caso de no poseer, tendrá el valor 'n/a'
id_rango_etario: Id que identifica al rango etario. En caso de no estar definido, tendrá el valor -1
rango_etario: El rango etario al cual pertenece el paciente. En caso de no poseer, tendrá el valor 'n/a'
sexo: El sexo del paciente. Podrá ser 'Femenino', 'Masculino', 'n/a' en caso de faltar el dato
*/

/*DROP TABLE IF EXISTS bronze.datosctes_consultas_patologia;

create table bronze.datosctes_consultas_patologia(
	id_consulta bigserial primary key,
	id_saps int,
	saps text,
	fecha date,
	patologia_desc text,
	agrupacion_cie10 text,
	patologia_cod varchar(8),
	id_rango_etario int,
	consulta_cantidad int,
	rango_etario varchar(15),
	sexo varchar(9)
	
);*/

DROP TABLE IF EXISTS bronze.datosctes_consultas_patologia;

CREATE TABLE bronze.datosctes_consultas_patologia (
    id_saps               TEXT,
    saps                  TEXT,
    fecha                 TEXT,
    mes                   INTEGER,
    anio                  INTEGER,
    patologia_desc        TEXT,
    agrupacion_cie10      TEXT,
    patologia_cod         TEXT,
    id_rango_etario       TEXT,
    id_sexo               DOUBLE PRECISION,
    consulta_cantidad     TEXT,
    rango_etario          TEXT,
    sexo                  TEXT,
    barrio_del_operativo  TEXT,
    unnamed_14             DOUBLE PRECISION,
    unnamed_15             DOUBLE PRECISION,
    unnamed_16             DOUBLE PRECISION,
    unnamed_17             DOUBLE PRECISION,
    unnamed_18             DOUBLE PRECISION,
    unnamed_19             DOUBLE PRECISION,
    unnamed_20             DOUBLE PRECISION,
    unnamed_21             DOUBLE PRECISION,
    unnamed_22             DOUBLE PRECISION,
    unnamed_23             DOUBLE PRECISION,
    unnamed_24             DOUBLE PRECISION,
    unnamed_25             DOUBLE PRECISION,
    unnamed_26             DOUBLE PRECISION,
    unnamed_27             DOUBLE PRECISION,
    unnamed_28             DOUBLE PRECISION,
    unnamed_29             DOUBLE PRECISION,
    unnamed_30             DOUBLE PRECISION,
    unnamed_31             TEXT
);


/*
Tabla con los datos de los saps

id_saps: El id que identifíca unívocamente al saps
saps: El nombre del saps
barrio: El nombre del barrio donde está ubicado el saps
ubicación: La calle o calles donde está ubicado el saps
contacto_telefono: El teléfono de contacto del saps
responsable: Nombre y apellido del responsable del saps
cargo: El cargo que ocupa el responsable del saps
*/

DROP TABLE IF EXISTS bronze.datosctes_saps;

create table bronze.datosctes_saps(
	saps text,
	barrio text,
	ubicacion text,
	contacto_telefono TEXT,
	responsable text,
	cargo text
);

/*
Tabla con los datos de inmunizaciones

id_inmunizacion: Id que identifíca unívocamente a cada inmunización
id_saps: El id del saps donde se realizó la inmunización
saps: El nombre del saps
fecha: La fecha cuando se realizó la inmunización
vacunas_tipo: El tipo de vacuna aplicada
vacunas_cantidad: La cantidad de vacunas aplicadas de ese tipo
*/

/*DROP TABLE IF EXISTS bronze.datosctes_inmunizacion;
create table bronze.datosctes_inmunizacion(
	id_inmunizacion bigserial primary key,
	id_saps int,
	saps text,
	fecha date,
	vacunas_tipo text,
	vacunas_cantidad int
);*/

DROP TABLE IF EXISTS bronze.datosctes_inmunizacion;

CREATE TABLE bronze.datosctes_inmunizacion(
    id_saps               TEXT,
    saps                  TEXT,
    fecha                 TEXT,
    mes                   TEXT,
    anio                  TEXT,
    vacunas_tipo          TEXT,
    vacunas_cantidad      TEXT,
    barrio_del_operativo  TEXT,
	aviso_operativo_territorial TEXT,
    unnamed_9             TEXT,
    unnamed_10            DOUBLE PRECISION,
    unnamed_11            DOUBLE PRECISION,
    unnamed_12            DOUBLE PRECISION,
    unnamed_13            DOUBLE PRECISION,
    unnamed_14            DOUBLE PRECISION,
    unnamed_15            DOUBLE PRECISION,
    unnamed_16            DOUBLE PRECISION,
    unnamed_17            DOUBLE PRECISION,
    unnamed_18            DOUBLE PRECISION,
    unnamed_19            DOUBLE PRECISION,
    unnamed_20            DOUBLE PRECISION,
    unnamed_21            DOUBLE PRECISION,
    unnamed_22            DOUBLE PRECISION,
    unnamed_23            DOUBLE PRECISION,
    unnamed_24            DOUBLE PRECISION,
    unnamed_25            TEXT
);

DROP TABLE IF EXISTS bronze.datosctes_cie10;

create table bronze.datosctes_cie10(
	id_patologia VARCHAR(6),
	tipo_patologia text,
	descripcion text
);

--Comentarios para la tabla y columnas de patología

COMMENT ON TABLE bronze.datosctes_consultas_patologia IS
'Datos de las consultas por patología, previa limpieza con Python – Fuente: Datos Abiertos Corrientes';

COMMENT ON COLUMN bronze.datosctes_consultas_patologia.id_saps
IS 'Identificador del SAPS donde se realizó la consulta';

COMMENT ON COLUMN bronze.datosctes_consultas_patologia.saps
IS 'Nombre del SAPS donde se realizó la consulta';

COMMENT ON COLUMN bronze.datosctes_consultas_patologia.fecha
IS 'Fecha en la que se realizó la consulta';

COMMENT ON COLUMN bronze.datosctes_consultas_patologia.patologia_desc
IS 'Descripción textual de la patología por la cual se realizó la consulta';

COMMENT ON COLUMN bronze.datosctes_consultas_patologia.agrupacion_cie10
IS 'Descripción de la patología según la clasificación CIE-10';

COMMENT ON COLUMN bronze.datosctes_consultas_patologia.patologia_cod
IS 'Código CIE-10 asociado a la patología';

COMMENT ON COLUMN bronze.datosctes_consultas_patologia.id_rango_etario
IS 'Identificador del rango etario del paciente';

COMMENT ON COLUMN bronze.datosctes_consultas_patologia.consulta_cantidad
IS 'Cantidad de consultas registradas para la patología';

COMMENT ON COLUMN bronze.datosctes_consultas_patologia.rango_etario
IS 'Descripción del rango etario del paciente';

COMMENT ON COLUMN bronze.datosctes_consultas_patologia.sexo
IS 'Sexo del paciente (Femenino, Masculino, n/a)';

---Comentario para la tablas y columnas de los saps

COMMENT ON TABLE bronze.datosctes_saps IS
'Datos de los SAPS, previa limpieza con Python – Fuente: Datos Abiertos Corrientes';


COMMENT ON COLUMN bronze.datosctes_saps.saps
IS 'Nombre del Servicio de Atención Primaria de la Salud (SAPS)';

COMMENT ON COLUMN bronze.datosctes_saps.barrio
IS 'Barrio donde se encuentra ubicado el SAPS';

COMMENT ON COLUMN bronze.datosctes_saps.ubicacion
IS 'Dirección o ubicación física del SAPS';

COMMENT ON COLUMN bronze.datosctes_saps.contacto_telefono
IS 'Número de teléfono de contacto del SAPS';

COMMENT ON COLUMN bronze.datosctes_saps.responsable
IS 'Nombre y apellido del responsable del SAPS';

COMMENT ON COLUMN bronze.datosctes_saps.cargo
IS 'Cargo que ocupa el responsable del SAPS';

---Comentario de la tabla y columnas para las inmunizaciones

COMMENT ON TABLE bronze.datosctes_inmunizacion IS
'Datos de las inmunizaciones realizadas, previa limpieza con Python – Fuente: Datos Abiertos Corrientes';

COMMENT ON COLUMN bronze.datosctes_inmunizacion.id_saps
IS 'Identificador del SAPS donde se realizó la inmunización';

COMMENT ON COLUMN bronze.datosctes_inmunizacion.saps
IS 'Nombre del SAPS donde se realizó la inmunización';

COMMENT ON COLUMN bronze.datosctes_inmunizacion.fecha
IS 'Fecha en la que se realizó la inmunización';

COMMENT ON COLUMN bronze.datosctes_inmunizacion.vacunas_tipo
IS 'Tipo de vacuna aplicada';

COMMENT ON COLUMN bronze.datosctes_inmunizacion.vacunas_cantidad
IS 'Cantidad de dosis aplicadas del tipo de vacuna';