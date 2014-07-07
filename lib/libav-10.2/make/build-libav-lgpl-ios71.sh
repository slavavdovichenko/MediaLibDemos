#  FILE: build-libav-lgpl-ios71.sh
#
#  libav LGPL ( --disable-gpl ) - iOS SDK 7.1 build script for arm64, armv7s, armv7, x86_64, i386 architectures
#
#  Created by Vyacheslav Vdovichenko on 16/04/14.
#  Copyright 2014 The Midnight Coders, Inc. All rights reserved.
#
##############################################################
# 1. download libav from http://ffmpeg.org/download.html     #
# 2. copy build-libav-lgpl-ios71.sh to ./libav               #
# 3. cd ./libav && ./build-libav-lgpl-ios71.sh               #
##############################################################


# delete old ./build dir
rm -r ./build


# configure for arm64 build
./configure --prefix=build/arm64 --arch=arm --target-os=darwin --cpu=cyclone \
    --cc=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang \
    --sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk \
    --extra-ldflags=-L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk/usr/lib/system \
    --extra-cflags='-arch arm64 -miphoneos-version-min=7.0' --extra-ldflags='-arch arm64 -miphoneos-version-min=7.0' --extra-cflags=-I/usr/local/include \
    --disable-doc --disable-programs --enable-cross-compile --enable-pic --disable-asm --disable-armv5te --disable-armv6 --disable-armv6t2 --disable-bzlib \
    --disable-decoders --disable-muxers --disable-demuxers --disable-devices --disable-parsers --disable-encoders --disable-protocols --disable-bsfs \
    --disable-filters --disable-filter=aformat --disable-filter=anull --disable-filter=atrim --disable-filter=format --disable-filter=null --disable-filter=setpts --disable-filter=trim \
    --enable-encoder=flv --enable-decoder=flv --enable-encoder=nellymoser --enable-decoder=nellymoser

# build for arm64
make clean
make && make install


# configure for armv7s build
./configure --prefix=build/armv7s --arch=arm --target-os=darwin --cpu=swift \
    --cc=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang \
    --sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk \
    --extra-ldflags=-L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk/usr/lib/system \
    --extra-cflags='-arch armv7s' --extra-ldflags='-arch armv7s' --extra-cflags=-I/usr/local/include \
    --disable-doc --disable-programs --enable-cross-compile --enable-pic --disable-asm --disable-armv5te --disable-armv6 --disable-armv6t2 --disable-bzlib \
    --disable-decoders --disable-muxers --disable-demuxers --disable-devices --disable-parsers --disable-encoders --disable-protocols --disable-bsfs \
    --disable-filters --disable-filter=aformat --disable-filter=anull --disable-filter=atrim --disable-filter=format --disable-filter=null --disable-filter=setpts --disable-filter=trim \
    --enable-encoder=flv --enable-decoder=flv --enable-encoder=nellymoser --enable-decoder=nellymoser

# build for armv7s
make clean
make && make install


# configure for armv7 build
./configure --prefix=build/armv7 --arch=arm --target-os=darwin --cpu=cortex-a8 \
    --cc=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang \
    --sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk \
    --extra-ldflags=-L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk/usr/lib/system \
    --extra-cflags='-arch armv7' --extra-ldflags='-arch armv7' --extra-cflags=-I/usr/local/include \
    --disable-doc --disable-programs --enable-cross-compile --enable-pic --disable-asm  --disable-armv5te --disable-armv6 --disable-armv6t2 --disable-bzlib \
    --disable-decoders --disable-muxers --disable-demuxers --disable-devices --disable-parsers --disable-encoders --disable-protocols --disable-bsfs \
    --disable-filters --disable-filter=aformat --disable-filter=anull --disable-filter=atrim --disable-filter=format --disable-filter=null --disable-filter=setpts --disable-filter=trim \
    --enable-encoder=flv --enable-decoder=flv --enable-encoder=nellymoser --enable-decoder=nellymoser

# build for armv7
make clean
make && make install


# configure for x86_64 build
./configure --prefix=build/x86_64 --arch=x86_64 --target-os=darwin --cpu=x86_64 \
    --cc=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang \
    --sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.1.sdk \
    --extra-ldflags=-L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.1.sdk/usr/lib/system \
    --extra-cflags='-arch x86_64 -mios-simulator-version-min=7.0' --extra-ldflags='-arch x86_64 -mios-simulator-version-min=7.0' --extra-cflags=-I/usr/local/include \
    --disable-doc --disable-programs --enable-cross-compile --enable-pic --disable-asm  --disable-armv5te --disable-armv6 --disable-armv6t2 --disable-bzlib \
    --disable-decoders --disable-muxers --disable-demuxers --disable-devices --disable-parsers --disable-encoders --disable-protocols --disable-bsfs \
    --disable-filters --disable-filter=aformat --disable-filter=anull --disable-filter=atrim --disable-filter=format --disable-filter=null --disable-filter=setpts --disable-filter=trim \
    --enable-encoder=flv --enable-decoder=flv --enable-encoder=nellymoser --enable-decoder=nellymoser

