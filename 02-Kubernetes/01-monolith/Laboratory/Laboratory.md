Crear .env con
```
NODE_ENV=develop
PORT=3000
DB_HOST=localhost
DB_USER=postgres
DB_PASSWORD=postgres
DB_PORT=5432
DB_NAME=todos_db
DB_VERSION=10.4
```

```bash
$ docker network create lemoncode
```

```bash
$ docker run --rm --network lemoncode -d -p 5432:5432 --name postgres postgres:10.4
```

```bash
$ docker exec -i postgres psql -U postgres < todos_db.sql
```

```bash
$ docker build -t manudous/lc-todo-db
```

```bash
$ docker run -d --network lemoncode -p 3000:3000 -e NODE_ENV=production \
	  -e PORT=3000 \
	  -e DB_HOST=postgres \
	  -e DB_USER=postgres \
	  -e DB_PASSWORD=postgres \
	  -e DB_PORT=5432 \
	  -e DB_NAME=todos_db \
	  -e DB_VERSION=10.4 \
	  --name lc-todo-db \
	  manudous/lc-todo-db
```
