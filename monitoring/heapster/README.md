# Deploying Heapster on UCP 3.x

Note this is currently kinda broken on UCP 3.0.x.

https://github.com/docker/orca/issues/13149

- 1) Because we containise the kubelet, cadvisor is unable to get pod 
statistics. Therefore we can only get node statistics from heapster.


## To deploy


```
# Create a SA
$ kubectl create sa heapster

# Log into the UI and give the SA account full control of all 
# naamespaces :(
```


Now you are a position to create your 3 artefacts. Including an ignress object
which you probably want to customise :)


```
$ kubectl apply -f .
```
