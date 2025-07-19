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


parsed_Attackspeed AS (
  SELECT
    Attackspeeds_label,
    
    -- Nettoyage de la chaîne pour JSON valide
    (REPLACE(json_data, '''', '"')::json ->> 'shots')::int AS shots,
    (REPLACE(json_data, '''', '"')::json ->> 'goals')::int AS goals,
    (REPLACE(json_data, '''', '"')::json ->> 'xG')::float AS xG,

    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'shots')::int AS against_shots,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'goals')::int AS against_goals,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'xG')::float AS against_xG

  FROM Attackspeed
)

SELECT * FROM parsed_Attackspeed