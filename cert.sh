#!/bin/bash

kubectl config set-cluster localkube-image --server=http://127.0.0.1:8080 --api-version=v1
kubectl config set-context localkube-image --cluster=localkube-image
kubectl config use-context localkube-image
