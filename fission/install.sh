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
X hey -z 60s -c 10 http://10.4.110.208:31314/fibonacci-single?x=1000
X hey -z 300s -c 10 http://10.4.110.208:31314/fibonacci-single?x=1000
X hey -z 300s -c 10 -o csv http://10.4.110.208:31314/fibonacci-single?x=1000 > fibonacci-single-10.csv
X hey -z 300s -c 50 http://10.4.110.208:31314/fibonacci-single?x=1000
X hey -z 300s -c 50 -o csv http://10.4.110.208:31314/fibonacci-single?x=1000 > fibonacci-single-50.csv
X hey -z 300s -c 150 http://10.4.110.208:31314/fibonacci-single?x=1000
X hey -z 300s -c 150 -o csv http://10.4.110.208:31314/fibonacci-single?x=1000 > fibonacci-single-150.csv
# Multiple
fission fn create --name fibonacci --env python --code fibonacci.py --executortype newdeploy --minscale 1 --maxscale 1000
fission route create --method GET --url /fibonacci --function fibonacci
curl http://10.4.110.208:31314/fibonacci?x=10
X hey -z 60s -c 10 http://10.4.110.208:31314/fibonacci?x=1000
X hey -z 300s -c 10 http://10.4.110.208:31314/fibonacci?x=1000
X hey -z 300s -c 10 -o csv http://10.4.110.208:31314/fibonacci?x=1000 > fibonacci-multiple-10.csv
X hey -z 300s -c 50 http://10.4.110.208:31314/fibonacci?x=1000
X hey -z 300s -c 50 -o csv http://10.4.110.208:31314/fibonacci?x=1000 > fibonacci-multiple-50.csv
X hey -z 300s -c 150 http://10.4.110.208:31314/fibonacci?x=1000
X hey -z 300s -c 150 -o csv http://10.4.110.208:31314/fibonacci?x=1000 > fibonacci-multiple-150.csv
X hey -z 300s -c 250 http://10.4.110.208:31314/fibonacci?x=1000
X hey -z 300s -c 250 -o csv http://10.4.110.208:31314/fibonacci?x=1000 > fibonacci-multiple-250.csv
X hey -z 300s -c 1000 http://10.4.110.208:31314/fibonacci?x=1000
X hey -z 300s -c 1000 -o csv http://10.4.110.208:31314/fibonacci?x=1000 > fibonacci-multiple-1000.csv
# Quicksort
cd quicksort
# Single
fission function create --name quicksort-single --env python --code quicksort.py --executortype newdeploy --minscale 1 --maxscale 1
fission route create --method GET --url /quicksort-single --function quicksort-single
curl http://10.4.110.208:31314/quicksort-single?x=1,7,4,1,10
hey -z 60s -c 10 http://10.4.110.208:31314/quicksort-single?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
X hey -z 300s -c 10 http://10.4.110.208:31314/quicksort-single?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
X hey -z 300s -c 10 -o csv http://10.4.110.208:31314/quicksort-single?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-single-10.csv
X hey -z 300s -c 50 http://10.4.110.208:31314/quicksort-single?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
X hey -z 300s -c 50 -o csv http://10.4.110.208:31314/quicksort-single?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-single-50.csv
X hey -z 300s -c 150 http://10.4.110.208:31314/quicksort-single?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
X hey -z 300s -c 150 -o csv http://10.4.110.208:31314/quicksort-single?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-single-150.csv
# Multiple
fission function create --name quicksort --env python --code quicksort.py --executortype newdeploy --minscale 1 --maxscale 1000
fission route create --method GET --url /quicksort --function quicksort
curl http://10.4.110.208:31314/quicksort?x=1,7,4,1,10
X hey -z 60s -c 10 http://10.4.110.208:31314/quicksort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
X hey -z 300s -c 10 http://10.4.110.208:31314/quicksort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
X hey -z 300s -c 10 -o csv http://10.4.110.208:31314/quicksort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-multiple-10.csv
X hey -z 300s -c 50 http://10.4.110.208:31314/quicksort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
X hey -z 300s -c 50 -o csv http://10.4.110.208:31314/quicksort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-multiple-50.csv
X hey -z 300s -c 150 http://10.4.110.208:31314/quicksort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
X hey -z 300s -c 150 -o csv http://10.4.110.208:31314/quicksort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-multiple-150.csv
X hey -z 300s -c 250 http://10.4.110.208:31314/quicksort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
X hey -z 300s -c 250 -o csv http://10.4.110.208:31314/quicksort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-multiple-250.csv
X hey -z 300s -c 1000 http://10.4.110.208:31314/quicksort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
X hey -z 300s -c 1000 -o csv http://10.4.110.208:31314/quicksort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-multiple-1000.csv