# build for x86_64
make clean
make && make install


# configure for i386 build
./configure --prefix=build/i386 --arch=i386 --target-os=darwin --cpu=i386 \
--cc=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang \
--sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.1.sdk \
--extra-ldflags=-L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.1.sdk/usr/lib/system \
--extra-cflags='-arch i386 -mios-simulator-version-min=5.0' --extra-ldflags='-arch i386 -mios-simulator-version-min=5.0' --extra-cflags=-I/usr/local/include \
--disable-doc --disable-programs --enable-cross-compile --enable-pic --disable-asm  --disable-armv5te --disable-armv6 --disable-armv6t2 --disable-bzlib \
--disable-decoders --disable-muxers --disable-demuxers --disable-devices --disable-parsers --disable-encoders --disable-protocols --disable-bsfs \
--disable-filters --disable-filter=aformat --disable-filter=anull --disable-filter=atrim --disable-filter=format --disable-filter=null --disable-filter=setpts --disable-filter=trim \
--enable-encoder=flv --enable-decoder=flv --enable-encoder=nellymoser --enable-decoder=nellymoser

# build for i386
make clean
make && make install


# copy lipo
cp /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/lipo ./build

# make fat libs
mkdir -p ./build/fat/lib

./build/lipo -output ./build/fat/lib/libavcodec.a  -create \
-arch arm64 ./build/arm64/lib/libavcodec.a \
-arch armv7s ./build/armv7s/lib/libavcodec.a \
-arch armv7 ./build/armv7/lib/libavcodec.a \
-arch x86_64 ./build/x86_64/lib/libavcodec.a \
-arch i386 ./build/i386/lib/libavcodec.a

./build/lipo -output ./build/fat/lib/libavdevice.a  -create \
-arch arm64 ./build/arm64/lib/libavdevice.a \
-arch armv7s ./build/armv7s/lib/libavdevice.a \
-arch armv7 ./build/armv7/lib/libavdevice.a \
-arch x86_64 ./build/x86_64/lib/libavdevice.a \
-arch i386 ./build/i386/lib/libavdevice.a

./build/lipo -output ./build/fat/lib/libavfilter.a  -create \
-arch arm64 ./build/arm64/lib/libavfilter.a \
-arch armv7s ./build/armv7s/lib/libavfilter.a \
-arch armv7 ./build/armv7/lib/libavfilter.a \
-arch x86_64 ./build/x86_64/lib/libavfilter.a \
-arch i386 ./build/i386/lib/libavfilter.a

./build/lipo -output ./build/fat/lib/libavformat.a  -create \
-arch arm64 ./build/arm64/lib/libavformat.a \
-arch armv7s ./build/armv7s/lib/libavformat.a \
-arch armv7 ./build/armv7/lib/libavformat.a \
-arch x86_64 ./build/x86_64/lib/libavformat.a \
-arch i386 ./build/i386/lib/libavformat.a

./build/lipo -output ./build/fat/lib/libavutil.a  -create \
-arch arm64 ./build/arm64/lib/libavutil.a \
-arch armv7s ./build/armv7s/lib/libavutil.a \
-arch armv7 ./build/armv7/lib/libavutil.a \
-arch x86_64 ./build/x86_64/lib/libavutil.a \
-arch i386 ./build/i386/lib/libavutil.a

./build/lipo -output ./build/fat/lib/libswscale.a  -create \
-arch arm64 ./build/arm64/lib/libswscale.a \
-arch armv7s ./build/armv7s/lib/libswscale.a \
-arch armv7 ./build/armv7/lib/libswscale.a \
-arch x86_64 ./build/x86_64/lib/libswscale.a \
-arch i386 ./build/i386/lib/libswscale.a

./build/lipo -output ./build/fat/lib/libavresample.a -create \
-arch arm64 ./build/arm64/lib/libavresample.a \
-arch armv7s ./build/armv7s/lib/libavresample.a \
-arch armv7 ./build/armv7/lib/libavresample.a \
-arch x86_64 ./build/x86_64/lib/libavresample.a \
-arch i386 ./build/i386/lib/libavresample.a

# copy include to fat
cp -R ./build/arm64/include ./build/fat/include/

# clean up
make clean

