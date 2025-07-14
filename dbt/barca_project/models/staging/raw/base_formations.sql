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

formations AS (
  SELECT
    row_num,
    CASE row_num
      WHEN 6 THEN '4-2-3-1'
      WHEN 7 THEN '4-3-3'
      WHEN 8 THEN '4-1-4-1'
    END AS formation_label,
    formation AS json_data
  FROM with_indexed
  WHERE row_num BETWEEN 6 AND 8
),

parsed_formations AS (
  SELECT
    formation_label,
    
    -- Nettoyage de la chaîne pour JSON valide
    REPLACE(json_data, '''', '"')::json ->> 'stat' AS stat,
    (REPLACE(json_data, '''', '"')::json ->> 'time')::int AS minutes,
    (REPLACE(json_data, '''', '"')::json ->> 'shots')::int AS shots,
    (REPLACE(json_data, '''', '"')::json ->> 'goals')::int AS goals,
    (REPLACE(json_data, '''', '"')::json ->> 'xG')::float AS xG,

    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'shots')::int AS against_shots,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'goals')::int AS against_goals,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'xG')::float AS against_xG

  FROM formations
)

SELECT * FROM parsed_formations
