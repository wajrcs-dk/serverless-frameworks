#!/bin/bash

# Source

kubectl create namespace openwhisk
kubectl label nodes --all openwhisk-role=invoker

git clone https://github.com/apache/openwhisk-deploy-kube.git  && cd openwhisk-deploy-kube

nano mycluster.yaml

whisk:
  ingress:
    type: NodePort
    apiHostName: 192.168.49.2
    apiHostPort: 31001
  limits:
    actionsInvokesPerminute: 1000
    actionsInvokesConcurrent: 1000
    triggersFiresPerminute: 60
    actionsSequenceMaxlength: 50
    actions:
      time:
        min: "100ms"
        max: "5m"
        std: "1m"
      memory:
        min: "128m"
        max: "512m"
        std: "256m"
      concurrency:
        min: 1
        max: 10000
        std: 5000
      log:
        min: "0m"
        max: "10m"
        std: "10m"
    activation:
      payload:
        max: "1048576"
nginx:
  httpsNodePort: 31001

helm install owdev ./helm/openwhisk -n openwhisk --create-namespace -f mycluster.yaml
kubectl -n openwhisk get pods
wsk property set --apihost $(minikube ip):31001 --auth 23bc46b1-71f6-4ed5-8c54-816aa4f8c502:123zO3xZCLrMN6v2BKK1dXYFpXlPkccOFqm12CdAsMgRU4VrNZ9lyGVCGuMDGIwP
wsk list -i
wsk api list -i

# Fibonacci
cd fibonacci
wsk api list -i
wskdeploy -m fibonacci.yaml
curl https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/hello/world?x=10
hey -z 300s -c 10 https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/hello/world?x=10

# Quicksort
cd quicksort
wsk api list -i
wskdeploy -m quicksort.yaml
curl https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/quick/sort?x=1,7,4,1,10
hey -z 300s -c 10 https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/quick/sort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2

# Users
cd users

# Thumbnail Generator
cd thumbnail