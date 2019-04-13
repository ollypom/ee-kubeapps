# Making Kube DNS Highly Available

In UCP today Kube-Dns is not highly available. We deploy 1 replica of kube-dns
on a manager node. However if whatever reason the manager node running that 1
replica goes down you will lose DNS resolution for 5-6 minutes. There are many
different ways to make this better however lets first expand on the 5-6 minute
problem. 

## Why does it take 5 minutes?

https://kubernetes.io/docs/concepts/architecture/nodes/

The node controller is responsible for updating the NodeReady condition of
NodeStatus to ConditionUnknown when a node becomes unreachable (i.e. the node
controller stops receiving heartbeats for some reason, e.g. due to the node
being down), and then later evicting all the pods from the node (using graceful
termination) if the node continues to be unreachable. (The default timeouts are
40s to start reporting ConditionUnknown and 5m after that to start evicting
pods.) 

https://github.com/kubernetes-sigs/kubespray/blob/master/docs/kubernetes-reliability.md

There are 3 variables that we can then tune to fix.

```
-–node-status-update-frequency # Default 10s
--node-monitor-period # Default 5s
--node-monitor-grace-period # Default is 40s
--pod-eviction-timeout # Default is 5m
```

However playing with these values can put a slot of stress on etcd, so read the
kubespray docs for some examples


## Why can't we just add new replicas to Kube-DNS

The Kube-DNS deployment yaml is actually managed by the ucp-reconciler,
everytime that runs the kube-dns yaml will automatically get converted back to
the default. Therefore if you change the replica count to 3 pods, the next time
reconciler runs on a manger node your back to 1. 

Can you just run a cron job on a manager, or a kube cron to fix this? Yes you
can. However I was wondering if there was a cleaner way.

## Kube DNS Horizontal Autoscaler

Kubernetes automatically maintains a Kube DNS Horizontal Autoscaler, as your
cluster grows the number of Kube-DNS pods grows with it.

https://kubernetes.io/docs/tasks/administer-cluster/dns-horizontal-autoscaling/
https://github.com/kubernetes-incubator/cluster-proportional-autoscaler

This is great, it is a light service constantly checking the API server for the
size of cluster, and adjusting the number of replicas accordingly. 

Its configuration component is:

```
--default-params={"linear":{"coresPerReplica":256,"nodesPerReplica":16,"preventSinglePointFailure":true}}
```

Straight away it will give us 2 pods, providing HA. It will automatically fight
the ucp-reconciler on our behalf, so i don't have to have a cron job running
anywhere, and finally as my cluster grows it will increase the number of
replicas. 

## Anti Affinity 

I want to avoid kube-dns pods running on the same manager nodes with
podAnftiAfinnity. Note if you make this change, you will be fighting the ucp
reconciler so will need to be cronned.  

```
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                  - key: k8s-app
                    operator: In
                    values: ["kube-dns"]
              topologyKey: kubernetes.io/hostname
```

In Feb 2018, anti affinity was added to Kube-Dns to stop replicas being deployed
on the same node. https://github.com/kubernetes/kubernetes/pull/57683

However this affected very large clusters, due to the performance of anti
affinity. https://github.com/kubernetes/kubernetes/issues/54164.

So it was reverted here. https://github.com/kubernetes/kubernetes/pull/59357
