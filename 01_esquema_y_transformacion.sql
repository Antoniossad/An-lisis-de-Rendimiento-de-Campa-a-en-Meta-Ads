-- ====================================================================
-- PROYECTO: ANÁLISIS DE CAMPAÑA DE MARKETING EN META ADS
-- ARCHIVO 1: ESQUEMA Y TRANSFORMACIÓN (ELT)
-- AUTOR: Sergio Antonio Alcántara Domínguez
-- FECHA: 30 de Septiembre de 2025
-- ====================================================================


-- =========== PASO A: CREACIÓN DEL ESQUEMA DE BASE DE DATOS ===========

-- Se eliminan todas las tablas si existen para asegurar un inicio limpio.
DROP TABLE IF EXISTS placements_staging;
DROP TABLE IF EXISTS demographics_staging;
DROP TABLE IF EXISTS campaign_placements;
DROP TABLE IF EXISTS campaign_demographics;


-- Creación de la tabla de staging para el archivo de ubicaciones (espejo del CSV crudo)
CREATE TABLE placements_staging (
    inicio_del_informe TEXT, fin_del_informe TEXT, nombre_del_anuncio TEXT, plataforma TEXT, ubicacion TEXT,
    plataforma_del_dispositivo TEXT, entrega_del_anuncio TEXT, resultados TEXT, indicador_de_resultado TEXT, coste_por_resultados TEXT,
    presupuesto_del_conjunto_de_anuncios TEXT, tipo_de_presupuesto_del_conjunto_de_anuncios TEXT, importe_gastado_mxn TEXT, impresiones TEXT, alcance TEXT,
    fin TEXT, configuracion_de_atribucion TEXT, puja TEXT, tipo_de_puja TEXT, ultimo_cambio_significativo TEXT,
    clasificacion_por_calidad TEXT, clasificacion_por_porcentaje_de_interaccion TEXT, clasificacion_por_tasa_de_conversion TEXT, nombre_del_conjunto_de_anuncios TEXT, actions_onsite_conversion_total_messaging_connection TEXT,
    contactos_de_mensajes_nuevos TEXT, compras TEXT, coste_por_compra_mxn TEXT, clics_en_el_enlace TEXT, ctr_porcentaje_de_clics_en_el_enlace TEXT,
    cpc_coste_por_clic_en_el_enlace_mxn TEXT
);


-- Creación de la tabla de staging para el archivo de demográficos (espejo del CSV crudo)
CREATE TABLE demographics_staging (
    inicio_del_informe TEXT, fin_del_informe TEXT, nombre_del_anuncio TEXT, edad TEXT, sexo TEXT,
    entrega_del_anuncio TEXT, resultados TEXT, indicador_de_resultado TEXT, coste_por_resultados TEXT, presupuesto_del_conjunto_de_anuncios TEXT,
    tipo_de_presupuesto_del_conjunto_de_anuncios TEXT, importe_gastado_mxn TEXT, impresiones TEXT, alcance TEXT, fin TEXT,
    configuracion_de_atribucion TEXT, puja TEXT, tipo_de_puja TEXT, ultimo_cambio_significativo TEXT, clasificacion_por_calidad TEXT,
    clasificacion_por_porcentaje_de_interaccion TEXT, clasificacion_por_tasa_de_conversion TEXT, nombre_del_conjunto_de_anuncios TEXT, actions_onsite_conversion_total_messaging_connection TEXT,
    contactos_de_mensajes_nuevos TEXT, compras TEXT, coste_por_compra_mxn TEXT, clics_en_el_enlace TEXT, ctr_porcentaje_de_clics_en_el_enlace TEXT,
    cpc_coste_por_clic_en_el_enlace_mxn TEXT
);


-- Creación de la tabla final y limpia para los datos de ubicación
CREATE TABLE campaign_placements (
    id SERIAL PRIMARY KEY, nombre_anuncio VARCHAR(255), plataforma VARCHAR(50), ubicacion VARCHAR(100),
    importe_gastado_mxn DECIMAL(10, 2), impresiones INT, resultados INT, costo_por_resultado_mxn DECIMAL(10, 2),
    clics_en_enlace INT, ctr_porcentaje DECIMAL(10, 4), cpc_mxn DECIMAL(10, 2)
);


-- Creación de la tabla final y limpia para los datos demográficos
CREATE TABLE campaign_demographics (
    id SERIAL PRIMARY KEY, nombre_anuncio VARCHAR(255), edad VARCHAR(50), sexo VARCHAR(50),
    importe_gastado_mxn DECIMAL(10, 2), impresiones INT, resultados INT, coste_por_resultados DECIMAL(10, 2),
    clics_en_enlace INT, ctr_porcentaje DECIMAL(10, 4), cpc_mxn DECIMAL(10, 2)
);


-- =========== PASO B: CARGA DE DATOS (LOAD) ===========
-- Este paso se realizó manualmente usando la herramienta de importación de pgAdmin.
-- 1. Se importó el CSV de ubicaciones a la tabla `placements_staging`.
-- 2. Se importó el CSV de demográficos a la tabla `demographics_staging`.


-- =========== PASO C: TRANSFORMACIÓN Y LIMPIEZA (TRANSFORM) ===========

-- Vaciamos las tablas limpias antes de llenarlas.
TRUNCATE TABLE campaign_placements, campaign_demographics RESTART IDENTITY;

-- Transformamos y movemos los datos desde el staging de ubicaciones a la tabla limpia final.
INSERT INTO campaign_placements (
    nombre_anuncio, plataforma, ubicacion, importe_gastado_mxn, impresiones, resultados,
    costo_por_resultado_mxn, clics_en_enlace, ctr_porcentaje, cpc_mxn
)
SELECT
    nombre_del_anuncio, plataforma, ubicacion,
    CAST(importe_gastado_mxn AS DECIMAL(10, 2)),
    CAST(impresiones AS INTEGER),
    CAST(NULLIF(resultados, '[null]') AS INTEGER),
    CAST(coste_por_resultados AS DECIMAL(10, 2)),
    CAST(clics_en_el_enlace AS INTEGER),
    CAST(ctr_porcentaje_de_clics_en_el_enlace AS DECIMAL(10, 4)),
    CAST(cpc_coste_por_clic_en_el_enlace_mxn AS DECIMAL(10, 2))
FROM
    placements_staging;


-- Transformamos y movemos los datos desde el staging de demográficos a la tabla limpia final.
INSERT INTO campaign_demographics (
    nombre_anuncio, edad, sexo, importe_gastado_mxn, impresiones, resultados,
    coste_por_resultados, clics_en_enlace, ctr_porcentaje, cpc_mxn
)
SELECT
    nombre_del_anuncio, edad, sexo,
    CAST(importe_gastado_mxn AS DECIMAL(10, 2)),
    CAST(impresiones AS INTEGER),
    CAST(NULLIF(resultados, '[null]') AS INTEGER),
    CAST(coste_por_resultados AS DECIMAL(10, 2)),
    CAST(clics_en_el_enlace AS INTEGER),
    CAST(ctr_porcentaje_de_clics_en_el_enlace AS DECIMAL(10, 4)),
    CAST(cpc_coste_por_clic_en_el_enlace_mxn AS DECIMAL(10, 2))
FROM
    demographics_staging;