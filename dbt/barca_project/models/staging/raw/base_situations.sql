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

parsed_situations AS (
  SELECT
    situation_label,
    
    -- Nettoyage de la chaîne pour JSON valide
    (REPLACE(json_data, '''', '"')::json ->> 'shots')::int AS shots,
    (REPLACE(json_data, '''', '"')::json ->> 'goals')::int AS goals,
    (REPLACE(json_data, '''', '"')::json ->> 'xG')::float AS xG,

    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'shots')::int AS against_shots,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'goals')::int AS against_goals,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'xG')::float AS against_xG

  FROM situations
)

SELECT * FROM parsed_situations
