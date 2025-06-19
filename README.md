# visca-data-barca
Pour avoir nos données à traiter on va utiliser ce site : https://fbref.com/en/ parceque il contient une grande diversité de données : équipe, joueur, calendrier

# Les commandes:
construire l'mage docker:

```bash
docker build -t barca-scraper .
```

Exécuter les conteneurs :
```bash
docker run --rm -v $(pwd)/data:/data barca-scraper
```

Créer un dossier:
```bash
mkdir -p data
```

# Structure de dossier Web_Scraper
| Fichier       | Rôle                                                               |
| ------------- | ------------------------------------------------------------------ |
| `__init__.py` | Rend le dossier `web_scraper` importable comme un module           |
| `scraper.py`  | Contient la logique principale pour charger et scraper les données |
| `utils.py`    | Contient les fonctions auxiliaires (comme `extract_and_load_data`) |
| `config.py`   | Gère les constantes (headers, URLs, noms de colonnes, etc.)        |
