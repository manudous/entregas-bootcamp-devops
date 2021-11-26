## Laboratory 01-monolith

- Create .env with
```env
NODE_ENV=develop
PORT=3000
DB_HOST=localhost
DB_USER=postgres
DB_PASSWORD=postgres
DB_PORT=5432
DB_NAME=todos_db
DB_VERSION=10.4
```

- Create the network
```bash
$ docker network create monolith-network
```
- Create the container for postgres
```bash
$ docker run --rm --network monolith-network -d -p 5432:5432 --name postgres postgres:10.4
```
- Copy the file for the data from the database
./02-Kubernetes/01-monolith/todo-app
```bash
$ docker exec -i postgres psql -U postgres < todos_db.sql
```
- create the image to our app
```bash
$ docker build -t manudous/lc-todo-db .
```
- create the container for our app
```bash
$ docker run -d --network monolith-network -p 3000:3000 -e NODE_ENV=production \
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
And then let's start deploying our app in Kubernetes.
## Postgress Deployment
**Annotation**: I have done the deployment in docker-desktop.

- First create Our Persistent Volume Claim, if we want to deploy in minikute storageClassName must be standard, not hostpath.

./01-monolith/Laboratory/postgres-pvc.yaml

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres
  labels:
    app: postgres
spec:
  storageClassName: hostpath
  resources:
    requests:
      storage: 300Mi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
```

- Create the Config Map for the Postgres environment variables.

./01-monolith/Laboratory/postgres-cm.yaml

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: postgres-cm
data:
  POSTGRES_DB: todos_db
  POSTGRES_USER: postgres
  POSTGRES_PASSWORD: postgres
```

- Create the deployment for Postres

./01-monolith/Laboratory/deploy-postgres.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
spec:
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        name: postgres
        app: postgres
    spec:
      volumes:
        - name: postgres
          persistentVolumeClaim:
            claimName: postgres
      containers:
        - name: postgres
          image: postgres:10.4
          ports:
            - containerPort: 5432
          envFrom:
            - configMapRef:
                name: postgres-cm
          volumeMounts:
            - name: postgres
              mountPath: /var/lib/postgresql/data
```

- Now we need the service to be able to expose it outside.

./01-monolith/Laboratory/svc-postgres.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: todo-sql-svc
  labels:
    app: todo-sql-svc
spec:
  selector:
    app: postgres
  ports:
    - port: 5432
  type: NodePort

```

### Initialize our databes

Before starting with the deployment of our app we need to enter data to our database:

- We open a terminal of our pod created.

```bash
$ kubectl exec -it <postgres Pod> -c postgres -- /bin/sh
```

- Let's go into postgres

```bash
# psql -U postgres
```

- To clean the screen use **CTRL+L** when we have into the postgres terminal. :)

- We copy inside all the content of the file _todos_db_

./02-Kubernetes/01-monolith/todo-app/todos_db.sql

```sql
postgres=#<all content todos_db file> 
```

## App Deployment

- First we create our Config Map

./01-monolith/Laboratory/cm-lc-todo-db.yaml

```yaml
kind: ConfigMap
apiVersion: v1
metadata:
  name: cm-lc-todo-db
  labels:
    app: ctldb
data:
  NODE_ENV: production
  PORT: "3000"
  DB_HOST: todo-sql-svc
  DB_USER: postgres
  DB_PASSWORD: postgres
  DB_PORT: "5432"
  DB_NAME: todos_db
  DB_VERSION: "10.4"
```

- Create our deployment

./01-monolith/Laboratory/deploy-lc-todo.db.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: ctldb
  name: ctldb
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ctldb
  template:
    metadata:
      labels:
        app: ctldb
    spec:
      containers:
        - image: manudous/lc-todo-db
          name: lc-todo-db
          envFrom:
            - configMapRef:
                name: cm-lc-todo-db
          ports:
            - containerPort: 3000
              name: todo-db
```

- And finally our service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: todo-sql-svc
  labels:
    app: todo-sql-svc
spec:
  selector:
    app: postgres
  ports:
    - port: 5432
  type: NodePort
```

Let's execute inside the folder where we have our yamls to deploy our app.

./01-monolith/Laboratory

```bash
$ kubectl apply -f .
```

- we check our service

```bash
$ kubectl get svc
```

- and see

```bash
NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
ctldb          NodePort       				<none>        3000:32412/TCP   2d19h
kubernetes     ClusterIP      				<none>        443/TCP          77d
todo-sql-svc   NodePort       				<none>        5432:30707/TCP   2d18h
```

- We write in our browser, the Port of our todo-sql-svc. it will be different in each deployment.

```
localhost:30707
```

