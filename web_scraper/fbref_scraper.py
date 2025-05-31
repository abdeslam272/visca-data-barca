import requests
from bs4 import BeautifulSoup
import pandas as pd

URL = "https://fbref.com/en/squads/206d90db/Barcelona-Stats"

def fetch_barca_squad():
    response = requests.get(URL)
    soup = BeautifulSoup(response.text, 'html.parser')

    # Exemple : récupérer le tableau des stats des joueurs
    table = soup.find("table", {"id": "stats_standard_24"})
    df = pd.read_html(str(table))[0]

    # Nettoyage basique
    df = df[df["Rk"] != "Rk"]  # supprimer les lignes de header répétées
    df.reset_index(drop=True, inplace=True)

    return df

if __name__ == "__main__":
    df = fetch_barca_squad()
    print(df.head())
    df.to_csv("../data/raw/barca_players_stats.csv", index=False)
