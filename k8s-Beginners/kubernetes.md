# Kubernetes Notes
## Daemon run on master
kube-apiserver - which is cluster manager and the kubectl command communicate to the apiserver to get and perform the action on resources. When we retreive resource details the api server get it from ETCD. When we perform the action on resources then it will go to scheduler to select the node and communicate the action to the kubelet on the worker node to perform the action. 

etcd: This is a key-value pair storage used to store all resource details

kube-scheduler: It will select the node to run the resources.

kube-controller-manager: Its monitor the all resources and service on the cluster to ensure the resources are in desired state. if found any issue on any of the resource then remediate it. 

node-controller: monitor the nodes every 5s secs through apiserver and mark it as inactive found issue on the node and move the pod from the problematic node to running node.

replication-controller: it will maintain the replication set as per configuration and start the pod if any issue found.


## Daemon on worker
kubelet: receive instruction from kube-apiserver and perform the action and provide the status back to the api-server which get store on etcd
kube-proxy:

## k8s ETCD
Its distributed reliable key-value store that is simple, secure and fast. ETCD listen on port 2379.
### Get stored keys from etcd
```
kubectl get pods -A
#copy the etcd pod name and describe
kubectl exec etcd-controlplane -n kube-system -- etcdctl get / --prefix --keys-only
```

## Install Kubernetes on Ubuntu
[Click here](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/) for latest document to install kubernetes on server.
- Turn off the swap and disable swap

```
swapoff -a
```

- port 6443 need to open for communicate between master and worked nodes
```
nc 127.0.0.1 6443 -v
```
- Install required packages
```
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
```
- Download public signed key. Create /etc/apt/keyrings/ if not exists
```
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```
- Add the apt source for k8s
```
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
```
- Install kubeadm, kubelet and kubectl and pin their version
```
sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubectl docker.io && sudo apt-mark hold kubelet kubeadm kubectl
```
- Enable kubelet before running kubeadm
```
sudo systemctl enable --now kubelet
```

## Initialize the k8s cluster
If you have multiple IP on the server then you need to specify the IP address to use for cluster communication and also you can specify the IP address need to use for pods.
```
sudo kubeadm init --apiserver-advertise-address 172.168.1.150 --pod-network-cidr="172.16.0.0/16"
```
The init will take time and provide token to join the cluster. Also need to configure the local user to run the kubectl command by performing following steps.

## Apply any configuration
```
kubectl apply -f input.yml
```

## Sample for nginx deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2 # tells deployment to run 2 pods matching the template
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```
Now apply this deployment on cluster.
```
kubectl apply -f nginx.yml 
deployment.apps/nginx-deployment created
```
If no error reported then it will show the deployment created and we can see the status by below.
```
kubectl get deploy
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   2/2     2            2           7s
```
Here the "READY" column will show how many replica created for this deployment. Use below command to get the pods on the cluster.
```
kubectl get pods
NAME                               READY   STATUS    RESTARTS   AGE
nginx-deployment-d556bf558-6n5r5   1/1     Running   0          36s
nginx-deployment-d556bf558-wzhxf   1/1     Running   0          36s
```
Here the "READY" column will show how many container running on the pod. In our sample deployment we are just using image nginx and the pod will have one container.

Now change replica count on the yaml file and apply the config.
```
kubectl apply -f nginx.yml 
deployment.apps/nginx-deployment configured
```
Verify the deploy and pods for the change.
```
~/kannan ➜  kubectl get deploy
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   1/1     1            1           2m19s
~/kannan ➜  kubectl get pods
NAME                               READY   STATUS    RESTARTS   AGE
nginx-deployment-d556bf558-6n5r5   1/1     Running   0          2m25s
```
We can also edit running configuration using kubectl edit.
```
kubectl edit deploy nginx-deployment
```
This will open the configuration in vi editor and we can able to edit few fields like replica,etc,..

If the yaml file got deleted accidently and it was applied on cluster then we can retrive the configuration using "kubectl edit" or "kubectl get".
```
kubectl get deploy nginx-deployment -o yaml
```

> Service Object: In Kubernetes, a Service is a method for exposing a network application that is running as one or more Pods in your cluster.

Get IP details and port details.
```
kubectl get svc
NAME         TYPE           CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
knote        LoadBalancer   10.43.60.38   <pending>     80:30000/TCP   3m8s
kubernetes   ClusterIP      10.43.0.1     <none>        443/TCP        45m
mongo        ClusterIP      10.43.96.63   <none>        27017/TCP      3m43s
```
```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: knote
spec:
  replicas: 1
  selector:
    matchLabels:
      app: knote
      tier: frontend
  template:
    metadata:
      labels:
        app: knote
        tier: frontend
    spec:
      containers:
        - name: app
          image: learnitguide/knotejs:1.0
          ports:
            - containerPort: 3000
          env:
            - name: MONGO_URL
              value: mongodb://mongo:27017/dev

