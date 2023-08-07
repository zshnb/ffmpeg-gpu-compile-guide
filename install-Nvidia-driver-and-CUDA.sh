


wget -q https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget -q https://developer.download.nvidia.com/compute/cuda/11.6.0/local_installers/cuda-repo-ubuntu2004-11-6-local_11.6.0-510.39.01-1_amd64.deb
dpkg -i cuda-repo-ubuntu2004-11-6-local_11.6.0-510.39.01-1_amd64.deb
rm cuda-repo-ubuntu2004-11-6-local_11.6.0-510.39.01-1_amd64.deb
apt-key add /var/cuda-repo-ubuntu2004-11-6-local/7fa2af80.pub

wget -q https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb
dpkg -i cuda-keyring_1.0-1_all.deb
rm cuda-keyring_1.0-1_all.deb


cat >/etc/apt/preferences.d/cuda-11.6-pin-1000.pref <<'EOF'
Package: cuda
Pin: version 11.6.*
Pin-Priority: 1000
EOF

cat >/etc/apt/preferences.d/libcudnn8-8.2.4-pin-1000.pref <<'EOF'
Package: libcudnn8
Pin: version 8.2.4.*
Pin-Priority: 1000
EOF

apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y cuda libcudnn8
sudo apt-get autoremove -y
sudo apt-get autoclean
sudo apt-get clean