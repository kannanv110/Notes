# Docker Notes

## To know the exposed port for the image
```
[from-host@bash-]$ docker inspect image_name
```
Look for the ExposedPorts.

## Open port on docker host
```
[from-host@bash-]$ docker run -d --name web1 -p 82:80 httpd
```
Here, -p port_on_host:port_on_container

## Save the docker image to tar
```
[from-host@bash-]$ docker copy image_name > image_name.tar
```

## Import the docker image from tar archive
```
[from-host@bash-]$ docker load -i image_name.tar
```

## To Remove the docker image
```
[from-host@bash-]$ docker rmi image_name
```

## Create image from running container
Below steps show how to create custmize ubuntu image
### Create ubuntu container
```
[from-host@bash-]$ docker run -it --name u22 ubuntu /bin/bash
```
### Custmize the container
The above command will launch ubuntu conatiner and provide command prompt. From the prompt install the required packages and make necessary changes on the container.

```
[from-container@bash-]$ apt install curl nmap github
[from-container@bash-]$ touch /.test
```
Press `ctrl+p+q` to detach from the container and create image from this container.

### Create image from running container
```
[from-host@bash-]$ docker ps
#Get the running container id from the above output.
[from-host@bash-]$ docker commit container-id image-name:version
[from-host@bash-]$ docker commit f386b9f2c336 custom-u22:1
```

### Verfiy the image

```
[from-host@bash-]$ docker images
```

### Create new container from this new image

```
[from-host@bash-]$ docker run -it --name web1-u22 custom-u22:1 /bin/bash
```

Now login to the container and verify the package curl, nmap and github installed. Also check for file /.test on container.

### Login and Upload the custum image to docker hub
Login to the docker hub by providing valid username/password.
```
[from-host@bash-]$ docker login
```
Rename the image to include your id before the image name.
```
[from-host@bash-]$ docker tag custom-us22:1 techiekannanv/custom-u22:1
```
Now push the image to the docker hub.
```
[from-host@bash-]$ docker push techiekannanv/custom-u22:1
```

## Create docker image using dockerfile
### Create dockerfile template
```
[from-host@bash-]$ cat > dockerfile << EOF
FROM ubuntu:latest

RUN apt-get update -y && apt-get install apache2

COPY index.html /var/www/html/

EXPOSE 80

ENTRYPOINT apachectl -D FOREGROUND
EOF
```
### Different between CMD and ENTRYPOINT
Both CMD and ENTRYPOINT are same as both will execute the given command at the time of running container. If you want to change the command to run at the time of running container you can pass the require command as argument to `docker run` if the image has CMD instruction. The command will not work on image which has ENTRYPOINT intruction.

