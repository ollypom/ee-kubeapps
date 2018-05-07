#!/bin/bash

# You need to create a role for your service account!! :( 

echo "Label Manager Nodes"
kubectl label nodes ip-172-31-16-8 opnoderole=loadbalancer

echo "Deploying all the yaml"
kubectl apply -f .
