# Pod Security

Pod Security comes in 2 forms. 

1) Security Contexts applied to a pod during deployment

2) Pod Security Policies - Enforcement of a Cluster pod standard, defined by
cluster admin. 

(PSPs, aren't supported today in Docker EE. You can enable the Admission
controller, however the lack of Kube RBAC makes it hard to allow a user to 
'use' a PSP.)
