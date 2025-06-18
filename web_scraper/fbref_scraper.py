import json
import re
from bs4 import BeautifulSoup
import requests
import pandas as pd

def load_data(url):
    # Send a GET request to the URL
    response = requests.get(url)

    # Parse the HTML content of the page using BeautifulSoup
    soup = BeautifulSoup(response.text, "html.parser")

    return soup

def extract_and_load_data(script_element, data_type):
    if script_element:
        # Extract the JSON data using a regular expression
        script_text = script_element.text
        match = re.search(f"var {data_type}\s+=\s+JSON\.parse\('(.+?)'\)",script_text)

        if match:
            json_data_encoded = match.group(1)

            try: 
                # Decode the encoded JSON data
                json_data = json.loads(json_data_encoded.encode('utf').decode('unicode_escape'))

                # Create a dataframe from the JSON data
                df_data = pd.DataFrame(json_data)

                print(f"Successfully loaded {data_type} data into DataFrame.")
                return df_data
            except Exception as e:
                print(f"Error decoding JSON data: {str(e)}")
                return None
        else:
            print(f"JSON data not found in the {data_type} script.")
            return None
    else:
        print(f"{data_type} scrpit element not found on the page.")
        return None

url_2024 = "https://understat.com/team/Barcelona/2024"

# Load the data for 2024 into the dataframes
soup_2024 = load_data(url_2024)
df_games_data_2024 = extract_and_load_data(soup_2024.find("script", string=re.compile(r"var datesData\s+=\s+JSON\.parse\(")), "datesData")
df_statistics_data_2024 = extract_and_load_data(soup_2024.find("script", string=re.compile(r"var statisticsData\s+=\s+JSON\.parse\(")), "statisticsData")
df_players_data_2024 = extract_and_load_data(soup_2024.find("script", string=re.compile(r"var playersData\s+=\s+JSON\.parse\(")), "playersData")

print(df_games_data_2024)