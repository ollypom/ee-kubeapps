# Deploying Heapster on UCP 3.x

Note this is currently broken on UCP 3.0.x.

https://github.com/docker/orca/issues/13149

- 1) The Kubelet does not support authentication from service accounts. There
fore we need to mount a users, kubeconfig file into the container. Below I 
do this with an admin's kubeconfig.


- 2) Because we containise the kubelet, cadvisor is unable to get pod 
statistics. Therefore we can only get node statistics from heapster.


## To deploy

Using a configuration map upload a Kubeconfig from a client bundle.

```
# Download a Client bundle and extract it.
$ unzip ucp-admin-bundle
$ cd ucp-admin-bundle

# Source the client bundle so kubectl points to the right place.
$ export KUBECONFIG=$PWD/kube.yml

# Upload the kube config as a config map.
$ kubectl -n kube-system create configmap adminconfig --from-file=kube.yml
```

Now you are a position to create your 3 artefacts. Including an ignress object
which you probably want to customise :)


```
$ kubectl apply -f .
```
