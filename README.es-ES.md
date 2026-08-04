Esta guía te ayudará a compilar la última versión de FFmpeg con CUDA de NVIDIA y varias bibliotecas externas, como libzimg y libplacebo, en tu computadora local.
La versión compilada de FFmpeg incluye la mayoría de los filtros comunes y otros filtros útiles, y es compatible con:
- CUDA
- CUVID
- Vulkan
- NVENC
- NVDEC
- zscale
- libplacebo

# Requisitos
- Ubuntu 20.04 LTS o superior
- GPU NVIDIA con soporte para CUDA

# Pasos
1. Instalar el controlador NVIDIA y CUDA
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
Puedes encontrar más información en:

https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#ubuntu

y

https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#ubuntu

2. Compilar FFmpeg
```shell
chmod a+x compile.sh
./compile.sh
```
3. Probar FFmpeg
```shell
./ffmpeg
```
Si todos los comandos se ejecutan correctamente, verás una salida como esta:
```text
ffmpeg version N-111683-g7aa9684db3 Copyright (c) 2000-2023 los desarrolladores de FFmpeg
  compilado con gcc 9 (Ubuntu 9.4.0-1ubuntu1~20.04.1)
  configuración: --enable-nonfree --enable-cuda-nvcc --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --incdir=/usr/include/x86_64-linux-gnu --libdir=/usr/lib/x86_64-linux-gnu --disable-static --enable-shared --enable-cuvid --enable-decoder=aac --enable-decoder=h264 --enable-decoder=h264_cuvid --enable-demuxer=mov --enable-filter=scale --enable-gnutls --enable-gpl --enable-libass --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-nonfree --enable-nvdec --enable-nvenc --enable-pic --enable-protocol=file --enable-protocol=https --enable-vaapi --enable-libplacebo --enable-vulkan --enable-ladspa --enable-libaom --enable-libbluray --enable-libbs2b --enable-libcaca --enable-libcdio --enable-libcodec2 --enable-libflite --enable-libfontconfig --enable-libfribidi --enable-libzimg --enable-libgme --enable-libgsm --enable-libjack --enable-libmysofa --enable-libopenjpeg --enable-libopenmpt --enable-libpulse --enable-librsvg --enable-librubberband --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libssh --enable-libtwolame --enable-libvidstab --enable-libwebp --enable-libx265 --enable-libxml2 --enable-libxvid --enable-libzmq --enable-libzvbi --enable-lv2 --enable-omx --enable-openal --enable-opencl --enable-opengl --enable-sdl2 --enable-libdc1394 --enable-libdrm --enable-libiec61883 --enable-frei0r
  libavutil      58. 14.100 / 58. 14.100
  libavcodec     60. 22.100 / 60. 22.100
  libavformat    60. 10.100 / 60. 10.100
  libavdevice    60.  2.101 / 60.  2.101
  libavfilter     9. 10.100 /  9. 10.100
  libswscale      7.  3.100 /  7.  3.100
  libswresample   4. 11.100 /  4. 11.100
  libpostproc    57.  2.100 / 57.  2.100
```
# Características admitidas junto con sus bibliotecas
| Característica | Biblioteca | Descripción |
|---------------|-----------|-------------|
| --enable-libplacebo | libplacebo | Primitivas de renderizado de video/imagen aceleradas por GPU |
| --enable-nvenc <br/>--enable-nvdec | CUDA | Codificador y decodificador de GPU |
| --enable-vulkan<br/>--enable-libshaderc | vulkan<br/>libshaderc | Soporte para la API Vulkan |
| --enable-libzimg | libzimg2 | Filtro zscale |
| --enable-libfdk-aac | libfdk-aac-dev | Soporte para AAC |
| --enable-libx264 | libx264-dev | Codificador y decodificador H.264 |
| --enable-libx265 | libx265-dev | Codificador y decodificador H.265/HEVC |

# Consejos para usar libplacebo con CUDA
Tras consultar con el autor de libplacebo, se descubrió que existen incompatibilidades con la versión actual de FFmpeg y CUDA.
Si deseas utilizar libplacebo con CUDA, es necesario compilar libplacebo en su versión v6.292.1 y agregar la opción `disable_multiplane=1` al comando de FFmpeg. Un ejemplo de comando es el siguiente:
```shell
./ffmpeg -y -init_hw_device vulkan=vk,disable_multiplane=1 -filter_hw_device vk -hwaccel nvdec -hwaccel_output_format cuda -i input.mp4 -vf "hwupload=derive_device=vulkan,libplacebo=format=yuv420p:colorspace=bt709:color_primaries=bt709:color_trc=bt709,hwupload=derive_device=cuda" -preset:v fast -tune:v hq -rc:v vbr -cq:v 22 -b:v 0 -c:v h264_nvenc -c:a copy libplacebo.cuda.mp4
```
Puedes encontrar más contexto en este [problema](https://github.com/haasn/libplacebo/issues/187).
