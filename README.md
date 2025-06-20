# visca-data-barca
Pour avoir nos données à traiter on va utiliser ce site : https://fbref.com/en/ parceque il contient une grande diversité de données : équipe, joueur, calendrier

# Les commandes:
construire l'mage docker:

```bash
docker build -t barca-scraper .
```

Exécuter les conteneurs :
```bash
docker run --rm -v "$(pwd -W)/data:/app/data" barca-scraper
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


# Commandes Bash/Linux essentielles

| Catégorie               | Commande                    | Description                                                                                  | Exemple                                |
|------------------------|-----------------------------|----------------------------------------------------------------------------------------------|--------------------------------------|
| **Navigation & fichiers** | `pwd`                      | Affiche le dossier courant                                                                   | `pwd`                                |
|                        | `ls`                        | Liste fichiers et dossiers                                                                   | `ls -l`                              |
|                        | `cd`                        | Change de dossier                                                                            | `cd /app/data`                       |
|                        | `mkdir`                     | Crée un dossier                                                                             | `mkdir data`                        |
|                        | `rm`                        | Supprime fichier (`-r` pour dossiers)                                                       | `rm file.txt` / `rm -r folder`      |
|                        | `cp`                        | Copie fichier ou dossier (`-r` pour dossiers)                                               | `cp file.txt backup.txt`             |
|                        | `mv`                        | Déplace ou renomme fichier/dossier                                                          | `mv old.txt new.txt`                 |
|                        | `touch`                     | Crée fichier vide ou modifie date de modif                                                 | `touch newfile.csv`                  |
|                        | `cat`                       | Affiche contenu fichier                                                                     | `cat file.txt`                      |
|                        | `head`, `tail`              | Affiche début/fin d’un fichier                                                             | `head -n 10 file.txt`                |
|                        | `less`                      | Affiche fichier page par page                                                               | `less logfile.log`                   |
|                        | `file`                      | Indique type d’un fichier                                                                   | `file data.csv`                     |
| **Texte & données**     | `grep`                      | Cherche motif (regex) dans fichier ou sortie                                               | `grep "ERROR" logfile.log`           |
|                        | `awk`                       | Extraction et traitement de colonnes                                                       | `awk -F, '{print $1}' file.csv`      |
|                        | `sed`                       | Recherche et remplace dans un fichier                                                      | `sed 's/foo/bar/g' file.txt`         |
|                        | `cut`                       | Extrait colonnes ou morceaux de ligne                                                      | `cut -d',' -f2 file.csv`              |
|                        | `sort`                      | Trie lignes                                                                               | `sort file.txt`                      |
|                        | `uniq`                      | Supprime doublons (souvent avec `sort`)                                                   | `sort file.txt | uniq`               |
|                        | `wc`                        | Compte lignes, mots, caractères                                                           | `wc -l file.txt`                     |
|                        | `tr`                        | Transforme caractères (ex : majuscules/minuscules)                                        | `tr 'a-z' 'A-Z' < file.txt`          |
| **Système & info**      | `top` / `htop`              | Affiche processus et ressources (CPU, mémoire)                                           | `top`                               |
|                        | `df -h`                     | Espace disque utilisé/libre                                                                | `df -h`                             |
|                        | `du -sh`                    | Taille d’un dossier                                                                        | `du -sh /app/data`                   |
|                        | `ps aux`                    | Liste processus en cours                                                                  | `ps aux | grep python`               |
|                        | `kill`, `killall`           | Termine processus                                                                         | `kill 1234`                        |
|                        | `chmod`, `chown`            | Change permissions / propriétaire                                                        | `chmod +x script.sh`                 |
|                        | `whoami`                    | Affiche utilisateur courant                                                               | `whoami`                           |
| **Réseau**              | `curl`                      | Faire requêtes HTTP / télécharger                                                        | `curl https://api.example.com/data` |
|                        | `wget`                      | Télécharger fichier depuis internet                                                      | `wget https://site.com/file.csv`    |
|                        | `ping`                      | Tester connexion à un hôte                                                               | `ping google.com`                   |
|                        | `netstat`                   | Affiche connexions réseau                                                                | `netstat -tuln`                     |
|                        | `ssh`                       | Connexion à serveur distant                                                              | `ssh user@server`                   |
| **Docker**              | `docker build`              | Construire image Docker                                                                   | `docker build -t myapp .`            |
|                        | `docker run`                | Lancer container avec options                                                            | `docker run -it --rm -v $(pwd)/data:/app/data myapp` |
|                        | `docker ps`                 | Lister containers actifs                                                                  | `docker ps`                        |
|                        | `docker logs`               | Voir logs d’un container                                                                 | `docker logs container_id`           |
|                        | `docker exec`               | Entrer dans un container                                                                  | `docker exec -it container_id sh`   |
| **Shell & scripts**     | Variables                   | Définir et utiliser variables shell                                                      | `NAME="data"; echo $NAME`            |
|                        | Redirections                | Rediriger sortie (`>`, `>>`) et pipes (`|`)                                            | `ls > files.txt`                    |
|                        | Conditions                  | Tester conditions dans scripts                                                          | `if [ -d data ]; then echo exists; fi` |
|                        | Boucles                     | Automatiser avec `for`, `while`                                                         | `for file in *.csv; do echo $file; done` |
| **Windows Git Bash / WSL** | Chemins Linux vs Windows    | Utiliser `${PWD}` en Bash, `pwd -W` pour chemin Windows                                 | `echo ${PWD}` / `pwd -W`             |
| **Bonus Data Eng.**     | `jq`                        | Manipuler JSON en ligne de commande                                                     | `curl api | jq '.'`                  |
|                        | `psql`, `mysql`             | Accéder base données SQL en CLI                                                         | `psql -U user dbname`                |
|                        | `az`, `aws` CLI             | Interagir avec Azure/AWS                                                               | `az login`                         |
|                        | `tar`, `zip`, `unzip`       | Compression/décompression fichiers                                                     | `tar -czvf archive.tar.gz data/`    |



# Structure de projet recommandée
```
visca-data-barca/
├── README.md
├── docker-compose.yml
├── airflow/
│   ├── dags/
│   ├── plugins/
│   └── Dockerfile
├── dbt/
│   ├── visca-data-barca/
│   │   ├── models/
│   │   └── ...
│   ├── profiles.yml
│   └── Dockerfile
├── streamlit/
│   ├── app.py
│   └── Dockerfile
├── web_scraper/
│   ├── scraper.py
│   └── requirements.txt
├── data/
│   ├── raw/
│   ├── staging/
│   └── warehouse/
└── utils/
    └── helpers.py
```


on utilise dbt (Data Build Tool) est devenu un standard dans l’industrie pour la transformation, nettoyage et modélisation de données en SQL, principalement dans les architectures modernes orientées ELT (Extract, Load, Transform).
