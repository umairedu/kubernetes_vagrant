# Local Kubernetes Cluster with Vagrant

A complete local Kubernetes development environment setup using Vagrant, featuring a Flask application with MySQL database. This project automates the entire cluster provisioning process, making it easy to spin up a multi-node Kubernetes cluster on your local machine.

## Overview

This project provides a containerized local development environment that eliminates "works on my machine" issues by ensuring all developers work with identical infrastructure. The solution uses Vagrant to provision virtual machines, Kubernetes for orchestration, and Helm for application deployment.

### Architecture

- **1 Master Node**: Kubernetes control plane (2GB RAM, 2 CPUs)
- **1 Worker Node**: Application workload node (1GB RAM, 1 CPU)
- **Flask Application**: Python web application with MySQL backend
- **Persistent Storage**: HostPath volumes for data persistence
- **Network**: Calico CNI for pod networking

## Prerequisites

Before you begin, ensure you have the following installed:

- **VirtualBox**: Version 5.2.X or higher
- **Vagrant**: Version 2.2.X or higher
- **Docker**: For building and pushing application images
- **Make**: For running automated commands (usually pre-installed on macOS/Linux)

### Installation Links

- [VirtualBox Download](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant Download](https://www.vagrantup.com/downloads)
- [Docker Desktop](https://www.docker.com/products/docker-desktop)

## Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url>
cd kubernetes_vagrant
```

### 2. Provision the Kubernetes Cluster

This command will:
- Create and configure the master node
- Create and configure the worker node
- Initialize the Kubernetes cluster
- Deploy Calico networking
- Install Helm
- Deploy the Flask application with MySQL

```bash
make up
```

**Note**: The first run will take 10-15 minutes as it downloads the Ubuntu base image and installs all required components. Subsequent runs will be faster.

### 3. Build and Push Docker Image

Build the Flask application Docker image and push it to DockerHub:

```bash
make build
```

**Important**: Before running this command, update the DockerHub repository name in the `Makefile` (line 5) if you want to use your own repository.

### 4. Access the Application

Once the cluster is up and running, access the Flask application at:

**http://localhost:8080**

The application will display a greeting message with a score retrieved from the MySQL database.

## Project Structure

```
kubernetes_vagrant/
├── Vagrantfile                 # Vagrant configuration for VMs
├── Makefile                    # Automation commands
├── buildspec.yml              # AWS CodeBuild configuration
├── project/                    # Flask application source
│   ├── app.py                 # Flask application
│   ├── Dockerfile             # Docker image definition
│   ├── requirements.txt       # Python dependencies
│   └── project.mk             # Build automation
├── kubernetes_manifest/        # Kubernetes deployment files
│   ├── flask/                 # Helm chart for Flask app
│   │   ├── Chart.yaml
│   │   ├── values.yaml        # Application configuration
│   │   └── templates/         # Kubernetes manifests
│   └── persistent-vol.yml     # Persistent volume definitions
└── vagrant_scripts/           # Provisioning scripts
    ├── bootstrap.sh           # Common setup for all nodes
    ├── master.sh              # Master node configuration
    ├── worker.sh              # Worker node configuration
    └── health_check.sh        # Application health check
```

## Available Commands

All commands are executed using `make`:

### Cluster Management

| Command | Description |
|---------|-------------|
| `make up` | Provision and start the Kubernetes cluster |
| `make suspend` | Suspend all VMs (preserves state) |
| `make resume` | Resume suspended VMs |
| `make halt` | Shutdown VMs gracefully |
| `make destroy` | Destroy all VMs and remove them |

### Application Management

| Command | Description |
|---------|-------------|
| `make build` | Build Docker image and push to DockerHub |
| `make app_update` | Rebuild image, push, and restart deployment |
| `make push` | Push Docker image to DockerHub |

### Utility Commands

| Command | Description |
|---------|-------------|
| `make list` | List all Docker containers, images, and networks |
| `make clean` | Clean up Docker system (prune unused resources) |
| `make help` | Display available commands |

## Configuration

### Changing DockerHub Repository

To use your own DockerHub repository:

1. Open `Makefile`
2. Update line 5 with your DockerHub username:
   ```makefile
   DOCKER_HUB_REPO = your-username
   ```
3. Run `make build` to build and push with the new repository

### Application Configuration

Application settings can be modified in `kubernetes_manifest/flask/values.yaml`:

- **Database credentials**: Update `configMap` section
- **Resource limits**: Modify `resources` section
- **Replica count**: Change `replicaCount`
- **Service type**: Modify `service.type` (NodePort, ClusterIP, etc.)

### Network Configuration

The cluster uses the following IP addresses:

- **Master Node**: `10.0.0.80` (master.lab.com)
- **Worker Node**: `10.0.0.81` (worker1.lab.com)

Port forwarding:
- **8080** → Flask application (NodePort 31731)

## Features

### Code Synchronization

The project folder (`project/`) is synced to `/share/app` on the worker node. Changes made to your local code will automatically reflect in the running container, enabling real-time development.

### Persistent Storage

- **MySQL Data**: Stored in `/data` on the worker node (persistent across restarts)
- **Application Code**: Synced from `project/` directory

### Automated Deployment

The cluster automatically:
- Initializes Kubernetes with kubeadm
- Deploys Calico CNI for networking
- Installs Helm package manager
- Deploys MySQL database
- Deploys Flask application
- Configures persistent volumes

## Troubleshooting

### Cluster Not Starting

1. Ensure VirtualBox is running
2. Check that virtualization is enabled in BIOS
3. Verify sufficient system resources (at least 4GB free RAM)
4. Check Vagrant logs: `vagrant status`

### Application Not Accessible

1. Verify pods are running:
   ```bash
   vagrant ssh master -c "kubectl get pods"
   ```
2. Check service status:
   ```bash
   vagrant ssh master -c "kubectl get svc"
   ```
3. Verify port forwarding in Vagrantfile

### Docker Build Issues

1. Ensure Docker is running
2. Verify DockerHub credentials: `docker login`
3. Check DockerHub repository permissions

### Reset Everything

To start fresh:

```bash
make destroy
make up
```

## Accessing the Cluster

### SSH into Nodes

**Master Node:**
```bash
vagrant ssh master
```

**Worker Node:**
```bash
vagrant ssh worker1
```

### Using kubectl

From the master node:
```bash
vagrant ssh master
kubectl get nodes
kubectl get pods --all-namespaces
kubectl get svc
```

### Using Helm

From the master node:
```bash
vagrant ssh master
helm list
helm status flask
```

## Technical Details

- **Kubernetes Version**: 1.21.1
- **Container Runtime**: containerd
- **CNI Plugin**: Calico
- **Base OS**: Ubuntu Bionic (18.04)
- **Helm Version**: 3.9.0
- **Python Version**: 3 (Alpine)
- **Flask Version**: 2.1.2

## Notes

- The cluster uses `kubeadmin` as the root password for SSH access
- All nodes are configured with password authentication enabled
- The master node has kubectl configured for the `vagrant` user
- Persistent volumes use hostPath storage (local development only)
- The application is exposed via NodePort service on port 31731
