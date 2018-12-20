# Curator - A way to clean up Elasticsearch

Curator lives here:
https://github.com/elastic/curator

## Create the Dockerfile

Navigate to the repo, and find the latest release
https://github.com/elastic/curator

```
$ wget https://github.com/elastic/curator/archive/v5.6.0.tar.gz
$ tar zvxf v5.6.0.tar.gz
$ cd curator-5.6.0/
$ docker build -t dtr.olly.dtcntr.net/admin/curator:5.6.0 .
$ docker push dtr.olly.dtcntr.net/admin/curator:5.6.0
```
