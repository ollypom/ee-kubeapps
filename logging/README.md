# A directory of deploying Elastic on EE. 

Things to think about.

Beats or Logstash.... I've got Beats.

ElasticBeats (JournalBeat/FileBeat) vs Fluent (Fluentd / fluentbit)

We need to get logs of:

- Docker Daemon
- Docker containers standalone (i.e. UCP components)
- Docker container swarm services (i.e. UCP agent)
- Kubernetes pods

Filebeat vs Journalbeat. As we are using the journald logging driver at the docker
daemon level. We need to use journalbeat :)

Would love to get fluent working, but don't configuration is tough getting UCP 
containers as well as Kube containers
