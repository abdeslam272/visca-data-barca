import streamlit as st
import pandas as pd
import psycopg2
import plotly.express as px

# Connexion à PostgreSQL
conn = psycopg2.connect(
    host="postgres-dbt",
    dbname="dbt-barca_db",
    user="dbt-barca",
    password="dbt-barca",
    port=5432
)

@st.cache_data
def load_formations():
    return pd.read_sql("SELECT * FROM base_formations", conn)

df = load_formations()
st.title("⚽ Statistiques des formations de jeu")
st.dataframe(df)

# Filtres interactifs
formations_list = sorted(df['formation_label'].unique())
formation_selected = st.selectbox("Choisir une formation", formations_list)

formation_df = df[df["formation_label"] == formation_selected].squeeze()

# Statistiques principales
col1, col2, col3, col4, col5, col6, col7 = st.columns(7)
col1.metric("⏱ Minutes", formation_df["minutes"])
col2.metric("🎯 Tirs", formation_df["shots"])
col3.metric("📊 xG", round(formation_df["xg"], 2))
col4.metric("⚽ Buts", formation_df["goals"])
col5.metric("🚫 Tirs concédés", formation_df["against_shots"])
col6.metric("🚫 Buts concédés", formation_df["against_goals"])
col7.metric("🚫 xG concédés", round(formation_df["against_xg"], 2))

# Graphique combiné
chart_data = pd.DataFrame({
    "Statistiques": [
        "Minutes", "Tirs", "xG", "Buts",
        "Tirs concédés", "Buts concédés", "xG concédés"
    ],
    "Valeur": [
        formation_df["minutes"], formation_df["shots"], formation_df["xg"], formation_df["goals"],
        formation_df["against_shots"], formation_df["against_goals"], formation_df["against_xg"]
    ]
})

fig = px.bar(
    chart_data,
    x="Statistiques",
    y="Valeur",
    color="Statistiques",
    text="Valeur",
    title=f"📊 Performance de la formation {formation_selected}"
)
st.plotly_chart(fig)

# Statistiques avancées
with st.expander("📈 Statistiques avancées"):
    st.dataframe(formation_df.to_frame().T)
