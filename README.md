
# Análisis de Rendimiento de Campaña en Meta Ads
### Identificación de Audiencias y Ubicaciones Rentables con SQL y Power BI

<img width="1268" height="704" alt="image" src="https://github.com/user-attachments/assets/4104384f-6559-4f0b-a7b2-eb578c8c1c4c" />
---

### Resumen del Proyecto

Este proyecto presenta un análisis de datos de punta a punta de una campaña real de marketing en Meta (Facebook e Instagram) para una empresa de limpieza de colchones. El objetivo es ir más allá de las métricas superficiales provistas por la plataforma para descubrir insights accionables que permitan optimizar el presupuesto publicitario, identificar los segmentos de audiencia más rentables y definir una estrategia de marketing data-driven para futuras campañas.

### El Problema de Negocio

La empresa invirtió en una campaña de Meta utilizando la función "Advantage+", permitiendo al algoritmo de Meta optimizar la distribución de 5 creativos de video diferentes. Si bien la campaña generó un volumen considerable de conversaciones de WhatsApp (leads), surgieron preguntas clave que la interfaz de Meta no respondía fácilmente:
* ¿Qué creativo de video fue realmente el más eficiente en términos de costo y volumen de leads?
* ¿En qué ubicaciones (Feed, Stories, Reels) fue más rentable invertir?
* ¿Qué segmentos demográficos (edad, sexo) respondieron mejor a cada anuncio?
* ¿Cómo podemos redefinir el "éxito" de un anuncio si el más "caro" es el que genera mayor volumen de oportunidades de venta?

### Metodología y Herramientas

* **Lenguaje:** `SQL (PostgreSQL)`
* **Base de Datos:** `PostgreSQL`
* **Interfaz de Base de Datos:** `pgAdmin`
* **Visualización de Datos:** `Power BI`
* **Lenguaje de Fórmulas:** `DAX`

El proceso siguió el robusto paradigma **ELT (Extract, Load, Transform)**:
1.  **Extract:** Se extrajeron dos CSVs desde Meta Ads, uno con desglose por ubicación y otro por demografía, debido a limitaciones de la plataforma.
2.  **Load:** Se diseñó un esquema en PostgreSQL con tablas de "staging" para cada CSV. Estas tablas se crearon con todas las columnas como tipo `TEXT` para asegurar una carga de datos crudos a prueba de errores.
3.  **Transform:** Se utilizaron scripts de SQL (`INSERT INTO ... SELECT ...`) para limpiar, seleccionar y transformar los datos desde las tablas de staging a las tablas finales de análisis. Las transformaciones clave incluyeron el uso de `CAST` para convertir tipos de datos y `NULLIF` para estandarizar valores nulos.

Posteriormente, en Power BI, se construyó un **Modelo Estrella** para relacionar los datos de demografía y ubicación, y se crearon **medidas en DAX** para los KPIs.

### Análisis y Hallazgos Clave

El análisis exploratorio de datos (EDA) reveló los siguientes insights:

* **Insight 1 (Rendimiento por Anuncio):** Se identificó un claro trade-off entre eficiencia y escala. El anuncio más eficiente en costo por resultado (`Test - 1`) no era el que generaba más volumen. El anuncio con mayor volumen (`Agosto Sofas Colchones`) era casi 6 veces más caro por lead.

* **Insight 2 (Rendimiento por Ubicación):** Contrario a la creencia popular, Instagram Reels fue la ubicación más cara e ineficiente ($140/lead). La "mina de oro" oculta fue la **Búsqueda de Facebook** ($4.55/lead), seguida por el **Feed de Instagram** ($19.76).

* **Insight 3 (Rendimiento por Demografía):** El análisis reveló que no existe un "mejor anuncio" único, sino un mejor anuncio para cada segmento de edad.
    * **35-44 años:** El segmento "punto dulce", con alto volumen y bajo costo, respondiendo mejor a los anuncios `Test 2 Mugre` y `Test Moho`.
    * **45-54 años:** Un segmento de alto riesgo para el anuncio principal, donde un solo lead llegó a costar más de $221.
    * **Mujeres:** Este segmento demostró ser significativamente más grande y más rentable que el masculino para esta campaña.

### Conclusión y Estrategia Recomendada

El análisis culmina en una estrategia de marketing segmentada y data-driven:

| Segmento Estratégico | Audiencia Clave | Anuncios Recomendados | Ubicaciones a Priorizar |
| :--- | :--- | :--- | :--- |
| **Crecimiento Eficiente** | 35-44 años | `Test 2 Mugre`, `Test Moho` | Feed de Instagram |
| **Volumen a Escala** | 25-34 y 65+ años | `Agosto Sofas Colchones` | Feed de Facebook (Excluir 45-54) |
| **Oportunidades de Nicho** | Abierta | `Test - Agosto Sofas Colchones` | Búsqueda de Facebook |

### Limitaciones y Próximos Pasos

La principal limitación es que el análisis se basa en "leads" y no en "ventas" reales. El próximo paso estratégico es implementar la **API de Conversiones de Meta (CAPI)**, integrando un CRM para enviar eventos de "Compra" offline de vuelta a Meta. Esto permitiría entrenar al algoritmo para que optimice por ingreso real (ROI) y no solo por leads.
