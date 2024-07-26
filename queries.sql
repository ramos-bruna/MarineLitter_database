SELECT
    B.name AS beach_name,
    AVG(W.wave_height) AS avg_wave_height
FROM Beach B
JOIN WeatherData W ON B.beach_id = W.beach_id
GROUP BY B.name
ORDER BY avg_wave_height DESC;


SELECT
    B.name AS beach_name,
    SUM(L.weight_g) AS total_weight_g
FROM Beach B
JOIN LitterData L ON B.beach_id = L.beach_id
GROUP BY B.name;

SELECT
    B.name AS beach_name,
    COALESCE(SUM(L.weight_g), 0) AS total_weight_g,
    COALESCE(AVG(W.wind_int), 0) AS avg_wind_intensity,
    BOOL_OR(BL.wrack) AS has_wrack, -- TRUE if any record has wrack, otherwise FALSE
    STRING_AGG(DISTINCT W.wind_dir, ', ') AS wind_directions
FROM Beach B
LEFT JOIN LitterData L ON B.beach_id = L.beach_id
LEFT JOIN WeatherData W ON B.beach_id = W.beach_id
LEFT JOIN BeachLog BL ON B.beach_id = BL.beach_id
GROUP BY B.name;



--- hard (PL24_3) and soft (PL24_4) average per square meter and wind

SELECT
    B.name AS beach_name,
    COALESCE(SUM(L.PL24_3) / NULLIF(SUM(L.area_m2), 0), 0) AS avg_PL24_3_per_m2,
    COALESCE(SUM(L.PL24_4) / NULLIF(SUM(L.area_m2), 0), 0) AS avg_PL24_4_per_m2,
    COALESCE(AVG(W.wind_int), 0) AS avg_wind_intensity,
    STRING_AGG(DISTINCT W.wind_dir, ', ') AS wind_directions
FROM Beach B
JOIN LitterData L ON B.beach_id = L.beach_id
JOIN WeatherData W ON L.survey_id = W.survey_id
GROUP BY B.name
ORDER BY (COALESCE(SUM(L.PL24_3) / NULLIF(SUM(L.area_m2), 0), 0) + COALESCE(SUM(L.PL24_4) / NULLIF(SUM(L.area_m2), 0), 0)) DESC;

---- foucus on the litter type
WITH LitterSummary AS (
    SELECT
        L.survey_id,
        'PL01' AS litter_type,
        COALESCE(SUM(L.PL01), 0) AS litter_quantity
    FROM LitterData L
    GROUP BY L.survey_id
    UNION ALL
    SELECT
        L.survey_id,
        'PL02' AS litter_type,
        COALESCE(SUM(L.PL02), 0) AS litter_quantity
    FROM LitterData L
    GROUP BY L.survey_id
    UNION ALL
    SELECT
        L.survey_id,
        'PL03' AS litter_type,
        COALESCE(SUM(L.PL03), 0) AS litter_quantity
    FROM LitterData L
    GROUP BY L.survey_id
    -- Add additional UNION ALL queries for other litter types as needed
),
LitterWeather AS (
    SELECT
        L.litter_type,
        W.wind_int AS wind_intensity,
        L.litter_quantity
    FROM LitterSummary L
    JOIN WeatherData W ON L.survey_id = W.survey_id
)
SELECT
    litter_type,
    AVG(wind_intensity) AS avg_wind_intensity,
    SUM(litter_quantity) AS total_litter
FROM LitterWeather
GROUP BY litter_type
ORDER BY total_litter DESC;


--- litter types and acess, toillet and food services
SELECT
    B.name AS beach_name,
    COALESCE(SUM(L.PL01), 0) AS total_PL01,
    COALESCE(SUM(L.PL02), 0) AS total_PL02,
    COALESCE(SUM(L.PL03), 0) AS total_PL03,
    AVG(BL.access::int) AS avg_access,
    AVG(BL.toilets_showers::int) AS avg_toilets_showers,
    AVG(BL.food_service::int) AS avg_food_service
FROM Beach B
JOIN LitterData L ON B.beach_id = L.beach_id
JOIN BeachLog BL ON B.beach_id = BL.beach_id
GROUP BY B.name
ORDER BY (COALESCE(SUM(L.PL01), 0) + COALESCE(SUM(L.PL02), 0) + COALESCE(SUM(L.PL03), 0)) DESC;


