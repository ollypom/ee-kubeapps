# A directory of deploying ELK on EE. 

ELK = Elastic / Logstash / Kibana
EFK = Elastic / Fluentd / Kibana

Things to think about.

We need to get logs of:

- Docker Daemon
- Docker containers standalone (i.e. UCP components)
- Docker container swarm services (i.e. UCP agent)
- Kubernetes pods
