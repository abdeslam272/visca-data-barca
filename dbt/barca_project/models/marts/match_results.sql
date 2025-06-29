WITH raw_games AS (

    SELECT 
        id,
        "isResult",
        side,
        datetime,

        -- Nettoyage des quotes simples → doubles, puis cast explicite
        REPLACE(goals, '''', '"')::json AS goals_json,
        REPLACE("xG", '''', '"')::json AS xg_json,
        REPLACE(forecast, '''', '"')::json AS forecast_json

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
        END AS match_type

    FROM raw_games

),
final AS (

    SELECT 
        id,
        match_type,
        datetime,
        home_goals,
        away_goals,
        home_xg,
        away_xg,
        forecast_win,
        forecast_draw,
        forecast_loss,

        -- Résultat vu depuis notre équipe
        CASE 
            WHEN match_type = 'home' AND home_goals > away_goals THEN 'win'
            WHEN match_type = 'home' AND home_goals = away_goals THEN 'draw'
            WHEN match_type = 'home' AND home_goals < away_goals THEN 'loss'
            WHEN match_type = 'away' AND away_goals > home_goals THEN 'win'
            WHEN match_type = 'away' AND away_goals = home_goals THEN 'draw'
            WHEN match_type = 'away' AND away_goals < home_goals THEN 'loss'
        END AS result

    FROM exploded

)

SELECT * FROM final