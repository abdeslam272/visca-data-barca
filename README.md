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


un terminal interactif dans le conteneur :

```bash
docker exec -it barca-dbt bash
```

Initialiser le projet dbt :

```bash
dbt init barca_project
```

Creer le fichier profiles.yml et aprés ca on teste la conexion avec 

```bash
dbt debug
```


📦 Structure propre d’un projet dbt avec Docker
Lorsque tu travailles avec Docker + dbt, il est essentiel de monter correctement deux éléments dans le conteneur :

🔧 Le fichier profiles.yml : pour la configuration de connexion à la base de données.

📁 Le dossier barca_project : qui contient ton projet dbt (models, seeds, snapshots, etc.).

🧠 Règle importante : montage ciblé
Dans le docker-compose.yml, on ne monte que ce qui est nécessaire :


```yaml
volumes:
  - ./dbt/barca_project:/usr/app                     # 📁 Contenu du projet dbt
  - ./dbt/profiles.yml:/root/.dbt/profiles.yml       # 🔐 Configuration de la connexion BDD
```

Cela permet à dbt de trouver :

/usr/app/dbt_project.yml → le cœur du projet

/root/.dbt/profiles.yml → la connexion à la base

📁 Rôle des fichiers dbt
Fichier / Dossier	Rôle
dbt_project.yml	Fichier principal du projet dbt (nom, modèles, configurations, etc.)
models/, seeds/, etc.	Contiennent tes transformations, données sources, snapshots, etc.
profiles.yml	Définit comment dbt se connecte à la base de données (type, host, user...)

✅ Exemple d’arborescence

```bash
├── dbt/
│   ├── profiles.yml                  👈 Fichier de config de la connexion (monté dans /root/.dbt/)
│   └── barca_project/               👈 Projet dbt (monté dans /usr/app/)
│       ├── dbt_project.yml
│       ├── models/
│       ├── seeds/
│       └── ...
```
🎯 Résultat
En lançant :

```bash
docker exec -it barca-dbt bash
cd /usr/app
dbt debug
```
Tu obtiens :

```pgsql
profiles.yml file [OK found and valid]
dbt_project.yml file [OK found and valid]
```
Et tu es prêt à exécuter tes commandes dbt run, dbt seed, dbt test, etc. 💪


# Différence entre ref() et source():
| Fonction   | Utilisation                                                                             | Ce que ça pointe                                            | Exemple                               |
| ---------- | --------------------------------------------------------------------------------------- | ----------------------------------------------------------- | ------------------------------------- |
| `ref()`    | Faire référence à un **modèle dbt** (ou à une table seedée avec `dbt seed`)             | Une table **créée ou gérée par dbt**                        | `{{ ref('players_2024') }}`           |
| `source()` | Faire référence à une **table brute externe**, souvent dans le schéma `raw` ou `public` | Une table **externe à dbt** (souvent existante dans ta BDD) | `{{ source('raw', 'players_2024') }}` |

# Pourquoi utiliser seeds/ + ref() est mieux ?
| Avantage             | Explication                                                                                  |
| -------------------- | -------------------------------------------------------------------------------------------- |
|  **Versionnable**  | Les fichiers `.csv` dans `seeds/` sont trackés par Git.                                      |
|  **Reproductible** | Tu peux recréer toute ta base avec `dbt seed` et `dbt run`, sans avoir besoin de re-scraper. |
|  **Intégré à dbt**  | Tu peux chaîner des transformations avec `ref()` entre seeds et modèles.                     |
|  **Stable**        | Pas besoin de connexion externe ou dépendance à un script de scraping pour tester le projet. |

# Run dbt Modeles
```bash
dbt run --select match_results
```

#  Structure des modèles dbt
1. raw (source déclarée dans sources.yml)
Contient les fichiers de données bruts (CSV, fichiers plats, base externe). Ces données ne sont pas modifiées. Exemple : games_2024.csv, players_2024.csv.

➡️ But : référencer les sources de données avec source() (pas de logique ici).

2. staging (modèles stg_)
Modèles intermédiaires pour :

Renommer les colonnes (snake_case),

Caster les types (ex : JSON → table),

Nettoyer les valeurs (ex : dates, strings, valeurs manquantes).

➡️ But : créer une base propre et uniforme pour tous les modèles métiers.

Exemple :
stg_players_2024.sql extrait et nettoie les données du fichier players_2024.csv.

3. marts (modèles métiers/finals)
Contient les modèles finaux utilisés pour la visualisation, reporting ou analyse. On distingue généralement :

