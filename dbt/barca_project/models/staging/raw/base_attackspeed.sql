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

-- Traitement des Vitesse d'attaque (lignes 26 à 29)
Attackspeed_{{year}} AS (
  SELECT
    row_num,
    {{year}} as year,
    CASE row_num
      WHEN 24 THEN 'Normal'
      WHEN 25 THEN 'Standard'
      WHEN 26 THEN 'Slow'
      WHEN 27 THEN 'Fast'
    END AS Attackspeeds_label,
    "attackSpeed" AS json_data
  FROM with_indexed_{{year}}
  WHERE row_num BETWEEN 24 AND 27
),


parsed_Attackspeed_{{year}} AS (
  SELECT
    Attackspeeds_label,
    year,
    -- Nettoyage de la chaîne pour JSON valide
    (REPLACE(json_data, '''', '"')::json ->> 'shots')::int AS shots,
    (REPLACE(json_data, '''', '"')::json ->> 'goals')::int AS goals,
    (REPLACE(json_data, '''', '"')::json ->> 'xG')::float AS xG,

    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'shots')::int AS against_shots,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'goals')::int AS against_goals,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'xG')::float AS against_xG

  FROM Attackspeed_{{year}}
)
{% if not loop.last %},{% endif %}
{% endfor %} 

--union all
SELECT * FROM parsed_Attackspeed_{{years[0]}}
{% for year in years[1:] %}
union all
select * from parsed_Attackspeed_{{year}}
{% endfor %}