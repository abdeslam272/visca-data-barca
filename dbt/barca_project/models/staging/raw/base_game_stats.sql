{% set years = [2024, 2025] %}

WITH
{% for year in years %}
raw_data_{{year}} AS (
  SELECT *
  FROM {{ ref('stats_' ~ year) }}
),

with_indexed_{{year}} AS (
  SELECT 
    *,
    row_number() OVER () AS row_num
  FROM raw_data_{{year}}
),

-- Traitement des États du jeu (lignes 10 à 15)
gamestate_cte_{{year}} AS (
  SELECT
    row_num,
    {{year}} as year,
    CASE row_num
      WHEN 9 THEN 'Goal diff 0'
      WHEN 10 THEN 'Goal diff +1'
      WHEN 11 THEN 'Goal diff > +1'
      WHEN 12 THEN 'Goal diff -1'
      WHEN 13 THEN 'Goal diff < -1'
    END AS gamestats_label,
    "gameState" AS json_data
  FROM with_indexed_{{year}}
  WHERE row_num BETWEEN 9 AND 13
),

parsed_gamestate_{{year}} AS (
  SELECT
    gamestats_label,
    year,
    -- Nettoyage de la chaîne pour JSON valide
    (REPLACE(json_data, '''', '"')::json ->> 'time')::int AS minutes,
    (REPLACE(json_data, '''', '"')::json ->> 'shots')::int AS shots,
    (REPLACE(json_data, '''', '"')::json ->> 'goals')::int AS goals,
    (REPLACE(json_data, '''', '"')::json ->> 'xG')::float AS xG,

    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'shots')::int AS against_shots,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'goals')::int AS against_goals,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'xG')::float AS against_xG

  FROM gamestate_cte_{{year}}
)
{% if not loop.last %},{% endif %}
{% endfor %} 

--union all
SELECT * FROM parsed_gamestate_{{years[0]}}
{% for year in years[1:] %}
union all
select * from parsed_gamestate_{{year}}
{% endfor %}