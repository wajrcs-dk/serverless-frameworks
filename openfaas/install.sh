#!/bin/bash

# Source
kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml
helm repo add openfaas https://openfaas.github.io/faas-netes/
helm repo update
kubectl -n openfaas create secret generic basic-auth --from-literal=basic-auth-user=admin --from-literal=basic-auth-password="click123"
helm upgrade openfaas --install openfaas/openfaas --namespace openfaas --set functionNamespace=openfaas-fn --set basic_auth=true
echo $(kubectl -n openfaas get secret basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode)
# 2nQAyZrzBI32

# Fass
curl -sL cli.openfaas.com | sudo sh

# Setup URL for OpenFaas
export OPENFAAS_URL=10.4.110.208:31112
export gw=10.4.110.208:31112

# Fass Admin Password
echo $(kubectl -n openfaas get secret basic-auth -o jsonpath="{.data.basic-auth-password}" | base64 --decode)
faas-cli login -g http://$OPENFAAS_URL -u admin --password 2nQAyZrzBI32
kubectl get pods -n openfaas

# Docker Login
sudo docker login

# Kubernetes Tunnel for local or remote access
kubectl port-forward svc/gateway -n openfaas 8080:8080

# Fibonacci
cd fibonacci
# Single
# faas-cli new --lang python3 fibonacci
sudo faas-cli build -f fibonacci.yml
sudo faas-cli push -f fibonacci.yml
faas-cli deploy -f fibonacci.yml --gateway $gw
curl http://10.4.110.208:31112/function/fibonacci -d "10"
X hey -z 60s -c 10 http://10.4.110.208:31112/function/fibonacci -d "1000"
X hey -z 300s -c 10 http://10.4.110.208:31112/function/fibonacci -d "1000"
X hey -z 300s -c 10 -o csv http://10.4.110.208:31112/function/fibonacci -d "1000" > fibonacci-single-10.csv
X hey -z 300s -c 50 http://10.4.110.208:31112/function/fibonacci -d "1000"
X hey -z 300s -c 50 -o csv http://10.4.110.208:31112/function/fibonacci -d "1000" > fibonacci-single-50.csv
X hey -z 300s -c 150 http://10.4.110.208:31112/function/fibonacci -d "1000"
X hey -z 300s -c 150 -o csv http://10.4.110.208:31112/function/fibonacci -d "1000" > fibonacci-single-150.csv
X hey -n 200000 -c 150 -o csv http://10.4.110.208:31112/function/fibonacci -d "1000" > fibonacci-single-200k.csv
X hey -z 300s -c 250 -o csv http://10.4.110.208:31112/function/fibonacci -d "1000" > fibonacci-multiple-250.csv
X hey -z 300s -c 1000 -o csv http://10.4.110.208:31112/function/fibonacci -d "1000" > fibonacci-multiple-1000.csv

# Quicksort
cd quicksort
# Single
# faas-cli new --lang python3 quicksort
sudo faas-cli build -f quicksort.yml
sudo faas-cli push -f quicksort.yml
faas-cli deploy -f quicksort.yml --gateway $gw
curl http://10.4.110.208:31112/function/quicksort -d "1,7,4,1,10"
X hey -z 60s -c 10 http://10.4.110.208:31112/function/quicksort -d "1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2"
X hey -z 300s -c 10 http://10.4.110.208:31112/function/quicksort -d "1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2"
X hey -z 300s -c 10 -o csv http://10.4.110.208:31112/function/quicksort -d "1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2" > quicksort-single-10.csv
X hey -z 300s -c 50 http://10.4.110.208:31112/function/quicksort -d "1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2"
X hey -z 300s -c 50 -o csv http://10.4.110.208:31112/function/quicksort -d "1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2" > quicksort-single-50.csv
X hey -z 300s -c 150 http://10.4.110.208:31112/function/quicksort -d "1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2"
X hey -z 300s -c 150 -o csv http://10.4.110.208:31112/function/quicksort -d "1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2" > quicksort-single-150.csv
X hey -n 200000 -c 150 -o csv http://10.4.110.208:31112/function/quicksort -d "1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2" > quicksort-single-200k.csv
X hey -z 300s -c 250 -o csv http://10.4.110.208:31112/function/quicksort -d "1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2" > quicksort-multiple-250.csv
X hey -z 300s -c 1000 -o csv http://10.4.110.208:31112/function/quicksort -d "1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2" > quicksort-multiple-1000.csv

# Users
cd users
# Single
# faas-cli new --lang python3 users
sudo faas-cli build -f users.yml
sudo faas-cli push -f users.yml
faas-cli deploy -f users.yml --gateway $gw
curl http://10.4.110.208:31112/function/users
X hey -z 60s -c 10 http://10.4.110.208:31112/function/users
X hey -z 300s -c 10 http://10.4.110.208:31112/function/users
X hey -z 300s -c 10 -o csv http://10.4.110.208:31112/function/users > users-single-10.csv
X hey -z 300s -c 50 http://10.4.110.208:31112/function/users
X hey -z 300s -c 50 -o csv http://10.4.110.208:31112/function/users > users-single-50.csv
X hey -z 300s -c 150 http://10.4.110.208:31112/function/users
X hey -z 300s -c 150 -o csv http://10.4.110.208:31112/function/users > users-single-150.csv
X hey -n 200000 -c 150 -o csv http://10.4.110.208:31112/function/users > users-single-200k.csv
X hey -z 300s -c 250 -o csv http://10.4.110.208:31112/function/users > users-multiple-250.csv
X hey -z 300s -c 1000 -o csv http://10.4.110.208:31112/function/users > users-multiple-1000.csv

# Thumbnail Generator
cd thumbnail
# Single
# faas-cli new --lang python3 thumbnail
sudo faas-cli build -f thumbnail.yml
sudo faas-cli push -f thumbnail.yml
faas-cli deploy -f thumbnail.yml --gateway $gw
curl http://10.4.110.208:31112/function/thumbnail
X hey -z 60s -c 10 http://10.4.110.208:31112/function/thumbnail
X hey -z 300s -c 10 http://10.4.110.208:31112/function/thumbnail
X hey -z 300s -c 10 -o csv http://10.4.110.208:31112/function/thumbnail > thumbnail-single-10.csv
X hey -z 300s -c 50 http://10.4.110.208:31112/function/thumbnail
X hey -z 300s -c 50 -o csv http://10.4.110.208:31112/function/thumbnail > thumbnail-single-50.csv
X hey -z 300s -c 150 http://10.4.110.208:31112/function/thumbnail
X hey -z 300s -c 150 -o csv http://10.4.110.208:31112/function/thumbnail > thumbnail-single-150.csv
X hey -n 200000 -c 150 -o csv http://10.4.110.208:31112/function/thumbnail > thumbnail-single-200k.csv
X hey -z 300s -c 250 -o csv http://10.4.110.208:31112/function/thumbnail > thumbnail-multiple-250.csv
X hey -z 300s -c 1000 -o csv http://10.4.110.208:31112/function/thumbnail > thumbnail-multiple-1000.csv