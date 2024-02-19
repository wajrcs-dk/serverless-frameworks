#!/bin/bash

# Source
#
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

export FISSION_URL=http://$(minikube ip):31313
export FISSION_ROUTER=$(minikube ip):31314

echo $FISSION_URL $FISSION_ROUTER
http://192.168.49.2:31313 192.168.49.2:31314

#autoscaller
https://fission.io/docs/usage/function/executor/

fission fn create --name foobar --env nodejs --code hello.js --executortype newdeploy \
    --minscale 1 --maxscale 3 --mincpu 100 --maxcpu 200 --minmemory 128 --maxmemory 256

fission env list
fission route list

# Fibonacci
cd fibonacci
fission function create --name fibonacci --env python --code fibonacci.py
fission route create --method GET --url /fibonacci --function fibonacci
curl http://192.168.49.2:31314/fibonacci?x=1000
hey -z 300s -c 50 http://192.168.49.2:31314/fibonacci?x=1000

# Quicksort
cd quicksort
fission function create --name quicksort --env python --code quicksort.py
fission route create --method GET --url /quicksort --function quicksort
curl http://192.168.49.2:31314/quicksort?x=1,7,4,1,10
hey -z 300s -c 50 http://192.168.49.2:31314/quicksort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2

# Users
cd users
docker build -t wajrcs/python-env --build-arg PY_BASE_IMG=3.7-alpine -f Dockerfile .
docker push wajrcs/python-env
fission env create --name users --image wajrcs/python-env --builder fission/python-builder:latest
fission function create --name users --env users --code users.py
fission route create --method GET --url /users --function users
fission route create --url /users --function users --createingress --ingressannotation "kubernetes.io/ingress.class=nginx"
curl http://192.168.49.2:31314/users
hey -z 300s -c 50 http://192.168.49.2:31314/users

# Thumbnail Generator
cd thumbnail
docker build -t wajrcs/python-env-thumb --build-arg PY_BASE_IMG=3.8-alpine -f Dockerfile .
docker push wajrcs/python-env-thumb
fission env create --name thumbnail --image wajrcs/python-env-thumb --builder fission/python-builder:latest
fission function create --name thumbnail --env thumbnail --code thumbnail.py
fission fn test --name thumbnail
fission route create --method GET --url /thumbnail --function thumbnail
curl http://192.168.49.2:31314/thumbnail
hey -z 300s -c 50 http://192.168.49.2:31314/thumbnail

