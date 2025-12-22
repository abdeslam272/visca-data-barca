import streamlit as st
import pandas as pd
import psycopg2
import matplotlib.pyplot as plt
import plotly.express as px


@st.cache_data(ttl=600)
def load_players():
    with psycopg2.connect(
        host="postgres-dbt",
        dbname="dbt-barca_db",
        user="dbt-barca",
        password="dbt-barca",
        port=5432
    ) as conn:
        return pd.read_sql("SELECT * FROM base_players", conn)

# === Chargement des données ===
df = load_players()
st.title("⚽ Statistiques des joueurs (2024 vs 2025)")

# st.dataframe(df)
def get_top10(df, year, metric):
    top10 = (
        df[df["year"] == year]
        .sort_values(metric, ascending=False)
        .head(10)
    )
    return top10["player_name"].tolist(), top10[metric].tolist()


joueurs_2024, goals_2024 = get_top10(df, 2024, "goals_scored")
joueurs_2025, goals_2025 = get_top10(df, 2025, "goals_scored")

joueurs_ast_2024, assists_2024 = get_top10(df, 2024, "assists")
joueurs_ast_2025, assists_2025 = get_top10(df, 2025, "assists")

joueurs_contrib_2024, contrib_2024 = get_top10(df, 2024, "contributions_ga")
joueurs_contrib_2025, contrib_2025 = get_top10(df, 2025, "contributions_ga")

# # === Extraction propre des listes ===
# joueurs_2024 = df[df["year"] == 2024]["player_name"].tolist()
# joueurs_2025 = df[df["year"] == 2025]["player_name"].tolist()

# minutes_2024 = df[df["year"] == 2024]["minutes_played"].tolist()
# minutes_2025 = df[df["year"] == 2025]["minutes_played"].tolist()

# goals_2024 = df[df["year"] == 2024]["goals_scored"].tolist()
# goals_2025 = df[df["year"] == 2025]["goals_scored"].tolist()

# assists_2024 = df[df["year"] == 2024]["assists"].tolist()
# assists_2025 = df[df["year"] == 2025]["assists"].tolist()

# Contibutions_GA_2024 = df[df["year"] == 2024]["contributions_ga"].tolist()
# Contibutions_GA_2025 = df[df["year"] == 2025]["contributions_ga"].tolist()

explode_small = 0.03  # petit écart visuel

# === Buts ===
col1, col2 = st.columns(2)
with col1:
    st.subheader("🕒 Répartition du buteurs — 2024")
    fig1, ax1 = plt.subplots()
    ax1.pie(goals_2024, labels=joueurs_2024, explode=[explode_small]*len(joueurs_2024),
            autopct='%1.1f%%', shadow=True, startangle=90)
    ax1.axis('equal')
    st.pyplot(fig1)

with col2:
    st.subheader("🕒 Répartition du buteurs — 2025")
    fig2, ax2 = plt.subplots()
    ax2.pie(goals_2025, labels=joueurs_2025, explode=[explode_small]*len(joueurs_2025),
            autopct='%1.1f%%', shadow=True, startangle=90)
    ax2.axis('equal')
    st.pyplot(fig2)

# === Assists ===
col3, col4 = st.columns(2)
with col3:
    st.subheader("⚽ Répartition des assisteurs — 2024")
    fig3, ax3 = plt.subplots()
    ax3.pie(assists_2024, labels=joueurs_ast_2024, explode=[explode_small]*len(joueurs_ast_2024),
            autopct='%1.1f%%', shadow=True, startangle=90)
    ax3.axis('equal')
    st.pyplot(fig3)

with col4:
    st.subheader("⚽ Répartition des assisteurs — 2025")
    fig4, ax4 = plt.subplots()
    ax4.pie(assists_2025, labels=joueurs_ast_2025, explode=[explode_small]*len(joueurs_ast_2025),
            autopct='%1.1f%%', shadow=True, startangle=90)
    ax4.axis('equal')
    st.pyplot(fig4)

# === Contributions G A  ===
col5, col6 = st.columns(2)
with col5:
    st.subheader("🎯 Répartition des contributions — 2024")
    fig5, ax5 = plt.subplots()
    ax5.pie(contrib_2024, labels=joueurs_contrib_2024, explode=[explode_small]*len(joueurs_contrib_2024),
            autopct='%1.1f%%', shadow=True, startangle=90)
    ax5.axis('equal')
    st.pyplot(fig5)

with col6:
    st.subheader("🎯 Répartition des contributions — 2025")
    fig6, ax6 = plt.subplots()
    ax6.pie(contrib_2025, labels=joueurs_contrib_2025, explode=[explode_small]*len(joueurs_contrib_2025),
            autopct='%1.1f%%', shadow=True, startangle=90)
    ax6.axis('equal')
    st.pyplot(fig6)
