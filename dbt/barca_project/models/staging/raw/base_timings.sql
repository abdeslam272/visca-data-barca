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


parsed_timings AS (
  SELECT
    timing,
    
    -- Nettoyage de la chaîne pour JSON valide
    REPLACE(json_data, '''', '"')::json ->> 'stat' AS stat,
    (REPLACE(json_data, '''', '"')::json ->> 'time')::int AS minutes,
    (REPLACE(json_data, '''', '"')::json ->> 'shots')::int AS shots,
    (REPLACE(json_data, '''', '"')::json ->> 'goals')::int AS goals,
    (REPLACE(json_data, '''', '"')::json ->> 'xG')::float AS xG,

    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'shots')::int AS against_shots,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'goals')::int AS against_goals,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'xG')::float AS against_xG

  FROM timings
)

SELECT * FROM parsed_timings