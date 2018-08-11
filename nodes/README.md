# Understand Docker EE Node Labels

A fresh Kubernetes Cluster, with 3 nodes, and the default orchestrator set to
kubernetes has given us the following labels:

For a manager node:

```
# From the Kubernetes Side
$ kubectl describe  nodes controller0.local
Name:               controller0.local
Roles:              master
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    com.docker.ucp.collection=system
                    com.docker.ucp.collection.root=true
                    com.docker.ucp.collection.swarm=true
                    com.docker.ucp.collection.system=true
                    kubernetes.io/hostname=controller0.local
                    node-role.kubernetes.io/master=
Annotations:        alpha.kubernetes.io/provided-node-ip=172.31.11.57
                    node.alpha.kubernetes.io/ttl=0
                    volumes.kubernetes.io/controller-managed-attach-detach=true
Taints:             com.docker.ucp.manager:NoSchedule

# From the Swarm Side
$ docker node inspect controller0.local | jq '.[].Spec.Labels'
{
  "com.docker.ucp.SANs": "controller0.local,127.0.0.1,172.17.0.1,35.178.184.132",
  "com.docker.ucp.access.label": "/System",
  "com.docker.ucp.collection": "system",
  "com.docker.ucp.collection.root": "true",
  "com.docker.ucp.collection.swarm": "true",
  "com.docker.ucp.collection.system": "true",
  "com.docker.ucp.orchestrator.kubernetes": "true",
  "com.docker.ucp.orchestrator.swarm": "true"
}
```

For a worker node: 

```bash
# From Kube
$ kubectl describe node worker0.local
Name:               worker0.local
Roles:              <none>
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/os=linux
                    com.docker.ucp.collection=shared
                    com.docker.ucp.collection.root=true
                    com.docker.ucp.collection.shared=true
                    com.docker.ucp.collection.swarm=true
                    kubernetes.io/hostname=worker0.local
Annotations:        alpha.kubernetes.io/provided-node-ip=172.31.7.173
                    node.alpha.kubernetes.io/ttl=0
                    volumes.kubernetes.io/controller-managed-attach-detach=true
Taints:             <none>

# From Swarm
$ docker node inspect worker0.local | jq '.[].Spec.Labels'
{
  "com.docker.ucp.SANs": "localhost,proxy.local,worker0.local,fvarhg3goojyi4a7vcccyo9dg,172.31.7.173,127.0.0.1",
  "com.docker.ucp.access.label": "/Shared",
  "com.docker.ucp.collection": "shared",
  "com.docker.ucp.collection.root": "true",
  "com.docker.ucp.collection.shared": "true",
  "com.docker.ucp.collection.swarm": "true",
  "com.docker.ucp.orchestrator.kubernetes": "true"
}
```

I'm trying to understand the taint on the managers in the Dashboard your see 
"Allow administrators to deploy containers on UCP managers or nodes running DTR"
and "Allow users to schedule on all nodes, including UCP managers and DTR nodes"
but i don't know if they apply to Kube. By default these are both ticked. And 
the taint `com.docker.ucp.manager:NoSchedule` exists. 

A quick experiment proves that the taint is not respected.

