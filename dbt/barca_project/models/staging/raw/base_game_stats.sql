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

parsed_gamestate AS (
  SELECT
    gamestats_label,
    
    -- Nettoyage de la chaîne pour JSON valide
    REPLACE(json_data, '''', '"')::json ->> 'stat' AS stat,
    (REPLACE(json_data, '''', '"')::json ->> 'time')::int AS minutes,
    (REPLACE(json_data, '''', '"')::json ->> 'shots')::int AS shots,
    (REPLACE(json_data, '''', '"')::json ->> 'goals')::int AS goals,
    (REPLACE(json_data, '''', '"')::json ->> 'xG')::float AS xG,

    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'shots')::int AS against_shots,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'goals')::int AS against_goals,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'xG')::float AS against_xG

  FROM gamestate_cte
)

SELECT * FROM parsed_gamestate