--- top 5 items per survey
WITH LitterDensity AS (
    SELECT
        survey_id,
        COALESCE(SUM(PL01), 0) / NULLIF(MAX(area_m2), 0) AS density_PL01,
        COALESCE(SUM(PL02), 0) / NULLIF(MAX(area_m2), 0) AS density_PL02,
        COALESCE(SUM(PL03), 0) / NULLIF(MAX(area_m2), 0) AS density_PL03,
        COALESCE(SUM(PL04), 0) / NULLIF(MAX(area_m2), 0) AS density_PL04,
        COALESCE(SUM(PL06), 0) / NULLIF(MAX(area_m2), 0) AS density_PL06,
        COALESCE(SUM(PL07), 0) / NULLIF(MAX(area_m2), 0) AS density_PL07,
        COALESCE(SUM(PL08), 0) / NULLIF(MAX(area_m2), 0) AS density_PL08,
        COALESCE(SUM(PL09), 0) / NULLIF(MAX(area_m2), 0) AS density_PL09,
        COALESCE(SUM(PL10), 0) / NULLIF(MAX(area_m2), 0) AS density_PL10,
        COALESCE(SUM(WD01), 0) / NULLIF(MAX(area_m2), 0) AS density_WD01,
        COALESCE(SUM(WD03), 0) / NULLIF(MAX(area_m2), 0) AS density_WD03,
        COALESCE(SUM(WD04), 0) / NULLIF(MAX(area_m2), 0) AS density_WD04,
        COALESCE(SUM(WD05), 0) / NULLIF(MAX(area_m2), 0) AS density_WD05
    FROM LitterData
    GROUP BY survey_id
),
RankedLitter AS (
    SELECT
        survey_id,
        'PL01' AS litter_type,
        density_PL01 AS density_per_sqm
    FROM LitterDensity
    UNION ALL
    SELECT
        survey_id,
        'PL02' AS litter_type,
        density_PL02 AS density_per_sqm
    FROM LitterDensity
    UNION ALL
    SELECT
        survey_id,
        'PL03' AS litter_type,
        density_PL03 AS density_per_sqm
    FROM LitterDensity
    UNION ALL
    SELECT
        survey_id,
        'PL04' AS litter_type,
        density_PL04 AS density_per_sqm
    FROM LitterDensity
    UNION ALL
    SELECT
        survey_id,
        'PL06' AS litter_type,
        density_PL06 AS density_per_sqm
    FROM LitterDensity
    UNION ALL
    SELECT
        survey_id,
        'PL07' AS litter_type,
        density_PL07 AS density_per_sqm
    FROM LitterDensity
    UNION ALL
    SELECT
        survey_id,
        'PL08' AS litter_type,
        density_PL08 AS density_per_sqm
    FROM LitterDensity
    UNION ALL
    SELECT
        survey_id,
        'PL09' AS litter_type,
        density_PL09 AS density_per_sqm
    FROM LitterDensity
    UNION ALL
    SELECT
        survey_id,
        'PL10' AS litter_type,
        density_PL10 AS density_per_sqm
    FROM LitterDensity
    UNION ALL
    SELECT
        survey_id,
        'WD01' AS litter_type,
        density_WD01 AS density_per_sqm
    FROM LitterDensity
    UNION ALL
    SELECT
        survey_id,
        'WD03' AS litter_type,
        density_WD03 AS density_per_sqm
    FROM LitterDensity
    UNION ALL
    SELECT
        survey_id,
        'WD04' AS litter_type,
        density_WD04 AS density_per_sqm
    FROM LitterDensity
    UNION ALL
    SELECT
        survey_id,
        'WD05' AS litter_type,
        density_WD05 AS density_per_sqm
    FROM LitterDensity
),
Ranked AS (
    SELECT
        survey_id,
        litter_type,
        density_per_sqm,
        ROW_NUMBER() OVER (PARTITION BY survey_id ORDER BY density_per_sqm DESC) AS rank
    FROM RankedLitter
)
SELECT
    survey_id,
    litter_type,
    density_per_sqm
