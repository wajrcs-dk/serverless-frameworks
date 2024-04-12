#!/bin/bash

# Source
# https://medium.com/@ansjin/openwhisk-deployment-on-a-kubernetes-cluster-7fd3fc2f3726
# https://github.com/apache/openwhisk-deploy-kube#initial-setup
# https://gist.github.com/aweijnitz/fa209cba244484afed0b824fb4c3e9f0
# https://cloud.ibm.com/docs/openwhisk?topic=openwhisk-prep

kubectl create namespace openwhisk
kubectl label nodes vmserverless0 openwhisk-role=core
kubectl label nodes vmserverless1 openwhisk-role=invoker
kubectl label nodes vmserverless2 openwhisk-role=invoker
# Minikube
kubectl label nodes --all openwhisk-role=invoker --overwrite

git clone https://github.com/apache/openwhisk-deploy-kube.git  && cd openwhisk-deploy-kube

nano mycluster.yaml

10.4.110.208
192.168.49.2

controller:
  replicaCount: 1
whisk:
  ingress:
    type: NodePort
    apiHostName: 10.4.110.208
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
wsk property set --apihost 10.4.110.208:31001
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
hey -z 60s -c 10 https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100
# Single
hey -z 300s -c 10 https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=1000
hey -z 300s -c 10 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100 > fibonacci-single-10.csv
hey -z 300s -c 50 https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100
hey -z 300s -c 50 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100 > fibonacci-single-50.csv
hey -z 300s -c 150 https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100
hey -z 300s -c 150 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100 > fibonacci-single-150.csv
hey -n 200000 -c 150 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100 > fibonacci-single-200k.csv
# Multiple
hey -z 300s -c 10 https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=1000
hey -z 300s -c 10 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100 > fibonacci-multiple-10.csv
hey -z 300s -c 50 https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100
hey -z 300s -c 50 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100 > fibonacci-multiple-50.csv
hey -z 300s -c 150 https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100
hey -z 300s -c 150 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100 > fibonacci-multiple-150.csv
hey -z 300s -c 250 https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100
hey -z 300s -c 250 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100 > fibonacci-multiple-250.csv
hey -z 300s -c 1000 https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100
hey -z 300s -c 1000 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/fibo/nacci?x=100 > fibonacci-multiple-1000.csv

# Quicksort
cd quicksort
wsk api list -i
wskdeploy -m quicksort.yaml
curl --insecure https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/quick/sort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
# Single
hey -z 60s -c 10  https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/quick/sort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
hey -z 300s -c 10 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/quick/sort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-single-10.csv
hey -z 300s -c 50 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/quick/sort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-single-50.csv
hey -z 300s -c 150 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/quick/sort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-single-150.csv
hey -z 300s -n 200000 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/quick/sort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-single-200k.csv
# Multiple
hey -z 60s -c 10  https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/quick/sort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
hey -z 300s -c 10 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/quick/sort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-multiple-10.csv
hey -z 300s -c 50 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/quick/sort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-multiple-50.csv
hey -z 300s -c 150 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/quick/sort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-multiple-150.csv
hey -z 300s -c 250 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/quick/sort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-multiple-250.csv
hey -z 300s -c 1000 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/quick/sort?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-multiple-1000.csv

sudo apt install python3-pip
pip3 install virtualenv
sudo apt install python3-virtualenv

# Users
cd users
virtualenv virtualenv
source virtualenv/bin/activate
python --version
pip install mysql-connector-python-rf
deactivate
# delete old action for testing
wsk action delete users -i
rm users.zip
# deploy function
zip -r users.zip virtualenv __main__.py
wsk action create users users.zip --web true --kind python:3  -i
wsk action invoke users --result  -i
wsk api create /users get users --response-type json  -i
curl --insecure https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/users
hey -z 60s -c 10  https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/users
# Single
hey -z 300s -c 10 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/users > users-single-10.csv
hey -z 300s -c 50 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/users > users-single-50.csv
hey -z 300s -c 150 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/users > users-single-150.csv
# Multiple
hey -z 300s -c 10 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/users > users-multiple-10.csv
hey -z 300s -c 50 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/users > users-multiple-50.csv
hey -z 300s -c 150 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/users > users-multiple-150.csv
hey -n 200000 -c 150 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/users > users-multiple-200k.csv
hey -z 300s -c 250 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/users > users-multiple-250.csv
hey -z 300s -c 1000 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/users > users-multiple-1000.csv

# Thumbnail Generator
cd thumbnail
# https://www.linuxcapable.com/how-to-install-python-3-7-on-ubuntu-linux/
python3.7 -m venv virtualenv
sudo apt-get install python3.7-distutils
virtualenv virtualenv
virtualenv virtualenv --python=python3.7
source virtualenv/bin/activate
python --version
pip install typing_extensions
pip install Pillow
deactivate
# delete old action for testing
wsk action delete thumbnail -i
rm thumbnail.zip
rm __main__.py
nano __main__.py
# deploy function
zip -r thumbnail.zip virtualenv __main__.py image.jpg
wsk action create thumbnail thumbnail.zip --web true --kind python:3 -i
wsk action invoke thumbnail --result  -i
wsk api create /thumbnail get thumbnail --response-type json  -i
wsk activation get --last -i
curl --insecure https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/thumbnail
hey -z 60s -c 10  https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/thumbnail
# Single
hey -z 300s -c 10 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/thumbnail > thumbnail-single-10.csv
hey -z 300s -c 50 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/thumbnail > thumbnail-single-50.csv
hey -z 300s -c 150 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/thumbnail > thumbnail-single-150.csv
# Multiple
hey -z 300s -c 10 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/thumbnail > thumbnail-multiple-10.csv
hey -z 300s -c 50 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/thumbnail > thumbnail-multiple-50.csv
hey -z 300s -c 150 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/thumbnail > thumbnail-multiple-150.csv
hey -n 200000 -c 150 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/thumbnail > thumbnail-multiple-200k.csv
hey -z 300s -c 250 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/thumbnail > thumbnail-multiple-250.csv
hey -z 300s -c 1000 -o csv https://192.168.49.2:31001/api/23bc46b1-71f6-4ed5-8c54-816aa4f8c502/thumbnail > thumbnail-multiple-1000.csv