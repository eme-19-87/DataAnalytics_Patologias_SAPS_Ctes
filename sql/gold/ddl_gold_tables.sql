CREATE SCHEMA IF NOT EXISTS gold;

/*
Dimensión con la información de los saps

saps_key: La clave subrrogada para los saps
id_saps: El id de los saps
saps: El nombre del saps
barrio: El barrio donde está ubicado el saps
ubicacion: Las calles donde está ubicado el saps
contacto_teléfono: El teléfono de contacto del saps
responsable: La persona responsable a cargo del saps
cargo: El cargo que ostenta la persona responsable
tiv: La fecha inicial desde la cual los datos de un registro son válidos.
tfv: La fecha final en la cual los datos de un registro dejaron de ser válidos.
*/
CREATE TABLE gold.dim_saps (
    saps_key            SERIAL PRIMARY KEY,
    id_saps             INT NOT NULL,
    saps                TEXT NOT NULL,
    barrio              TEXT NOT NULL,
    ubicacion           TEXT NOT NULL,
    contacto_telefono   TEXT NOT NULL,
    responsable         TEXT NOT NULL,
    cargo               TEXT NOT NULL,
    tiv                 DATE NOT NULL DEFAULT CURRENT_DATE,
    tfv                 DATE NOT NULL DEFAULT '9999-01-01'::DATE
);

/*
Tabla de dimensión con los datos de la patología

patologia_key: La clave subrrogada para la dimensión
patologia_cod: El código de la patología según el cie10
agrupacion_cie10: La descripción de la patología según cie10
patología_desc: Una descripción adicional de la patología usada en los saps
*/
CREATE TABLE gold.dim_patologia (
    patologia_key       BIGSERIAL PRIMARY KEY,
    patologia_cod       VARCHAR(8) NOT NULL,
    agrupacion_cie10    TEXT NOT NULL,
    patologia_desc      TEXT NOT NULL
);

/*
Tabla de dimensiones para los rangos etarios y sexo. Se emplea como una junk dimension

rango_etario_key: La clave subrogada de la dimensión
rango_etario: El rango etario
sexo: El sexo de la persona para el rango etario
*/
CREATE TABLE gold.dim_rango_etario (
    rango_etario_key    SERIAL PRIMARY KEY,
    id_rango_etario     INT NOT NULL,
    rango_etario        VARCHAR(18) NOT NULL,
    sexo                VARCHAR(12)
);

/*
La tabla de dimensión con los datos sobre el tipo de vacunas

vacuna_key: La clave subrogada de la tabla
tipo_vacuna: El nombre del tipo de vacuna
*/
CREATE TABLE gold.dim_vacuna (
    vacuna_key      SERIAL PRIMARY KEY,
    tipo_vacuna     TEXT NOT NULL
);

/*
La tabla con los datos de la dimensión calendario

calendario_key: La clave subrogada de la tabla
fecha: La fecha en cuestión
dia: El día de la fecha en cuestión.
mes: El mes en cuestión.
anio: El anio en cuestión.
nombre_dia: El nombre del día en cuestión
nombre_mes: El nombre del mes
dia_mes: La combinacion del dia y mes para la fecha en cuestión.
mes_anio: La combinación mes y año para la fecha en cuestión.
anio_mes: La combinación del año y mes para le fecha en cuestión.
semana_anio: Indica la semana del año que representa el fecha en cuestión.
trimestre: Indica el trimestre del año para la fecha en cuestión.
es_fin_semana: Indica si es fin de semana.

*/
CREATE TABLE gold.dim_calendario (
    calendario_key      INT PRIMARY KEY,
    fecha               DATE NOT NULL,

    dia                 INT NOT NULL,
    mes                 INT NOT NULL,
    anio                INT NOT NULL,

    nombre_dia          VARCHAR(10),
    nombre_mes          VARCHAR(10),

    dia_mes             VARCHAR(5),     -- ej: 15-08
    mes_anio            VARCHAR(7),     -- ej: 08-2023
    anio_mes            VARCHAR(7),     -- ej: 2023-08

    semana_anio         INT,
    trimestre           INT,

    es_fin_semana       BOOLEAN DEFAULT FALSE,
    es_fin_mes          BOOLEAN,
    es_fin_anio         BOOLEAN
);

/*
La tabla de hechos para las consultas

consulta_key: La clave subrogada para la tabla
saps_key: La clave subrogada del saps
patologia_key: La clave subrogada de la patología
calendario_key: La clave subrogada del calendario
rango_etario_key: La clave subrogada para el rango etario
consulta_cantidad: la cantidad de consultas realizadas
*/
CREATE TABLE gold.fact_consulta (
    consulta_key        BIGSERIAL PRIMARY KEY,

    saps_key            INT NOT NULL,
    patologia_key       BIGINT NOT NULL,
    calendario_key      INT NOT NULL,
    rango_etario_key    INT NOT NULL,

    consultas_cantidad  INT NOT NULL
);

/*
La tabla de hechos para las inmunizaciones

inmunizacion_key: La clave subrogada de la tabla de hechos

*/
CREATE TABLE gold.facts_inmunizacion (
    inmunizacion_key    BIGSERIAL PRIMARY KEY,

    saps_key            INT NOT NULL,
    calendario_key      INT NOT NULL,
    vacuna_key          INT NOT NULL,

    cantidad_vacuna     INT NOT NULL

);

