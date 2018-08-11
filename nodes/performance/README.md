# Testing memory controls of a Docker EE worker node

By default there are no memory controls on a Docker EE worker node. So
lets see what happens when i apply pressure using stress-ng. 

> Before we get started its worth following Docker's advice on memory
> swap and memory overcommit. 
> https://success.docker.com/article/node-using-swap-memory-instead-of-host-memory

A simple deployment of stress-ng could look like:

```
# Docker run
$ docker run -d --rm lorel/docker-stress-ng --vm 1 --vm-bytes 536870912 --timeout 0

# Kube Pod
$ cat simplepod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: stress-ng-2
spec:
  containers:
  - name: stress
    image: lorel/docker-stress-ng
    command: ["/usr/bin/stress-ng"]
    args: ["--vm", "1", "--vm-bytes", "536870912", "--timeout", "0"]
```

I'm also going to follow some of the advice from the Docker team (here)
[https://success.docker.com/article/running-docker-ee-at-scale] which talk about
setting up a global service with 2 Gi RAM dedicated to it. As we are using Kube
use a Daemonset here instead of a Swarm service. It is also worth nothing I used
a non admin user so this didn't get deployed on the managers. 

```
$ cat sysres.yaml
apiVersion: apps/v1beta2
kind: DaemonSet
metadata:
  name: system-reservation
  namespace: default
  annotations:
   seccomp.security.alpha.kubernetes.io/pod: docker/default
spec:
  selector:
    matchLabels:
      app: system-reservation
  template:
    metadata:
      labels:
        app: system-reservation
    spec:
      containers:
        - name: system-res
          image: nginx
          resources:
            requests:
              memory: "2Gi"
            limits:
              memory: "2Gi"
```

Also remember you can also set default memory limits for a given namespace using
the limit range controller. This will make sure that even if you don't set a 
resource limitations on your deployments, kubernetes will put some default on
there for you. You can even set the size of the largest reservation if you
wanted to too. 
 
https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/ 
https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-constraint-namespace/

```
apiVersion: v1
kind: LimitRange
metadata:
  name: mem-limit-range
spec:
  limits:
  - default:
      memory: 512Mi
    defaultRequest:
      memory: 256Mi
    type: Container
```

You can also set maximum limites for total resources in a namespace using 
resource quotas.   
https://kubernetes.io/docs/concepts/policy/resource-quotas/

```
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-resources
spec:
  hard:
#    pods: "4"
#    requests.cpu: "1"
    requests.memory: 2Gi
#    limits.cpu: "2"
    limits.memory: 2Gi
```


