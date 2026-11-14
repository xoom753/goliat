# README

## boot the app
```
RAILS_ENV=production bin/rails assets:precompile

RAILS_ENV=production bin/rails server
```

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## to do

- [x] when importing presentes por pabellón: mark as inactive the ones who are not present
- [] associate person#pabellon
- [] associate LegacyPersonActivity to parseable to track what file is it imported from

### notes

```
bundle exec erd --generator=graphviz --filetype=pdf
bundle exec erd --generator=graphviz --filetype=png
```

### specs

```
RAILS_ENV=test bundle exec rspec spec
RAILS_ENV=test bundle exec rspec --format json --out spec_results.json spec
RAILS_ENV=test bundle exec rspec --format h --out spec_results.html spec
```

### backup db

```
pg_dump postgres://postgres:password@db/goliat_db -Fc -f backup.dump

pg_restore --dbname="postgres://postgres:password@db/goliat_prod_db" backup.dump
```
