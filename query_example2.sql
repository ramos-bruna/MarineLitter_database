--- Query to Find Weather Conditions for the Highest Litter Concentration Per Square Meter

WITH LitterConcentration AS (
    SELECT
        L.beach_id,
        L.survey_id,
        S.survey_date,
        COALESCE(SUM(L.CL01), 0) +
        COALESCE(SUM(L.CL05), 0) +
        COALESCE(SUM(L.CL06), 0) +
        COALESCE(SUM(L.FP02), 0) +
        COALESCE(SUM(L.FP03), 0) +
        COALESCE(SUM(L.FP04), 0) +
        COALESCE(SUM(L.FP05), 0) +
        COALESCE(SUM(L.GC01), 0) +
        COALESCE(SUM(L.GC02), 0) +
        COALESCE(SUM(L.GC07), 0) +
        COALESCE(SUM(L.GC08), 0) +
        COALESCE(SUM(L.ME01), 0) +
        COALESCE(SUM(L.ME02), 0) +
        COALESCE(SUM(L.ME03), 0) +
        COALESCE(SUM(L.ME06), 0) +
        COALESCE(SUM(L.ME07), 0) +
        COALESCE(SUM(L.ME08), 0) +
        COALESCE(SUM(L.ME09), 0) +
        COALESCE(SUM(L.OT01), 0) +
        COALESCE(SUM(L.OT02), 0) +
        COALESCE(SUM(L.OT04), 0) +
        COALESCE(SUM(L.OT05_1), 0) +
        COALESCE(SUM(L.OT05_2), 0) +
        COALESCE(SUM(L.OT05_3), 0) +
        COALESCE(SUM(L.PC01), 0) +
        COALESCE(SUM(L.PC03), 0) +
        COALESCE(SUM(L.PC05), 0) +
        COALESCE(SUM(L.PL01), 0) +
        COALESCE(SUM(L.PL02), 0) +
        COALESCE(SUM(L.PL02_1), 0) +
        COALESCE(SUM(L.PL03), 0) +
        COALESCE(SUM(L.PL04), 0) +
        COALESCE(SUM(L.PL06), 0) +
        COALESCE(SUM(L.PL07), 0) +
        COALESCE(SUM(L.PL08), 0) +
        COALESCE(SUM(L.PL09), 0) +
        COALESCE(SUM(L.PL10), 0) +
        COALESCE(SUM(L.PL11), 0) +
        COALESCE(SUM(L.PL12), 0) +
        COALESCE(SUM(L.PL15), 0) +
        COALESCE(SUM(L.PL17), 0) +
        COALESCE(SUM(L.PL18), 0) +
        COALESCE(SUM(L.PL19), 0) +
        COALESCE(SUM(L.PL20), 0) +
        COALESCE(SUM(L.PL21), 0) +
        COALESCE(SUM(L.PL22), 0) +
        COALESCE(SUM(L.PL24), 0) +
        COALESCE(SUM(L.PL24_1), 0) +
        COALESCE(SUM(L.PL24_2), 0) +
        COALESCE(SUM(L.PL24_3), 0) +
        COALESCE(SUM(L.PL24_4), 0) +
        COALESCE(SUM(L.PL24_6), 0) +
        COALESCE(SUM(L.PL24_7), 0) +
        COALESCE(SUM(L.PL25), 0) +
        COALESCE(SUM(L.RB01), 0) +
        COALESCE(SUM(L.RB02), 0) +
        COALESCE(SUM(L.RB04), 0) +
        COALESCE(SUM(L.RB06), 0) +
        COALESCE(SUM(L.RB07), 0) +
        COALESCE(SUM(L.RB08), 0) +
        COALESCE(SUM(L.WD01), 0) +
        COALESCE(SUM(L.WD03), 0) +
        COALESCE(SUM(L.WD04), 0) +
        COALESCE(SUM(L.WD05), 0) AS total_litter,
        COALESCE(SUM(L.area_m2), 0) AS total_area_m2,
        CASE WHEN COALESCE(SUM(L.area_m2), 0) > 0 THEN
            (COALESCE(SUM(L.CL01), 0) +
            COALESCE(SUM(L.CL05), 0) +
            COALESCE(SUM(L.CL06), 0) +
            COALESCE(SUM(L.FP02), 0) +
            COALESCE(SUM(L.FP03), 0) +
            COALESCE(SUM(L.FP04), 0) +
            COALESCE(SUM(L.FP05), 0) +
            COALESCE(SUM(L.GC01), 0) +
            COALESCE(SUM(L.GC02), 0) +
            COALESCE(SUM(L.GC07), 0) +
            COALESCE(SUM(L.GC08), 0) +
            COALESCE(SUM(L.ME01), 0) +
            COALESCE(SUM(L.ME02), 0) +
            COALESCE(SUM(L.ME03), 0) +
            COALESCE(SUM(L.ME06), 0) +
            COALESCE(SUM(L.ME07), 0) +
            COALESCE(SUM(L.ME08), 0) +
            COALESCE(SUM(L.ME09), 0) +
            COALESCE(SUM(L.OT01), 0) +
            COALESCE(SUM(L.OT02), 0) +
            COALESCE(SUM(L.OT04), 0) +
            COALESCE(SUM(L.OT05_1), 0) +
            COALESCE(SUM(L.OT05_2), 0) +
            COALESCE(SUM(L.OT05_3), 0) +
            COALESCE(SUM(L.PC01), 0) +
            COALESCE(SUM(L.PC03), 0) +
            COALESCE(SUM(L.PC05), 0) +
            COALESCE(SUM(L.PL01), 0) +
            COALESCE(SUM(L.PL02), 0) +
            COALESCE(SUM(L.PL02_1), 0) +
            COALESCE(SUM(L.PL03), 0) +
            COALESCE(SUM(L.PL04), 0) +
            COALESCE(SUM(L.PL06), 0) +
            COALESCE(SUM(L.PL07), 0) +
            COALESCE(SUM(L.PL08), 0) +
            COALESCE(SUM(L.PL09), 0) +
            COALESCE(SUM(L.PL10), 0) +
            COALESCE(SUM(L.PL11), 0) +
            COALESCE(SUM(L.PL12), 0) +
            COALESCE(SUM(L.PL15), 0) +
            COALESCE(SUM(L.PL17), 0) +
            COALESCE(SUM(L.PL18), 0) +
            COALESCE(SUM(L.PL19), 0) +
            COALESCE(SUM(L.PL20), 0) +
            COALESCE(SUM(L.PL21), 0) +
            COALESCE(SUM(L.PL22), 0) +
            COALESCE(SUM(L.PL24), 0) +
            COALESCE(SUM(L.PL24_1), 0) +
            COALESCE(SUM(L.PL24_2), 0) +
            COALESCE(SUM(L.PL24_3), 0) +
            COALESCE(SUM(L.PL24_4), 0) +
            COALESCE(SUM(L.PL24_6), 0) +
            COALESCE(SUM(L.PL24_7), 0) +
            COALESCE(SUM(L.PL25), 0) +
            COALESCE(SUM(L.RB01), 0) +
            COALESCE(SUM(L.RB02), 0) +
            COALESCE(SUM(L.RB04), 0) +
            COALESCE(SUM(L.RB06), 0) +
            COALESCE(SUM(L.RB07), 0) +
            COALESCE(SUM(L.RB08), 0) +
            COALESCE(SUM(L.WD01), 0) +
            COALESCE(SUM(L.WD03), 0) +
            COALESCE(SUM(L.WD04), 0) +
            COALESCE(SUM(L.WD05), 0)) / COALESCE(SUM(L.area_m2), 0)
        ELSE 0
        END AS litter_per_sqm
    FROM
        LitterData L
    JOIN
        SurveyDetails S ON L.survey_id = S.survey_id
    GROUP BY
        L.survey_id, L.beach_id, S.survey_date
),
MaxLitterSurvey AS (
    SELECT
        LC.survey_id,
        LC.beach_id,
        LC.survey_date,
        LC.litter_per_sqm
    FROM
        LitterConcentration LC
    ORDER BY
        LC.litter_per_sqm DESC
    LIMIT 1
)
SELECT
    LC.beach_id,
    LC.survey_date,
    LC.litter_per_sqm,
    W.wind_dir,
    W.wind_int,
    W.wave_height,
    W.wave_dir,
    W.wave_period
FROM
    MaxLitterSurvey LC
JOIN
    WeatherData W ON LC.survey_id = W.survey_id;


