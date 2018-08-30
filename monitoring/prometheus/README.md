# Deploying Promtheus on Docker EE

## Monitoring Namespace

Create a montoring namespace

```
$ kubectl create ns monitoring

# If you have kubens installed, switch to your new namespace
$ kubens monitoring

```

## Monitoring Service Account

Create a new SA and then give it persmissions. I am using Diver for this but you could use the UCP UI 

```
$ kubectl create sa prometheus

$ diver ucp login \
   --username admin \
   --password password \
   --url https://ucp.olly.dtcntr.net:8443

$ diver ucp auth grants set \
   --role fullcontrol \
   --subject system:serviceaccuont:monitoring:prometheus \
   --collection kubernetesnamespaces \
   --type all
```

## Deploying Prometheus

Prometheus configurations are defined through a ConfigMap mapped into the container. 

> Note today I am only scraping Kubernetes Nodes. We are unable to scrape pods with the /metrics api.
> Docker EE today does not support deploying heapster or the metrics server


```
$ kubectl create -f prometheus-config.yaml
```

Deploy the prometheus deployment

> Note i'm using temporary data storage on an empty vol
> for production put this on a physical volume

```
$ kubectl create -f prometheus-deployment.yaml
$ kubectl create -f prometheus-service.yaml
```

You should be now able to access Prom via an Ingress Controller

## Deploying Grafana

Now deploy Grafana

```
$ kubectl apply -f graf-deployment.yaml
$ kubectl apply -f graf-service.yaml
```

You should be able to reach Grafana now in the Web UI. 

> Creds are admin / admin by defualt
> change them to whatever you want :)


* add datasource *

This would be `http://prometheus:9090` and type prometheus


* create a new dashboard *

I haven't got a precreated dashboard to use yet :S 
