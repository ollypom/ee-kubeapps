# Demo Script for Kube Deployments

Note if you don't have DNS set up, you put an app fqdn in to a http header like this

```
$ curl --resolve demo.test.com:80:51.140.223.104 http://demo.test.com/ping
```

#### 1) Stand up "Simple Deployment"

```bash
$ kubectl apply -f simpledeployments/.
```

Set up a ping loop

``` bash
$ while true; do curl -s hello.demo.olly.dtcntr.net/ping; sleep .5; done
```

Play around with changing the number of replicas, showing resilience etc

### 2) Show blue green deployments

```bash
$ kubectl apply -f bluegreendeployments/deploymentv1.yaml
$ kubectl apply -f bluegreendeployments/service.yaml
$ kubectl apply -f bluegreendeployments/ingress.yaml
```

Set up a ping loop

```bash
$ while true; do curl -s hello.demo.olly.dtcntr.net/ping; sleep .5; done
```

Deploy v2 service

```bash
$ kubectl apply -f bluegreendeployments/deploymentv2.yaml
```

Switch over service

```
$ vim bluegreendeployments/service.yaml
$ kubectl apply -f bluegreendeployments/service.yaml
```

Watch the result in the curl 

### 3) Show Canary Deployments

```bash
$ kubectl apply -f canarydeployments/deploymentsv1.yaml
$ kubectl apply -f canarydeployments/service.yaml
$ kubectl apply -f canarydeployments/ingress.yaml
```

Set up a ping loop

```bash
$ while true; do curl -s hello.demo.olly.dtcntr.net/ping; sleep .5; done
```

Deploy a v2 service

```bash
$ kubectl apply -f canarydeployments/deploymentsv2.yaml
```

In the curl logs, you should now see that 25% of your workload is being routed to the v2 version

Alternatively we could set up a canary URL within the ingress

