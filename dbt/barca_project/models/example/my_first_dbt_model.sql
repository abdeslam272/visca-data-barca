-- models/my_first_model.sql
SELECT *
FROM {{ ref('players_2024') }}
WHERE goals >= 10