#!/bin/bash

# You need to create a role for your service account!! :( 

#echo "Label Manager Nodes"
#kubectl label nodes ip-172-31-16-8 opnoderole=loadbalancer

# Create Secrets

kubectl create secret generic dtr-certs --from-file=certs/dtr.cert.pem  --from-file=certs/cache.cert.pem --from-file=certs/cache.key.pem

# Create Config map

kubectl create configmap dtr-cache-config --from-file=config.yml

#echo "Deploying all the yaml"
#kubectl apply -f .

# You can verify 

curl -X GET -k https://dtr-cache/v2/_catalog

# Define a DTR cache within DTR

curl -X POST "https://dtr.olly.dtcntr.net/api/v0/content_caches" -H "accept: application/json" -H "content-type: application/json" -d "{ \"host\": \"https://dtr-cache.dtr.svc.cluster.local\", \"name\": \"aks\"}"

# Create a Registry Secret for Jeff in Kube

REG='dtr.example.com'
REGUSER=jeff
REGPASS=password
REGMAIL='jeff@example.com'

kubectl create secret docker-registry dtrcreds 
    --docker-server=$REG \
    --docker-username=$REGUSER \
    --docker-password=$REGPASS \
    --docker-email=$REGMAIL
