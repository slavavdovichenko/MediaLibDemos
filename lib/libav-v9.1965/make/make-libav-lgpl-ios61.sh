#  FILE: make-libav-lgpl-ios61.sh
#
#  libav LGPL ( --disable-gpl ) - iOS SDK 6.1 compilation script for armv7s, armv7 & i386 architectures
#
#  Created by Vyacheslav Vdovichenko on 09/02/13.
#  Copyright 2013 The Midnight Coders, Inc. All rights reserved.
#
##############################################################
# 1. download libav from http://ffmpeg.org/download.html     #
# 2. copy make-libav-lgpl-ios61.sh to ./libav                #
# 3. cd ./libav && ./make-libav-lgpl-ios61.sh                #
##############################################################

# delete old ./compiled
rm -r ./compiled

# configure for armv7s build
./configure --prefix=compiled/armv7s --extra-ldflags=-L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk/usr/lib/system --disable-bzlib --disable-doc --disable-programs --disable-avplay --disable-avprobe --disable-avserver --enable-cross-compile --arch=arm --target-os=darwin --cc=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/gcc --sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk --cpu=cortex-a8 --extra-cflags='-arch armv7s' --extra-ldflags='-arch armv7s' --extra-cflags=-I/usr/local/include --enable-pic --disable-asm

# build for armv7s
make clean
make && make install

# configure for armv7 build
./configure --prefix=compiled/armv7 --extra-ldflags=-L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk/usr/lib/system --disable-bzlib --disable-doc --disable-programs --disable-avplay --disable-avprobe --disable-avserver --enable-cross-compile --arch=arm --target-os=darwin --cc=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/gcc --sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk --cpu=cortex-a8 --extra-cflags='-arch armv7' --extra-ldflags='-arch armv7' --extra-cflags=-I/usr/local/include --enable-pic --disable-asm

# build for armv7
make clean
make && make install

# configure for i386 build
./configure --prefix=compiled/i386 --extra-ldflags=-L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.1.sdk/usr/lib/system --disable-bzlib --disable-doc --disable-programs --disable-avplay --disable-avprobe --disable-avserver --enable-cross-compile --arch=i386 --target-os=darwin --cc=/Applications/Xcode.app/Contents/Developer/usr/bin/gcc --sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.1.sdk --cpu=i386 --extra-cflags='-arch i386' --extra-ldflags='-arch i386' --extra-cflags=-I/usr/local/include --enable-pic --disable-asm

# build for i386
make clean
make && make install

# copy lipo
cp /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/lipo ./compiled

# make fat libs
mkdir -p ./compiled/fat/lib

./compiled/lipo -output ./compiled/fat/lib/libavcodec.a  -create \
-arch armv7s ./compiled/armv7s/lib/libavcodec.a \
-arch armv7 ./compiled/armv7/lib/libavcodec.a \
-arch i386 ./compiled/i386/lib/libavcodec.a

./compiled/lipo -output ./compiled/fat/lib/libavdevice.a  -create \
-arch armv7s ./compiled/armv7s/lib/libavdevice.a \
-arch armv7 ./compiled/armv7/lib/libavdevice.a \
-arch i386 ./compiled/i386/lib/libavdevice.a

./compiled/lipo -output ./compiled/fat/lib/libavfilter.a  -create \
-arch armv7s ./compiled/armv7s/lib/libavfilter.a \
-arch armv7 ./compiled/armv7/lib/libavfilter.a \
-arch i386 ./compiled/i386/lib/libavfilter.a

./compiled/lipo -output ./compiled/fat/lib/libavformat.a  -create \
-arch armv7s ./compiled/armv7s/lib/libavformat.a \
-arch armv7 ./compiled/armv7/lib/libavformat.a \
-arch i386 ./compiled/i386/lib/libavformat.a

./compiled/lipo -output ./compiled/fat/lib/libavutil.a  -create \
-arch armv7s ./compiled/armv7s/lib/libavutil.a \
-arch armv7 ./compiled/armv7/lib/libavutil.a \
-arch i386 ./compiled/i386/lib/libavutil.a

./compiled/lipo -output ./compiled/fat/lib/libswscale.a  -create \
-arch armv7s ./compiled/armv7s/lib/libswscale.a \
-arch armv7 ./compiled/armv7/lib/libswscale.a \
-arch i386 ./compiled/i386/lib/libswscale.a

./compiled/lipo -output ./compiled/fat/lib/libavresample.a -create \
-arch armv7s ./compiled/armv7s/lib/libavresample.a \
-arch armv7 ./compiled/armv7/lib/libavresample.a \
-arch i386 ./compiled/i386/lib/libavresample.a

# clean up
make clean

