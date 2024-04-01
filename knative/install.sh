#!/bin/bash

# Source
# https://knative.dev/docs/install/yaml-install/serving/install-serving-with-yaml/

# Install Knative CLI
wget https://github.com/knative/client/releases/download/knative-v1.13.0/kn-linux-amd64
mv kn-linux-amd64 kn
sudo cp kn /usr/local/bin
sudo chmod +x /usr/local/bin/kn
kn version

# Install the Knative Serving component
# Install the required custom resources by running the command:
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.13.1/serving-crds.yaml
# Install the core components of Knative Serving by running the command:
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.13.1/serving-core.yaml

# Install a networking layer
kubectl apply -f https://github.com/knative/net-kourier/releases/download/knative-v1.13.0/kourier.yaml
kubectl patch configmap/config-network \
  --namespace knative-serving \
  --type merge \
  --patch '{"data":{"ingress-class":"kourier.ingress.networking.knative.dev"}}'

# Verification
kubectl get pods -n knative-serving
kubectl get all -n knative-serving
kubectl --namespace kourier-system get service kourier

# Configure DNS
# here 10.103.12.15 is CLUSTER-IP
kubectl patch configmap -n knative-serving config-domain -p "{\"data\": {\"10.102.154.41.nip.io\": \"\"}}"
kubectl get ksvc -n knative-serverless

# HPA autoscaling
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.13.1/serving-hpa.yaml

# Docker Login
docker login

# Create Namespace
cd functions
kubectl apply -f ./namespace/namespace.yaml

# Check services
kn service ls -n knative-serverless

# Fibonacci
cd fibonacci
docker build -t "wajrcs/fibonacci-knative" .
docker push wajrcs/fibonacci-knative
kubectl apply --filename service.yaml
kubectl apply --filename service-single.yaml
# Single
curl http://fibonacci-single.knative-serverless.10.100.104.164.nip.io?x=1000
hey -z 60s -c 10 http://fibonacci-single.knative-serverless.10.100.104.164.nip.io?x=1000
hey -z 300s -c 10 http://fibonacci-single.knative-serverless.10.100.104.164.nip.io?x=1000
hey -z 300s -c 10 -o csv http://fibonacci-single.knative-serverless.10.100.104.164.nip.io?x=1000 > fibonacci-single-10.csv
hey -z 300s -c 50 http://fibonacci-single.knative-serverless.10.100.104.164.nip.io?x=1000
hey -z 300s -c 50 -o csv http://fibonacci-single.knative-serverless.10.100.104.164.nip.io?x=1000 > fibonacci-single-50.csv
hey -z 300s -c 150 http://fibonacci-single.knative-serverless.10.100.104.164.nip.io?x=1000
hey -z 300s -c 150 -o csv http://fibonacci-single.knative-serverless.10.100.104.164.nip.io?x=1000 > fibonacci-single-150.csv
hey -n 200000 -c 150 -o csv http://fibonacci-single.knative-serverless.10.100.104.164.nip.io?x=1000 > fibonacci-single-200k.csv
# Multiple
curl http://fibonacci.knative-serverless.10.100.104.164.nip.io?x=1000
hey -z 60s -c 10 http://fibonacci.knative-serverless.10.100.104.164.nip.io?x=1000
hey -z 300s -c 10 http://fibonacci.knative-serverless.10.100.104.164.nip.io?x=1000
hey -z 300s -c 10 -o csv http://fibonacci.knative-serverless.10.100.104.164.nip.io?x=1000 > fibonacci-multiple-10.csv
hey -z 300s -c 50 http://fibonacci.knative-serverless.10.100.104.164.nip.io?x=1000
hey -z 300s -c 50 -o csv http://fibonacci.knative-serverless.10.100.104.164.nip.io?x=1000 > fibonacci-multiple-50.csv
hey -z 300s -c 150 http://fibonacci.knative-serverless.10.100.104.164.nip.io?x=1000
hey -z 300s -c 150 -o csv http://fibonacci.knative-serverless.10.100.104.164.nip.io?x=1000 > fibonacci-multiple-150.csv
hey -z 300s -c 250 http://fibonacci.knative-serverless.10.100.104.164.nip.io?x=1000
hey -z 300s -c 250 -o csv http://fibonacci.knative-serverless.10.100.104.164.nip.io?x=1000 > fibonacci-multiple-250.csv
hey -z 300s -c 1000 http://fibonacci.knative-serverless.10.100.104.164.nip.io?x=1000
hey -z 300s -c 1000 -o csv http://fibonacci.knative-serverless.10.100.104.164.nip.io?x=1000 > fibonacci-multiple-1000.csv
hey -n 200000 -c 150 -o csv http://fibonacci.knative-serverless.10.100.104.164.nip.io?x=1000 > fibonacci-multiple-200k.csv

