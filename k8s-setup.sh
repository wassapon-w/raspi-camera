# sudo -i

# sudo swapoff -a
# sudo dphys-swapfile swapoff
sudo systemctl disable dphys-swapfile.service
# sudo cat /etc/fstab

ARCH=amd64

if [ "$(uname -m)" = "aarch64" ]; then ARCH=arm64; fi
wget https://github.com/containerd/containerd/releases/download/v1.7.16/containerd-1.7.16-linux-${ARCH}.tar.gz
sudo tar Cxzvf /usr/local containerd-1.7.16-linux-${ARCH}.tar.gz

sudo wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service -P /lib/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable --now containerd

wget https://github.com/opencontainers/runc/releases/download/v1.1.12/runc.${ARCH}
sudo install -m 755 runc.${ARCH} /usr/local/sbin/runc

wget https://github.com/containernetworking/plugins/releases/download/v1.4.1/cni-plugins-linux-${ARCH}-v1.4.1.tgz
mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-${ARCH}-v1.4.1.tgz
sudo chown -R root:root /opt/cni/bin

sudo mkdir /etc/containerd/
sudo bash -c "containerd config default > /etc/containerd/config.toml"

# sudo nano /etc/containerd/config.toml
###  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
###  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
###  SystemdCgroup = true

CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
if [ "$(uname -m)" = "aarch64" ]; then ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${ARCH}.tar.gz{,.sha256sum}

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl enable --now kubelet

# sudo kubeadm config images pull

# Control Plane Set Up
### sudo kubeadm init
### mkdir -p $HOME/.kube
### sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
### sudo chown $(id -u):$(id -g) $HOME/.kube/config
### cilium install

### kubeadm token create --print-join-command

# Debugging
### journalctl -xeu kubelet
### kubectl cluster-info
### kubectl describe nodes nedo1
### kubectl describe pods -n kube-system cilium-v8c8v
### kubectl logs -n kube-system -p cilium-22vvd

# Rasberry Pi Cgroup Memory Issue
### sudo nano /boot/firmware/cmdline.txt
##### cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1

# Deploy Application
### kubectl apply -f straming-deployment.yml
### kubectl expose deployment/pi-camera-deployment --type="NodePort" --port 8000
### kubectl delete deployment pi-camera-deployment
