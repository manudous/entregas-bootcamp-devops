```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: todoapp
  name: todoapp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: todoapp
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: todoapp
    spec:
      containers:
      - image: manudous/lc-todo-monolith
        name: lc-todo-monolith
        resources: {}
status: {}
```