```
# Ran as an Admin User
$ kubectl run demo --image nginx --replicas 20
$ kubectl get pods -o wide
NAME                    READY     STATUS              RESTARTS   AGE       IP                NODE
demo-86bd468c59-5jtqg   1/1       Running             0          25s       192.168.223.131   worker0.local
demo-86bd468c59-64w9f   1/1       Running             0          25s       192.168.90.7      controller0.local
demo-86bd468c59-76jtz   1/1       Running             0          25s       192.168.223.140   worker0.local
demo-86bd468c59-bgj6x   1/1       Running             0          25s       192.168.223.141   worker0.local
demo-86bd468c59-c4ppf   1/1       Running             0          25s       192.168.90.5      controller0.local
demo-86bd468c59-d5lj7   1/1       Running             0          25s       192.168.223.133   worker0.local
demo-86bd468c59-frpfz   1/1       Running             0          25s       192.168.90.4      controller0.local
demo-86bd468c59-hh52b   1/1       Running             0          25s       192.168.223.135   worker0.local
demo-86bd468c59-hqc56   1/1       Running             0          25s       192.168.223.132   worker0.local
demo-86bd468c59-mdfm9   1/1       Running             0          25s       192.168.90.8      controller0.local
demo-86bd468c59-pv472   1/1       Running             0          25s       192.168.90.3      controller0.local
demo-86bd468c59-rg8hg   0/1       ContainerCreating   0          25s       <none>            worker0.local
demo-86bd468c59-shtfp   1/1       Running             0          25s       192.168.223.137   worker0.local
demo-86bd468c59-tl7hn   1/1       Running             0          25s       192.168.223.130   worker0.local
demo-86bd468c59-tmtch   1/1       Running             0          25s       192.168.223.138   worker0.local
demo-86bd468c59-wkxvx   1/1       Running             0          25s       192.168.223.136   worker0.local
demo-86bd468c59-wx5tw   1/1       Running             0          25s       192.168.223.139   worker0.local
demo-86bd468c59-z9fgc   1/1       Running             0          25s       192.168.90.6      controller0.local
demo-86bd468c59-zl775   1/1       Running             0          25s       192.168.223.134   worker0.local
demo-86bd468c59-zs5wc   1/1       Running             0          25s       192.168.223.129   worker0.local

# Ran as a Restricted Control user
$ kubectl run demo --image nginx --replicas 20
deployment "demo" created
$ kubectl get pods -o wide
NAME                    READY     STATUS    RESTARTS   AGE       IP                NODE
demo-855b94666b-4l8dt   1/1       Running   0          1m        192.168.223.156   worker0.local
demo-855b94666b-59kb7   1/1       Running   0          1m        192.168.223.162   worker0.local
demo-855b94666b-5pzpj   1/1       Running   0          1m        192.168.223.152   worker0.local
demo-855b94666b-6l8lj   1/1       Running   0          1m        192.168.223.146   worker0.local
demo-855b94666b-8plwk   1/1       Running   0          1m        192.168.223.161   worker0.local
demo-855b94666b-8whdt   1/1       Running   0          1m        192.168.223.157   worker0.local
demo-855b94666b-f52fr   1/1       Running   0          1m        192.168.223.159   worker0.local
demo-855b94666b-fb5w8   1/1       Running   0          1m        192.168.223.154   worker0.local
demo-855b94666b-g2d9n   1/1       Running   0          1m        192.168.223.145   worker0.local
demo-855b94666b-h22gh   1/1       Running   0          1m        192.168.223.148   worker0.local
demo-855b94666b-h8hx8   1/1       Running   0          1m        192.168.223.143   worker0.local
demo-855b94666b-jnmsw   1/1       Running   0          1m        192.168.223.149   worker0.local
demo-855b94666b-kdpxf   1/1       Running   0          1m        192.168.223.144   worker0.local
demo-855b94666b-knkmz   1/1       Running   0          1m        192.168.223.155   worker0.local
demo-855b94666b-qcv56   1/1       Running   0          1m        192.168.223.150   worker0.local
demo-855b94666b-rkdpr   1/1       Running   0          1m        192.168.223.151   worker0.local
demo-855b94666b-rskvc   1/1       Running   0          1m        192.168.223.158   worker0.local
demo-855b94666b-sbmqn   1/1       Running   0          1m        192.168.223.153   worker0.local
demo-855b94666b-tvxpm   1/1       Running   0          1m        192.168.223.147   worker0.local
demo-855b94666b-wxzbt   1/1       Running   0          1m        192.168.223.160   worker0.local
```

Ok so by default it looks like, UCP Admins can schedule pods on Controller nodes
, but normal users can not schedule pods on controller nodes.
