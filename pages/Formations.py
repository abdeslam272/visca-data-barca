import streamlit as st
import pandas as pd
import psycopg2
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
    
# chargement de donnee 
df = load_formations()
st.title("Statistiques des formations de jeu (2024 vs 2025)")

# Liste deroulante des formations dispo
formations_list = sorted(df["formation_label"].unique())
formations_selected = st.selectbox("Choisir une formation", formations_list)

#sous-ensemble pour la formation sélectionnée
formation_df = df[df["formation_label"] == formations_selected].sort_values("year")

# verifie les deux années dispo
years_available = formation_df["year"].unique()

# affichage des donnees 2025

st.subheader(f" Statistiques {formations_selected} par année")

# Stylisation : mise en subrillance de 2025
def highlight_2025(row):
    if row["year"] == 2025:
        return ["background-color : "]*len(row)
    else:
        return [""]*len(row)
    
st.dataframe(
    formation_df.style.apply(highlight_2025, axis=1)
)

# Comparaison 2024 vs 2025
if set([2024, 2025]).issubset(years_available):
    st.subheader(f"Comparaison 2024 vs 2025 - {formations_selected}")

    stats_cols = ["minutes", "shots", "goals", "xg", "against_shots", "against_goals", "against_xg"]

    df_compare = (
        formation_df.pivot(index="formation_label", columns = "year", values = stats_cols)
        .swaplevel(axis=1)
        .sort_index(axis=1)
    )

    df_compare.columns = [f"{year}_{stat}" for (year, stat) in df_compare.columns]
    df_compare = df_compare.reset_index()

    # Calcul des écarts
    for stat in stats_cols:
        col_2024 = f"2024_{stat}"
        col_2025 = f"2025_{stat}"
        if col_2024 in df_compare.columns and col_2025 in df_compare.columns:
            df_compare[f"{stat}"] = df_compare[f"2025_{stat}"] - df_compare[f"2025_{stat}"]

    st.dataframe(df_compare)

    #Graphique comparatif
    chart_data = pd.melt(
        formation_df,
        id_vars=["year"],
        value_vars=["goals", "xg", "against_goals", "against_xg"],
        var_name="Statistique",
        value_name="Valeur"
    )

    fig = px.bar(
        chart_data,
        x="Statistique",
        y="Valeur",
        color="year",
        barmode="group",
        text_auto=".2f",
        title = f"Comparaison de performances ({formations_selected})"
    )

    st.plotly_chart(fig, use_container_width=True)

else:
    st.info(f"les donnes pour 2024 et 2025 ne sont pas toutes dispo pour {formations_selected}")