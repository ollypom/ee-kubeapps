# Setting up PodSecurityPolicies on UCP 3.1

> Note this only works on UCP 3.1.x

Grab the existing UCP config

```
$ URL=ucp.olly.dtcntr.net
$ UCPPORT=8443
$ PASS='password'
$ token=$(curl -skX POST -H "Content-Type: application/json" -H  "accept: application/json" -d '{"username":"admin","password":"'$PASS'"}' "https://$URL:$UCPPORT/auth/login" | jq -r .auth_token)

$ curl -kX GET \
    -H "Content-Type: application/json" \
    -H  "accept: application/json" \
    -H "Authorization: Bearer $token" \
    https://$URL:$UCPPORT/api/ucp/config-toml > existingconfig.toml
```

Add this to the bottom of the config

```
custom_kube_api_server_flags = ["--enable-admission-plugins=Initializers,NamespaceLifecycle,LimitRanger,ServiceAccount,PersistentVolumeLabel,DefaultStorageClass,DefaultTolerationSeconds,NodeRestriction,ResourceQuota,PodNodeSelector,UCPAuthorization,CheckImageSigning,UCPNodeSelector,PodSecurityPolicy"]
```

And then post it back up to UCP using:

```
curl -sk -H "Authorization: Bearer $token" \
    --upload-file existingconfig.toml \
    "https://$URL:$UCPPORT/api/ucp/config-toml"

# Can't get this bottom one to work :( :( 
curl -kX PUT -H "Content-Type: application/json" \
    -H  "accept: application/json" \
    -H "Authorization: Bearer $token" \
    -d 'custom_kube_api_server_flags = ["PodSecurityPolicy"]' \
     https://$URL:$UCPPORT/api/ucp/config-toml
```
