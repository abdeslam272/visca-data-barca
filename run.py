import os
from web_scraper.scraper import scrape_team_data

output_dir = "/app/data"
os.makedirs(output_dir, exist_ok=True)

if __name__ == "__main__":
    df_games, df_stats, df_players = scrape_team_data("Barcelona", 2024)

    df_games.to_csv(os.path.join(output_dir, "games_2024.csv"), index=False)
    df_stats.to_csv(os.path.join(output_dir, "stats_2024.csv"), index=False)
    df_players.to_csv(os.path.join(output_dir, "players_2024.csv"), index=False)

    print("Scraping terminé et fichiers sauvegardés.")


