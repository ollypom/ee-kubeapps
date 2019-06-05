## Fluentbit Collector

This deployment will contain the yaml to forward the collected data to either ElasticSearch or to a FluentD instance.

Fluent-Bit has been setup to read from JournalD or /var/logs/containers for k8s logs. Apply the appropriate fb-configmap-config-*.yaml file.