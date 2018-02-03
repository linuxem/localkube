#!/bin/bash
echo "Starting Kubernetes v${Version}..."
docker run -d --net=host gcr.io/google_containers/etcd:2.2.1 /usr/local/bin/etcd --listen-client-urls=http://0.0.0.0:4001 --advertise-client-urls=http://0.0.0.0:4001 --data-dir=/var/etcd/data
docker run -d --name=api --net=host --pid=host --privileged=true gcr.io/google_containers/hyperkube:v${Version} /hyperkube apiserver --insecure-bind-address=0.0.0.0 --service-cluster-ip-range=10.0.0.1/24 --etcd_servers=http://127.0.0.1:4001 --v=2
docker run -d --name=kubs --volume=/:/rootfs:ro --volume=/sys:/sys:ro --volume=/dev:/dev --volume=/var/lib/docker/:/var/lib/docker:rw --volume=/var/lib/kubelet/:/var/lib/kubelet:rw --volume=/var/run:/var/run:rw --net=host --pid=host --privileged=true gcr.io/google_containers/hyperkube:v${Version} /hyperkube kubelet --hostname-override="127.0.0.1" --address="0.0.0.0" --api-servers=http://0.0.0.0:8080 --cluster_dns=10.0.0.10 --cluster_domain=cluster.local --config=/etc/kubernetes/manifests-multi
docker run -d --name=proxy --net=host --privileged gcr.io/google_containers/hyperkube:v${Version} /hyperkube proxy --master=http://0.0.0.0:8080 --v=2
echo "Downloading Kubectl..."
curl -o ~/.bin/kubectl http://storage.googleapis.com/kubernetes-release/release/v${Version}/bin/linux/amd64/kubectl 
chmod u+x ~/.bin/kubectl 
export KUBERNETES_MASTER=http://localhost:8080
echo "Waiting for Kubernetes to start..."
until $(kubectl cluster-info &> /dev/null); do
  sleep 3
done
