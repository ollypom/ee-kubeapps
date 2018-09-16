# Installing the Metrics Server on UCP 3.1.x

Example yamls to deploy the kubernetes metrics server as noted on here
https://github.com/kubernetes-incubator/metrics-server

> Note this does not work on UCP 3.0.x due to the lack of RBAC.

> Note because lack of DNS in my environment I have also had to hard
> set the resolution of IPS in my metrics server pod. Hopefully you 
> dont need to do this, so can take that bit out.

```
$ kubectl apply -f .
```