---
apiVersion: v1
kind: Service
metadata:
  name: knote
spec:
  selector:
    app: knote
    tier: frontend

  ports:
    - port: 80
      targetPort: 3000
      nodePort: 30000
  type: NodePort
```
```
controlplane ~/kannan/knote ➜  kubectl apply -f mongo.yml 
deployment.apps/mongo created
service/mongo created

controlplane ~/kannan/knote ➜  vi knote.yml

controlplane ~/kannan/knote ➜  kubectl apply -f knote.yml 
deployment.apps/knote created
service/knote created

controlplane ~/kannan/knote ➜  kubectl get deploy
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
knote              0/1     1            0           5s
mongo              1/1     1            1           40s
nginx-deployment   1/1     1            1           26m

controlplane ~/kannan/knote ➜  kubectl get pods
NAME                               READY   STATUS    RESTARTS        AGE
knote-97574c78f-4rqbs              1/1     Running   0               13s
mongo-5cbfdbf5d7-d8bwp             1/1     Running   0               48s
newpods-c5fxf                      1/1     Running   1 (9m10s ago)   25m
newpods-hrzk5                      1/1     Running   1 (13m ago)     30m
newpods-hwbm6                      1/1     Running   1 (13m ago)     30m
nginx                              1/1     Running   0               29m
nginx-deployment-d556bf558-6n5r5   1/1     Running   0               27m

controlplane ~/kannan/knote ➜  kubectl get pods -o wide
NAME                               READY   STATUS    RESTARTS        AGE   IP           NODE           NOMINATED NODE   READINESS GATES
knote-97574c78f-4rqbs              1/1     Running   0               29s   10.42.0.17   controlplane   <none>           <none>
mongo-5cbfdbf5d7-d8bwp             1/1     Running   0               64s   10.42.0.16   controlplane   <none>           <none>
newpods-c5fxf                      1/1     Running   1 (9m26s ago)   26m   10.42.0.15   controlplane   <none>           <none>
newpods-hrzk5                      1/1     Running   1 (14m ago)     30m   10.42.0.9    controlplane   <none>           <none>
newpods-hwbm6                      1/1     Running   1 (14m ago)     30m   10.42.0.10   controlplane   <none>           <none>
nginx                              1/1     Running   0               29m   10.42.0.12   controlplane   <none>           <none>
nginx-deployment-d556bf558-6n5r5   1/1     Running   0               27m   10.42.0.13   controlplane   <none>           <none>

controlplane ~/kannan/knote ➜  
```

## K8s networking and services
These are the networking available on k8s.

- Container to container
    - container within the pod dont have IP address and they listen on PORT and the communication can happen by using the port with the pod.
- POD to POD 
    - Intra node pod network communication
        - The communication happening between pods on same node
        - By default the communication enabled between pods on same node by using the bridge network
    - Inter node pod network communication
        - The communication happening between pods on different node
        - We need external plugin like Fannel, calico to communicate between pods accross different node
- POD to Service
    - To communicate to the container we need service object
    - From service object we can decide whether to communicate internal or external
    - POD to service is one communication and External to Service is another communication
    - We dont have any type on POD to service communication but we have 4 types on External to service communication
- External to service communication
    - Those types are ClusterIP, NodePort, LoadBalancer and ExternalName
    - ClusterIP: Local kubernetes Kube-DNS this is the default service and we can use this to communicate internal to the cluster. We can use it for backend application
    - NodePort and LoadBalancer we can access it from outside the cluster
    - NodePort: We can map the container to node port and we can access with WorkernodeIP:port
    - LoadBalancer: The cloud provider need to provide as the public IP to configure the loadbalancer
    - ExternalName: We can add service IP from different cluster by adding DNS CNAME record and make communication

## K8s Namespaces
In Kubernetes, namespaces provide a mechanism for isolating groups of resources within a single cluster. Names of resources need to be unique within a namespace, but not across namespaces.

### Initial namespaces
Kubernetes starts with four initial namespaces:

- default: Kubernetes includes this namespace so that you can start using your new cluster without first creating a namespace.
- kube-node-lease: This namespace holds Lease objects associated with each node. Node leases allow the kubelet to send heartbeats so that the control plane can detect node failure.
- kube-public: This namespace is readable by all clients (including those not authenticated). This namespace is mostly reserved for cluster usage, in case that some resources should be visible and readable publicly throughout the whole cluster. The public aspect of this namespace is only a convention, not a requirement.
- kube-system: The namespace for objects created by the Kubernetes system.

### To Get list of namespaces.
```
kubectl get ns
NAME              STATUS   AGE
default           Active   31m
kube-node-lease   Active   31m
kube-public       Active   31m
kube-system       Active   31m
```
### Deploy app on different namespace
```yaml
cat busapp.yml 
---
apiVersion: v1
kind: Namespace
metadata:
  name: develop

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: busapp
  namespace: develop