# Quicksort
cd quicksort
docker build -t "wajrcs/quicksort-knative" .
docker push wajrcs/quicksort-knative
kubectl apply --filename service.yaml
kubectl apply --filename service-single.yaml
# Single
curl http://quicksort-single.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
hey -z 60s -c 10 http://quicksort-single.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
hey -z 300s -c 10 http://quicksort-single.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
hey -z 300s -c 10 -o csv http://quicksort-single.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-single-10.csv
hey -z 300s -c 50 http://quicksort-single.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
hey -z 300s -c 50 -o csv http://quicksort-single.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-single-50.csv
hey -z 300s -c 150 http://quicksort-single.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
hey -z 300s -c 150 -o csv http://quicksort-single.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-single-150.csv
hey -n 200000 -c 150 -o csv http://quicksort-single.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-single-200k.csv
# Multiple
curl http://quicksort.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
hey -z 60s -c 10 http://quicksort.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
hey -z 300s -c 10 http://quicksort.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
hey -z 300s -c 10 -o csv http://quicksort.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-multiple-10.csv
hey -z 300s -c 50 http://quicksort.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
hey -z 300s -c 50 -o csv http://quicksort.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-multiple-50.csv
hey -z 300s -c 150 http://quicksort.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
hey -z 300s -c 150 -o csv http://quicksort.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-multiple-150.csv
hey -z 300s -c 250 http://quicksort.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
hey -z 300s -c 250 -o csv http://quicksort.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-multiple-250.csv
hey -z 300s -c 1000 http://quicksort.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
hey -z 300s -c 1000 -o csv http://quicksort.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-multiple-1000.csv
hey -n 200000 -c 150 -o csv http://quicksort.knative-serverless.10.100.104.164.nip.io?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2 > quicksort-multiple-200k.csv

# Users
cd users
docker build -t "wajrcs/users-knative-v2" .
docker push wajrcs/users-knative-v2
kubectl apply --filename service.yaml
kubectl apply --filename service-single.yaml
# Single
curl http://users-single.knative-serverless.10.100.104.164.nip.io
hey -z 60s -c 10 http://users-single.knative-serverless.10.100.104.164.nip.io
hey -z 300s -c 10 http://users-single.knative-serverless.10.100.104.164.nip.io
hey -z 300s -c 10 -o csv http://users-single.knative-serverless.10.100.104.164.nip.io > users-single-10.csv
hey -z 300s -c 50 http://users-single.knative-serverless.10.100.104.164.nip.io
hey -z 300s -c 50 -o csv http://users-single.knative-serverless.10.100.104.164.nip.io > users-single-50.csv
hey -z 300s -c 150 http://users-single.knative-serverless.10.100.104.164.nip.io
hey -z 300s -c 150 -o csv http://users-single.knative-serverless.10.100.104.164.nip.io > users-single-150.csv
hey -n 200000 -c 150 -o csv http://users-single.knative-serverless.10.100.104.164.nip.io > users-single-200k.csv
# Multiple
curl http://users.knative-serverless.10.100.104.164.nip.io
hey -z 60s -c 10 http://users.knative-serverless.10.100.104.164.nip.io
hey -z 300s -c 10 http://users.knative-serverless.10.100.104.164.nip.io
hey -z 300s -c 10 -o csv http://users.knative-serverless.10.100.104.164.nip.io > users-multiple-10.csv
hey -z 300s -c 50 http://users.knative-serverless.10.100.104.164.nip.io
hey -z 300s -c 50 -o csv http://users.knative-serverless.10.100.104.164.nip.io > users-multiple-50.csv
hey -z 300s -c 150 http://users.knative-serverless.10.100.104.164.nip.io
hey -z 300s -c 150 -o csv http://users.knative-serverless.10.100.104.164.nip.io > users-multiple-150.csv
hey -z 300s -c 250 http://users.knative-serverless.10.100.104.164.nip.io
hey -z 300s -c 250 -o csv http://users.knative-serverless.10.100.104.164.nip.io > users-multiple-250.csv
hey -z 300s -c 1000 http://users.knative-serverless.10.100.104.164.nip.io
hey -z 300s -c 1000 -o csv http://users.knative-serverless.10.100.104.164.nip.io > users-multiple-1000.csv
hey -n 200000 -c 150 -o csv http://users.knative-serverless.10.100.104.164.nip.io > users-multiple-200k.csv

