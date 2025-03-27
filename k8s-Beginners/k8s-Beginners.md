# k8s for Beginners

## minikube cluster

### What is minikube?
Minikube is a tool that allows you to set up a Kubernetes cluster on your local computer to develop and test applications. Minikube is a lightweight, single-node Kubernetes distribution that you can use to run Kubernetes locally. Minikube creates a local Kubernetes environment that mirrors the behavior of a production cluster. It includes all the components needed to run Kubernetes, such as the API server, controller manager, and scheduler. Minikube is a great way to experiment with Kubernetes before deploying it in production. It's easy to install and use, and it supports all major operating systems, including Windows, Linux, and macOS.

### Install kubectl

Install kubectl before install minikube. [Click here](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) for instruction to install kubectl.

### Install minikube

Check the virtualiation enabled on the system you are installing minikube. If the virtualization not enabled on the system then reboot the system and enable virtualization from BIOS.
```shell
egrep --color "vmx|svm" /proc/cpuinfo
```

[Click here](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2F.exe+download) for instruction to install and start minikube.


### Start minikube

```shell
minikube start
```

Start the minikube with specific driver. [Verify link](https://minikube.sigs.k8s.io/docs/drivers/) for available drivers.
```shell
minikube start --driver=docker
```

### Check the status of cluster
Command:
```shell
minikube status
```

Output:

```shell
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured
```

### Get cluster status
Command:
```shell
kubectl cluster-info
```

Output:
```shell
Kubernetes control plane is running at https://192.168.49.2:8443
CoreDNS is running at https://192.168.49.2:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

### Get list of nodes
```shell
kubectl get nodes
```

### Stop the minikube cluster
```shell
minikube stop
```


## Pods

### What is pod?
- The smallest unit of computing that can be deployed and managed.
- Its a group of one or more containers that share same resources
  like Storage, Network and configuration data.
- Containers within a pod can communicate each other via localhost
  because they share the same network namespace.

### How to create pod?
Command:-
```shell
kubectl run nginx --image nginx
```

### How to view the pods?
Command:-
```shell
kubectl get pods
```
Output
```shell
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          19m
```
View the pods list with more details like running node.
Command:
```shell
kubectl get pods -o wide
```
Output:
```shell
NAME    READY   STATUS    RESTARTS      AGE   IP           NODE       NOMINATED NODE   READINESS GATES
nginx   1/1     Running   1 (11h ago)   12h   10.244.0.5   minikube   <none>           <none>
```

### To view the details about the pods
Command:
```shell
kubectl describe pods nginx
```

Output:
```shell
Name:             nginx
Namespace:        default
Priority:         0
Service Account:  default
Node:             minikube/192.168.49.2
Start Time:       Wed, 20 Nov 2024 12:05:06 +0530
Labels:           run=nginx
Annotations:      <none>
Status:           Running
IP:               10.244.0.5
IPs:
  IP:  10.244.0.5
Containers:
  nginx:
    Container ID:   docker://d509b0ec423e72c2d94fa9a5d03b7f89a7cac4feaac0401ea066cc632eb56d54
    Image:          nginx
    Image ID:       docker-pullable://nginx@sha256:bc5eac5eafc581aeda3008b4b1f07ebba230de2f27d47767129a6a905c84f470
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Wed, 20 Nov 2024 23:41:26 +0530
    Last State:     Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Wed, 20 Nov 2024 12:09:09 +0530
      Finished:     Wed, 20 Nov 2024 12:40:03 +0530
    Ready:          True
    Restart Count:  1
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-pvxpk (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True
  Initialized                 True
  Ready                       True
  ContainersReady             True
  PodScheduled                True
Volumes:
  kube-api-access-pvxpk:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason          Age                From               Message
  ----     ------          ----               ----               -------
  Normal   Scheduled       11h                default-scheduler  Successfully assigned default/nginx to minikube
  Warning  Failed          11h                kubelet            Failed to pull image "nginx": error pulling image configuration: download failed after attempts=6: dial tcp [2600:1f18:2148:bc01:571f:e759:a87a:2961]:443: connect: cannot assign requested address
  Warning  Failed          11h                kubelet            Error: ErrImagePull
  Normal   BackOff         11h                kubelet            Back-off pulling image "nginx"
  Warning  Failed          11h                kubelet            Error: ImagePullBackOff
  Normal   Pulling         11h (x2 over 11h)  kubelet            Pulling image "nginx"
  Normal   Pulled          11h                kubelet            Successfully pulled image "nginx" in 2m44.956s (2m44.956s including waiting). Image size: 191670156 bytes.
  Normal   Created         11h                kubelet            Created container nginx
  Normal   Started         11h                kubelet            Started container nginx
  Normal   SandboxChanged  18m                kubelet            Pod sandbox changed, it will be killed and re-created.
  Normal   Pulling         18m                kubelet            Pulling image "nginx"
  Normal   Pulled          18m                kubelet            Successfully pulled image "nginx" in 3.14s (3.14s including waiting). Image size: 191670156 bytes.
  Normal   Created         18m                kubelet            Created container nginx
  Normal   Started         18m                kubelet            Started container nginx
```

### Pods Reference
[Click here](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/) for more details about pods.

### Yaml definition file
In Kubernetes, YAML definition files are used because they provide a human-readable, structured way to define the desired state of your cluster components like pods, services, and deployments, making it easy to manage and understand complex configurations, while also allowing for version control and easy deployment updates across different environments.

Each definition have some default format looks like below.
```yaml
---
# Api version to use.
# Pod v1
# Service v1
# ReplicationController v1
# ReplicaSet apps/v1
# Deployment apps/v1
apiVersion: 
# The kind of item going to implement like Pod, Service, Replicaset and Deployment
kind:
# name and labels of the item. Labels used to identify the item on the cluster
metadata:
# Specification for the implementation
spec:
```
### Create pods using yaml file

#### Yaml structure for pods definition
```yaml
---
apiVersion: v1
kind: Pod
metadata:
    name: myapp-nginx
    labels:
        app: myapp
        type: front-end
spec:
    containers:
        - name: nginx-container
          image: nginx

```
#### Create pod from the definition file
Create pod
```shell
kubectl create -f pod-def.yml
pod/myapp-nginx created
```
Check the status
```shell
kubectl get pods -o wide
NAME          READY   STATUS    RESTARTS      AGE     IP           NODE       NOMINATED NODE   READINESS GATES
myapp-nginx   1/1     Running   0             2m58s   10.244.0.7   minikube   <none>           <none>
nginx         1/1     Running   1 (12h ago)   13h     10.244.0.5   minikube   <none>           <none>
```

## Replication Controller/Replica set

Replication controller take care of running pod on the cluster. If the pod get failed due to some reason then the Replication controller start the pod on same node or different node on the cluster. Also the Replication controller maintain the desired replica set for the pod.

Another reason we need replication controller is to create multiple pods to share the load accross the nodes.
Let say we have single pod running on node to serve users and when there is a increase in user traffic we can deploy additional pod on the same/different node to handle the request. Further increase in the traffic we can deploy additional pod on current node or another node on the cluster. By this way the load getting sharded among pods on different nodes.

ReplicationController and ReplicaSet do the same thing but both are different. ReplicationController is older one and the ReplicaSet is new one. By using replication controller we can control the running replica at the time of creation and we can't change replica of running pod but we can achieve it on ReplicaSet.

### ReplicationController definition
```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: myapp-rc
  labels:
    app: myapp
    type: front-end
spec:
  template:
    metadata:
      name: myapp-pod
      labels:
        app: myapp
        type: front-end
    spec:
      containers:
      - name: nginx-controller
        image: nginx
  replicas: 3
```

### Create and get details about replication controller
```shell
[kannan@workstation ReplicasYaml]$kubectl create -f replicaControl.yml 
replicationcontroller/myapp-rc created
[kannan@workstation ReplicasYaml]$kubectl get replicationcontrollers
NAME       DESIRED   CURRENT   READY   AGE
myapp-rc   3         3         0       4s
[kannan@workstation ReplicasYaml]$kubectl describe replicationcontrollers myapp-rc
Name:         myapp-rc
Namespace:    default
Selector:     app=myapp,type=front-end
Labels:       app=myapp
              type=front-end
Annotations:  <none>
Replicas:     3 current / 3 desired
Pods Status:  1 Running / 2 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:  app=myapp
           type=front-end
  Containers:
   nginx-controller:
    Image:         nginx
    Port:          <none>
    Host Port:     <none>
    Environment:   <none>
    Mounts:        <none>
  Volumes:         <none>
  Node-Selectors:  <none>
  Tolerations:     <none>
Events:
  Type    Reason            Age   From                    Message
  ----    ------            ----  ----                    -------
  Normal  SuccessfulCreate  7s    replication-controller  Created pod: myapp-rc-cjtk4
  Normal  SuccessfulCreate  7s    replication-controller  Created pod: myapp-rc-nzrck
  Normal  SuccessfulCreate  7s    replication-controller  Created pod: myapp-rc-bt7n5
[kannan@workstation ReplicasYaml]$
```

### How to increase the replica count on controller?

#### Scale up/down replicas by updating definition file

Update the replicas count on the definition file and run below command to change.

```shell
[kannan@workstation ReplicasYaml]$grep replicas replicaControl.yml 
  replicas: 3
[kannan@workstation ReplicasYaml]$kubectl get replicationcontroller
NAME       DESIRED   CURRENT   READY   AGE
myapp-rc   3         3         3       4m20s
[kannan@workstation ReplicasYaml]$vi replicaControl.yml
[kannan@workstation ReplicasYaml]$grep replicas replicaControl.yml 
  replicas: 2
[kannan@workstation ReplicasYaml]$kubectl replace -f replicaControl.yml 
replicationcontroller/myapp-rc replaced
[kannan@workstation ReplicasYaml]$kubectl get replicationcontroller
NAME       DESIRED   CURRENT   READY   AGE
myapp-rc   2         2         2       4m36s
[kannan@workstation ReplicasYaml]$
```

#### Scale up/down replicas from cli

```shell
[kannan@workstation ReplicasYaml]$kubectl scale --replicas=3 replicationcontroller myapp-rc
replicationcontroller/myapp-rc scaled
[kannan@workstation ReplicasYaml]$kubectl describe replicationcontroller myapp-rc
Name:         myapp-rc
Namespace:    default
Selector:     app=myapp,type=front-end
Labels:       app=myapp
              type=front-end
Annotations:  <none>
Replicas:     3 current / 3 desired
Pods Status:  2 Running / 1 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:  app=myapp
           type=front-end
  Containers:
   nginx-controller:
    Image:         nginx
    Port:          <none>
    Host Port:     <none>
    Environment:   <none>
    Mounts:        <none>
  Volumes:         <none>
  Node-Selectors:  <none>
  Tolerations:     <none>
Events:
  Type    Reason            Age   From                    Message
  ----    ------            ----  ----                    -------
  Normal  SuccessfulCreate  18m   replication-controller  Created pod: myapp-rc-cjtk4
  Normal  SuccessfulCreate  18m   replication-controller  Created pod: myapp-rc-nzrck
  Normal  SuccessfulCreate  18m   replication-controller  Created pod: myapp-rc-bt7n5
  Normal  SuccessfulDelete  17m   replication-controller  Deleted pod: myapp-rc-cjtk4
  Normal  SuccessfulCreate  15m   replication-controller  Created pod: myapp-rc-v6vch
  Normal  SuccessfulDelete  14m   replication-controller  Deleted pod: myapp-rc-v6vch
  Normal  SuccessfulCreate  3s    replication-controller  Created pod: myapp-rc-7r9ds
[kannan@workstation ReplicasYaml]$
```

### Create replicaset

Yaml definition for replicaset
```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: myapp-replicaset
  labels:
    name: myapp
    type: front-end
spec:
  template:
    metadata:
      name: myapp-pod
      labels:
        app: myapp
        type: front-end
    spec:
      containers:
      - name: nginx-container
        image: nginx
  replicas: 3
  selector:
    matchLabels:
      type: front-end
```

Replication creation and get details about the replicaset.

```shell
[kannan@workstation ReplicasYaml]$kubectl create -f replicaset.yml 
replicaset.apps/myapp-replicaset created
[kannan@workstation ReplicasYaml]$kubectl get replicaset
NAME               DESIRED   CURRENT   READY   AGE
myapp-replicaset   3         3         1       7s
[kannan@workstation ReplicasYaml]$kubectl describe replicaset myapp-replicaset
Name:         myapp-replicaset
Namespace:    default
Selector:     type=front-end
Labels:       name=myapp
              type=front-end
Annotations:  <none>
Replicas:     3 current / 3 desired
Pods Status:  3 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:  app=myapp
           type=front-end
  Containers:
   nginx-container:
    Image:         nginx
    Port:          <none>
    Host Port:     <none>
    Environment:   <none>
    Mounts:        <none>
  Volumes:         <none>
  Node-Selectors:  <none>
  Tolerations:     <none>
Events:
  Type    Reason            Age   From                   Message
  ----    ------            ----  ----                   -------
  Normal  SuccessfulCreate  22s   replicaset-controller  Created pod: myapp-replicaset-c5kjb
  Normal  SuccessfulCreate  22s   replicaset-controller  Created pod: myapp-replicaset-tn4tj
  Normal  SuccessfulCreate  22s   replicaset-controller  Created pod: myapp-replicaset-9r989
[kannan@workstation ReplicasYaml]$
```

### Scale up/down replicaset from cli
```shell
[kannan@workstation ReplicasYaml]$kubectl scale --replicas=6 replicaset myapp-replicaset
replicaset.apps/myapp-replicaset scaled
[kannan@workstation ReplicasYaml]$kubectl get replicaset
NAME               DESIRED   CURRENT   READY   AGE
myapp-replicaset   6         6         4       13m
[kannan@workstation ReplicasYaml]$kubectl get replicaset
NAME               DESIRED   CURRENT   READY   AGE
myapp-replicaset   6         6         6       14m
[kannan@workstation ReplicasYaml]$kubectl get pods
NAME                     READY   STATUS    RESTARTS      AGE
myapp-nginx              1/1     Running   1 (12d ago)   12d
myapp-rc-7r9ds           1/1     Running   0             5m17s
myapp-rc-bt7n5           1/1     Running   0             24m
myapp-rc-nzrck           1/1     Running   0             24m
myapp-replicaset-9r989   1/1     Running   0             13m
myapp-replicaset-bccb8   1/1     Running   0             16s
myapp-replicaset-c5kjb   1/1     Running   0             13m
myapp-replicaset-h7vbj   1/1     Running   0             16s
myapp-replicaset-lc9sh   1/1     Running   0             16s
myapp-replicaset-tn4tj   1/1     Running   0             13m
nginx                    1/1     Running   2 (12d ago)   13d
postgres                 1/1     Running   1 (12d ago)   12d
[kannan@workstation ReplicasYaml]$
```

### Delete replicaset

```shell
[kannan@workstation ReplicasYaml]$kubectl get replicaset
NAME               DESIRED   CURRENT   READY   AGE
myapp-replicaset   2         2         2       16m
[kannan@workstation ReplicasYaml]$kubectl delete replicaset myapp-replicaset
replicaset.apps "myapp-replicaset" deleted
[kannan@workstation ReplicasYaml]$
```

## Deployments
A Kubernetes deployment is a resource object that manages the lifecycle of containerized applications. It allows administrators to define the desired state of an application, and Kubernetes will work to ensure that state is achieved. 

### What does a Kubernetes deployment do? 
- Defines the desired state of an application
- Manages the application's life cycle
- Enables automated rollouts and rollbacks
- Eliminates the need for manual updates and deployments

### How does a Kubernetes deployment work? 
- The Kubernetes control plane monitors the cluster and compares the actual state with the desired state
- If discrepancies are detected, the control plane takes action to achieve the desired state

### What are some Kubernetes deployment strategies?
#### Rolling deployment
The default deployment strategy, which incrementally replaces pod instances with new instances 
#### Blue-green deployment
Deploys a new version of the application alongside the old one, and then switches traffic to the new version once it's stable 
#### Shadow deployment
Deploys a new version of the application alongside the existing version, but only directs traffic to the existing version 

### Deployment definition yaml
```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deployment
  labels:
    app: myapp
    type: frontend
spec:
  template:
    metadata:
      name: myapp-pod
      labels:
        app: myapp
        type: frontend
    spec:
      containers:
      - name: nginx-container
        image: nginx:1.26
  replicas: 3
  selector:
    matchLabels:
      type: frontend
...
```

### Create deployment
```shell
kubectl create -f deployment_def.yml
```

### Check status of deployment
```shell
# To view deployment
kubectl get deployment
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
myapp-deployment   3/3     3            3           17m

# To view replicaset created by deployment
kubectl get replicaset
NAME                          DESIRED   CURRENT   READY   AGE
myapp-deployment-7c685b9458   3         3         3       11m

# To view pods created by deployment
kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
myapp-deployment-7c685b9458-6t8xl   1/1     Running   0          11m
myapp-deployment-7c685b9458-dcpqt   1/1     Running   0          11m
myapp-deployment-7c685b9458-xcxsm   1/1     Running   0          11m
```

### Check rollout status
```shell
kubectl rollout status deployment/myapp-deployment
```

### Check rollout revision history
```shell
kubectl rollout history deployment/myapp-deployment
```

### Perform the Rolling Deployment
The Rolling Deployment create new replicaset and create pod with new version image and delete pod from old replicaset. The image version can be update by 2 methods. Edit deployment definition file and update the docker image version and apply the configuration.


#### Method#1: Updating yaml file with the nginx image version to latest
```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-deployment
  labels:
    app: hr-webapp
    type: front-end
spec:
  template:
    metadata:
      name: webapp-pods
      labels:
        app: hr-webapp
        type: front-end
    spec:
      containers:
        - name: nginx-container
          image: nginx:latest
  replicas: 3
  selector:
    matchLabels:
      app: hr-webapp
...
```
```shell
# Apply the rolling update
kubectl apply -f webapp_deployment.yml --record
# Get status of the rolling update
kubectl rollout status deployment/webapp-deployment
kubectl rollout history deployment/webapp-deployment
kubectl describe deployment/webapp-deployment
```

#### Method#2: Edit the running deployment and update nginx version
```shell
# Change the version, save and quit. 
kubectl edit deployment webapp-deployment --record
# Here --record will update the change cause for rollout
# Get status of the rolling update
kubectl rollout status deployment/webapp-deployment
kubectl rollout history deployment/webapp-deployment
kubectl describe deployment/webapp-deployment
```

#### Method#3: Update the container image version directly
```shell
# Update the version of the container image from cli
kubectl set image deployment/webapp-deployment nginx-conatiner=nginx:latest --record
# Get the status of rollout
kubectl rollout status deployment/webapp-deployment
```

### Rollback the deployment
```shell
kubectl rollout undo deployment/webapp-deployment
```

### Kubenetes Networking
In docker the IP address assigned to container and in k8s cluster the IP address assigned to POD. Each pod on the cluster will get assign to an ipaddress at the time of creation.
Pods can communicate with each other through IP address configured on the local network. Pods can't access the pods on other nodes using this local IP address.

k8s cluster expect as conifgure the network that should meet below criteria.

- All containers/pods can communicate to one another without NAT.
- All nodes can communicate with all containers and vice-versa without NAT.

We no need to build our own networking as there are multiple pre build networking solutions available and they are cisco ACI network, cilium, flannel, calico, nsx, Big cloud fabric, etc,.

### Kubernetes Service
Kubernetes Services are an abstraction that defines a logical set of Pods and a policy by which to access them. Here's a concise overview:

#### Purpose
 - Enable reliable network access to Pods, which are ephemeral (can be created and destroyed).
 - Provide a stable IP address and DNS name for a group of Pods.
 - Load balance traffic across multiple Pods.
#### Types
##### ClusterIP
 - Exposes the Service on an internal IP in the cluster.
 - Only reachable from within the cluster.
 - Default Service type.
Example#1
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-app-service
spec:
  selector:
    app: my-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: ClusterIP
```
Example#2
```yaml
apiVersion: v1
kind: Service
metadata:
  name: image-processing
  labels:
    app: myapp
spec:
  type: ClusterIP
  ports:
    - targetPort: 8080
      port: 80
  selector:
    tier: backend
```
##### NodePort
 - Exposes the Service on a static port on each Node's IP.
 - Allows external access to the Service via <NodeIP>:<NodePort>.
 - ClusterIP Service is automatically created.
 - Node port range from 30000 to 32767
Example#1:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
spec:
  type: NodePort
  ports:
    - targetPort: 80
      port: 80
      nodePort: 30080
  selector:
    app: hrapp
```
Example#2
```yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend
  label:
    app: myapp
spec:
  type: NodePort
  ports:
    - targetPort: 80
      port: 80
  selector:
    app: myapp
```

##### LoadBalancer
 - Exposes the Service externally using a cloud provider's load balancer.
 - External traffic is routed to the NodePort and ClusterIP Services.
 - Cloud provider specific.
##### ExternalName
 - Maps the Service to an external DNS name.
 - Does not create a ClusterIP.
 - Useful for accessing services outside the cluster.
#### Selectors
 - Services use selectors to determine which Pods they target.
 - Selectors match Pod labels.
#### Benefits
 - Decoupling: Services decouple applications from individual Pods.
 - Scalability: Load balancing distributes traffic across multiple Pods, improving scalability.
 - Reliability: Services ensure consistent access to applications, even if Pods fail.
 - Discovery: Internal DNS names allow other pods within the cluster to easily discover the service.
### Key Components
#### Label Selector
Services use labels to find the pods they need to route traffic to.
#### Ports
Each service specifies a set of ports that define how to connect to the pods.
#### Endpoints
These are automatically managed by Kubernetes and represent the actual pods that are part of the service.
### 
### Accessing Services
You can access and manage services using the kubectl command. For example, running `kubectl get svc` lists all services in the cluster, showing details such as type, cluster IP, external IP, and ports.
