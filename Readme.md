# Local Kubernetes Environment Using Vagrant

## Development Issues:
As we reported developers observing different outputs from the
same code which slows down deliverables and taking
time in repeatedly troubleshooting however containerize the local
environment minimize such issues.

## Solution:
DevOps team containerized the local development environment 
using Vagrant, Kubernetes, and Makefile and yes, of course, 
the solution we have implemented doesn't require long 
learning curves you can give a simple command which does 
all the job.


## Usage:
Vagrant and Virtualbox must be installed.

`clone repository`
```shell
git clone https://github.com/umairedu/jenkins_pipeline_java_maven.git
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
Click on the following [link](http://localhost:8080/) to access the 
application


> Change dockerhub repo:
>>open the [Makefile](./Makefile) and change the repository 
name in line number 5 and run the make build again to push 
the docker image in newly added repository



## Prerequisites:
* Virtualbox version: 5.2.X
* Vagrant: 2.2.X
