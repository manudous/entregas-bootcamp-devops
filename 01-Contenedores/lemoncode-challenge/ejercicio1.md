>## Creamos nuestra network
<br />

```bash
$ docker network create lemoncode-challenge
```

>## Creamos el contenedor para meter nuestra base de datos
<br />

```
$ docker run -d --name some-mongo -p 27017:27017 --network lemoncode-challenge --mount source=mongo-volume,target=/data/db/mongo-volume mongo
```

>## Introduzco más datos a mi base de datos con el archivo db.json
```
db.json
```

>## Dockerfile del Backend
```bash
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /app

COPY *.csproj ./

RUN dotnet restore

COPY . ./

RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
ENV MONGO_URI=mongodb://some-mongo:27017
WORKDIR /app
EXPOSE 80
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "backend.dll"]
```
>## Creamos la build del backend
```bash
$ docker build -t backend .
```
>## Creamos el contenedor para el backend y lo metemos en nuestro network lomoncode-challenge

```bash
$ docker run -d --name backendapp -p 5000:80 --network lemoncode-challenge backend
```

>## Dockerfile del Frontend
```
FROM node:14-alpine
ENV NODE_ENV=production
ENV API_URI=http://backendapp/api/topics
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN npm install --production --silent && mv node_modules ../
COPY . .
EXPOSE 3000
RUN chown -R node /usr/src/app
USER node
CMD ["node", "server.js"]
```

>## Creamos la build
```bash
$ docker build -t frontend .
```
>## Y por último creamos el contenedor para el frontend y lo metemos en nuestro network lemoncode-challenge

```bash
$ docker run -d --name frontendapp -p 8080:3000 --network lemoncode-challenge frontend
```