spec:
  replicas: 1
  selector:
    matchLabels:
      app: bus
      tier: frontend
  template:
    metadata:
      labels:
        app: bus
        tier: frontend
    spec:
      containers:
        - name: busapp
          image: learnitguide/busapp:1.0
          ports:
            - containerPort: 8001
---
apiVersion: v1
kind: Service
metadata:
  name: busapp
  namespace: develop
spec:
  selector:
    app: bus
    tier: frontend
  ports:
    - port: 80
      targetPort: 8001
      nodePort: 30002
  type: NodePort
```
### Apply the configuration to create new namespace
```
controlplane ~/kannan/develop ➜  kubectl apply -f busapp.yml 
namespace/develop unchanged
deployment.apps/busapp unchanged
service/busapp created

controlplane ~/kannan/develop ➜  kubectl get ns
NAME              STATUS   AGE
default           Active   55m
develop           Active   25s
kube-node-lease   Active   55m
kube-public       Active   55m
kube-system       Active   55m

controlplane ~/kannan/develop ➜  kubectl get pods -n develop
NAME                     READY   STATUS    RESTARTS   AGE
busapp-9d6594576-m4b46   1/1     Running   0          33s

controlplane ~/kannan/develop ➜  kubectl get svc -n develop
NAME     TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
busapp   NodePort   10.43.79.93   <none>        80:30002/TCP   24s
```
### To get resource from the particular namespace
```
controlplane ~/kannan ➜  kubectl get pods -n kube-system
NAME                                      READY   STATUS      RESTARTS   AGE
coredns-5dd589bf46-knd8c                  1/1     Running     0          31m
helm-install-traefik-crd-nxdb4            0/1     Completed   0          31m
helm-install-traefik-tgmvc                0/1     Completed   2          31m
local-path-provisioner-846b9dcb6c-zd8hl   1/1     Running     0          31m
metrics-server-5dc58b587c-br72q           1/1     Running     0          31m
svclb-traefik-792d20fc-t2mcb              2/2     Running     0          31m
traefik-7f4b44bf74-fn95w                  1/1     Running     0          31m

controlplane ~/kannan ➜  kubectl get svc -n kube-system
NAME             TYPE           CLUSTER-IP     EXTERNAL-IP    PORT(S)                      AGE
kube-dns         ClusterIP      10.43.0.10     <none>         53/UDP,53/TCP,9153/TCP       37m
metrics-server   ClusterIP      10.43.131.39   <none>         443/TCP                      37m
traefik          LoadBalancer   10.43.101.52   192.35.189.9   80:31076/TCP,443:32692/TCP   36m

controlplane ~/kannan ➜ 
```
### To get Resources from all namespace
```
controlplane ~/kannan/develop ➜  kubectl get pods -A
NAMESPACE     NAME                                      READY   STATUS      RESTARTS   AGE
default       busapp-9d6594576-d58cr                    1/1     Running     0          12m
default       knote-97574c78f-cplvc                     1/1     Running     0          39m
default       mongo-5cbfdbf5d7-x4jtv                    1/1     Running     0          40m
develop       busapp-9d6594576-m4b46                    1/1     Running     0          6m20s
kube-system   coredns-5dd589bf46-knd8c                  1/1     Running     0          61m
kube-system   helm-install-traefik-crd-nxdb4            0/1     Completed   0          61m
kube-system   helm-install-traefik-tgmvc                0/1     Completed   2          61m
kube-system   local-path-provisioner-846b9dcb6c-zd8hl   1/1     Running     0          61m
kube-system   metrics-server-5dc58b587c-br72q           1/1     Running     0          61m
kube-system   svclb-traefik-792d20fc-t2mcb              2/2     Running     0          60m
kube-system   traefik-7f4b44bf74-fn95w                  1/1     Running     0          60m

