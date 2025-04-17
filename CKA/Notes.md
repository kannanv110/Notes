# Preparing for CKA

## Below are some references:

Certified Kubernetes Administrator: https://www.cncf.io/certification/cka/

Exam Curriculum (Topics): https://github.com/cncf/curriculum

Candidate Handbook: https://www.cncf.io/certification/candidate-handbook

Exam Tips: http://training.linuxfoundation.org/go//Important-Tips-CKA-CKAD

Head over to this link to enroll in the Certification Exam. Remember to keep the code – 20KODE – handy to get a 20% discount while registering for the CKA exam with Linux Foundation.

## Kubernetes Architecture
Kubernetes cluster consists of Master node and worker node. 
### Components of Master node
Master node take care of Manage, Plan, Schedule, Monitor Nodes.
#### etcd Cluster
 - Core Data Store: Etcd serves as Kubernetes' essential distributed key-value store, holding all cluster data, including configurations, states, and metadata.
 - High Availability & Consistency: Etcd utilizes the Raft consensus algorithm to ensure high availability and data consistency across the cluster, critical for reliable Kubernetes operations.
 - Raft consensus algorithm implemented on v2.0 on Feb 2015. It allows more than 10k writes per sec.
 - ETCD listen on port 2379.
 - Everything we get/set from `kubectl` command retreived/updated from etcd cluster.
 - ETCD on manual install While starting etcd we can mention the IP address to listen on cli option `--advertise-client-urls https://ip-address:2379`.
 - ETCD on kubeadm we can get the etcd pod using `kubectl get pods -n kube-system`. This will provide the name of the pod for etcd as `etcd-master`.
 - We can retrieve the key value stored on etcd using `kubectl exec etcd-master -n kube-system etcdctl get / --prefix -keys-only`
#### etcd used to store below data on cluster
 - Nodes
 - Pods
 - Configs
 - Secrets
 - Accounts
 - Roles
 - Bindings
 - Others

#### etcd versions
etcd support 2 versions v2 and v3. 
##### Check the current version
```shell
etcdctl --version
```
##### Switch version from v2 to v3 for onetime/single execution
```shell
ETCDCTL_API=3 etcdctl version
```
##### Switch version from v2 to v3 for the entire session
```shell
export ETCDCTL_API=3
etcdctl version
```
#### etcd set the value
```shell
# v2
etcdctl set key1 value1
# v3
etcdctl put key1 value1
```
#### etcd get the value
```shell
# v2 and v3
etcdctl get key1
```

#### kube-scheduler
#### Role and Function:
 - The kube-scheduler is a control plane component responsible for watching newly created pods that have no assigned node.It then selects the best node for them to run on. This process is crucial for distributing workloads across the cluster.
 - It operates independently, allowing for custom scheduling policies and algorithms to be implemented.
#### Scheduling Process:
The scheduling process involves two main phases: filtering and scoring.
 - Filtering: The scheduler filters out nodes that do not meet the pod's requirements (e.g., resource constraints, node selectors, taints).
 - Scoring: The scheduler scores the remaining nodes based on predefined or custom scoring functions, prioritizing nodes that best fit the pod's needs.
#### Scheduling Factors:
The scheduler considers various factors when making scheduling decisions, including:
 - Resource requirements (CPU, memory)
 - Node selectors and affinity/anti-affinity rules
 - Taints and tolerations
 - Pod affinity and anti-affinity
 - Data locality
 - Inter-pod interference
#### Extensibility:
Kubernetes allows for custom schedulers or scheduler plugins to be used, enabling users to implement specific scheduling policies tailored to their applications or environments.
This extensibility allows for complex scheduling logic.
#### Default Scheduler:
The default scheduler is sufficient for most use cases, and is designed to be general purpose.
It is designed to be highly available, and redundant.

