#!/bin/sh
./configure --enable-nonfree --enable-cuda-nvcc --enable-libnpp --extra-cflags=-I/usr/local/cuda/include \
  --extra-ldflags=-L/usr/local/cuda/lib64 --incdir=/usr/include/x86_64-linux-gnu \
  --libdir=/usr/lib/x86_64-linux-gnu --disable-static --enable-shared --enable-cuvid --enable-decoder=aac \
  --enable-decoder=h264 --enable-decoder=h264_cuvid --enable-demuxer=mov \
  --enable-filter=scale --enable-gnutls --enable-gpl --enable-libass --enable-libfdk-aac --enable-libfreetype \
  --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-nonfree \
  --enable-nvdec --enable-nvenc --enable-pic --enable-protocol=file --enable-protocol=https \
  --enable-vaapi --enable-libplacebo --enable-vulkan --enable-libshaderc \
  --enable-ladspa --enable-libaom --enable-libbluray --enable-libbs2b --enable-libcaca --enable-libcdio --enable-libcodec2 \
  --enable-libflite --enable-libfontconfig --enable-libfribidi --enable-libzimg \
  --enable-libgme --enable-libgsm --enable-libjack --enable-libmysofa \
  --enable-libopenjpeg --enable-libopenmpt --enable-libpulse --enable-librsvg \
  --enable-librubberband --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libspeex \
  --enable-libssh --enable-libtwolame --enable-libvidstab \
  --enable-libwebp --enable-libx265 --enable-libxml2 --enable-libxvid \
  --enable-libzmq --enable-libzvbi --enable-lv2 --enable-omx --enable-openal --enable-opencl --enable-opengl \
  --enable-sdl2 --enable-libdc1394 --enable-libdrm --enable-libiec61883 --enable-frei0r
