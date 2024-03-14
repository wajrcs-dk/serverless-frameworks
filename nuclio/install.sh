#!/bin/bash

# Source
# https://nuclio.io/docs/latest/setup/k8s/getting-started-k8s/
# https://nuclio.io/docs/latest/setup/k8s/running-in-production-k8s/
# https://github.com/nuclio/nuclio/blob/development/docs/reference/function-configuration/function-configuration-reference.md

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
curl http://0.0.0.0:32768
X hey -z 60s -c 10 http://0.0.0.0:32768
X hey -z 300s -c 10 http://0.0.0.0:32768
X hey -z 300s -c 10 -o csv http://0.0.0.0:32768 > fibonacci-single-10.csv
X hey -z 300s -c 50 http://0.0.0.0:32768
X hey -z 300s -c 50 -o csv http://0.0.0.0:32768 > fibonacci-single-50.csv
X hey -z 300s -c 150 http://0.0.0.0:32768
X hey -z 300s -c 150 -o csv http://0.0.0.0:32768 > fibonacci-single-150.csv
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
curl http://0.0.0.0:32769
X hey -z 60s -c 10 http://0.0.0.0:32769
X hey -z 300s -c 10 http://0.0.0.0:32769
X hey -z 300s -c 10 -o csv http://0.0.0.0:32769 > fibonacci-multiple-10.csv
X hey -z 300s -c 50 http://0.0.0.0:32769
X hey -z 300s -c 50 -o csv http://0.0.0.0:32769 > fibonacci-multiple-50.csv
X hey -z 300s -c 150 http://0.0.0.0:32769
X hey -z 300s -c 150 -o csv http://0.0.0.0:32769 > fibonacci-multiple-150.csv
X hey -z 300s -c 250 http://0.0.0.0:32769
X hey -z 300s -c 250 -o csv http://0.0.0.0:32769 > fibonacci-multiple-250.csv
X hey -z 300s -c 1000 http://0.0.0.0:32769
X hey -z 300s -c 1000 -o csv http://0.0.0.0:32769 > fibonacci-multiple-1000.csv

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
X hey -z 60s -c 10 http://0.0.0.0:32770
X hey -z 300s -c 10 http://0.0.0.0:32770
X hey -z 300s -c 10 -o csv http://0.0.0.0:32770 > quicksort-single-10.csv
X hey -z 300s -c 50 http://0.0.0.0:32770
X hey -z 300s -c 50 -o csv http://0.0.0.0:32770 > quicksort-single-50.csv
X hey -z 300s -c 150 http://0.0.0.0:32770
X hey -z 300s -c 150 -o csv http://0.0.0.0:32770 > quicksort-single-150.csv
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
X hey -z 60s -c 10 http://0.0.0.0:32771
X hey -z 300s -c 10 http://0.0.0.0:32770
X hey -z 300s -c 10 -o csv http://0.0.0.0:32770 > quicksort-multiple-10.csv
X hey -z 300s -c 50 http://0.0.0.0:32770
X hey -z 300s -c 50 -o csv http://0.0.0.0:32770 > quicksort-multiple-50.csv
X hey -z 300s -c 150 http://0.0.0.0:32770
X hey -z 300s -c 150 -o csv http://0.0.0.0:32770 > quicksort-multiple-150.csv
X hey -z 300s -c 250 http://0.0.0.0:32770
X hey -z 300s -c 250 -o csv http://0.0.0.0:32770 > quicksort-multiple-250.csv
X hey -z 300s -c 1000 http://0.0.0.0:32770
X hey -z 300s -c 1000 -o csv http://0.0.0.0:32770 > quicksort-multiple-1000.csv

# Users
cd users
# Single
sudo docker build -t users:v1 .
sudo docker push users:v1
cp function-single.yaml function.yaml
sudo nuctl deploy users-single \
  --verbose \
  --namespace default \
  --runtime python \
  --handler users:handler \
  --run-image users:v1 \
  --http-trigger-service-type NodePort \
  --registry docker.io/wajrcs
curl http://0.0.0.0:32779
X hey -z 60s -c 10 http://0.0.0.0:32779
X hey -z 300s -c 10 http://0.0.0.0:32779
X hey -z 300s -c 10 -o csv http://0.0.0.0:32779 > users-single-10.csv
X hey -z 300s -c 50 http://0.0.0.0:32779
X hey -z 300s -c 50 -o csv http://0.0.0.0:32779 > users-single-50.csv
X hey -z 300s -c 150 http://0.0.0.0:32779
X hey -z 300s -c 150 -o csv http://0.0.0.0:32779 > users-single-150.csv
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
  --registry docker.io/wajrcs
curl  http://0.0.0.0:32780
X hey -z 60s -c 10 http://0.0.0.0:32780
X hey -z 300s -c 10 http://0.0.0.0:32780
X hey -z 300s -c 10 -o csv http://0.0.0.0:32780 > users-multiple-10.csv
X hey -z 300s -c 50 http://0.0.0.0:32780
X hey -z 300s -c 50 -o csv http://0.0.0.0:32780 > users-multiple-50.csv
X hey -z 300s -c 150 http://0.0.0.0:32780
X hey -z 300s -c 150 -o csv http://0.0.0.0:32780 > users-multiple-150.csv
X hey -z 300s -c 250 http://0.0.0.0:32780
X hey -z 300s -c 250 -o csv http://0.0.0.0:32780 > users-multiple-250.csv
X hey -z 300s -c 1000 http://0.0.0.0:32780
X hey -z 300s -c 1000 -o csv http://0.0.0.0:32780 > users-multiple-1000.csv
# Fixed
rm function.yaml
cp function-fixed.yaml function.yaml
sudo nuctl deploy users-fixed \
  --verbose \
  --namespace nuclio \
  --runtime python \
  --handler users:handler \
  --run-image users:v1 \
  --http-trigger-service-type NodePort \
  --registry docker.io/wajrcs
curl  http://0.0.0.0:32783

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
X hey -z 60s -c 10  http://0.0.0.0:32772
X hey -z 300s -c 10  http://0.0.0.0:32772
X hey -z 300s -c 10 -o csv http://0.0.0.0:32772 > users-single-10.csv
X hey -z 300s -c 50  http://0.0.0.0:32772
X hey -z 300s -c 50 -o csv http://0.0.0.0:32772 > users-single-50.csv
X hey -z 300s -c 150  http://0.0.0.0:32772
X hey -z 300s -c 150 -o csv http://0.0.0.0:32772 > users-single-150.csv
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
X hey -z 60s -c 10  http://0.0.0.0:32773
X hey -z 300s -c 10  http://0.0.0.0:32773
X hey -z 300s -c 10  http://0.0.0.0:32773 > users-multiple-10.csv
X hey -z 300s -c 50  http://0.0.0.0:32773
X hey -z 300s -c 50  http://0.0.0.0:32773 > users-multiple-50.csv
X hey -z 300s -c 150  http://0.0.0.0:32773
X hey -z 300s -c 150  http://0.0.0.0:32773 > users-multiple-150.csv
X hey -z 300s -c 250  http://0.0.0.0:32773
X hey -z 300s -c 250  http://0.0.0.0:32773 > users-multiple-250.csv
X hey -z 300s -c 1000  http://0.0.0.0:32773
X hey -z 300s -c 1000  http://0.0.0.0:32773 > users-multiple-1000.csv