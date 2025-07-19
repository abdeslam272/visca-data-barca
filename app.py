import streamlit as st
import pandas as pd
import psycopg2

# Connexion à la base PostgreSQL
conn = psycopg2.connect(
    host="postgres",        # le nom du service si en Docker Compose
    dbname="barca_db",
    user="postgres",
    password="your_password",
    port=5432
)

# Exemple de lecture d'une vue dbt
@st.cache_data
def load_data():
    return pd.read_sql("SELECT * FROM base_formations", conn)

df = load_data()

st.title("📊 Analyse des formations du Barça")
st.dataframe(df)
