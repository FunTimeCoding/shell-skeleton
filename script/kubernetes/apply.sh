#!/bin/sh -e

kubectl apply -f configuration/kubernetes/deployment.yaml
kubectl apply -f configuration/kubernetes/service.yaml
