import streamlit as st
import pandas as pd
import psycopg2
import matplotlib.pyplot as plt
import plotly.express as px


@st.cache_data(ttl=600)
def load_formations():
    with psycopg2.connect(
        host="postgres-dbt",
        dbname="dbt-barca_db",
        user="dbt-barca",
        password="dbt-barca",
        port=5432
    ) as conn:
        return pd.read_sql("SELECT * FROM base_formations", conn)

# === Chargement des données ===
df = load_formations()
st.title("⚽ Statistiques des formations de jeu (2024 vs 2025)")

# st.dataframe(df)

# === Extraction propre des listes ===
formations_2024 = df[df["year"] == 2024]["formation_label"].tolist()
formations_2025 = df[df["year"] == 2025]["formation_label"].tolist()

minutes_2024 = df[df["year"] == 2024]["minutes"].tolist()
minutes_2025 = df[df["year"] == 2025]["minutes"].tolist()

goals_2024 = df[df["year"] == 2024]["goals"].tolist()
goals_2025 = df[df["year"] == 2025]["goals"].tolist()

shots_2024 = df[df["year"] == 2024]["shots"].tolist()
shots_2025 = df[df["year"] == 2025]["shots"].tolist()

explode_small = 0.03  # petit écart visuel

# === Temps de jeu ===
col1, col2 = st.columns(2)
with col1:
    st.subheader("🕒 Répartition du temps de jeu — 2024")
    fig1, ax1 = plt.subplots()
    ax1.pie(minutes_2024, labels=formations_2024, explode=[explode_small]*len(formations_2024),
            autopct='%1.1f%%', shadow=True, startangle=90)
    ax1.axis('equal')
    st.pyplot(fig1)

with col2:
    st.subheader("🕒 Répartition du temps de jeu — 2025")
    fig2, ax2 = plt.subplots()
    ax2.pie(minutes_2025, labels=formations_2025, explode=[explode_small]*len(formations_2025),
            autopct='%1.1f%%', shadow=True, startangle=90)
    ax2.axis('equal')
    st.pyplot(fig2)

# === Buts ===
col3, col4 = st.columns(2)
with col3:
    st.subheader("⚽ Répartition des buts — 2024")
    fig3, ax3 = plt.subplots()
    ax3.pie(goals_2024, labels=formations_2024, explode=[explode_small]*len(formations_2024),
            autopct='%1.1f%%', shadow=True, startangle=90)
    ax3.axis('equal')
    st.pyplot(fig3)

with col4:
    st.subheader("⚽ Répartition des buts — 2025")
    fig4, ax4 = plt.subplots()
    ax4.pie(goals_2025, labels=formations_2025, explode=[explode_small]*len(formations_2025),
            autopct='%1.1f%%', shadow=True, startangle=90)
    ax4.axis('equal')
    st.pyplot(fig4)

# === Tirs ===
col5, col6 = st.columns(2)
with col5:
    st.subheader("🎯 Répartition des tirs — 2024")
    fig5, ax5 = plt.subplots()
    ax5.pie(shots_2024, labels=formations_2024, explode=[explode_small]*len(formations_2024),
            autopct='%1.1f%%', shadow=True, startangle=90)
    ax5.axis('equal')
    st.pyplot(fig5)

with col6:
    st.subheader("🎯 Répartition des tirs — 2025")
    fig6, ax6 = plt.subplots()
    ax6.pie(shots_2025, labels=formations_2025, explode=[explode_small]*len(formations_2025),
            autopct='%1.1f%%', shadow=True, startangle=90)
    ax6.axis('equal')
    st.pyplot(fig6)


st.subheader("⚽ Efficacité des formations — Buts marqués / concédés")

df_efficiency_goals = df[[
    "year", 
    "formation_label", 
    "efficient_goal_formations", 
    "efficient_against_goals_formations"
]]

st.dataframe(df_efficiency_goals)

# Melt the dataframe
df_melted_goals = pd.melt(
    df_efficiency_goals,
    id_vars=["year", "formation_label"],
    value_vars=["efficient_goal_formations", "efficient_against_goals_formations"],
    var_name="Type d’efficacité",
    value_name="Valeur"
)

# Build the chart
fig7 = px.bar(
    df_melted_goals,
    x="formation_label",
    y="Valeur",
    color="year",                     # Legend: 2024 / 2025
    barmode="group",                  # Side-by-side bars
    facet_col="Type d’efficacité",    # Two columns: buts marqués / buts concédés
    title="Comparaison des efficacités par formation et par année"
)

st.plotly_chart(fig7, use_container_width=True)

