# Using Horizontal Pod Autoscaler on UCP

A pre-req for using HPAs on Docker Enterprise UCP is to have a metrics-server
running. We do support using heapster here (as heapster is depreciated in HPA in
1.11).

Docs to deploy metrics-server are [here](./../metrics-server)

The demo here is based off of: 

https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/
