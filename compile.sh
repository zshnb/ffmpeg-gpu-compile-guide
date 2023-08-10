#!/bin/sh
mkdir build-ffmpeg
cd build-ffmpeg
git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
cd nv-codec-headers && make install && cd ../
echo 'installed ffnvcodec'
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg/
apt-get install -y build-essential yasm cmake libtool libc6 libc6-dev unzip wget libnuma1 libnuma-dev libdrm-dev libass-dev libopus-dev libmp3lame-dev libva-dev libfdk-aac-dev
echo 'installed basic dependencies'

apt-get install -y libavcodec-dev libavformat-dev libavutil-dev \
  liblilv-0-0 liblilv-dev lilv-utils \
  libiec61883-dev libraw1394-tools libraw1394-doc libraw1394-dev libraw1394-doc libraw1394-tools \
  libavc1394-0 libavc1394-dev libavc1394-tools \
  libbluray-dev libbluray-doc libbluray-bin \
  libbs2b-dev libbs2b0 libcaca-dev libdc1394-22-dev \
  frei0r-plugins-dev ladspa-sdk-dev libgsm1-dev libmysofa-dev \
  flite1-dev libcodec2-dev libopenjp2-7-dev libopenmpt-dev librsvg2-dev \
  librubberband-dev libshine-dev libsnappy-dev libsoxr-dev libssh-dev \
  libspeex-dev libtwolame-dev libvidstab-dev libvpx-dev libwebp-dev \
  libx264-dev libx265-dev libxvidcore-dev libzmq5-dev libzvbi-dev \
  libopenal-dev libomxil-bellagio-dev libjack-dev libcdio-dev libcdparanoia-dev \
  libcdio-dev libcdio-paranoia-dev libsdl2-dev libtheora-dev libgme-dev
echo 'installed extra dependencies'

mkdir aom
cd aom
git clone https://aomedia.googlesource.com/aom
cmake ./aom && make && make install
echo 'installed aom'
cd ..

git clone https://github.com/sekrit-twc/zimg.git --recursive
cd zimg
sh autogen.sh && ./configure && make install
echo 'installed zimg'
cd ..

wget -qO - https://packages.lunarg.com/lunarg-signing-key-pub.asc | apt-key add -
wget -qO /etc/apt/sources.list.d/lunarg-vulkan-1.3.250-focal.list https://packages.lunarg.com/vulkan/1.3.250/lunarg-vulkan-1.3.250-focal.list
apt update
apt install -y vulkan-sdk
echo 'installed vulkan'

apt-get -y install python3-pip
pip3 install meson ninja
git clone --recursive https://code.videolan.org/videolan/libplacebo -b v6.292.1
cd libplacebo
DIR=./build
meson $DIR -Dvulkan-registry=/usr/share/vulkan/registry/vk.xml
ninja -C$DIR install
echo 'installed libplacebo'
cd ../..

export PATH=$PATH:/usr/local/cuda/bin
if [ ! -x conf.sh ]; then
  chmod a+x conf.sh
fi
cp conf.sh build-ffmpeg/ffmpeg/
cd build-ffmpeg/ffmpeg
./conf.sh
make -j 8
make install
echo 'installed ffmpeg'
ldconfig
./ffmpeg
