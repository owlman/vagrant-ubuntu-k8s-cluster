# 项目说明

本项目演示如何使用Vagrant搭建Kubernetes集群，并针对国内的网络环境做了优化。请在使用前先安装[VirtualBox](https://www.virtualbox.org/wiki/Downloads)与[Vagrant](https://www.vagrantup.com/docs/installation)。

## 使用方法

### 搭建集群

```bash
git clone https://github.com/owlman/vagrant-ubuntu-k8s-cluster.git
cd vagrant-ubuntu-k8s-cluster
vagrant up
```

### 连接节点

```bash
vagrant ssh k8s-master
vagrant ssh k8s-worker1
vagrant ssh k8s-worker2
```

### 暂停与启动集群

```bash
vagrant halt
vagrant up
```

### 销毁集群

```bash
vagrant destroy -f
```

## 版本说明

本项目搭建的集群版本：

```bash
kube-apiserver: v1.21.1
kube-proxy: v1.21.1
kube-controller-manager: v1.21.1
kube-scheduler: v1.21.1
pause: 3.4.1
coredns: v1.8.0
etcd: 3.4.13-0  
```
