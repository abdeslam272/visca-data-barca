{% set years = [2024, 2025] %}

with
{% for year in years %}
raw_data_{{year}} as (
  select *
  from {{ ref('stats_' ~ year) }}
),

with_indexed_{{year}} as (
  select 
    *,
    row_number() over () as row_num
  from raw_data_{{year}}
),

formations_{{year}} as (
  select
    row_num,
    {{year}} as year,
    case row_num
      when 6 then '4-2-3-1'
      when 7 then '4-3-3'
      when 8 then '4-1-4-1'
    end as formation_label,
    formation as json_data
  from with_indexed_{{year}}
  where row_num between 6 and 8
),

parsed_formations_{{year}} as (
  select
    year,
    formation_label,
    
    replace(json_data, '''', '"')::json ->> 'stat'   as stat,
    (replace(json_data, '''', '"')::json ->> 'time')::int   as minutes,
    (replace(json_data, '''', '"')::json ->> 'shots')::int  as shots,
    (replace(json_data, '''', '"')::json ->> 'goals')::int  as goals,
    (replace(json_data, '''', '"')::json ->> 'xG')::float   as xG,

    (replace(json_data, '''', '"')::json -> 'against' ->> 'shots')::int  as against_shots,
    (replace(json_data, '''', '"')::json -> 'against' ->> 'goals')::int  as against_goals,
    (replace(json_data, '''', '"')::json -> 'against' ->> 'xG')::float   as against_xG

  from formations_{{year}}
),

transformed_formations_{{year}} as (
  select
    year,
    formation_label,
    stat,
    minutes,
    shots,
    goals,
    xG,
    against_shots,
    against_goals,
    against_xG,
    CASE WHEN xG = 0 then null else goals/xG end as efficient_goal_formations,
    shots - against_shots as efficient_shots_formations,
    CASE WHEN against_xG = 0 then null else against_goals/against_xG end as efficient_against_goals_formations

  from parsed_formations_{{year}}
)
{% if not loop.last %},{% endif %}
{% endfor %} 

-- union final
select * from transformed_formations_{{ years[0] }}
{% for year in years[1:] %}
union all
select * from transformed_formations_{{year}}
{% endfor %}
