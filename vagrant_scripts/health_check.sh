#!/bin/bash
echo "[TASK 1] Checking deployments health"
while [[ $(kubectl --kubeconfig=/etc/kubernetes/kubelet.conf get pods -l app.kubernetes.io/name=mysql -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
   echo "still waiting for flask app to come online"
   sleep 1
done
echo "The application is up and running....."