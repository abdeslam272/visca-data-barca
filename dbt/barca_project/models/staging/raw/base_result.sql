{%set years = [2024,2025 ] %}

WITH
{% for year in years%}
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

-- Traitement des Results (lignes 31 à 34)
Result_{{year}} AS (
  SELECT
      {{year}} as year,
    row_num,
    CASE row_num
      WHEN 28 THEN 'Shot on post'
      WHEN 29 THEN 'Missed shot'
      WHEN 30 THEN 'Saved shot'
      WHEN 31 THEN 'Goal'
      WHEN 32 THEN 'Shot on post'
    END AS Results_label,
    result AS json_data
  FROM with_indexed_{{year}}
  WHERE row_num BETWEEN 28 AND 32
),


parsed_Result_{{year}} AS (
  SELECT
    Results_label,
    year,
    -- Nettoyage de la chaîne pour JSON valide
    (REPLACE(json_data, '''', '"')::json ->> 'shots')::int AS shots,
    (REPLACE(json_data, '''', '"')::json ->> 'goals')::int AS goals,
    (REPLACE(json_data, '''', '"')::json ->> 'xG')::float AS xG,

    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'shots')::int AS against_shots,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'goals')::int AS against_goals,
    (REPLACE(json_data, '''', '"')::json -> 'against' ->> 'xG')::float AS against_xG

  FROM Result_{{year}}
)

{% if not loop.last %},{% endif %}
{% endfor %} 

--union all
SELECT * FROM parsed_Result_{{years[0]}}
{% for year in years[1:] %}
union all
select * from parsed_Result_{{year}}
{% endfor %}