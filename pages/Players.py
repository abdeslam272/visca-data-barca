import streamlit as st
import pandas as pd
import psycopg2
import plotly.express as px

@st.cache_data(ttl=600)
def load_data():
    with psycopg2.connect(
        host="postgres-dbt",
        dbname="dbt-barca_db",
        user="dbt-barca",
        password="dbt-barca",
        port=5432
    ) as conn:
        query = """
        SELECT player_id, player_name, team_title, "position", games, "time", goals, assists, shots,
               yellow_cards, red_cards, "xG", "xA", npg, "npxG", "xGChain", "xGBuildup",
               goal_conversion_efficiency, xg_per_goal, assist_conversion_efficiency,
               goal_per_shot_ratio, xg_per_shot, goals_per_90, assists_per_90, shots_per_90,
               xg_per_90, xa_per_90, goal_contributions, goal_contributions_per_90,
               xg_diff, xa_diff, npxg_diff, xg_ratio, xgchain_per_90, xgbuildup_per_90,
               discipline_score
        FROM public.fct_player_season_stats
        """
        df = pd.read_sql(query, conn)
    return df

df = load_data()

# Vérification sécurité
if df.empty:
    st.warning("Aucune donnée disponible pour le moment.")
    st.stop()

# Filtres interactifs
teams = sorted(df['team_title'].unique())
team_selected = st.selectbox("Choisir une équipe", teams)
filtered_df = df[df["team_title"] == team_selected]

if filtered_df.empty:
    st.warning(f"Aucune donnée pour l'équipe {team_selected}.")
    st.stop()

players = sorted(filtered_df['player_name'].unique())
player_selected = st.selectbox("Choisir un joueur", players)
player_df = filtered_df[filtered_df["player_name"] == player_selected].iloc[0]  # prend la première ligne

# Statistiques principales
col1, col2, col3 = st.columns(3)
col1.metric("🎯 Buts", player_df["goals"])
col2.metric("🅰️ Passes", player_df["assists"])
col3.metric("📊 xG", round(player_df["xG"], 2))

# Graphique combiné
chart_data = pd.DataFrame({
    "Statistiques": ["Buts", "xG", "Passes", "xA"],
    "Valeur": [player_df["goals"], player_df["xG"], player_df["assists"], player_df["xA"]]
})
fig = px.bar(chart_data, x="Statistiques", y="Valeur", color="Statistiques",
             text="Valeur", title=f"📊 Performance de {player_selected}")
st.plotly_chart(fig)

# Statistiques avancées
with st.expander("📈 Statistiques avancées"):
    st.dataframe(pd.DataFrame(player_df).T)
