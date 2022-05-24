#!/bin/bash

NODENAME=$(hostname -s)

echo "[TASK 1] Pull required containers"
kubeadm config images pull >/dev/null 2>&1

echo "[TASK 2] Initialize Kubernetes Cluster"
kubeadm init --kubernetes-version=v1.21.1 --apiserver-advertise-address=10.0.0.80 --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/12 --node-name=$NODENAME --ignore-preflight-errors=Swap >> /root/kubeinit.log 2>/dev/null

echo "[TASK 3] Deploy Calico network"
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/manifests/calico.yaml >/dev/null 2>&1

echo "[TASK 4] Generate and save cluster join command to /joincluster.sh"
kubeadm token create --print-join-command > /joincluster.sh 2>/dev/null

echo "[TASK 5] Copy Kubectl file and add auto complete with alias"
sudo -i -u vagrant bash << EOF
mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown 1000:1000 /home/vagrant/.kube/config
sudo echo 'source <(kubectl completion bash)' >>/home/vagrant/.bashrc
sudo echo 'alias k=kubectl' >>/home/vagrant/.bashrc
sudo echo 'complete -F __start_kubectl k' >>/home/vagrant/.bashrc
EOF

echo "[TASK 7] Download the Helm installer"
wget --progress=bar:force https://get.helm.sh/helm-v3.9.0-linux-amd64.tar.gz
tar -xzf helm-v3.9.0-linux-amd64.tar.gz
chmod +x ./linux-amd64/helm
mv ./linux-amd64/helm /usr/local/bin/helm
helm version --short

echo "[TASK 8] Deploy application and list pods"
sudo -i -u vagrant bash << EOF
kubectl apply -f /deployments/persistent-vol.yml
helm install flask /deployments/flask
kubectl get pods
helm list
EOF