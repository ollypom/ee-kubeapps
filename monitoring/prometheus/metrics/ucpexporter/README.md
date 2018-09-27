# Integrating UCP-Metrics into Prometheus

### Get the UCP Inventory

> Note I need to think of an automated way to make sure this data doesn't go 
> stale. 

```
$ URL=ucp.olly.dtcntr.net
$ UCPPORT=8443
$ PASS='password'

# Grab a Token
$ token=$(curl -skX POST -H "Content-Type: application/json" -H  "accept: application/json" -d '{"username":"admin","password":"'$PASS'"}' "https://$URL:$UCPPORT/auth/login" | jq -r .auth_token)

# Grab the Inventory
$ curl -H "Authorization: Bearer $token" -o inventory.json https://$URL:$UCPPORT/dtmetricsdiscovery

# Check your file
$  cat inventory.json
[{"targets":["172.31.8.8:12376","172.31.13.181:12376","172.31.13.181:8443","172.31.1.128:12376"]}]

# Upload the file to Kube
$ kubectl create configmap inventory-config --from-file=inventory.json
```

### Alternatively define your inventory in a static configmap file

```
apiVersion: v1
kind: ConfigMap
metadata:
  name: inventory-config
  namespace: monitoring
data:
  inventory.json: |-
    [
      {
        "targets":[
            "172.31.8.8:12376",
            "172.31.13.181:12376",
            "172.31.1.128:12376",
            "172.31.13.181:8443",
        ]
      }
    ]
```


kubectl create secret generic prometheus --from-file=ca.pem --from-file=cert.pem --from-file=key.pem

## An example Inventory.json

In this cluster I have 2 nodes: 

  - worker0.local = manager node  = 172.31.10.180
  - worker1.local = worker node   = 172.31.13.211

It looks like we are scraping the UCP controller api on port 443, as well as
scraping the docker tls proxy port which is port 12376.

[{"targets":["172.31.10.180:12376","172.31.10.180:443","172.31.13.211:12376"]}]

