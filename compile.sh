#!/bin/sh
mkdir build-ffmpeg
cd build-ffmpeg
git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
cd nv-codec-headers && sudo make install && cd ../
echo 'installed ffnvcodec'
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg/
sudo apt-get install -y build-essential yasm cmake libtool libc6 libc6-dev unzip wget libnuma1 libnuma-dev
echo 'installed basic dependencies'

apt-get install -y frei0r-plugins-dev
apt-get install -y ladspa-sdk-dev
apt-get install -y libgsm1-dev
apt-get install -y libmysofa-dev
apt-get install -y flite1-dev
apt-get install -y libcodec2-dev
apt-get install -y libavcodec-dev libavformat-dev libavutil-dev
apt-get install -y libopenjp2-7-dev
apt-get install -y libopenmpt-dev
apt-get install -y librsvg2-dev
apt-get install -y librubberband-dev
apt-get install -y libshine-dev
apt-get install -y libsnappy-dev
apt-get install -y libsoxr-dev
apt-get install -y libssh-dev
apt-get install -y libspeex-dev
apt-get install -y libtwolame-dev
apt-get install -y libvidstab-dev
apt-get install -y libvpx-dev
apt-get install -y libwebp-dev
apt-get install -y libx265-dev
apt-get install -y libxvidcore-dev
apt-get install -y libzmq5-dev
apt-get install -y libzvbi-dev
apt-get install -y libopenal-dev
apt-get install -y libomxil-bellagio-dev
apt-get install -y libjack-dev
apt-get install -y libcdio-dev
apt-get install -y libcdparanoia-dev
apt-get install -y libcdio-dev libcdio-paranoia-dev
apt-get install -y libsdl2-dev
echo 'installed extra dependencies'

mkdir aom
cd aom
git clone https://aomedia.googlesource.com/aom
cmake ./aom && make && sudo make install
echo 'installed aom'

git clone https://github.com/sekrit-twc/zimg.git --recursive
cd zimg
sh autogen.sh && ./configure && make
echo 'installed zimg'

ldconfig

wget -qO - https://packages.lunarg.com/lunarg-signing-key-pub.asc | sudo apt-key add -
sudo wget -qO /etc/apt/sources.list.d/lunarg-vulkan-1.3.250-focal.list https://packages.lunarg.com/vulkan/1.3.250/lunarg-vulkan-1.3.250-focal.list
sudo apt update
sudo apt install vulkan-sdk
echo 'installed vulkan'

sudo apt-get -y install python3-pip
git clone --recursive https://code.videolan.org/videolan/libplacebo
DIR=./build
meson $DIR -Dvulkan-registry=/usr/share/vulkan/registry/vk.xml
ninja -C$DIR install
echo 'installed libplacebo'

export PATH=$PATH:/usr/local/cuda/bin
if [ ! -x conf.sh ]; then
  chmod a+x conf.sh
fi
./conf.sh
make -j 8
make install
echo 'installed ffmpeg'
./ffmpeg
