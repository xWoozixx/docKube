# Commands needed in all machines
#!/bin/bash

# Desactiver le swap
sudo sed -i 's/\/swap.img/#\/swap.img/g' /etc/fstab
sudo swapoff -a

#0 Ajout au démarrage de modules nécessaires
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

# Ajout des paramètres pour le réseau
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Les appliquer sans redémarrer
sudo sysctl --system

# Installation de Containerd
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update 
sudo apt-get install -y containerd.io

# Créer le fichier de config
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

# Activer le driver cgroup systemd
sudo sed -i 's/ SystemdCgroup = false/ SystemdCgroup = true/' /etc/containerd/config.toml

# Redémarrer containerd avec la nouvelle configuration
sudo systemctl restart containerd

# Installer les packages Kubernetes - kubeadm, kubelet et kubectl
# Ajouter la clé GPG du référentiel apt de Google
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

# Ajouter le référentiel apt de Kubernetes
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Mettre à jour la liste des paquets et utiliser apt-cache policy pour inspecter les versions disponibles dans le référentiel
sudo apt-get update
apt-cache policy kubelet | head -n 20 

# Installer les paquets requis, si nécessaire, vous pouvez demander une version spécifique.
# Utilisez cette version pour la compatibilité avec les versions ultérieures.
# VERSION=1.27.2-00
# sudo apt-get install -y kubelet=$VERSION kubeadm=$VERSION kubectl=$VERSION 
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl containerd

# S'assurer qu'ils démarrent au démarrage du système.
sudo systemctl enable kubelet.service
sudo systemctl enable containerd.service

# Client pour le stockage
sudo apt install nfs-common -y 

sudo reboot
