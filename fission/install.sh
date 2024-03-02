#!/bin/bash

# Source
# https://fission.io/docs/usage/languages/python/#working-with-dependencies

# Install Fission
export FISSION_NAMESPACE="fission"
kubectl create namespace $FISSION_NAMESPACE
kubectl create -k "github.com/fission/fission/crds/v1?ref=v1.19.0"
helm repo add fission-charts https://fission.github.io/fission-charts/
helm repo update
helm install --version v1.19.0 --namespace $FISSION_NAMESPACE fission \
  --set serviceType=NodePort,routerServiceType=NodePort \
  fission-charts/fission-all

# Install Fission CLI
curl -Lo fission https://github.com/fission/fission/releases/download/v1.19.0/fission-v1.19.0-linux-amd64 \
    && chmod +x fission && sudo mv fission /usr/local/bin/

# Checking
fission version

export FISSION_URL=http://10.4.110.208:31313
export FISSION_ROUTER=10.4.110.208:31314

echo $FISSION_URL $FISSION_ROUTER
http://10.4.110.208:31313 10.4.110.208:31314

#autoscaller
https://fission.io/docs/usage/function/executor/

fission fn create --name foobar --env nodejs --code hello.js --executortype newdeploy \
    --minscale 1 --maxscale 3 --mincpu 100 --maxcpu 200 --minmemory 128 --maxmemory 256

fission env list
fission route list

# Fibonacci
cd fibonacci
# Single
fission fn create --name fibonacci-single --env python --code fibonacci.py --executortype newdeploy --minscale 1 --maxscale 1
fission route create --method GET --url /fibonacci-single --function fibonacci-single
curl http://10.4.110.208:31314/fibonacci-single?x=10
hey -z 60s -c 10 http://10.4.110.208:31314/fibonacci-single?x=1000
hey -z 300s -c 10 http://10.4.110.208:31314/fibonacci-single?x=1000
hey -z 300s -c 10 -o csv http://10.4.110.208:31314/fibonacci-single?x=1000 > fibonacci-single-10.csv
hey -z 300s -c 50 http://10.4.110.208:31314/fibonacci-single?x=1000
hey -z 300s -c 50 -o csv http://10.4.110.208:31314/fibonacci-single?x=1000 > fibonacci-single-50.csv
hey -z 300s -c 150 http://10.4.110.208:31314/fibonacci-single?x=1000
hey -z 300s -c 150 -o csv http://10.4.110.208:31314/fibonacci-single?x=1000 > fibonacci-single-150.csv

# Multiple
fission fn create --name fibonacci --env python --code fibonacci.py --executortype newdeploy --minscale 1 --maxscale 1000 --mincpu 200 --maxcpu 250 --minmemory 128 --maxmemory 256
fission route create --method GET --url /fibonacci --function fibonacci
curl http://10.4.110.208:31314/fibonacci?x=10
hey -z 300s -c 50 http://10.4.110.208:31314/fibonacci?x=1000

# Quicksort
cd quicksort
# Single
fission function create --name quicksort-single --env python --code quicksort.py --executortype newdeploy --minscale 1 --maxscale 1
fission route create --method GET --url /quicksort-single --function quicksort-single
curl http://10.4.110.208:31314/quicksort-single?x=1,7,4,1,10
hey -z 300s -c 50 http://10.4.110.208:31314/quicksort-single?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
# Multiple
fission function create --name quicksort --env python --code quicksort.py --executortype newdeploy --minscale 1 --maxscale 1000 --mincpu 200 --maxcpu 250 --minmemory 128 --maxmemory 256
fission route create --method GET --url /quicksort --function quicksort
curl http://10.4.110.208:31314/quicksort?x=1,7,4,1,10
hey -z 300s -c 50 http://10.4.110.208:31314/quicksort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2

# Users
cd users
docker build -t wajrcs/python-env --build-arg PY_BASE_IMG=3.7-alpine -f Dockerfile .
docker push wajrcs/python-env
fission env create --name users --image wajrcs/python-env --builder fission/python-builder:latest
# Single
fission function create --name users-single --env users --code users.py --executortype newdeploy --minscale 1 --maxscale 1
fission route create --method GET --url /users --function users-single
fission route create --url /users-single --function users-single --createingress --ingressannotation "kubernetes.io/ingress.class=nginx"
curl http://10.4.110.208:31314/users-single
hey -z 300s -c 50 http://10.4.110.208:31314/users-single
# Multiple
fission function create --name users --env users --code users.py --executortype newdeploy --minscale 1 --maxscale 1000 --mincpu 200 --maxcpu 250 --minmemory 128 --maxmemory 256
fission route create --method GET --url /users --function users
fission route create --url /users --function users --createingress --ingressannotation "kubernetes.io/ingress.class=nginx"
curl http://10.4.110.208:31314/users
hey -z 300s -c 50 http://10.4.110.208:31314/users

# Thumbnail Generator
cd thumbnail
docker build -t wajrcs/python-env-thumb --build-arg PY_BASE_IMG=3.8-alpine -f Dockerfile .
docker push wajrcs/python-env-thumb
fission env create --name thumbnail --image wajrcs/python-env-thumb --builder fission/python-builder:latest
# Single
fission function create --name thumbnail-single --env thumbnail --code thumbnail.py --executortype newdeploy --minscale 1 --maxscale 1
fission fn test --name thumbnail-single
fission route create --method GET --url /thumbnail-single --function thumbnail-single
curl http://10.4.110.208:31314/thumbnail-single
hey -z 300s -c 50 http://10.4.110.208:31314/thumbnail-single
# Multiple
fission function create --name thumbnail --env thumbnail --code thumbnail.py --executortype newdeploy --minscale 1 --maxscale 1000 --mincpu 200 --maxcpu 250 --minmemory 128 --maxmemory 256
fission fn test --name thumbnail
fission route create --method GET --url /thumbnail --function thumbnail
curl http://10.4.110.208:31314/thumbnail
hey -z 300s -c 50 http://10.4.110.208:31314/thumbnail
