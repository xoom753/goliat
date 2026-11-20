# goliat

## boot the app
```
RAILS_ENV=production bin/rails assets:precompile

RAILS_ENV=production bin/rails server
```

## todo

* Ruby version `ruby 4.0.7`

* System dependencies `bundle install`


## to do

- [x] when importing presentes por pabellón: mark as inactive the ones who are not present
- [] associate person#pabellon
- [] associate LegacyPersonActivity to parseable to track what file is it imported from

## ERD

```
bundle exec erd --generator=graphviz --filetype=pdf
bundle exec erd --generator=graphviz --filetype=png
```

## specs

```
RAILS_ENV=test bundle exec rspec spec
RAILS_ENV=test bundle exec rspec --format json --out spec_results.json spec
RAILS_ENV=test bundle exec rspec --format h --out spec_results.html spec
```

## rubocop
```
./bin/rubocop -a
```

## backup db

```
pg_dump postgres://postgres:password@db/goliat_prod_db -Fc -f backup.dump

pg_restore --dbname="postgres://postgres:password@db/goliat_db_production" backup.dump
```

## build docker container for prod

```
docker compose -f docker-compose.prod.yml up -d --build
```


## docker containers for dev env

1. list all containers:

```
~ % docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED        STATUS                        PORTS                    NAMES
3479cb09c955   ruby          "bash"                   22 hours ago   Exited (255) 16 minutes ago   0.0.0.0:3000->3000/tcp   betstabe-web-run-bb12aea16e44
178a9c024913   postgres:14   "docker-entrypoint.s…"   23 hours ago   Exited (255) 16 minutes ago   0.0.0.0:5432->5432/tcp   betstabe-db-1
```

2. boot db container:
```
~ % docker start 178a9c024913
```

3. boot app container:
```
~ % docker start 3479cb09c955
```

4. log into app container:
```
~ % docker exec -ti 3479cb09c955 bash
```

5. boot app:
```
root@3479cb09c955:/app# RAILS_ENV=production ./goliat/bin/rails s

```

6. head to:

```
http://localhost:3000/
```
