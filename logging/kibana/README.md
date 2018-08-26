
# Basic Auth

I wanted to add a layer of auth on top of kibana, as by default it doesn't
come with any :( 

```
$ htpasswd -c auth olly
New password: <docker123>
New password:
Re-type new password:
Adding password for user olly
```

```
$ kubectl create secret generic basic-auth --from-file=auth
secret "basic-auth" created
```

And now deploy my ingress file :)
