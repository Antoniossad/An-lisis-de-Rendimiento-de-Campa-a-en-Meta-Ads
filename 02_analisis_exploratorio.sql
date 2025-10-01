-- ====================================================================
-- PROYECTO: ANÁLISIS DE CAMPAÑA DE MARKETING EN META ADS
-- ARCHIVO 2: ANÁLISIS EXPLORATORIO DE DATOS (EDA)
-- AUTOR: Sergio Antonio Alcántara Domínguez
-- FECHA: 30 de Septiembre de 2025
-- ====================================================================


-- ANÁLISIS 1: ¿Cuál es el rendimiento general de cada anuncio?
-- Objetivo: Identificar el anuncio más eficiente (menor costo) y el de mayor volumen (más resultados).
SELECT
    nombre_anuncio,
    SUM(resultados) AS resultados_totales,
    SUM(importe_gastado_mxn) AS inversion_total,
    SUM(importe_gastado_mxn) / SUM(resultados) AS costo_por_resultado_promedio
FROM
    campaign_demographics
WHERE
    resultados > 0
GROUP BY
    nombre_anuncio
ORDER BY
    costo_por_resultado_promedio ASC;


-- ANÁLISIS 2: ¿En qué ubicación (Feed, Reels, Stories) funciona mejor la campaña?
-- Objetivo: Determinar las ubicaciones más y menos rentables para la inversión publicitaria.
SELECT
    plataforma,
    ubicacion,
    SUM(resultados) AS resultados_totales,
    SUM(importe_gastado_mxn) AS inversion_total,
    SUM(importe_gastado_mxn) / SUM(resultados) AS costo_por_resultado_promedio
FROM
    campaign_placements
WHERE
    resultados > 0
GROUP BY
    plataforma, ubicacion
ORDER BY
    costo_por_resultado_promedio ASC;


-- ANÁLISIS 3A: ¿Qué anuncio funciona mejor para cada grupo de edad?
-- Objetivo: Segmentar el rendimiento de los anuncios por demografía para una segmentación avanzada.
SELECT
    edad,
    nombre_anuncio,
    SUM(resultados) AS resultados_totales,
    SUM(importe_gastado_mxn) / SUM(resultados) AS costo_por_resultado
FROM
    campaign_demographics
WHERE
    resultados > 0
GROUP BY
    edad, nombre_anuncio
ORDER BY
    edad, costo_por_resultado ASC;


-- ANÁLISIS 3B: ¿Qué anuncio funciona mejor en cada ubicación?
-- Objetivo: Cruzar el rendimiento del anuncio con la ubicación para obtener insights más granulares.
SELECT
    plataforma,
    ubicacion,
    nombre_anuncio,
    SUM(resultados) AS resultados_totales,
    SUM(importe_gastado_mxn) / SUM(resultados) AS costo_por_resultado
FROM
    campaign_placements
WHERE
    resultados > 0
GROUP BY
    plataforma, ubicacion, nombre_anuncio
ORDER BY
    plataforma, ubicacion, costo_por_resultado ASC;