#!/bin/bash

# Fixing the Ingress Controller to 1 node

## 1) Attach label to the node

https://kubernetes.io/docs/concepts/configuration/assign-pod-node/

$ ukp get nodes

$ ukp label nodes <node-name> <label-key>=<label-value>

$ ukp label nodes ip-172-31-24-173 theloadbalancer=true

## 2) adding NodeSlector to a pod

spec:
  containers:
  - name: nginx
    image: nginx
    imagePullPolicy: IfNotPresent
  nodeSelector:
    theloadbalancer: true
