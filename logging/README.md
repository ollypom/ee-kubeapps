# A directory of deploying ELK on EE. 

ELK = Elastic / Logstash / Kibana
EFK = Elastic / Fluentd / Kibana

Things to think about.

We need to get logs of:

- Docker Daemon
- Docker containers standalone (i.e. UCP components)
- Docker container swarm services (i.e. UCP agent)
- Kubernetes pods

Because of this any Kubernetes native solutions, fluentd logging, fluentd bit won't work
as they talk to the kube api server for metadata.... We have a lot of containers
the kube-api-server doesn't know anything about. 

Filebeat vs Journalbeat. As we are using the journald logging driver at the docker
daemon level. We need to use journalbeat :)
