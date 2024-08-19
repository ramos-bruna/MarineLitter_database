--- What are the data for beach wrack, food services presence, MPA presence, wind velocity and light fragments concentration for September 2022, for all beaches?

SELECT
    B.name AS beach_name,
    SD.survey_date,
    COALESCE(BL.wrack, FALSE) AS has_wrack,
    COALESCE(BL.food_service, FALSE) AS has_food_service,
    COALESCE(BL.mpa, FALSE) AS has_mpa,
    COALESCE(SUM(L.PL24_4), 0) / NULLIF(SUM(L.area_m2), 0) AS light_fragments_concentration,
    W.wind_int AS wind_intensity,
    W.wind_dir AS wind_direction
FROM
    Beach B
JOIN
    BeachLog BL ON B.beach_id = BL.beach_id
JOIN
    SurveyDetails SD ON BL.survey_id = SD.survey_id
LEFT JOIN
    LitterData L ON SD.survey_id = L.survey_id
LEFT JOIN
    WeatherData W ON SD.survey_id = W.survey_id
WHERE
    SD.survey_date BETWEEN '2022-09-01' AND '2022-09-30'
GROUP BY
    B.name, SD.survey_date, BL.wrack, BL.food_service, BL.mpa, W.wind_int, W.wind_dir
ORDER BY
    light_fragments_concentration DESC, B.name, SD.survey_date;

