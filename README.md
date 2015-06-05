# iotivity-docker-ci

Evaluating docker for build.iotivity.org

Get libs, choose rsync or cp

rsync:
```
mkdir iotivity-extlibs-03272015/
gsutil rsync -d -r -p gs://iotivity-extlibs/iotivity-extlibs-03272015/ iotivity-extlibs-03272015/
chmod -R +x iotivity-extlibs-03272015/
```

cp:
```
gsutil cp gs://iotivity-extlibs/extlibs-03272015.tar.gz .
gsutil cp gs://iotivity-extlibs/extlibs-03272015.md5 .
md5sum extlibs-03272015.tar.gz; cat extlibs-03272015.md5
tar -xvf extlibs-03272015.tar.gz
```

Run build:
```
docker build -t iotivityslave .
docker run --workdir="/root"  -v "$(pwd)"/iotivity-extlibs-03272015:/root/extlibs -t iotivityslave bash -x BuildScript
```
Run build with hosts env variables
```
env > host_env; docker run --workdir="/root" --env-file="$(pwd)"/"host_env"   -v "$(pwd)"/iotivity-extlibs-03272015:/root/extlibs -i -t iotivityslave bash -x BuildScript
```


If you want to mess around in the container after it is built you can jump into interactive mode.
```
docker run --workdir="/root"  -v "$(pwd)"/iotivity-extlibs-03272015:/root/extlibs -i -t iotivityslave /bin/bash
```

TODO use pushed jenkins ENV variables to pull the right refspec.