controlplane ~/kannan/develop ➜  kubectl get svc -A
NAMESPACE     NAME             TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)                      AGE
default       busapp           NodePort       10.43.211.162   <none>         80:30001/TCP                 10m
default       knote            NodePort       10.43.225.250   <none>         80:30000/TCP                 40m
default       kubernetes       ClusterIP      10.43.0.1       <none>         443/TCP                      61m
default       mongo            ClusterIP      10.43.93.99     <none>         27017/TCP                    40m
develop       busapp           NodePort       10.43.79.93     <none>         80:30002/TCP                 6m6s
kube-system   kube-dns         ClusterIP      10.43.0.10      <none>         53/UDP,53/TCP,9153/TCP       61m
kube-system   metrics-server   ClusterIP      10.43.131.39    <none>         443/TCP                      61m
kube-system   traefik          LoadBalancer   10.43.101.52    192.35.189.9   80:31076/TCP,443:32692/TCP   60m

controlplane ~/kannan/develop ➜ 
```
## k8s secrets
Secrets object used to store senstive data like password, ssh key, ssl cert, token, etc,.
While create the secrets we need to mention the type of secrets we are going to store. Type Opaque is User defined key:value secret.
### Sample secret file
```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: mysql-cred
type: Opaque
data:
  MYSQL_ROOT_PASSWORD: YWJjQDEyMw==
  MYSQL_USER: a2FubmFu
  MYSQL_PASSWORD: YWJjQDEyMw==
```
> The secret value need to be encoded as base64 and we can encode using command `echo -n SecretValue | base64 -w0` .

Now create the secret using above templete.
```
controlplane ~/kannan/secrets ➜  kubectl apply -f secret.yml 
secret/mysql-cred created

controlplane ~/kannan/secrets ➜  kubectl get secret
NAME         TYPE     DATA   AGE
mysql-cred   Opaque   3      8s

controlplane ~/kannan/secrets ➜  kubectl describe secret mysql-cred
Name:         mysql-cred
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
MYSQL_PASSWORD:       7 bytes
MYSQL_ROOT_PASSWORD:  7 bytes
MYSQL_USER:           6 bytes

controlplane ~/kannan/secrets ➜ 
```
### Get the actual value from the secret
```
controlplane ~/kannan/secrets ➜  kubectl describe secret mysql-cred
Name:         mysql-cred
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
MYSQL_PASSWORD:       7 bytes
MYSQL_ROOT_PASSWORD:  7 bytes
MYSQL_USER:           6 bytes

controlplane ~/kannan/secrets ➜  kubectl get secret mysql-cred -o jsonpath='{.data.MYSQL_ROOT_PASSWORD}'
YWJjQDEyMw==
controlplane ~/kannan/secrets ➜  kubectl get secret mysql-cred -o jsonpath='{.data.MYSQL_ROOT_PASSWORD}' |base64 -d
abc@123
controlplane ~/kannan/secrets ➜ 
```

### Use the secret to deploy mariadb
```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: mariadb
  name: mariadb-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mariadb
  template:
    metadata:
      labels:
        app: mariadb
    spec:
      containers:
      - name: mariadb
        image: docker.io/mariadb:10.4
        ports:
        - containerPort: 3306
          protocol: TCP
        env:
          - name: MYSQL_ROOT_PASSWORD
            valueFrom:
              secretKeyRef:
                name: mysql-cred
                key: MYSQL_ROOT_PASSWORD
        envFrom:
        - secretRef:
            name: mysql-cred
---
apiVersion: v1
kind: Service
metadata:
  name: mariadb
spec:
  selector:
    app: mariadb
  type: NodePort
  ports:
    - port: 3306
      targetPort: 3306
      nodePort: 30000

