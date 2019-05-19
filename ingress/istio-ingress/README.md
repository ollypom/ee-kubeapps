# Install Isitio Ingress as part of UCP 3.2 Beta

The 7 yamls files here will succesfully deploy an Isitio Ingress controller. 

There is 1 prereq, that is to install the metrics-server to allow horizontal pod
autoscaling in UCP. Instructions [here](ee-kubeapps/tree/master/monitoring/metrics-server)

```
$ kubectl apply -f .
```

There is a simple demo-app in the demoapp directory, including ingress rules.
