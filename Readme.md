# Local Kubernetes Cluster with Vagrant

## Development Issues:
As we reported developers observing different outputs from the
same code which slows down deliverables and taking
time repeatedly in troubleshooting however containerize the local
environment minimize such issues.

## Solution:
DevOps team containerized the local development environment 
using Vagrant, Kubernetes, and Makefile and yes, of course, 
the solution we have implemented doesn't require long 
learning curves you can give a simple command which does 
all the job for you.

## Prerequisites:
* Virtualbox version: 5.2.X
* Vagrant: 2.2.X


## Usage:
Vagrant and Virtualbox must be installed.

`clone repository`
```shell
git clone git@github.com:umairedu/flask_demo.git
```

`provision cluster`
```shell
$ make up
```

`build and push docker`
```shell
$ make build
```

`update codebase`
```shell
$ make update
```

`suspend cluster`
```shell
$ make suspend
```

`resume cluster`
```shell
$ make resume
```

`destroy cluster`
```shell
$ make destroy
```


### Access application
> Click on the following [link](http://localhost:8080/) to access the 
application

### Code synchronization
> In this Kubernetes cluster, we have used persistent
volumes to keep the data safe and synchronize. The changes you will made in [Project Folder](./project)
will automatically deploy and you will be able to see the change in real-time.

### Change dockerhub repo:
> open the [Makefile](./Makefile) and change the repository 
name in line number 5 and run the make build again to push 
the docker image in newly added repository


