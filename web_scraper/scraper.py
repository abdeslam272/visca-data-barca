import re
import json
import pandas as pd
from bs4 import BeautifulSoup
import requests
from .config import HEADERS
from .utils import extract_and_load_data

def load_data(url):
    response = requests.get(url, headers=HEADERS)
    if response.status_code != 200:
        raise Exception(f"Failed to retrieve data from {url}, status code: {response.status_code}")
    soup = BeautifulSoup(response.text, "html.parser")
    return soup

def scrape_team_data(team_name, year):
    url = f"https://understat.com/team/{team_name}/{year}"
    soup = load_data(url)

    df_games = extract_and_load_data(soup.find("script", string=re.compile(r"var datesData")), "datesData")
    df_stats = extract_and_load_data(soup.find("script", string=re.compile(r"var statisticsData")), "statisticsData")
    df_players = extract_and_load_data(soup.find("script", string=re.compile(r"var playersData")), "playersData")

    return df_games, df_stats, df_players
