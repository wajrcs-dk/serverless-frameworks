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
kubectl create namespace nuclio

read -s mypassword # <enter your password>
kubectl --namespace nuclio create secret docker-registry registry-credentials \
    --docker-username wajrcs \
    --docker-password $mypassword \
    --docker-server https://hub.docker.com \
    --docker-email wajrcs@gmail.com
unset mypassword
helm repo add nuclio https://nuclio.github.io/nuclio/charts
helm install nuclio \
    --set registry.secretName=registry-credentials \
    --set registry.pushPullUrl= docker.io/wajrcs \
    --namespace nuclio \
    nuclio/nuclio
kubectl get pods --namespace nuclio

# Fibonacci
cd fibonacci
# Single
cp function-single.yaml function.yaml
sudo nuctl deploy fibonacci-single \
	--namespace nuclio \
	--path /home/waqar/serverless-frameworks/nuclio/functions/fibonacci/fibonacci.py \
	--runtime python \
	--handler fibonacci:handler \
	--http-trigger-service-type NodePort \
	--registry docker.io/wajrcs
curl http://0.0.0.0:31438
hey -z 300s -c 50 http://0.0.0.0:31438
# Multiple
rm function.yaml
cp function-multiple.yaml function.yaml
sudo nuctl deploy fibonacci \
	--namespace nuclio \
	--path /home/waqar/serverless-frameworks/nuclio/functions/fibonacci/fibonacci.py \
	--runtime python \
	--handler fibonacci:handler \
	--http-trigger-service-type NodePort \
	--registry docker.io/wajrcs
curl http://0.0.0.0:31438
hey -z 300s -c 50 http://0.0.0.0:31438

# Quicksort
cd quicksort
# Single
cp function-single.yaml function.yaml
sudo nuctl deploy quicksort-single \
	--namespace nuclio \
	--path /home/waqar/serverless-frameworks/nuclio/functions/quicksort/quicksort.py \
	--runtime python \
	--handler quicksort:handler \
	--http-trigger-service-type NodePort \
	--registry docker.io/wajrcs
curl http://0.0.0.0:32770
hey -z 300s -c 50 http://0.0.0.0:32770
# Multiple
rm function.yaml
cp function-multiple.yaml function.yaml
sudo nuctl deploy quicksort \
	--namespace nuclio \
	--path /home/waqar/serverless-frameworks/nuclio/functions/quicksort/quicksort.py \
	--runtime python \
	--handler quicksort:handler \
	--http-trigger-service-type NodePort \
	--registry docker.io/wajrcs
curl http://0.0.0.0:32771
hey -z 300s -c 50 http://0.0.0.0:32771

# Users
cd users
# Single
docker build -t 0.0.0.0:5000/users:v1 .
docker push 0.0.0.0:5000/users:v1
mv function-single.yaml function.yaml
nuctl deploy users-single \
  --verbose \
  --namespace nuclio \
  --runtime python \
  --handler users:handler \
  --run-image users:v1 \
  --http-trigger-service-type NodePort \
  --registry 0.0.0.0:5000 --run-registry localhost:5000
# Multiple
rm function.yaml
cp function-multiple.yaml function.yaml
sudo nuctl deploy users \
  --verbose \
  --namespace nuclio \
  --runtime python \
  --handler users:handler \
  --run-image users:v1 \
  --http-trigger-service-type NodePort \
  --registry 0.0.0.0:5000 --run-registry localhost:5000
curl  http://0.0.0.0:30534
hey -z 300s -c 50 http://0.0.0.0:30534

# Thumbnail Generator
cd thumbnail
# Single
docker build -t thumbnail:v1 .
docker push thumbnail:v1
cp function-single.yaml function.yaml
sudo nuctl deploy thumbnail-single \
  --verbose \
  --namespace nuclio \
  --runtime python \
  --handler thumbnail:handler \
  --run-image thumbnail:v1 \
  --http-trigger-service-type NodePort \
  --registry docker.io/wajrcs
curl  http://0.0.0.0:32772
hey -z 300s -c 50  http://0.0.0.0:32772
# Multiple
rm function.yaml
cp function-multiple.yaml function.yaml
sudo nuctl deploy thumbnail \
  --verbose \
  --namespace nuclio \
  --runtime python \
  --handler thumbnail:handler \
  --run-image thumbnail:v1 \
  --http-trigger-service-type NodePort \
  --registry docker.io/wajrcs
curl  http://0.0.0.0:32773
hey -z 300s -c 50  http://0.0.0.0:32773