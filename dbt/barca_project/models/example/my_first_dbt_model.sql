-- models/my_first_model.sql
SELECT *
FROM {{ source('raw', 'players_2024') }}
WHERE goals >= 10;
