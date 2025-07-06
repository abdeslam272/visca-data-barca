SELECT
  id AS player_id,
  player_name,
  team_title,
  position,
  games,
  time,
  goals,
  assists,
  shots,
  yellow_cards,
  red_cards,
  "xG",
  "xA",
  npg,
  "npxG",
  "xGChain",
  "xGBuildup",

  -- Efficiency Metrics
  CASE 
    WHEN "xG"::float > 0 THEN goals::float / "xG"::float
    ELSE NULL
  END AS goal_conversion_efficiency,         -- goals / xG

  CASE 
    WHEN goals::float > 0 THEN "xG"::float / goals::float
    ELSE NULL
  END AS xG_per_goal,                        -- xG / goals

  CASE 
    WHEN "xA"::float > 0 THEN assists::float / "xA"::float
    ELSE NULL
  END AS assist_conversion_efficiency,       -- assists / xA

  CASE 
    WHEN shots::float > 0 THEN goals::float / shots::float
    ELSE NULL
  END AS goal_per_shot_ratio,               -- goals / shots

  CASE 
    WHEN shots::float > 0 THEN "xG"::float / shots::float
    ELSE NULL
  END AS xG_per_shot                         -- xG / shots

FROM {{ ref('players_2024') }}
