WITH raw_data AS (
  SELECT
    *
  FROM {{ ref('stats_2024') }}
),

-- Ajoute un index de ligne pour déterminer les types plus tard
with_indexed AS (
  SELECT 
    *,
    row_number() OVER () AS row_num
  FROM raw_data
),

-- Traitement des situations (lignes 2 à 6)
situations AS (
  SELECT
    row_num,
    unnest(ARRAY[
      'Open play', 'From corner', 'Direct Freekick', 'Set piece', 'Penalty'
    ]) AS situation_label,
    situation AS json_data
  FROM with_indexed
  WHERE row_num <= 5
),

-- Traitement des formations (lignes 7 à 9)
formations AS (
  SELECT
    row_num,
    unnest(ARRAY[
      '4-2-3-1', '4-3-3', '4-1-4-1'
    ]) AS formation_label,
    formation AS json_data
  FROM with_indexed
  WHERE row_num <= 8 and row_num > 5
),

-- Traitement des États du jeu (lignes 10 à 15)
gamestate_cte AS (
  SELECT
    row_num,
    unnest(ARRAY[
      'Goal diff 0', 'Goal diff +1', 'Goal diff > +1', 'Goal diff -1', 'Goal diff < -1'
    ]) AS gameState_label,
    "gameState" AS json_data
  FROM with_indexed
  WHERE row_num <= 13 and row_num > 8
),

-- Traitement des timing (lignes 15 à 21)
timing AS (
  SELECT
    row_num,
    unnest(ARRAY[
      '1-15', '16-30', '31-45', '46-60', '61-75', '76+'
    ]) AS timing_label,
    timing AS json_data
  FROM with_indexed
  WHERE row_num <= 19 and row_num > 14
),

-- Traitement des Zones de tir (lignes 22 à 25)
Shotzones AS (
  SELECT
    row_num,
    unnest(ARRAY[
      'Own goals', 'Out of box', 'Penalty area', 'Six-yard box'
    ]) AS Shotzones_label,
    Shotzone AS json_data
  FROM with_indexed
  WHERE row_num <= 23 and row_num > 18
),

-- Traitement des Vitesse d'attaque (lignes 26 à 29)
Attackspeed AS (
  SELECT
    row_num,
    unnest(ARRAY[
      'Normal', 'Standard', 'Slow', 'Fast'
    ]) AS Attackspeed_label,
    Attackspeed AS json_data
  FROM with_indexed
  WHERE row_num <= 27 and row_num > 22
),

-- Traitement des Results (lignes 31 à 34)
Result AS (
  SELECT
    row_num,
    unnest(ARRAY[
      'Blocked shot', 'Missed shot', 'Saved shot', 'Goal', 'Shot on post'
    ]) AS Result_label,
    Result AS json_data
  FROM with_indexed
  WHERE row_num <= 32 and row_num > 27
),

-- Parse les données de situations
parsed_situations AS (
  SELECT
    situation_label,
    CAST(json_extract_path_text(json_data::json, 'shots') AS INTEGER) AS shots,
    CAST(json_extract_path_text(json_data::json, 'goals') AS INTEGER) AS goals,
    CAST(json_extract_path_text(json_data::json, 'xG') AS FLOAT) AS xG,
    CAST(json_extract_path_text(json_data::json, 'against', 'shots') AS INTEGER) AS shots_against,
    CAST(json_extract_path_text(json_data::json, 'against', 'goals') AS INTEGER) AS goals_against,
    CAST(json_extract_path_text(json_data::json, 'against', 'xG') AS FLOAT) AS xG_against
  FROM situations
),

-- Parse les données de formations
parsed_formations AS (
  SELECT
    json_extract_path_text(json_data::json, 'stat') AS formation_label,
    CAST(json_extract_path_text(json_data::json, 'time') AS INTEGER) AS minutes_played,
    CAST(json_extract_path_text(json_data::json, 'shots') AS INTEGER) AS shots,
    CAST(json_extract_path_text(json_data::json, 'goals') AS INTEGER) AS goals,
    CAST(json_extract_path_text(json_data::json, 'xG') AS FLOAT) AS xG,
    CAST(json_extract_path_text(json_data::json, 'against', 'shots') AS INTEGER) AS shots_against,
    CAST(json_extract_path_text(json_data::json, 'against', 'goals') AS INTEGER) AS goals_against,
    CAST(json_extract_path_text(json_data::json, 'against', 'xG') AS FLOAT) AS xG_against
  FROM formations
)

-- Résultat final
SELECT * FROM parsed_situations
UNION ALL
SELECT 
  formation_label AS situation_label,
  shots,
  goals,
  xG,
  shots_against,
  goals_against,
  xG_against
FROM parsed_formations
