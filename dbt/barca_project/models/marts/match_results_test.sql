WITH raw_games AS (

        SELECT 
        id,
        "isResult",
        side,
        datetime,

        -- Nettoyage des quotes simples → doubles, puis cast explicite
        REPLACE(goals, '''', '"')::json AS goals_json,
        REPLACE("xG", '''', '"')::json AS xg_json,
        REPLACE(forecast, '''', '"')::json AS forecast_json,
        REPLACE(a, '''', '"')::json AS away_team_json,
        REPLACE(h, '''', '"')::json AS home_team_json,

        result

    FROM {{ ref('games_2024') }}
), 
exploded AS (
    SELECT 
        id,
        side,
        datetime,

        -- Score réel
        goals_json->>'h' AS home_goals,
        goals_json->>'a' AS away_goals,

        -- xG (expected goals)
        xg_json->>'h' AS home_xg,
        xg_json->>'a' AS away_xg,

        -- Probabilités (forecast)
        forecast_json->>'w' AS forecast_win,
        forecast_json->>'d' AS forecast_draw,
        forecast_json->>'l' AS forecast_loss,

        -- Home ou Away
        CASE 
            WHEN side = 'h' THEN 'home'
            WHEN side = 'a' THEN 'away'
        END AS match_type,

        away_team_json->>'title' AS away_team,
        home_team_json->>'title' AS home_team,
        
        CASE 
            WHEN side = 'h' THEN away_team_json->>'title'
            WHEN side = 'a' THEN home_team_json->>'title'
        END AS Oppenent_team,

        CASE 
            WHEN result = 'w' THEN 3
            WHEN result = 'l' THEN 0
            WHEN result = 'd' THEN 1
        END AS Points,

        CASE 
            WHEN side = 'h' THEN goals_json->>'h'
            WHEN side = 'a' THEN goals_json->>'a'
        END AS Goals_Scored_By_Barcelona,

        CASE 
            WHEN side = 'h' THEN goals_json->>'a'
            WHEN side = 'a' THEN goals_json->>'h'
        END AS Goals_Scored_By_opponent,

        CASE 
            WHEN side = 'h' THEN xg_json->>'h'
            WHEN side = 'a' THEN xg_json->>'a'
        END AS XG_made_By_Barcelona,

        CASE 
            WHEN side = 'h' THEN xg_json->>'a'
            WHEN side = 'a' THEN xg_json->>'h'
        END AS XG_made_By_opponent

FROM raw_games) 

SELECT 
        datetime,
        away_team,
        home_team,
        match_type,
        Oppenent_team,
        Points,
        Goals_Scored_By_Barcelona,
        Goals_Scored_By_opponent,
        XG_made_By_Barcelona,
        XG_made_By_opponent

FROM exploded