from bs4 import BeautifulSoup
import requests

def load_data(url):
    """
    Load data from a given URL using BeautifulSoup.

    Parameters:
    - url (str): The URL to fetch data from.

    Returns:
    - soup (BeautifulSoup): Parsed HTML content.
    """
    # Send a GET request to the URL
    response = requests.get(url)

    # Parse the HTML content of the page using BeautifulSoup
    soup = BeautifulSoup(response.text, "html.parser")

    return soup

fbref_scraper = "https://fbref.com/en/squads/206d90db/Barcelona-Stats"

soup = load_data(fbref_scraper)

print(soup.prettify()[:1000])
