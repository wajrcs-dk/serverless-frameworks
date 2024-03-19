#!/bin/bash

# Source
# https://medium.com/@ansjin/openwhisk-deployment-on-a-kubernetes-cluster-7fd3fc2f3726
# https://github.com/apache/openwhisk-deploy-kube#initial-setup

kubectl create namespace openwhisk
kubectl label nodes vmserverless0 openwhisk-role=core
kubectl label nodes vmserverless1 openwhisk-role=invoker
kubectl label nodes vmserverless2 openwhisk-role=invoker

git clone https://github.com/apache/openwhisk-deploy-kube.git  && cd openwhisk-deploy-kube

nano mycluster.yaml

controller:
  replicaCount: 2
whisk:
  ingress:
    type: NodePort
    apiHostName: 192.168.49.2
    apiHostPort: 31001
  limits:
    actionsInvokesPerminute: 75000
    actionsInvokesConcurrent: 250
    triggersFiresPerminute: 75000
    actionsSequenceMaxlength: 75000
    actions:
      minuteRate: 75000
      concurrency:
        min: 1
        max: 1000
        std: 150
    activation:
      payload:
        max: "1048576"
k8s:
  persistence:
    enabled: false
nginx:
  httpsNodePort: 31001
invoker:
  containerFactory:
    impl: "kubernetes"
metrics:
  prometheusEnabled: true
  userMetricsEnabled: true

wget https://github.com/apache/openwhisk-cli/releases/download/latest/OpenWhisk_CLI-latest-linux-386.tgz
tar -xvf OpenWhisk_CLI-latest-linux-386.tgz
sudo mv wsk /usr/local/bin/wsk

wget https://github.com/apache/openwhisk-wskdeploy/releases/download/1.2.0/openwhisk_wskdeploy-1.2.0-linux-amd64.tgz
tar -xvf openwhisk_wskdeploy-1.2.0-linux-amd64.tgz
sudo mv wskdeploy /usr/local/bin/wskdeploy

helm install owdev ./helm/openwhisk -n openwhisk --create-namespace -f mycluster.yaml
helm uninstall owdev -n openwhisk

kubectl -n openwhisk get pods -w
wsk property set --apihost 192.168.49.2:31001
wsk property set --auth 23bc46b1-71f6-4ed5-8c54-816aa4f8c502:123zO3xZCLrMN6v2BKK1dXYFpXlPkccOFqm12CdAsMgRU4VrNZ9lyGVCGuMDGIwP
wsk list -i
wsk api list -i

export NODE_TLS_REJECT_UNAUTHORIZED="0"

# Fibonacci
cd fibonacci
wsk api list -i
wskdeploy -m fibonacci.yaml
curl --insecure https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100
hey -z 60s -c 10 https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=1000
hey -z 300s -c 10 https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=1000
hey -z 300s -c 10 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100 > fibonacci-single-10.csv
hey -z 300s -c 50 https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100
hey -z 300s -c 50 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100 > fibonacci-single-50.csv
hey -z 300s -c 150 https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100
hey -z 300s -c 150 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100 > fibonacci-single-150.csv
hey -z 300s -c 250 https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100
hey -z 300s -c 250 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100 > fibonacci-multiple-250.csv
hey -z 300s -c 1000 https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100
hey -z 300s -c 1000 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100 > fibonacci-multiple-1000.csv

# Quicksort
cd quicksort
wsk api list -i
wskdeploy -m quicksort.yaml
curl --insecure https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/quick/sort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
hey -z 60s -c 10  https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/quick/sort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
hey -z 300s -c 10 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/quick/sort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-single-10.csv
hey -z 300s -c 50 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/quick/sort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-single-50.csv
hey -z 300s -c 150 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/quick/sort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-single-150.csv
hey -z 300s -c 250 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/quick/sort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-multiple-250.csv
hey -z 300s -c 1000 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/quick/sort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-multiple-1000.csv

# Users
cd users

# Thumbnail Generator
cd thumbnail
