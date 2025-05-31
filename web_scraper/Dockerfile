# Étape 1 : choisir une image légère avec Python
FROM python:3.11-slim

# Étape 2 : créer un répertoire de travail
WORKDIR /app

# Étape 3 : copier les fichiers du scraper
COPY fbref_scraper.py .
COPY requirements.txt .

# Étape 4 : installer les dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# Étape 5 : créer le dossier de sortie s’il n'existe pas
RUN mkdir -p /data/raw

# Étape 6 : définir le point d’entrée du conteneur
CMD ["python", "fbref_scraper.py"]
