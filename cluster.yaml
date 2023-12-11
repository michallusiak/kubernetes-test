## --------------------------------------------------------------------------------------------
## Cluster - a set of nodes that run containerized applications.
##
## A Kubernetes cluster contains six main components: 
##   - API server: Exposes a REST interface to all Kubernetes resources.
##     Serves as the front end of the Kubernetes control plane.
##   - Scheduler: Places containers according to resource requirements and metrics.
##     Makes note of Pods with no assigned node, and selects nodes for them to run on.
##   - Controller manager: Runs controller processes and reconciles the cluster’s actual state
##     with its desired specifications. Manages controllers such as node controllers, endpoints
##     controllers and replication controllers.
##   - Kubelet: Ensures that containers are running in a Pod by interacting with the Docker engine,
##     the default program for creating and managing containers. Takes a set of provided
##     PodSpecs and ensures that their corresponding containers are fully operational.
##   - Kube-proxy: Manages network connectivity and maintains network rules across nodes.
##     Implements the Kubernetes Service concept across every node in a given cluster.
##   - Etcd: Stores all cluster data. Consistent and highly available Kubernetes backing store.
## --------------------------------------------------------------------------------------------

# Create a new cluster:
$ minikube start --nodes 3 --profile k8s --driver=docker

# List all available minikube profiles (clusters):
$ minikube profile list

# Switch to a specific profile (cluster):
```console
$ minikube profile <PROFILE / CLUSTER_NAME>
```

# Check active cluster:
```console
$ kubectl config current-context
```

# List all nodes in active cluster:
```console
$ kubectl get nodes
```

# View the cluster events:
```console
$ kubectl get events
```

# View kubectl configuration:
```console
$ kubectl config view
```

# Stopping the cluster:
```console
$ minikube stop <CLUSTER_NAME>
```

# Remove the current cluster:
```console
$ minikube delete
```