#! /bin/bash

# 指定主控节点的IP地址
MASTER_IP="192.168.100.21"
# 指定主控节点的主机名
NODENAME=$(hostname -s)
# 指定当前 K8s 集群中 Service 所使用的 CIDR
SERVICE_CIDR="10.96.0.0/12"
# 指定当前 K8s 集群中 Pod 所使用的 CIDR
POD_CIDR="10.244.0.0/16"
# 指定当前使用的 K8s 版本
KUBE_VERSION=v1.21.1

# 特别预先加载 coredns 插件
COREDNS_VERSION=1.8.0
sudo docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:$COREDNS_VERSION
sudo docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:$COREDNS_VERSION registry.cn-hangzhou.aliyuncs.com/google_containers/coredns/coredns:v$COREDNS_VERSION

# 使用 kubeadm 工具初始化 K8s 集群
sudo kubeadm init \
  --kubernetes-version=$KUBE_VERSION \
  --apiserver-advertise-address=$MASTER_IP \
  --image-repository=registry.cn-hangzhou.aliyuncs.com/google_containers \
  --service-cidr=$SERVICE_CIDR \
  --pod-network-cidr=$POD_CIDR \
  --node-name=$NODENAME \
  --ignore-preflight-errors=Swap

# 生成主控节点的配置文件
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 将主控节点的配置文件备份到别处
config_path="/vagrant/configs"

if [ -d $config_path ]; then
   sudo rm -f $config_path/*
else
   sudo mkdir -p $config_path
fi

sudo cp -i /etc/kubernetes/admin.conf $config_path/config
sudo touch $config_path/join.sh
sudo chmod +x $config_path/join.sh       

# 将往 K8s 集群中添加工作节点的命令保存为脚本文件
kubeadm token create --print-join-command > $config_path/join.sh

# 安装名为 calico 的网路插件
sudo wget https://docs.projectcalico.org/manifests/calico.yaml
sudo kubectl apply -f calico.yaml

# 针对 Vagrant+VirtualBox 虚拟机环境的一些特定处理
sudo -i -u vagrant bash << EOF
mkdir -p /home/vagrant/.kube
sudo cp -i /vagrant/configs/config /home/vagrant/.kube/
sudo chown 1000:1000 /home/vagrant/.kube/config
EOF
