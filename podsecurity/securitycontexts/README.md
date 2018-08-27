
export KUBECONFIG=/home/olly/dockeree/creds/ucp3-azure/admin/kube.yml

export KUBECONFIG=/home/olly/dockeree/creds/ucp3-azure/user/kube.yml

worker-11 = 51.140.255.48
worker-12 = 51.140.254.210
worker-13 = 51.140.252.225

## UID / GUID 

Deploy sleeping ubuntu container.

```
apiVersion: v1
kind: Pod
metadata:
  name: uuid-pod
spec:
  containers:
    - name:  basic-pod
      image: ubuntu:latest
      command:
        - sleep
        - "500000"
```

A quick look at the pids.

```
# In the container
root@uuid-pod:/# ps aux
USER        PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root          1  0.0  0.0   4520   384 ?        Ss   15:10   0:00 sleep 500000
root          5  0.0  0.0  18496  2012 pts/0    Ss   15:10   0:00 /bin/bash
root         13  0.0  0.0  34388  1456 pts/0    R+   15:11   0:00 ps aux
root@uuid-pod:/# whoami
root

# On the docker host
$ ps u 51146
USER        PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root      51146  0.0  0.0   4520   384 ?        Ss   15:10   0:00 sleep 500000
```

Deploy that same pod, with a uuid sec context set.

```
apiVersion: v1
kind: Pod
metadata:
  name: uuid-pod
spec:
  containers:
    - name:  basic-pod
      image: ubuntu:latest
      command:
        - sleep
        - "50000"
  securityContext:
    runAsUser: 1000
```

A quick look inside.

```
# In the container
I have no name!@uuid-pod:/$ ps aux
USER        PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
1000          1  0.0  0.0   4520   384 ?        Ss   15:12   0:00 sleep 50000
1000          5  0.1  0.0  18496  1988 pts/0    Ss   15:14   0:00 /bin/bash
1000         12  0.0  0.0  34388  1460 pts/0    R+   15:14   0:00 ps aux
I have no name!@uuid-pod:/$ whoami
whoami: cannot find name for user ID 1000

# Quick look on the host
$ ps u 67116
USER        PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
olly      67116  0.0  0.0   4520   384 ?        Ss   15:12   0:00 sleep 50000
```

So what did we achieve?

The container wants to run as root, it is unable because root is UID 1, we set
the UID 1000. This means that the default user in the container is now UID 1000.
This is an undefined user in the container image, hence why it can't find the
name. Note this is not a root user, we can't `apt-get update` for example. 
Permission denied. 

Interestingly if you look on the host, UID 1000 does actually match a defined
user. UID 1000 is my default user olly, hence why he owns the process on the
host.


## Privileged / Unprivileged

Docker EE RBAC Makes this reallly easy :)

## SELinux / App Armour


## Seccomp and Linux Capabilities

I tried to demo what could happen if users failed to set the secomp
profile onto their kubernetes deployments... However I failed. 

On a System with User namespace enabled in the kernel (Ubuntu) its easy
you can start an alpine container as the nobody user. 

Run this command. 

```
$ unshare --map-root-user --user sh -c whoami
```

And you will be able to run as root. 

However for RHEL user namespaces is not enabled in the kernel. I investigated 
2 other possible demos.

1) Netstat. Without a seccomp profile you can listen to socket syscall, this 
works quite well... if you are generating traffic on a port in your container.
I was not, and you can't to get traffic of the host without using the host net
namespace. 

```
# Use something with Netstat installed, like nicolaka/netshoot
$ nc -v -l 80
```

2) Use strace to listen to the system calls a process was making.... I tried to
do this, by sharing PIDs of 2 containers in the same POD. I think this is a 
Kubernetes 1.11 feature only :( Therefore plan no2 was to use strace to listen
to host processes, by deploying the container using pid=host. This worked ok, 
however strace was blocked by the capability. 

You can succesfully do this though with the below example.. But who is deploying
a pod on the host PID namespace, with a ptrace capability.

```
$ cat hostpids.yaml
apiVersion: v1
kind: Pod
metadata:
  name: hostpids
spec:
  hostPID: true
  containers:
  - name: nginx
    image: nicolaka/netshoot
    command:
      - sleep
      - "500000"
    securityContext:
      capabilities:
        add:
        - SYS_PTRACE

$ kubectl create -f hostpids.yaml
$ kubectl exec -it hostpids sh
$ strace -f -p <pid>
```






 



