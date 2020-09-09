#!/bin/sh -e

kubectl delete -f configuration/kubernetes/service.yaml
kubectl delete -f configuration/kubernetes/deployment.yaml
