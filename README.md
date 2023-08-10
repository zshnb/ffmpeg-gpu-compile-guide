This guide is to help you compile the latest ffmpeg with Nvidia CUDA and so much external library like libzimg, libplacebo 
in your local computer.
The compiled ffmpeg has mostly common filter and other useful filter, support
- CUDA
- CUVID
- Vulkan
- NVENC
- NVDEC
- zscale
- libplacebo

# Requirements
- Ubuntu 20.04+ LTS
- Nvidia GPU with CUDA support

# Steps
1. Install Nvidia driver and CUDA
```shell
  wget -q https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
  mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
  wget -q https://developer.download.nvidia.com/compute/cuda/11.6.0/local_installers/cuda-repo-ubuntu2004-11-6-local_11.6.0-510.39.01-1_amd64.deb
  dpkg -i cuda-repo-ubuntu2004-11-6-local_11.6.0-510.39.01-1_amd64.deb
  rm cuda-repo-ubuntu2004-11-6-local_11.6.0-510.39.01-1_amd64.deb
  apt-key add /var/cuda-repo-ubuntu2004-11-6-local/7fa2af80.pub

  wget -q https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb
  dpkg -i cuda-keyring_1.0-1_all.deb
  rm cuda-keyring_1.0-1_all.deb

  cat >/etc/apt/preferences.d/cuda-11.6-pin-1000.pref <<EOF
Package: cuda
Pin: version 11.6.*
Pin-Priority: 1000
EOF
  cat >/etc/apt/preferences.d/libcudnn8-8.2.4-pin-1000.pref <<EOF
Package: libcudnn8
Pin: version 8.2.4.*
Pin-Priority: 1000
EOF

  apt-get update -qq
  DEBIAN_FRONTEND=noninteractive apt-get install -y cuda libcudnn8
  sudo apt-get autoremove -y
  sudo apt-get autoclean
  sudo apt-get clean
```
you can find more information in 

https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#ubuntu 

and 

https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#ubuntu

2. Compile ffmpeg
```shell
chmod a+x compile.sh
./compile.sh
```
3. Test ffmpeg
```shell
./ffmpeg
```
if all command passed, you will see the output like this
```text
ffmpeg version N-111683-g7aa9684db3 Copyright (c) 2000-2023 the FFmpeg developers
  built with gcc 9 (Ubuntu 9.4.0-1ubuntu1~20.04.1)
  configuration: --enable-nonfree --enable-cuda-nvcc --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --incdir=/usr/include/x86_64-linux-gnu --libdir=/usr/lib/x86_64-linux-gnu --disable-static --enable-shared --enable-cuvid --enable-decoder=aac --enable-decoder=h264 --enable-decoder=h264_cuvid --enable-demuxer=mov --enable-filter=scale --enable-gnutls --enable-gpl --enable-libass --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-nonfree --enable-nvdec --enable-nvenc --enable-pic --enable-protocol=file --enable-protocol=https --enable-vaapi --enable-libplacebo --enable-vulkan --enable-ladspa --enable-libaom --enable-libbluray --enable-libbs2b --enable-libcaca --enable-libcdio --enable-libcodec2 --enable-libflite --enable-libfontconfig --enable-libfribidi --enable-libzimg --enable-libgme --enable-libgsm --enable-libjack --enable-libmysofa --enable-libopenjpeg --enable-libopenmpt --enable-libpulse --enable-librsvg --enable-librubberband --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libssh --enable-libtwolame --enable-libvidstab --enable-libwebp --enable-libx265 --enable-libxml2 --enable-libxvid --enable-libzmq --enable-libzvbi --enable-lv2 --enable-omx --enable-openal --enable-opencl --enable-opengl --enable-sdl2 --enable-libdc1394 --enable-libdrm --enable-libiec61883 --enable-frei0r
  libavutil      58. 14.100 / 58. 14.100
  libavcodec     60. 22.100 / 60. 22.100
  libavformat    60. 10.100 / 60. 10.100
  libavdevice    60.  2.101 / 60.  2.101
  libavfilter     9. 10.100 /  9. 10.100
  libswscale      7.  3.100 /  7.  3.100
  libswresample   4. 11.100 /  4. 11.100
  libpostproc    57.  2.100 / 57.  2.100
```
# Support feature with its library
| feature                                 | library               | description                                      |
|-----------------------------------------|-----------------------|--------------------------------------------------|
| --enable-libplacebo                     | libplacebo            | GPU-accelerated video/image rendering primitives |
| --enable-nvenc <br/>--enable-nvdec      | CUDA                  | GPU decoder & encoder                            |
| --enable-vulkan<br/>--enable-libshaderc | vulkan<br/>libshaderc | support Vulkan api                               |
| --enable-libzimg                        | libzimg2              | zscale filter                                    |
| --enable-libfdk-aac                     | libfdk-aac-dev        | aac support                                      |
| --enable-libx264                        | libx264-dev           | h264 encoder & decoder                           |
| --enable-libx265                        | libx265-dev           | h265/hevc encoder & decoder                      |

# Tips for use libplacebo with CUDA
After discuss with libplacebo author, there has some incompatible with ffmpeg master, CUDA.
So if you want to use libplacebo with CUDA, you need to compile libplacebo with version v6.292.1,
and add disable_multiplane=1 in the ffmpeg command. The example command is
```shell
./ffmpeg -y -init_hw_device vulkan=vk,disable_multiplane=1 -filter_hw_device vk -hwaccel nvdec -hwaccel_output_format cuda -i input.mp4 -vf "hwupload=derive_device=vulkan,libplacebo=format=yuv420p:colorspace=bt709:color_primaries=bt709:color_trc=bt709,hwupload=derive_device=cuda" -preset:v fast -tune:v hq -rc:v vbr -cq:v 22 -b:v 0  -c:v h264_nvenc -c:a copy libplacebo.cuda.mp4
```
you can find more context in this [issue](https://github.com/haasn/libplacebo/issues/187)
