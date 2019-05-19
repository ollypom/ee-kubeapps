# Install Isitio Ingress as part of UCP 3.2 Beta

The 7 yamls files here will succesfully deploy an Isitio Ingress controller. 

There is 1 prereq, that is to install the metrics-server to allow horizontal pod
autoscaling in UCP. Instructions [here](/monitoring/metrics-server)

Once you've installed the metrics service, you can deploy these 7 yamls. You
may need to customise no6, the service yaml, if you want to specify different
nodeports, or used a different type (Such as Loadbalancer).

```
$ kubectl apply -f .
```

Finally there is a simple demo-app in the demoapp directory, including ingress rules.
