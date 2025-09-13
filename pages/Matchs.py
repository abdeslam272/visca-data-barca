import streamlit as st
import pandas as pd
import psycopg2

@st.cache_data(ttl=600)  # cache pendant 10 minutes
def load_teams():
    with psycopg2.connect(
        host="postgres-dbt",
        dbname="dbt-barca_db",
        user="dbt-barca",
        password="dbt-barca",
        port=5432
    ) as conn:
        return pd.read_sql("SELECT * FROM match_results", conn)


df = load_teams()
st.title("⚽ Statistiques des matchs")
st.dataframe(df)
