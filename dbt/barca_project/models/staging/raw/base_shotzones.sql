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

parsed_Shotzones AS (
  SELECT
    Shotzones_label,
    
    -- Nettoyage de la chaîne pour JSON valide
    REPLACE(json_data, '''', '"')::json ->> 'stat' AS stat,
    (REPLACE(json_data, '''', '"')::json ->> 'shots')::int AS shots,
    (REPLACE(json_data, '''', '"')::json ->> 'goals')::int AS goals,
    (REPLACE(json_data, '''', '"')::json ->> 'xG')::float AS xG,

    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'shots')::int AS against_shots,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'goals')::int AS against_goals,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'xG')::float AS against_xG

  FROM Shotzones
)

SELECT * FROM parsed_Shotzones