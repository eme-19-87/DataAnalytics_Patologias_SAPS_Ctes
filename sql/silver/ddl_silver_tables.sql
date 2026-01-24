CREATE SCHEMA IF NOT EXISTS silver;

/*
Tabla con los datos de las consultas por patología. Obtenida de la tabla silver.datosctes_consultas_patologia
en la capa bronce

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

DROP TABLE IF EXISTS silver.datosctes_consultas_patologia;

create table silver.datosctes_consultas_patologia(
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
	
);

/*
Tabla con los datos de los saps. Obtenidos de la tabla silver.datosctes_saps

id_saps: El id que identifíca unívocamente al saps
saps: El nombre del saps
barrio: El nombre del barrio donde está ubicado el saps
ubicación: La calle o calles donde está ubicado el saps
contacto_telefono: El teléfono de contacto del saps
responsable: Nombre y apellido del responsable del saps
cargo: El cargo que ocupa el responsable del saps
tiv: Tiempo inicial válido (vit: valid initial time). Representa la fecha inicial en el cual el estado de 
los datos de un SAPS se toma como válido. Útil para indicar si hay algún cambio en el teléfono o 
en las autoridades.
tfv: Tiempo final válido (vft: valid final time). Representa la fecha final en la cual un estado de los datos
de un SAPS se deja de tomar como válido. Este tiempo toma un valor muy lejano en el futuro al principio,
y cambia cuando uno o más datos se modifican en la tabla. Así, los datos de un registro son válidos 
desde su tiv hasta su tfv. Por ejemplo, si un directivo empieza a ejercer sus funciones desde el 
día 01-01-2016, el registro tendrá tiv=2016/01/01, tfv=2999/01/01 (por ejemplo). Si deja de ejercer su 
función el 18/05/2027, el registro tendrá tiv=2016/01/01, vft=2027/05/18 y se crea un nuevo registro con 
todos los datos iguales, excepto por el nombre del nuevo director y tiv=2027/05/19, tfv=2999/01/01 (por ejemplo)
*/

DROP TABLE IF EXISTS silver.datosctes_saps;

create table silver.datosctes_saps(
	id_registro_saps bigserial primary key,
	id_saps int,
	saps text,
	barrio text,
	ubicacion text,
	contacto_telefono varchar(12),
	responsable text,
	cargo text,
    tiv date DEFAULT CURRENT_DATE,
    tfv date DEFAULT DATE '9999-12-31'
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

DROP TABLE IF EXISTS silver.datosctes_inmunizacion;
create table silver.datosctes_inmunizacion(
	id_inmunizacion bigserial primary key,
	id_saps int,
	saps text,
	fecha date,
	vacunas_tipo text,
	vacunas_cantidad int
);

--Comentarios para la tabla y columnas de patología

COMMENT ON TABLE silver.datosctes_consultas_patologia IS
'Datos de las consultas por patología, previa limpieza con Python – Fuente: Datos Abiertos Corrientes';

COMMENT ON COLUMN silver.datosctes_consultas_patologia.id_consulta
IS 'Identificador único autoincremental de la consulta';

COMMENT ON COLUMN silver.datosctes_consultas_patologia.id_saps
IS 'Identificador del SAPS donde se realizó la consulta';

COMMENT ON COLUMN silver.datosctes_consultas_patologia.saps
IS 'Nombre del SAPS donde se realizó la consulta';

COMMENT ON COLUMN silver.datosctes_consultas_patologia.fecha
IS 'Fecha en la que se realizó la consulta';

COMMENT ON COLUMN silver.datosctes_consultas_patologia.patologia_desc
IS 'Descripción textual de la patología por la cual se realizó la consulta';

COMMENT ON COLUMN silver.datosctes_consultas_patologia.agrupacion_cie10
IS 'Descripción de la patología según la clasificación CIE-10';

COMMENT ON COLUMN silver.datosctes_consultas_patologia.patologia_cod
IS 'Código CIE-10 asociado a la patología';

COMMENT ON COLUMN silver.datosctes_consultas_patologia.id_rango_etario
IS 'Identificador del rango etario del paciente';

COMMENT ON COLUMN silver.datosctes_consultas_patologia.consulta_cantidad
IS 'Cantidad de consultas registradas para la patología';

COMMENT ON COLUMN silver.datosctes_consultas_patologia.rango_etario
IS 'Descripción del rango etario del paciente';

COMMENT ON COLUMN silver.datosctes_consultas_patologia.sexo
IS 'Sexo del paciente (Femenino, Masculino, n/a)';

---Comentario para la tablas y columnas de los saps

COMMENT ON TABLE silver.datosctes_saps IS
'Datos de los SAPS, previa limpieza con Python – Fuente: Datos Abiertos Corrientes';

COMMENT ON COLUMN silver.datosctes_saps.id_saps
IS 'Identificador único del SAPS';

COMMENT ON COLUMN silver.datosctes_saps.saps
IS 'Nombre del Servicio de Atención Primaria de la Salud (SAPS)';

COMMENT ON COLUMN silver.datosctes_saps.barrio
IS 'Barrio donde se encuentra ubicado el SAPS';

COMMENT ON COLUMN silver.datosctes_saps.ubicacion
IS 'Dirección o ubicación física del SAPS';

COMMENT ON COLUMN silver.datosctes_saps.contacto_telefono
IS 'Número de teléfono de contacto del SAPS';

COMMENT ON COLUMN silver.datosctes_saps.responsable
IS 'Nombre y apellido del responsable del SAPS';

COMMENT ON COLUMN silver.datosctes_saps.cargo
IS 'Cargo que ocupa el responsable del SAPS';

COMMENT ON COLUMN silver.datosctes_saps.tiv
IS 'La fecha desde la cual los datos para el registro en cuestión son válidos';

COMMENT ON COLUMN silver.datosctes_saps.tfv
IS 'La fecha desde la cual los datos para el registro en cuestión dejan de ser válidos';
---Comentario de la tabla y columnas para las inmunizaciones

COMMENT ON TABLE silver.datosctes_inmunizacion IS
'Datos de las inmunizaciones realizadas, previa limpieza con Python – Fuente: Datos Abiertos Corrientes';

COMMENT ON COLUMN silver.datosctes_inmunizacion.id_inmunizacion
IS 'Identificador único autoincremental de la inmunización';

COMMENT ON COLUMN silver.datosctes_inmunizacion.id_saps
IS 'Identificador del SAPS donde se realizó la inmunización';

COMMENT ON COLUMN silver.datosctes_inmunizacion.saps
IS 'Nombre del SAPS donde se realizó la inmunización';

COMMENT ON COLUMN silver.datosctes_inmunizacion.fecha
IS 'Fecha en la que se realizó la inmunización';

COMMENT ON COLUMN silver.datosctes_inmunizacion.vacunas_tipo
IS 'Tipo de vacuna aplicada';

COMMENT ON COLUMN silver.datosctes_inmunizacion.vacunas_cantidad
IS 'Cantidad de dosis aplicadas del tipo de vacuna';