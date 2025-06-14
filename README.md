# visca-data-barca
Pour avoir nos données à traiter on va utiliser ce site : https://fbref.com/en/ parceque il contient une grande diversité de données : équipe, joueur, calendrier

# Les commandes:
construire l'mage docker:

'''bash
docker build -t barca-scraper ./web_scraper
'''

Exécuter les conteneurs :
'''bash
docker run --rm -v $(pwd)/data:/data barca-scraper
'''
