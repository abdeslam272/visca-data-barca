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

-- Traitement des Zones de tir (lignes 22 à 25)
Shotzones_{{year}} AS (
  SELECT
    row_num,
    {{year}} as year,
    CASE row_num
      WHEN 20 THEN 'Own goals'
      WHEN 21 THEN 'Out of box'
      WHEN 22 THEN 'Penalty area'
      WHEN 23 THEN 'Six-yard box'
    END AS Shotzones_label,
    "shotZone" AS json_data
  FROM with_indexed_{{year}}
  WHERE row_num BETWEEN 20 AND 23
),

parsed_Shotzones_{{year}} AS (
  SELECT
    Shotzones_label,
    year,
    -- Nettoyage de la chaîne pour JSON valide
    REPLACE(json_data, '''', '"')::json ->> 'stat' AS stat,
    (REPLACE(json_data, '''', '"')::json ->> 'shots')::int AS shots,
    (REPLACE(json_data, '''', '"')::json ->> 'goals')::int AS goals,
    (REPLACE(json_data, '''', '"')::json ->> 'xG')::float AS xG,

    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'shots')::int AS against_shots,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'goals')::int AS against_goals,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'xG')::float AS against_xG

  FROM Shotzones_{{year}}
)

{% if not loop.last %},{% endif %}
{% endfor %} 

--union all
SELECT * FROM parsed_Shotzones_{{years[0]}}
{% for year in years[1:] %}
union all
select * from parsed_Shotzones_{{year}}
{% endfor %}