marts/fact/ → tables de faits (indicateurs, mesures),

marts/dim/ → tables de dimensions (joueurs, équipes),

marts/stats/ → KPIs dérivés ou résumés statistiques.

➡️ But : produire les jeux de données métier prêts à être utilisés dans Streamlit, Power BI ou autres.

Exemples :

fct_player_season_stats.sql

fct_matches.sql

dim_team.sql

# Effeicney Metrics :
Let’s say a player:

Passes → Passes → Key pass → Shot → Goal

If the xG of the shot is 0.5, then:

All players involved in that sequence get +0.5 in xGChain

Only those who didn't make the key pass or shoot get +0.5 in xGBuildup

| Type de métrique         | Exemples                                          |
| ------------------------ | ------------------------------------------------- |
| Normalisées (per 90)     | `goals_per_90`, `xG_per_90`                       |
| Agrégées offensives      | `goal_contributions`, `goal_contributions_per_90` |
| Écart réel vs attendu    | `xG_diff`, `xA_diff`                              |
| Ratios de performance    | `goal_per_shot_ratio`, `xG_per_shot`              |
| Discipline et style      | `discipline_score`, `player_type`                 |
| Statistiques de création | `xGChain_per_90`, `xGBuildup_per_90`              |

# Streamlit

| Élément                                              | Pourquoi c’est important                                         |
| ---------------------------------------------------- | ---------------------------------------------------------------- |
| `Dockerfile.streamlit`                               | Définit comment construire l’environnement Streamlit             |
| `requirements.txt`                                   | Liste claire des dépendances nécessaires                         |
| Nom du host = nom du service Docker (`postgres-dbt`) | Permet à Streamlit de communiquer avec PostgreSQL dans Docker    |
| `volumes` dans `docker-compose.yml`                  | Permet un développement en live sans rebuild à chaque changement |
| `EXPOSE 8501` + mapping `8501:8501`                  | Ouvre le port nécessaire pour accéder à l’interface Web          |

✅ Si vous modifiez le code Python, pas besoin de rebuild, un simple docker-compose restart streamlit suffit.

🐞 Si vous avez une erreur de connexion PostgreSQL, vérifiez que le nom du host correspond bien au nom du service Docker.

💡 Utilisez st.cache_data pour optimiser les requêtes longues.

pour restart streamlit :
```bash
docker-compose restart streamlit
```

pour les logs :
```bash
docker compose logs streamlit
```


** Structure multi-pages Streamlit avec Docker **
L’application est organisée avec une page d’accueil (app.py) et plusieurs pages thématiques dans le dossier pages/.
Streamlit détecte automatiquement les fichiers présents dans pages/ et les affiche dans la barre latérale.

📂 Arborescence
```bash
.
├── app.py                  # Page d'accueil
├── pages/                  # Pages additionnelles
│   ├── 1_📊_Players.py
│   ├── 2_⚽_Teams.py
│   ├── 3_📋_Matchs.py
│   └── 4_🗺_Formations.py
├── requirements.txt
├── Dockerfile.streamlit
├── docker-compose.yml
```

🐳 Dockerfile
Le Dockerfile.streamlit copie tout le code dans /app, installe les dépendances, puis lance Streamlit :

```dockerfile
FROM python:3.10
WORKDIR /app
COPY . /app
RUN pip install --upgrade pip && pip install -r requirements.txt
EXPOSE 8501
CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
```

⚙️ docker-compose.yml

```yaml
streamlit:
  build:
    context: .
    dockerfile: Dockerfile.streamlit
  container_name: barca-streamlit
  depends_on:
    - postgres-dbt
  ports:
    - "8501:8501"
  environment:
    - PYTHONUNBUFFERED=1
  volumes:
    - .:/app
```

🚀 Lancer l'application
```bash
docker compose build streamlit
docker compose up streamlit
```
Ouvrir ensuite http://localhost:8501 pour accéder à la page d’accueil et naviguer entre les pages via la sidebar.


# Airflow

we create the containers we need to add an airflow user by :

```sh
docker exec -it airflow-webserver airflow users create \
    --username admin \
    --firstname First \
    --lastname Last \
    --role Admin \
    --email admin@example.com \
    --password admin
```

## 
le souci vient du fait que $(pwd -W) est évalué dans le conteneur Airflow, et donc ne correspond pas au chemin local.

La bonne pratique est de monter ./data dans le conteneur Airflow via docker-compose, puis de toujours utiliser ce chemin (/opt/airflow/data) dans tes DAGs.
