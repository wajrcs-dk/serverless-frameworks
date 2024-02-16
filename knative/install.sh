# Source
# https://knative.dev/docs/install/yaml-install/serving/install-serving-with-yaml/

# Install Knative CLI
curl -O https://github.com/knative/client/releases/download/knative-v1.13.0/kn-linux-amd64
mv kn-linux-amd64 kn
sudo cp kn /usr/local/bin
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
kubectl --namespace kourier-system get service kourier
kubectl get pods -n knative-serving

# Configure DNS
kubectl patch configmap/config-domain \
      --namespace knative-serving \
      --type merge \
      --patch '{"data":{"example.com":""}}'
kubectl get ksvc

# HPA autoscaling
kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.13.1/serving-hpa.yaml

# Fibonacci
cd fibonacci
docker build -t "wajrcs/fibonacci-knative" .
docker push wajrcs/fibonacci-knative
kubectl apply --filename service.yaml
kubectl apply --filename service-single.yaml
hey -z 300s -c 10 http://fibonacci.default.example.com?x=1000
hey -z 300s -c 10 http://fibonacci-single.default.example.com?x=1000

# Quicksort
cd quicksort
docker build -t "wajrcs/quicksort-knative" .
docker push wajrcs/quicksort-knative
kubectl apply --filename service.yaml
kubectl apply --filename service-single.yaml
hey -z 300s -c 10 http://quicksort.default.example.com?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2
hey -z 300s -c 10 http://quicksort-single.default.example.com?x=1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2,1,7,4,1,10,9,-2

# Users
docker build -t "wajrcs/users-knative" .
docker push wajrcs/users-knative
kubectl apply --filename service.yaml
kubectl apply --filename service-single.yaml
hey -z 10s -c 50 http://users.default.example.com
hey -z 10s -c 50 http://users-single.default.example.com

# Thumbnail Generator
docker build -t "wajrcs/thumbnail-knative" .
docker push wajrcs/thumbnail-knative
kubectl apply --filename service.yaml
kubectl apply --filename service-single.yaml
hey -z  10s -c 50 http://thumbnail.default.example.com
hey -z  10s -c 50 http://thumbnail-sample.default.example.com