# Deploying Heapster on UCP 3.0

Note this is currently broken on UCP 3.0.0 due to the Kubelet cAdvisor unable to get container stats.

### To deploy

Upload the Admin's Auth file from a client bundle as a config

```
$ kubectl -n kube-system create configmap adminconfig --from-file=kube.yml
```

and now you can deploy the components:

```
$ kubectl apply -f .
```
