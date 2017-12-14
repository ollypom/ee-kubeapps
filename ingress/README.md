# Ingress Installation

Following guidance from: https://github.com/docker/orca/issues/10836

Due to Beta RBAC issues you need to do the following:

#### 1)

Following the Mandatory Commands from:

https://github.com/kubernetes/ingress-nginx/blob/master/deploy/README.md#mandatory-commands

Mandotory Commands:

```
$ curl https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/namespace.yaml \
     | ukp apply -f -
 
$ curl https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/default-backend.yaml \
     | ukp apply -f -
 
$ curl https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/configmap.yaml \
     | ukp apply -f -
 
$ curl https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/tcp-services-configmap.yaml \
     | ukp apply -f -
 
$ curl https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/udp-services-configmap.yaml \
     | ukp apply -f -
```

#### 2)

And then because we can't use the default service account we have changed the "without-rbac.yaml" to create a new Service account.

$ ukp apply -f ingress.yaml 

#### 3)

Deploy a demo app

$ ukp apply -f exampleapp.yaml

#### 4)

Some people might want to fix the nodes that the Ingress controller starts on: 

$ ukp label nodes ip-172-31-24-173 theloadbalancer=yep 

$ ukp apply -f ingresswithfixednodes.yaml

#### 5)

Tried to deploy in a DaemonSet however HostPorts no longer work