FROM Ranked
WHERE rank <= 5
ORDER BY survey_id, rank;

        
---- top 5 items per beach
WITH LitterDensity AS (
    SELECT
        L.beach_id,
        COALESCE(SUM(L.PL01), 0) / NULLIF(MAX(L.area_m2), 0) AS density_PL01,
        COALESCE(SUM(L.PL02), 0) / NULLIF(MAX(L.area_m2), 0) AS density_PL02,
        COALESCE(SUM(L.PL03), 0) / NULLIF(MAX(L.area_m2), 0) AS density_PL03,
        COALESCE(SUM(L.PL04), 0) / NULLIF(MAX(L.area_m2), 0) AS density_PL04,
        COALESCE(SUM(L.PL06), 0) / NULLIF(MAX(L.area_m2), 0) AS density_PL06,
        COALESCE(SUM(L.PL07), 0) / NULLIF(MAX(L.area_m2), 0) AS density_PL07,
        COALESCE(SUM(L.PL08), 0) / NULLIF(MAX(L.area_m2), 0) AS density_PL08,
        COALESCE(SUM(L.PL09), 0) / NULLIF(MAX(L.area_m2), 0) AS density_PL09,
        COALESCE(SUM(L.PL10), 0) / NULLIF(MAX(L.area_m2), 0) AS density_PL10,
        COALESCE(SUM(L.WD01), 0) / NULLIF(MAX(L.area_m2), 0) AS density_WD01,
        COALESCE(SUM(L.WD03), 0) / NULLIF(MAX(L.area_m2), 0) AS density_WD03,
        COALESCE(SUM(L.WD04), 0) / NULLIF(MAX(L.area_m2), 0) AS density_WD04,
        COALESCE(SUM(L.WD05), 0) / NULLIF(MAX(L.area_m2), 0) AS density_WD05
    FROM LitterData L
    GROUP BY L.beach_id
),
RankedLitter AS (
    SELECT
        L.beach_id,
        'PL01' AS litter_type,
        L.density_PL01 AS density_per_sqm
    FROM LitterDensity L
    UNION ALL
    SELECT
        L.beach_id,
        'PL02' AS litter_type,
        L.density_PL02 AS density_per_sqm
    FROM LitterDensity L
    UNION ALL
    SELECT
        L.beach_id,
        'PL03' AS litter_type,
        L.density_PL03 AS density_per_sqm
    FROM LitterDensity L
    UNION ALL
    SELECT
        L.beach_id,
        'PL04' AS litter_type,
        L.density_PL04 AS density_per_sqm
    FROM LitterDensity L
    UNION ALL
    SELECT
        L.beach_id,
        'PL06' AS litter_type,
        L.density_PL06 AS density_per_sqm
    FROM LitterDensity L
    UNION ALL
    SELECT
        L.beach_id,
        'PL07' AS litter_type,
        L.density_PL07 AS density_per_sqm
    FROM LitterDensity L
    UNION ALL
    SELECT
        L.beach_id,
        'PL08' AS litter_type,
        L.density_PL08 AS density_per_sqm
    FROM LitterDensity L
    UNION ALL
    SELECT
        L.beach_id,
        'PL09' AS litter_type,
        L.density_PL09 AS density_per_sqm
    FROM LitterDensity L
    UNION ALL
    SELECT
        L.beach_id,
        'PL10' AS litter_type,
        L.density_PL10 AS density_per_sqm
    FROM LitterDensity L
    UNION ALL
    SELECT
        L.beach_id,
        'WD01' AS litter_type,
        L.density_WD01 AS density_per_sqm
    FROM LitterDensity L
    UNION ALL
    SELECT
        L.beach_id,
        'WD03' AS litter_type,
        L.density_WD03 AS density_per_sqm
    FROM LitterDensity L
    UNION ALL
    SELECT
        L.beach_id,
        'WD04' AS litter_type,
        L.density_WD04 AS density_per_sqm
    FROM LitterDensity L
    UNION ALL
    SELECT
        L.beach_id,
        'WD05' AS litter_type,
        L.density_WD05 AS density_per_sqm
    FROM LitterDensity L
),
Ranked AS (
    SELECT
        R.beach_id,
        R.litter_type,
        R.density_per_sqm,
        ROW_NUMBER() OVER (PARTITION BY R.beach_id ORDER BY R.density_per_sqm DESC) AS rank
    FROM RankedLitter R
)
SELECT
    R.beach_id,
    R.litter_type,
    R.density_per_sqm
FROM Ranked R
WHERE R.rank <= 5
ORDER BY R.beach_id, R.rank;

-- plastic bags and wrack

SELECT
    B.name AS beach_name,
    SD.survey_date,
    COALESCE(SUM(L.PL06), 0) AS pl06_count,
    COALESCE(bool_or(BL.wrack), FALSE) AS has_wrack
FROM
    LitterData L
JOIN
    SurveyDetails SD ON L.survey_id = SD.survey_id
JOIN
    Beach B ON SD.beach_id = B.beach_id
JOIN
    BeachLog BL ON SD.survey_id = BL.survey_id AND B.beach_id = BL.beach_id
GROUP BY
    B.name,
    SD.survey_date
ORDER BY
    B.name,
    SD.survey_date;

