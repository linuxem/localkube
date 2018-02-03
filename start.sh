docker run -d --name=kubs \
  --net=host --pid=host --privileged=true \
  --volume=/:/rootfs:ro --volume=/sys:/sys:ro \
  --volume=/dev:/dev --volume=/var/lib/docker/:/var/lib/docker:rw \
  --volume=/var/lib/kubelet/:/var/lib/kubelet:rw \
  --volume=/var/run:/var/run:rw  \
  gcr.io/google_containers/hyperkube:v1.2.2 \
  /hyperkube kubelet \
  --allow-privileged=true --containerized --enable-server \
  --cluster_dns=10.0.0.10 --cluster_domain=cluster.local \
  --config=/etc/kubernetes/manifests-multi \
  --hostname-override="172.17.0.32" \
  --address=0.0.0.0 --api-servers=http://172.17.0.30:8080


