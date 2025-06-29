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
        REPLACE(h, '''', '"')::json AS home_team_json

    FROM {{ ref('games_2024') }}