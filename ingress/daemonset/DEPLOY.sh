#!/bin/bash

echo "Label Manager Nodes"
kubectl label nodes ip-172-31-16-8 opnoderole=loadbalancer

echo "Deploying all the yaml"
kubectl apply -f .
