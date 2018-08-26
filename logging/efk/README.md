# Deploying Elastic / Fluentd / Kibana

I used this guide: https://blog.ptrk.io/how-to-deploy-an-efk-stack-to-kubernetes

The components include:
 - Fluentd daemonset. With the host logging directories mounted in to it
 - Fluentd bit. He adds kubernetes metadata to the logs, and sends them to
   elastic
 - ...

## 1) Deploy fluentd

[https://github.com/fluent/fluentd-kubernetes-daemonset]





