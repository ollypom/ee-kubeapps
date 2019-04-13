# Installing the Metrics Server on UCP 3.1.x

Example yamls to deploy the kubernetes metrics server as noted on here
https://github.com/kubernetes-incubator/metrics-server

```
$ kubectl apply -f .
```

Once deployed, the default polling interval is 60 seconds. So after 60 seconds
do a quick top command to verify.

```
$ kubectl top nodes
NAME               CPU(cores)   CPU%      MEMORY(bytes)   MEMORY%
dtr-01.local       82m          4%        4373Mi          58%
manager-01.local   320m         18%       3695Mi          65%
worker-01.local    70m          3%        1971Mi          26%
```
