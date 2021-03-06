#!/bin/bash
export Version=1.9.0
echo "Starting Kubernetes v${Version}..."

docker run -d --volume=/:/rootfs:ro --volume=/sys:/sys:rw --volume=/var/lib/docker:/var/lib/docker:rw --volume=/var/lib/kubelet:/var/lib/kubelet:rw --volume=/var/run:/var/run:rw --net=host --pid=host --privileged gcr.io/k8s-minikube/localkube-image:v${Version} /localkube start --apiserver-insecure-address=0.0.0.0 --apiserver-insecure-port=8080 --logtostderr=true --containerized
docker run -d --name=proxy --net=host --privileged gcr.io/google_containers/hyperkube:v${Version} /hyperkube proxy --master=http://0.0.0.0:8080 --v=2
#docker run --volume=/:/rootfs:ro --volume=/sys:/sys:ro --volume=/dev:/dev --volume=/var/lib/docker/:/var/lib/docker:rw --volume=/var/lib/kubelet/:/var/lib/kubelet:rw --volume=/var/run:/var/run:rw --net=host --privileged=true --pid=host -d gcr.io/google_containers/hyperkube:v1.5.8 /hyperkube kubelet --api-servers=http://${MASTER_IP}:8080 --v=2 --address=0.0.0.0 --enable-server --hostname-override=$(hostname -i) --cluster-dns=10.0.0.10 --cluster-domain=cluster.local
docker run --volume=/:/rootfs:ro --volume=/sys:/sys:ro --volume=/dev:/dev --volume=/var/lib/docker/:/var/lib/docker:rw --volume=/var/lib/kubelet/:/var/lib/kubelet:rw --volume=/var/run:/var/run:rw --net=host --privileged=true --pid=host -d gcr.io/google_containers/hyperkube:v1.9.0 /hyperkube kubelet  --containerized  --kubeconfig=/etc/kubernetes/kubelet.kubeconfig --v=2 --address=0.0.0.0 --enable_server --hostname_override=127.0.0.1 --node-ip=10.0.8.1 --cluster-dns=10.0.0.10 --cluster-domain=cluster.local --fail-swap-on=false --logtostderr=true Restart=on-failure RestartSec=5
echo "Downloading Kubectl..."
#curl -o ~/.bin/kubectl http://storage.googleapis.com/kubernetes-release/release/v${Version}/bin/linux/amd64/kubectl 
#chmod u+x ~/.bin/kubectl
export KUBERNETES_MASTER=http://localhost:8080
echo "Waiting for Kubernetes to start..."
until $(kubectl cluster-info &> /dev/null); do
  sleep 1
done

###########################################################################
#--experimental-bootstrap-kubeconfig=/etc/kubernetes/bootstrap.kubeconfig
#--cert-dir=/etc/kubernetes/ssl
#--hairpin-mode=promiscuous-bridge
#--allow-privileged=true \
#--fail-swap-on=false \
#--logtostderr=true
