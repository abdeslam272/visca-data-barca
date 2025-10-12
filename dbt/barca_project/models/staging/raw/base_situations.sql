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

situations_{{year}} AS (
  SELECT
    row_num,
    {{year}} as year,
    CASE row_num
      WHEN 1 THEN 'Open play'
      WHEN 2 THEN 'From corner'
      WHEN 3 THEN 'Direct Freekick'
      WHEN 4 THEN 'Set piece'
      WHEN 5 THEN 'Penalty'
    END AS situation_label,
    situation AS json_data
  FROM with_indexed_{{year}}
  WHERE row_num BETWEEN 1 AND 5
),

parsed_situations_{{year}} AS (
  SELECT
    situation_label,
    year,
    -- Nettoyage de la chaîne pour JSON valide
    (REPLACE(json_data, '''', '"')::json ->> 'shots')::int AS shots,
    (REPLACE(json_data, '''', '"')::json ->> 'goals')::int AS goals,
    (REPLACE(json_data, '''', '"')::json ->> 'xG')::float AS xG,

    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'shots')::int AS against_shots,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'goals')::int AS against_goals,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'xG')::float AS against_xG

  FROM situations_{{year}}
)

{% if not loop.last %},{% endif %}
{% endfor %} 

--union all
SELECT * FROM parsed_situations_{{years[0]}}
{% for year in years[1:] %}
union all
select * from parsed_situations_{{year}}
{% endfor %}
