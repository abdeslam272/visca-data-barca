WITH raw_data AS (
  SELECT *
  FROM {{ ref('stats_2024') }}
),

with_indexed AS (
  SELECT 
    *,
    row_number() OVER () AS row_num
  FROM raw_data
),

situations AS (
  SELECT
    row_num,
    CASE row_num
      WHEN 1 THEN 'Open play'
      WHEN 2 THEN 'From corner'
      WHEN 3 THEN 'Direct Freekick'
      WHEN 4 THEN 'Set piece'
      WHEN 5 THEN 'Penalty'
    END AS situation_label,
    situation AS json_data
  FROM with_indexed
  WHERE row_num BETWEEN 1 AND 5
),

-- Traitement des formations (lignes 7 à 9)
formations AS (
  SELECT
    row_num,
    CASE row_num
      WHEN 6 THEN '4-2-3-1'
      WHEN 7 THEN '4-3-3'
      WHEN 8 THEN '4-1-4-1'
    END AS formations_label,
    formation AS json_data
  FROM with_indexed
  WHERE row_num BETWEEN 6 AND 8
),

-- Traitement des États du jeu (lignes 10 à 15)
gamestate_cte AS (
  SELECT
    row_num,
    CASE row_num
      WHEN 9 THEN 'Goal diff 0'
      WHEN 10 THEN 'Goal diff +1'
      WHEN 11 THEN 'Goal diff > +1'
      WHEN 12 THEN 'Goal diff -1'
      WHEN 13 THEN 'Goal diff < -1'
    END AS gamestats_label,
    "gameState" AS json_data
  FROM with_indexed
  WHERE row_num BETWEEN 9 AND 13
),

-- Traitement des États du jeu (lignes 10 à 15)
timings AS (
  SELECT
    row_num,
    CASE row_num
      WHEN 14 THEN '1-15'
      WHEN 15 THEN '16-30'
      WHEN 16 THEN '31-45'
      WHEN 17 THEN '46-60'
      WHEN 18 THEN '61-75'
      WHEN 19 THEN '76+'
    END AS timings_label,
    timing AS json_data
  FROM with_indexed
  WHERE row_num BETWEEN 14 AND 19
),

-- Traitement des Zones de tir (lignes 22 à 25)
Shotzones AS (
  SELECT
    row_num,
    CASE row_num
      WHEN 20 THEN 'Own goals'
      WHEN 21 THEN 'Out of box'
      WHEN 22 THEN 'Penalty area'
      WHEN 23 THEN 'Six-yard box'
    END AS Shotzones_label,
    "shotZone" AS json_data
  FROM with_indexed
  WHERE row_num BETWEEN 20 AND 23
),

-- Traitement des Vitesse d'attaque (lignes 26 à 29)
Attackspeed AS (
  SELECT
    row_num,
    CASE row_num
      WHEN 24 THEN 'Normal'
      WHEN 25 THEN 'Standard'
      WHEN 26 THEN 'Slow'
      WHEN 27 THEN 'Fast'
    END AS Attackspeeds_label,
    "attackSpeed" AS json_data
  FROM with_indexed
  WHERE row_num BETWEEN 24 AND 27
),

-- Traitement des Results (lignes 31 à 34)
Result AS (
  SELECT
    row_num,
    CASE row_num
      WHEN 28 THEN 'Shot on post'
      WHEN 29 THEN 'Missed shot'
      WHEN 30 THEN 'Saved shot'
      WHEN 31 THEN 'Goal'
      WHEN 32 THEN 'Shot on post'
    END AS Results_label,
    result AS json_data
  FROM with_indexed
  WHERE row_num BETWEEN 28 AND 32
),


-- Union de tous les blocs
all_data AS (
  SELECT * FROM situations
  UNION ALL SELECT * FROM formations
  UNION ALL SELECT * FROM gamestate_cte
  UNION ALL SELECT * FROM timings
  UNION ALL SELECT * FROM Shotzones
  UNION ALL SELECT * FROM Attackspeed
  UNION ALL SELECT * FROM Result
)


SELECT * FROM all_data

