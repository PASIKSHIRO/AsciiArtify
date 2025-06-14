#!/bin/bash

set -e

case "$1" in
  minikube)
    echo ">>> Starting Minikube cluster..."
    minikube start --driver=podman

    echo ">>> Deploying hello-world..."
    kubectl create deployment hello-world --image=kicbase/echo-server:1.0 || true
    kubectl expose deployment hello-world --type=LoadBalancer --port=8080 || true

    echo ">>> Opening service in browser..."
    minikube service hello-world
    ;;

  kind)
    echo ">>> Creating Kind cluster..."
    kind create cluster --name kind-hello || true

    echo ">>> Deploying hello-world..."
    kubectl create deployment hello-world --image=kicbase/echo-server:1.0 || true
    kubectl expose deployment hello-world --type=NodePort --port=8080 || true

    echo ">>> Forwarding port..."
    kubectl port-forward service/hello-world 8080:8080
    ;;

  k3d)
    echo ">>> Creating K3d cluster..."
    k3d cluster create k3d-hello || true

    echo ">>> Deploying hello-world..."
    kubectl create deployment hello-world --image=kicbase/echo-server:1.0 || true
    kubectl expose deployment hello-world --type=LoadBalancer --port=8080 || true

    echo ">>> Access the service manually by checking mapped port via 'docker ps'."
    ;;

  *)
    echo "Usage: $0 {minikube|kind|k3d}"
    exit 1
    ;;
esac
