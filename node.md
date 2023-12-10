## ----
## Node
## ----

# Label nodes:
$ kubectl label node <NODE_NAME> node-role.kubernetes.io/worker=worker

# List nodes:
$ kubectl get nodes