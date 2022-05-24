#!/bin/bash
echo "[TASK 1] Check deployments health"
while [[ $(kubectl get pods -l app.kubernetes.io/name=flask -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
   echo "still waiting for flask app to come online"
   sleep 1
done
echo "Application seems up and running now....."