```

### Check the environment variable on container
```bash
controlplane ~/kannan/secrets ➜  kubectl get pods
NAME                                  READY   STATUS    RESTARTS   AGE
mariadb-deployment-6f45b8d7d6-56jbl   1/1     Running   0          13m

controlplane ~/kannan/secrets ➜ kubectl exec -it mariadb-deployment-6f45b8d7d6-56jbl -- /bin/bash
root@mariadb-deployment-6f45b8d7d6-56jbl:/# printenv |grep MYSQL
MYSQL_ROOT_PASSWORD=abc@123
MYSQL_PASSWORD=abc@123
MYSQL_USER=kannan
root@mariadb-deployment-6f45b8d7d6-56jbl:/#
```

### Check the mariadb access after resource creation
```shell
controlplane ~/kannan/secrets ➜  kubectl get svc
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
kubernetes   ClusterIP   10.43.0.1       <none>        443/TCP          61m
mariadb      NodePort    10.43.246.180   <none>        3306:30000/TCP   5m18s

controlplane ~/kannan/secrets ➜ mysql -h 10.43.246.180 -u root -p
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 11
Server version: 10.4.34-MariaDB-1:10.4.34+maria~ubu2004 mariadb.org binary distribution

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]>
```
### Mount secret as volume
```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: mariadb
  name: mariadb-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mariadb
  template:
    metadata:
      labels:
        app: mariadb
    spec:
      volumes:
        - name: newsecret
          secret:
            secretName: mysql-cred
      containers:
      - name: mariadb
        image: docker.io/mariadb:10.4
        ports:
        - containerPort: 3306
          protocol: TCP
        volumeMounts:
          - name: newsecret
            mountPath: "/etc/newsecret"
            readOnly: true
        env:
          - name: MYSQL_ROOT_PASSWORD
            valueFrom:
              secretKeyRef:
                name: mysql-cred
                key: MYSQL_ROOT_PASSWORD
        envFrom:
        - secretRef:
            name: mysql-cred
---
apiVersion: v1
kind: Service
metadata:
  name: mariadb
spec:
  selector:
    app: mariadb
  type: NodePort
  ports:
    - port: 3306
      targetPort: 3306
      nodePort: 30000

```
### Check the container for secret
```
controlplane ~/kannan ➜  kubectl get pods
NAME                                  READY   STATUS    RESTARTS   AGE
mariadb-deployment-697d4b7d5d-d7t7q   1/1     Running   0          3m47s

controlplane ~/kannan ➜  kubectl get svc
NAME         TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE
kubernetes   ClusterIP   10.43.0.1     <none>        443/TCP          22m
mariadb      NodePort    10.43.71.77   <none>        3306:30000/TCP   4m50s

controlplane ~/kannan ✖ kubectl exec -it mariadb-deployment-697d4b7d5d-d7t7q -- bash
root@mariadb-deployment-697d4b7d5d-d7t7q:/# df -hP /etc/newsecret
Filesystem      Size  Used Avail Use% Mounted on
tmpfs           205G   12K  205G   1% /etc/newsecret
root@mariadb-deployment-697d4b7d5d-d7t7q:/# cd /etc/newsecret/
root@mariadb-deployment-697d4b7d5d-d7t7q:/etc/newsecret# ls 
MYSQL_PASSWORD  MYSQL_ROOT_PASSWORD  MYSQL_USER
root@mariadb-deployment-697d4b7d5d-d7t7q:/etc/newsecret# cat MYSQL_ROOT_PASSWORD 
abc@123root@mariadb-deployment-697d4b7d5d-d7t7q:/etc/newsecret# 
```
## ConfigMaps
A ConfigMap is an API object used to store non-confidential data in key-value pairs. Pods can consume ConfigMaps as environment variables, command-line arguments, or as configuration files in a volume.
### List out configMap
```
controlplane ~/kannan ➜  kubectl get cm
NAME               DATA   AGE
kube-root-ca.crt   1      29m

controlplane ~/kannan ➜ 
```
### Create configMap
```
controlplane ~/kannan ➜  cat mysql-extra.conf 
[mysqld]
max_allowed_packet = 64M

controlplane ~/kannan ➜ kubectl create cm mysql-extra --from-file=mysql-extra.conf
controlplane ~/kannan ➜  kubectl get cm
NAME               DATA   AGE
kube-root-ca.crt   1      58m
mysql-extra        1      6m25s

