#!/bin/bash

if [ -z "$1" ]
  then
    echo "No argument supplied. Please provide the username"
    exit 0
fi

sudo snap install microk8s --classic
sudo usermod --append --groups microk8s $1
microk8s start
sudo snap enable microk8s
microk8s kubectl get nodes
microk8s.kubectl run httpd --image httpd
microk8s kubectl get services
microk8s.enable registry
microk8s.config
microk8s kubectl delete pod httpd
microk8s kubectl get pods
microk8s kubectl -n kube-system get secret
microk8s.enable dashboard dns
microk8s.enable dashboard dnsmicrok8s kubectl create token -n kube-system default --duration=8544h
token=$(microk8s kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
microk8s kubectl -n kube-system describe secret $token
microk8s.enable storage
microk8s.enable prometheus
# sudo firewall-cmd --zone=public --add-port 9090/tcp --permanent
# sudo firewall-cmd --zone=public --add-port 3000/tcp --permanent
yay -S  --noconfirm helm
microk8s enable helm
microk8s enable ingress

# microk8s kubectl port-forward -n monitoring service/grafana --address 0.0.0.0 3000:3000
# microk8s kubectl port-forward -n monitoring service/grafana --address 0.0.0.0 9090:9090
