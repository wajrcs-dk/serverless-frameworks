#!/bin/bash

# Source
# https://nuclio.io/docs/latest/setup/k8s/getting-started-k8s/
# https://nuclio.io/docs/latest/setup/k8s/running-in-production-k8s/

# Nuclio CLI
curl -s https://api.github.com/repos/nuclio/nuclio/releases/latest \
			| grep -i "browser_download_url.*nuctl.*$(uname)" \
			| cut -d : -f 2,3 \
			| tr -d \" \
			| wget -O nuctl -qi - && chmod +x nuctl
sudo mv nuctl /usr/local/bin/

# Install Nuclio
kubectl -- create namespace nuclio
helm repo add nuclio https://nuclio.github.io/nuclio/charts
helm --namespace nuclio install nuclio nuclio/nuclio
kubectl get pods --namespace nuclio

# Fibonacci
cd fibonacci
mv function-single.yaml function.yaml
nuctl deploy fibonacci-single \
	--namespace nuclio \
	--path /vagrant_data/fibonacci/fibonacci.py \
	--runtime python \
	--handler fibonacci:handler \
	--http-trigger-service-type NodePort \
	--registry 192.168.49.2:5000 --run-registry localhost:5000
mv function-multiple.yaml function.yaml
nuctl deploy fibonacci \
	--namespace nuclio \
	--path /vagrant_data/fibonacci/fibonacci.py \
	--runtime python \
	--handler fibonacci:handler \
	--http-trigger-service-type NodePort \
	--registry 192.168.49.2:5000 --run-registry localhost:5000
curl http://192.168.49.2:31438
hey -z 300s -c 50 http://192.168.49.2:31438

# Quicksort
cd quicksort
mv function-single.yaml function.yaml
nuctl deploy quicksort-single \
	--namespace nuclio \
	--path /vagrant_data/quicksort/quicksort.py \
	--runtime python \
	--handler quicksort:handler \
	--http-trigger-service-type NodePort \
	--registry 192.168.49.2:5000 --run-registry localhost:5000
mv function-multiple.yaml function.yaml
nuctl deploy quicksort \
	--namespace nuclio \
	--path /vagrant_data/quicksort/quicksort.py \
	--runtime python \
	--handler quicksort:handler \
	--http-trigger-service-type NodePort \
	--registry 192.168.49.2:5000 --run-registry localhost:5000
curl http://192.168.49.2:30424
hey -z 300s -c 50 http://192.168.49.2:30424

# Users
cd users
docker build -t 192.168.49.2:5000/users:v1 .
docker push 192.168.49.2:5000/users:v1
mv function-single.yaml function.yaml
nuctl deploy users-single \
  --verbose \
  --namespace nuclio \
  --runtime python \
  --handler users:handler \
  --run-image users:v1 \
  --http-trigger-service-type NodePort \
  --registry 192.168.49.2:5000 --run-registry localhost:5000
mv function-multiple.yaml function.yaml
nuctl deploy users \
  --verbose \
  --namespace nuclio \
  --runtime python \
  --handler users:handler \
  --run-image users:v1 \
  --http-trigger-service-type NodePort \
  --registry 192.168.49.2:5000 --run-registry localhost:5000
curl  http://192.168.49.2:30534
hey -z 300s -c 50 http://192.168.49.2:30534

# Thumbnail Generator
cd thumbnail
docker build -t 192.168.49.2:5000/thumbnail:v1 .
docker push 192.168.49.2:5000/thumbnail:v1
mv function-single.yaml function.yaml
nuctl deploy thumbnail-single \
  --verbose \
  --namespace nuclio \
  --runtime python \
  --handler thumbnail:handler \
  --run-image thumbnail:v1 \
  --http-trigger-service-type NodePort \
  --registry 192.168.49.2:5000 --run-registry localhost:5000
mv function-multiple.yaml function.yaml
nuctl deploy thumbnail \
  --verbose \
  --namespace nuclio \
  --runtime python \
  --handler thumbnail:handler \
  --run-image thumbnail:v1 \
  --http-trigger-service-type NodePort \
  --registry 192.168.49.2:5000 --run-registry localhost:5000
curl  http://192.168.49.2:31438
hey -z 300s -c 50  http://192.168.49.2:31438