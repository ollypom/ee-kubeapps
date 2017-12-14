#!/bin/bash

kubectl --kubeconfig="/home/ubuntu/.kube/ucp" create configmap map --from-file=configmap.md
