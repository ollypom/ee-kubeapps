# Trying to Understand the state of Kubernetes Monitoring in UCP 3.1

Endpoints:

The Kubelet has 3 endpoints that you can hit with an authenticated request. 
2 Prometheus ones, and 1 stats one. 

- :10250/metrics -> example [here](./metrics/exampleoutputs/kubeletprometheusexporter)
- :10250/metrics/cadvisor -> example [here](./metrics/exampleoutputs/kubeletcadvisor)
- :10250/stats/ [here](./metrics/exampleoutputs/kubeletcadvisor)

Exporters:

There a few official "exporters" which can get us a lot of data from the under
lying nodes. I can't work out yet if I am duplicating data, so will run some of
these today, but take them off if they are no longer required. I run all of 
these exporters as Kubernetes daemonsets, and scrape them using the Prometheus
flags in the kubernetes manifests. 

- Node Exporter [official](https://github.com/prometheus/node_exporter) -> 
example [here](./metrics/exampleoutputs/nodeexporter). This is required to get
performance metrics from the node (cpu/memory/disk/network). 

- Docker Engine Exporter [docs](https://docs.docker.com/config/thirdparty/prometheus/)
-> example [here](./metrics/exampleoutputs/dockerenginemetrics). This can give 
us metrics on engine stats and swarm stats. It does not give us container info.

- cadvisor [docs](https://github.com/google/cadvisor) -> example 
[here](./metrics/exampleouts/cdavisormetrics). We have to run this because the
UCP kubelet container does not hold container names in its cadvisor output!!!!!!
This data might be in UCP metrics.

- ucp-metrics [docs](https://beta.docs.docker.com/ee/ucp/admin/configure/collect-cluster-metrics/)
-> example [here](./metrics/exampleouts/ucpmetrics). I'm trying to understand if
this data is complete, and makes some of the other exporters redundant.
