{% set years = [2024, 2025] %}

with
{% for year in years %}

raw_data_{{ year }} as (
    select *
    from {{ ref('players_' ~ year) }}
),

cleaned_players_{{ year }} as (
    select
        {{ year }} as year,
        player_name,
        games as games_played,
        time as minutes_played,
        goals as goals_scored,

        -- xG metrics (cast once)
        cast("xG" as float)        as xg_created,
        cast("xA" as float)        as assists_created,
        cast("xGChain" as float)   as xg_chain,
        cast("xGBuildup" as float) as xg_buildup,

        assists,
        shots,
        key_passes,
        npg as non_penalty_goals

    from raw_data_{{ year }}
),

transformed_players_{{ year }} as (
    select
        year,
        player_name,
        games_played,
        minutes_played,
        goals_scored,
        xg_created,
        assists,
        assists_created,
        shots,
        key_passes,
        non_penalty_goals,
        xg_chain,
        xg_buildup,
        (goals_scored * 1.0 / minutes_played) * 90 as goals_scored_per_90_minutes,
        (assists * 1.0 / minutes_played) * 90 as assists_per_90_minutes,
        (xg_created * 1.0 / minutes_played) * 90 as xg_created_per_90_minutes,
        (assists_created * 1.0 / minutes_played) * 90 as assists_created_per_90_minutes,
        goals_scored / nullif(xg_created, 0) as efficient_goal_scoring

    from cleaned_players_{{ year }}
)

{% if not loop.last %},{% endif %}
{% endfor %}

-- union final
select * from transformed_players_{{ years[0] }}
{% for year in years[1:] %}
union all
select * from transformed_players_{{ year }}
{% endfor %}
