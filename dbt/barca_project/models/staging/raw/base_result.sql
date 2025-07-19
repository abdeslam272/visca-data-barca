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


parsed_Result AS (
  SELECT
    Results_label,
    
    -- Nettoyage de la chaîne pour JSON valide
    (REPLACE(json_data, '''', '"')::json ->> 'shots')::int AS shots,
    (REPLACE(json_data, '''', '"')::json ->> 'goals')::int AS goals,
    (REPLACE(json_data, '''', '"')::json ->> 'xG')::float AS xG,

    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'shots')::int AS against_shots,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'goals')::int AS against_goals,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'xG')::float AS against_xG

  FROM Result
)

SELECT * FROM parsed_Result