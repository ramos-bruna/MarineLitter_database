--- Which beach had the fishing items such as lures, traps, pots and fishing nets observed during surveys?

--- total items numer
--- PL17 = Fishing gear (lures, traps & pots)
--- PL20 = Fishing net

SELECT
    B.name AS beach_name,
    COALESCE(SUM(L.PL17), 0) + COALESCE(SUM(L.PL20), 0) AS total_fishing_items
FROM
    Beach B
JOIN
    LitterData L ON B.beach_id = L.beach_id
GROUP BY
    B.name
ORDER BY
    total_fishing_items DESC
LIMIT 3;


--- items per saquare meter

WITH FishingItems AS (
    SELECT
        L.beach_id,
        COALESCE(SUM(L.PL17), 0) + COALESCE(SUM(L.PL20), 0) AS total_fishing_items,
        COALESCE(SUM(L.area_m2), 0) AS total_area_m2
    FROM
        LitterData L
    GROUP BY
        L.beach_id
),
BeachInfo AS (
    SELECT
        B.beach_id,
        B.name AS beach_name,
        FI.total_fishing_items,
        FI.total_area_m2,
        CASE WHEN FI.total_area_m2 > 0 THEN FI.total_fishing_items / FI.total_area_m2 ELSE 0 END AS items_per_sqm
    FROM
        Beach B
    JOIN
        FishingItems FI ON B.beach_id = FI.beach_id
)
SELECT
    beach_name,
    total_fishing_items,
    total_area_m2,
    items_per_sqm
FROM
    BeachInfo
ORDER BY
    items_per_sqm DESC
LIMIT 3;
