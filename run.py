import os
from web_scraper.scraper import scrape_team_data

output_dir = "/app/data"
os.makedirs(output_dir, exist_ok=True)

if __name__ == "__main__":
    for year in [2024, 2025]:
        print(f"🔎 Scraping Barcelona {year}...")
        try:
            df_games, df_stats, df_players = scrape_team_data("Barcelona", year)

            if df_games is None or df_stats is None or df_players is None:
                print(f"⚠️ Scraping {year} failed: one of the DataFrames is None")
                continue

            df_games.to_csv(os.path.join(output_dir, f"games_{year}.csv"), index=False)
            df_stats.to_csv(os.path.join(output_dir, f"stats_{year}.csv"), index=False)
            df_players.to_csv(os.path.join(output_dir, f"players_{year}.csv"), index=False)

            print(f"✅ Scraping {year} terminé et fichiers sauvegardés.")
        except Exception as e:
            print(f"❌ Error while scraping {year}: {str(e)}")