# Thumbnail Generator
cd thumbnail
docker build -t "wajrcs/thumbnail-knative" .
docker push wajrcs/thumbnail-knative
kubectl apply --filename service.yaml
kubectl apply --filename service-single.yaml
# Single
curl http://thumbnail-single.knative-serverless.10.100.104.164.nip.io
hey -z 60s -c 10 http://thumbnail-single.knative-serverless.10.100.104.164.nip.io
hey -z 300s -c 10 http://thumbnail-single.knative-serverless.10.100.104.164.nip.io
hey -z 300s -c 10 -o csv http://thumbnail-single.knative-serverless.10.100.104.164.nip.io > thumbnail-single-10.csv
hey -z 300s -c 50 http://thumbnail-single.knative-serverless.10.100.104.164.nip.io
hey -z 300s -c 50 -o csv http://thumbnail-single.knative-serverless.10.100.104.164.nip.io > thumbnail-single-50.csv
hey -z 300s -c 150 http://thumbnail-single.knative-serverless.10.100.104.164.nip.io
hey -z 300s -c 150 -o csv http://thumbnail-single.knative-serverless.10.100.104.164.nip.io > thumbnail-single-150.csv
hey -n 200000 -c 150 -o csv http://thumbnail-single.knative-serverless.10.100.104.164.nip.io > thumbnail-single-200k.csv
# Multiple
curl http://thumbnail.knative-serverless.10.100.104.164.nip.io
hey -z 60s -c 10 http://thumbnail.knative-serverless.10.100.104.164.nip.io
hey -z 300s -c 10 http://thumbnail.knative-serverless.10.100.104.164.nip.io
hey -z 300s -c 10 -o csv http://thumbnail.knative-serverless.10.100.104.164.nip.io > thumbnail-multiple-10.csv
hey -z 300s -c 50 http://thumbnail.knative-serverless.10.100.104.164.nip.io
hey -z 300s -c 50 -o csv http://thumbnail.knative-serverless.10.100.104.164.nip.io > thumbnail-multiple-50.csv
hey -z 300s -c 150 http://thumbnail.knative-serverless.10.100.104.164.nip.io
hey -z 300s -c 150 -o csv http://thumbnail.knative-serverless.10.100.104.164.nip.io > thumbnail-multiple-150.csv
hey -z 300s -c 250 http://thumbnail.knative-serverless.10.100.104.164.nip.io
hey -z 300s -c 250 -o csv http://thumbnail.knative-serverless.10.100.104.164.nip.io > thumbnail-multiple-250.csv
hey -z 300s -c 1000 http://thumbnail.knative-serverless.10.100.104.164.nip.io
hey -z 300s -c 1000 -o csv http://thumbnail.knative-serverless.10.100.104.164.nip.io > thumbnail-multiple-1000.csv
hey -n 200000 -c 150 -o csv http://thumbnail.knative-serverless.10.100.104.164.nip.io > thumbnail-multiple-200k.csv