[Click here](https://www.learnitguide.net/2018/06/dockerfile-explained-with-examples-of.html) for more instructions.

### Create index.html
```
[from-host@bash-]$ echo "Hello World!" > index.html
```
### Build docker image from the dockerfile
```
[from-host@bash-]$ docker build -t ubuntu-apache2:latest .
```
### Verify the image
```
[from-host@bash-]$ docker images
```
### Create new container from the image
```
[from-host@bash-]$ docker run -d --name apache2 -p 80:80 ubuntu-apache2:latest
```

## Docker Network

### Types of network
Docker uses 3 types of network and those are bridge, host and none. By default the docker will use bridge network and we can change the network at the time of container creation using option --network=network_name.

By Using bridge network we can able to communicate between docker host and container. Also the containers on same network can communicate among them.

By Using host and none network we can't communicate to the container through network.

### To list the available network
```
[from-host@bash-]$ docker network ls
```

### To create new bridge network
```
[from-host@bash-]$ docker network create test-bridge --subnet "172.168.2.0/16" --gateway "172.168.2.1"
```

### Add the custom bridge network to the container
```
[from-host@bash-]$ docker run -d -it --name u22 --network=test-bridge ubuntu
```

### Verify the network details on the container
```
[from-host@bash-]$ docker inspect u22
```

## Docker Storage
Whatever changes made on the container will get vanish when we destroy the container. If we want to preserve the data then we need to make changes on the volume created from docker host.

### List the existing volumes
```
[from-host@bash-]$ docker volume ls
```

### Create and verify new volume
```
[from-host@bash-]$ docker volume create data_vol
[from-host@bash-]$ docker volume inspect data_vol
```

### Volume mount from docker area(/var/lib/docker/volumes)
```
[from-host@bash-]$ docker run -it --name u22 --mount source=data_vol,destination=/data ubuntu
[from-container@bash-]$ date > /data/current_date
[from-host@bash-]$ cat /var/lib/docker/volumes/data_vol/_data/current_date
```

### Bind mount the file system
We can map any file system to mount on container.
```
[from-host@bash-]$ docker run -d -it --name u22 -v /data:/app/data ubuntu
[from-container@bash-]$ date > /app/data/current_date
[from-host@bash-]$ cat /data/current_date
```

## Docker swarm
### Initialize the swarm cluster
Initialize and create worked node joining token.
```
[from-host@bash-]$ docker init --advertise-addr 172.168.1.140
```
Use the token generated from the above command to join the worked node in cluster.

### Get list of nodes on swarm cluster
We can only able to execute swarm command from swarm manager and can't be run from workers.
```
[from-swarm-master]$ docker node ls
ID                            HOSTNAME           STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
7wji0a1x7gcr2hbccypoeb9p6     kube-node1-u22     Ready     Active                          24.0.7
l3y5emjiweb6kovcu85rkky4w     kube-node2-u22     Ready     Active                          24.0.7
6udow7lhbw9cqurga2vqhlp5y *   swarm-master-u22   Ready     Active         Leader           24.0.7
```

### Create service in cluster
```
[from-swarm-master-@bash]$ docker service create --name web1 -p 80:80 httpd
```

### Verify the service
```
[from-swarm-master-@bash]$ docker service ls
ID             NAME      MODE         REPLICAS   IMAGE          PORTS
j6l7lu1g4x8a   web2      replicated   1/1        httpd:latest   *:80->80/tcp
[from-swarm-master-@bash]$ docker service ps web1
ID             NAME      IMAGE          NODE             DESIRED STATE   CURRENT STATE                ERROR     PORTS
vfvpcfcsbacb   web2.1    httpd:latest   kube-node2-u22   Running         Running about a minute ago
```

### Create service with replicas
```
[from-swarm-master@bash-]$ docker service create --replicas 2 --name web1 -p 1080:80 httpd
```

### Check the service status
```
[from-swarm-master@bash-]$ docker service ls
ID             NAME      MODE         REPLICAS   IMAGE          PORTS
p2suh5h2fo12   web1      replicated   2/2        httpd:latest   *:8080->80/tcp
```

### Check where the container's running
```
[from-swarm-master@bash-]$ docker service ps web1
ID             NAME      IMAGE          NODE               DESIRED STATE   CURRENT STATE                ERROR     PORTS
ptw3sz3nbvcw   web1.1    httpd:latest   kube-node1-u22     Running         Running about a minute ago
ijnwus275da0   web1.2    httpd:latest   swarm-master-u22   Running         Running about a minute ago
```

### Run the service on all nodes in the cluster
```
[from-swarm-master@bash-]$ docker service create --mode global --name web2 -p 8081:80 httpd
[from-swarm-master@bash-]$ docker service ls
ID             NAME      MODE         REPLICAS   IMAGE          PORTS
p2suh5h2fo12   web1      replicated   2/2        httpd:latest   *:8080->80/tcp
uvjhqto0z421   web2      global       3/3        httpd:latest   *:8081->80/tcp
[from-swarm-master@bash-]$ docker service ps web2
ID             NAME                             IMAGE          NODE               DESIRED STATE   CURRENT STATE            ERROR     PORTS
qktiftds9xq8   web2.6udow7lhbw9cqurga2vqhlp5y   httpd:latest   swarm-master-u22   Running         Running 17 minutes ago
u9cpe0yw8a4b   web2.7wji0a1x7gcr2hbccypoeb9p6   httpd:latest   kube-node1-u22     Running         Running 17 minutes ago
3gqlcp9vmgfs   web2.l3y5emjiweb6kovcu85rkky4w   httpd:latest   kube-node2-u22     Running         Running 17 minutes ago
```

### Scale up the running services
```
[from-swarm-master@bash-]$ docker service scale web1=3
[from-swarm-master@bash-]$ docker service ls
ID             NAME      MODE         REPLICAS   IMAGE          PORTS
p2suh5h2fo12   web1      replicated   3/3        httpd:latest   *:8080->80/tcp
uvjhqto0z421   web2      global       3/3        httpd:latest   *:8081->80/tcp
[from-swarm-master@bash-]$ docker service ps web1
ID             NAME         IMAGE          NODE               DESIRED STATE   CURRENT STATE             ERROR     PORTS
jgm2qnjlrtvy   web1.1       httpd:latest   kube-node2-u22     Running         Running 33 minutes ago
ptw3sz3nbvcw    \_ web1.1   httpd:latest   kube-node1-u22     Shutdown        Shutdown 32 minutes ago
ijnwus275da0   web1.2       httpd:latest   swarm-master-u22   Running         Running 39 minutes ago
vf6pp6but7zo   web1.3       httpd:latest   kube-node1-u22     Running         Running 37 seconds ago
```

### Scale down the running service
```
 [from-swarm-master@bash-]$ docker service scale web1=1
web1 scaled to 1
overall progress: 1 out of 1 tasks
1/1: running   [==================================================>]
verify: Service converged
[from-swarm-master@bash-]$ docker service ls
ID             NAME      MODE         REPLICAS   IMAGE          PORTS
p2suh5h2fo12   web1      replicated   1/1        httpd:latest   *:8080->80/tcp
uvjhqto0z421   web2      global       3/3        httpd:latest   *:8081->80/tcp
[from-swarm-master@bash-]$ docker service ps web1
ID             NAME         IMAGE          NODE             DESIRED STATE   CURRENT STATE             ERROR     PORTS
jgm2qnjlrtvy   web1.1       httpd:latest   kube-node2-u22   Running         Running 34 minutes ago
ptw3sz3nbvcw    \_ web1.1   httpd:latest   kube-node1-u22   Shutdown        Shutdown 33 minutes ago
```

### Rolling Update the running service
```
docker service create --replicas=2 -p 8001:8001 --name busapp learnitguide/busapp:2.1
# verify the service
docker service ls
# Now update the busapp from 2.1 to 2.5
docker service update --image learnitguide/busapp:2.5 busapp
# verify the service
docker service ls
```

### Rollback the update on running service
```
docker service rollback busapp
# verify the service
docker service ls
```

### Move the running container from unhealthy node
```
docker node update --availability drain
```

### Freeze the node to stop creating new container and keep the running conatiner up
```
docker node update --availability pause
```

## Docker CPU/Memory resource allocation
Always allocate only 80% of the resource to the container and keep 20% of resources for the docker host to run.

If the system is having 4 CPU cores then we can consider that as 4000m and if its having 8Gb RAM then we can consider that as 8000mi. 
cpu request=100m means this is the minimum guarantee cpu to the container.
cpu limit=200m means this is the maximum limit the container can use.
This is same for memory resource.

### Create container with CPU limit to 1 core and 512mb
```
docker run -d -it --cpus=1 --memory=512m --name u22 ubuntu
```

### Create container which can use guarnteed mem as 100m and max limit as 512m
```
docker run -d -it --memory-reservation=100m -m 512m --name u22 ubuntu
```

### View the resource limit on the container
Look for NanoCpus, Memory and MemoryReservation from inspect output.
```
docker inspect u22
```