import streamlit as st
import pandas as pd
import psycopg2

conn = psycopg2.connect(
    host="postgres-dbt",
    dbname="dbt-barca_db",
    user="dbt-barca",
    password="dbt-barca",
    port=5432
)

@st.cache_data
def load_teams():
    return pd.read_sql("SELECT * FROM base_game_stats", conn)

df = load_teams()
st.title("⚽ Statistiques des équipes")
st.dataframe(df)
