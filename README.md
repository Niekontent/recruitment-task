## Run project

docker compose up --build

Phoenix API: http://localhost:4000
Symfony Admin: http://localhost:8000

## Users Import

To import users to Phoenix API:

1. Start containers:
```
docker-compose up -d
```

2. Initiate the import
```
curl -X POST http://localhost:4000/import -H "Authorization: VERY_SECRET_TOKEN"
```

## Data sources
Imiona męskie https://dane.gov.pl/pl/dataset/1667,lista-imion-wystepujacych-w-rejestrze-pesel-osoby-zyjace/resource/1159669/table?page=1&per_page=20&q=&sort=
Imiona żeńskie https://dane.gov.pl/pl/dataset/1667,lista-imion-wystepujacych-w-rejestrze-pesel-osoby-zyjace/resource/1159670/table?page=1&per_page=20&q=&sort=
Nazwiska męskie https://dane.gov.pl/pl/dataset/1681,nazwiska-osob-zyjacych-wystepujace-w-rejestrze-pesel/resource/1148808/table?page=1&per_page=20&q=&sort=
Nazwiska żeńskie https://dane.gov.pl/pl/dataset/1681,nazwiska-osob-zyjacych-wystepujace-w-rejestrze-pesel/resource/1148811/table?page=1&per_page=20&q=&sort=