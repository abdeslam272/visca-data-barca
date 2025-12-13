{% set years = [2024, 2025] %}

with
{% for year in years %}
raw_data_{{year}} as (
  select *
  from {{ ref('players_' ~ year) }}
),

with_indexed_{{year}} as (
  select
    {{year}} as year,,
    player_name,
    games as games_played,
    time as minutes_played,
    goals as goals_scored,
    xG as xG_created,
    assists,
    xA as assists_created,
    shots,
    key_passes,
    npg as non_penalty_goals,
    xGchain, --xGChain gives every player who touches the ball in a possession the shot's xG if that possession ends in a shot
    xGBuildup, --based on knowing which players are part of passing chains that end in a shot but without taking into account the last two links - shot and last pass
    CASE WHEN xG = 0 then null else goals/xG end as efficient_goal_scoring,
    ),
