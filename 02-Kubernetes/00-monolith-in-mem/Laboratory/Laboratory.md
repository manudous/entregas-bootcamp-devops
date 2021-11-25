## Laboratory 00-monolith-in-men
First I try locally, I created an image of the application and upload it to my docker hub repository.
```bash
$ docker build -t manudous/lc-todo-monolith .
```
And start the App
```bash
docker run -d -p 3000:3000 -e NODE_ENV=production -e PORT=3000 manudous/lc-todo-monolith
```
To test that everything works correctly locally write in your browser<br />
```
localhost:3000
```
**Delete this container for next step.**<br />
<br />
And now that we see that everything works correctly we are going to deploy it in Kubernetes.

## **To do this exercise I have used the context of docker-hub**

./02-Kubernetes/00-monolith-in-mem/Laboratory/cm-lc-todo-monolith.yaml
- First we create the ConfigMap where we will save our environment variables.
```yaml
kind: ConfigMap
apiVersion: v1
metadata:
  name: cm-lc-todo-monolith
  labels:
    app: mln
data:
  NOD_ENV: "production"
  PORT: "3000"
```
./02-Kubernetes/00-monolith-in-mem/Laboratory/lc-todo-monolith.yaml
- Next we create our Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: mln
  name: mln
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mln
  template:
    metadata:
      labels:
        app: mln
    spec:
      containers:
        - image: manudous/lc-todo-monolith
          name: lc-todo-monolith
          envFrom:
            - configMapRef:
                name: cm-lc-todo-monolith
```
./02-Kubernetes/00-monolith-in-mem/Laboratory/lc-todo-monolith.yaml
- And finally we create our service to expose our app
```yaml
apiVersion: v1
kind: Service
metadata:
  name: mln
  labels:
    app: mln
spec:
  selector:
    app: mln
  ports:
  - port: 3000
  type: NodePort
```
./02-Kubernetes/00-monolith-in-mem/Laboratory
- For everything to work we make an apply of all the yaml that we have inside the Laboratory folder
```bash
$ kubectl apply -f .
```
- To Check what works we type in our console
```bash
$ kubectl get svc
```
```bash
mln            NodePort    10.97.105.178    <none>        3000:30131/TCP   12s
```
- We will see the port that exposes our service in my case it would be 30131. To check it through our browser it would be.
```
localhost:30131
```




