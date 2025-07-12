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
  END AS xG_per_shot,                         -- xG / shots

  CASE WHEN time > 0 THEN goals * 90.0 / time ELSE NULL END AS goals_per_90,
  CASE WHEN time > 0 THEN assists * 90.0 / time ELSE NULL END AS assists_per_90,
  CASE WHEN time > 0 THEN shots * 90.0 / time ELSE NULL END AS shots_per_90,
  CASE WHEN time > 0 THEN "xG" * 90.0 / time ELSE NULL END AS xG_per_90,
  CASE WHEN time > 0 THEN "xA" * 90.0 / time ELSE NULL END AS xA_per_90,

  goals + assists AS goal_contributions,

  CASE WHEN time > 0 THEN (goals + assists) * 90.0 / time ELSE NULL END AS goal_contributions_per_90,

  goals - "xG" AS xG_diff,
  assists - "xA" AS xA_diff,
  npg - "npxG" AS npxG_diff,

  CASE 
    WHEN "npxG"::float != 0 THEN "xG"::float / "npxG"::float 
    ELSE NULL 
  END AS xG_ratio,

  CASE WHEN time > 0 THEN "xGChain" * 90.0 / time ELSE NULL END AS xGChain_per_90,
  CASE WHEN time > 0 THEN "xGBuildup" * 90.0 / time ELSE NULL END AS xGBuildup_per_90,

  CASE 
    WHEN games > 0 THEN 
      (yellow_cards * 1 + red_cards * 3)::float / games
    ELSE NULL 
  END AS discipline_score

FROM {{ ref('players_2024') }}