controlplane ~/kannan ➜ kubectl create cm input --from-literal=name=kannan
```
```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: mariadb
  name: mariadb-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mariadb
  template:
    metadata:
      labels:
        app: mariadb
    spec:
      volumes:
        - name: newsecret
          secret:
            secretName: mysql-cred
        - name: newcm
          configMap:
            name: mysql-extra
      containers:
      - name: mariadb
        image: docker.io/mariadb:10.4
        ports:
        - containerPort: 3306
          protocol: TCP
        volumeMounts:
          - name: newsecret
            mountPath: "/etc/newsecret"
            readOnly: true
          - name: newcm
            mountPath: /etc/mysql/conf.d
            readOnly: true
        env:
          - name: MYSQL_EXTRA_CONFIG
            valueFrom:
              configMapKeyRef:
                name: input
                key: name
          - name: MYSQL_ROOT_PASSWORD
            valueFrom:
              secretKeyRef:
                name: mysql-cred
                key: MYSQL_ROOT_PASSWORD
        envFrom:
        - secretRef:
            name: mysql-cred
---
apiVersion: v1
kind: Service
metadata:
  name: mariadb
spec:
  selector:
    app: mariadb
  type: NodePort
  ports:
    - port: 3306
      targetPort: 3306
      nodePort: 30000

```
## k8s Volumes
Volumes are used to store persistent data from container.

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: volume-mount
spec:
  selector:
    matchLabels:
      app: volume-mount
  template:
    metadata:
      labels:
        app: volume-mount
    spec:
      volumes:
      - name: volume1
        hostPath:
          path: /mnt/data1
      - name: volume2
        hostPath:
          path: /mnt/data2
      containers:
      - name: nginx
        image: nginx
        volumeMounts:
        - name: volume1
          mountPath: /var/nginx-data
      - name: tomcat
        image: tomcat
        volumeMounts:
        - name: volume2
          mountPath: /var/tomcat-data
```
## k8s PersistentVolume
A PersistentVolume (PV) is a piece of storage in the cluster that has been provisioned by an administrator or dynamically provisioned using Storage Classes. It is a resource in the cluster just like a node is a cluster resource. PVs are volume plugins like Volumes, but have a lifecycle independent of any individual Pod that uses the PV. This API object captures the details of the implementation of the storage, be that NFS, iSCSI, or a cloud-provider-specific storage system.

A PersistentVolumeClaim (PVC) is a request for storage by a user. It is similar to a Pod. Pods consume node resources and PVCs consume PV resources. Pods can request specific levels of resources (CPU and Memory). Claims can request specific size and access modes (e.g., they can be mounted ReadWriteOnce, ReadOnlyMany, ReadWriteMany, or ReadWriteOncePod, see AccessModes).
```yaml
---
apiVersion: v1
kind: PersistentVolume
metadata:
    name: nginx-pv
spec:
    capacity:
        storage: 20Gi
    volumeMode: Filesystem
    accessModes:
        - ReadWriteOnce
    persistentVolumeReclaimPolicy: Recycle
    storageClassName: nginxStorage
    mountOptions:
        - nfsvers=4.1
    nfs:
        path: /nfsdata
        server: 192.168.1.7
---

---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-log
spec:
  capacity:
    storage: 100Mi
  hostPath:
    path: /pv/log
  persistentVolumeReclaimPolicy: Retain
  accessModes:
    - ReadWriteMany
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: claim-log-1
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 50Mi
```

### Create pod
```yaml
apiVersion: v1
kind: Pod
metadata:
    name: myapp-nginx
    labels:
        app: myapp-nginx
        tier: frontend
spec:
    containers:
    - name:
      image: nginx
      ports:
      - containerPort: 80

```
### Create ReplicaSet
```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
    name: myapp-replicaset
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
            - name: nginx
              image: nginx
    replicas: 3
    selector:
        matchLabels:
            app: myapp
```
### Create replicaset
```
kubectl create -f replicaset.yml
kubectl get replicaset
kubectl get pods
```
### Scale up the pods
Update the yaml file to increase the no.of replicas and replace the configuraion or change the replica count with scale command.
```
kubectl replace -f replicaset.yml
kubectl scale --replicas=6 -f replicaset.yml
kubectl scale --replicas=6 replicaset myapp-replicaset
```

### Node maintenance
Move the pods from the node.
```
kubectl drain node-1
```
Once the activity completed then make the node active
```
kubectl uncordon node-1
```