# Users
cd users
sudo docker build -t wajrcs/python-users-env --build-arg PY_BASE_IMG=3.7-alpine -f Dockerfile .
sudo docker push wajrcs/python-users-env
fission env create --name env-users --image wajrcs/python-users-env --builder fission/python-builder:latest
# Single
fission function create --name users-single --env env-users --code users.py --executortype newdeploy --minscale 1 --maxscale 1
fission function test --name users-single
fission route create --method GET --url /users-single --function users-single
fission route create --url /users-single --function users-single --createingress --ingressannotation "kubernetes.io/ingress.class=nginx"
curl http://10.4.110.208:31314/users-single
X hey -z 60s -c 10 http://10.4.110.208:31314/users-single
X hey -z 300s -c 10 http://10.4.110.208:31314/users-single
X hey -z 300s -c 10 -o csv http://10.4.110.208:31314/users-single > users-single-10.csv
X hey -z 300s -c 50 http://10.4.110.208:31314/users-single
X hey -z 300s -c 50 -o csv http://10.4.110.208:31314/users-single > users-single-50.csv
X hey -z 300s -c 150 http://10.4.110.208:31314/users-single
X hey -z 300s -c 150 -o csv http://10.4.110.208:31314/users-single > users-single-150.csv
# Multiple
fission function create --name users --env env-users --code users.py --executortype newdeploy --minscale 1 --maxscale 1000
fission route create --method GET --url /users --function users
curl http://10.4.110.208:31314/users
X hey -z 60s -c 10 http://10.4.110.208:31314/users
X hey -z 300s -c 10 http://10.4.110.208:31314/users
X hey -z 300s -c 10 -o csv http://10.4.110.208:31314/users > users-multiple-10.csv
X hey -z 300s -c 50 http://10.4.110.208:31314/users
X hey -z 300s -c 50 -o csv http://10.4.110.208:31314/users > users-multiple-50.csv
X hey -z 300s -c 150 http://10.4.110.208:31314/users
X hey -z 300s -c 150 -o csv http://10.4.110.208:31314/users > users-multiple-150.csv
X hey -z 300s -c 250 http://10.4.110.208:31314/users
X hey -z 300s -c 250 -o csv http://10.4.110.208:31314/users > users-multiple-250.csv
X hey -z 300s -c 1000 http://10.4.110.208:31314/users
X hey -z 300s -c 1000 -o csv http://10.4.110.208:31314/users > users-multiple-1000.csv

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
X hey -z 60s -c 10 http://10.4.110.208:31314/thumbnail-single
X hey -z 300s -c 10 http://10.4.110.208:31314/thumbnail-single
X hey -z 300s -c 10 -o csv http://10.4.110.208:31314/thumbnail-single > thumbnail-single-10.csv
X hey -z 300s -c 50 http://10.4.110.208:31314/thumbnail-single
X hey -z 300s -c 50 -o csv http://10.4.110.208:31314/thumbnail-single > thumbnail-single-50.csv
X hey -z 300s -c 150 http://10.4.110.208:31314/thumbnail-single
X hey -z 300s -c 150 -o csv http://10.4.110.208:31314/thumbnail-single > thumbnail-single-150.csv
# Multiple
fission function create --name thumbnail --env thumbnail --code thumbnail.py --executortype newdeploy --minscale 1 --maxscale 1000
fission fn test --name thumbnail
fission route create --method GET --url /thumbnail --function thumbnail
curl http://10.4.110.208:31314/thumbnail
X hey -z 60s -c 10 http://10.4.110.208:31314/thumbnail
X hey -z 300s -c 10 http://10.4.110.208:31314/thumbnail
X hey -z 300s -c 10 -o csv http://10.4.110.208:31314/thumbnail > thumbnail-multiple-10.csv
X hey -z 300s -c 50 http://10.4.110.208:31314/thumbnail
X hey -z 300s -c 50 -o csv http://10.4.110.208:31314/thumbnail > thumbnail-multiple-50.csv
X hey -z 300s -c 150 http://10.4.110.208:31314/thumbnail
X hey -z 300s -c 150 -o csv http://10.4.110.208:31314/thumbnail > thumbnail-multiple-150.csv
X hey -z 300s -c 250 http://10.4.110.208:31314/thumbnail
X hey -z 300s -c 250 -o csv http://10.4.110.208:31314/thumbnail > thumbnail-multiple-250.csv
X hey -z 300s -c 1000 http://10.4.110.208:31314/thumbnail
X hey -z 300s -c 1000 -o csv http://10.4.110.208:31314/thumbnail > thumbnail-multiple-1000.csv
