>## Crea las imágenes y los contenedores
```
$ docker-compose up -d
$ docker-compose up --build 
```
>## Parar los contenedores
```
$ docker-compose stop
```
>## Borrar los contendores
```
$ docker compose down # 
$ docker-compose down --volumes
```
>## Borrar contendores e imágenes
```
$ docker-compose down --rmi all
```
>## Ver los contendedores que tenemos
```
$ docker-compose ps
```
>## Reiniciar los contendores
```
$ docker compose restart
```