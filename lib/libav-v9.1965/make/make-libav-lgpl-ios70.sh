#  FILE: make-libav-lgpl-ios70.sh
#
#  libav LGPL ( --disable-gpl ) - iOS SDK 7.0 compilation script for x86_64, i386, arm64, armv7s, armv7 architectures
#
#  Created by Vyacheslav Vdovichenko on 08/01/14.
#  Copyright 2014 The Midnight Coders, Inc. All rights reserved.
#
##############################################################
# 1. download libav from http://ffmpeg.org/download.html     #
# 2. copy make-libav-lgpl-ios70.sh to ./l                    #
# 3. cd ./libav && ./make-libav-lgpl-ios61.sh                #
##############################################################


# delete old ./compiled
rm -r ./compiled


# configure for arm64 build
./configure --prefix=compiled/arm64 --arch=arm --target-os=darwin --cpu=cyclone \
    --cc=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang \
    --sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk \
    --extra-ldflags=-L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk/usr/lib/system \
    --extra-cflags='-arch arm64 -miphoneos-version-min=7.0' --extra-ldflags='-arch arm64 -miphoneos-version-min=7.0' --extra-cflags=-I/usr/local/include \
    --disable-doc --disable-programs --enable-cross-compile --enable-pic --disable-asm --disable-armv5te --disable-armv6 --disable-armv6t2 --disable-bzlib \
    --disable-decoders --disable-muxers --disable-demuxers --disable-devices --disable-parsers --disable-encoders --disable-protocols --disable-bsfs \
    --disable-filters --disable-filter=aformat --disable-filter=anull --disable-filter=atrim --disable-filter=format --disable-filter=null --disable-filter=setpts --disable-filter=trim \
    --enable-encoder=flv --enable-decoder=flv --enable-encoder=nellymoser --enable-decoder=nellymoser

# build for arm64
make clean
make && make install


# configure for armv7s build
./configure --prefix=compiled/armv7s --arch=arm --target-os=darwin --cpu=swift \
    --cc=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang \
    --sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk \
    --extra-ldflags=-L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk/usr/lib/system \
    --extra-cflags='-arch armv7s' --extra-ldflags='-arch armv7s' --extra-cflags=-I/usr/local/include \
    --disable-doc --disable-programs --enable-cross-compile --enable-pic --disable-asm --disable-armv5te --disable-armv6 --disable-armv6t2 --disable-bzlib \
    --disable-decoders --disable-muxers --disable-demuxers --disable-devices --disable-parsers --disable-encoders --disable-protocols --disable-bsfs \
    --disable-filters --disable-filter=aformat --disable-filter=anull --disable-filter=atrim --disable-filter=format --disable-filter=null --disable-filter=setpts --disable-filter=trim \
    --enable-encoder=flv --enable-decoder=flv --enable-encoder=nellymoser --enable-decoder=nellymoser

# build for armv7s
make clean
make && make install


# configure for armv7 build
./configure --prefix=compiled/armv7 --arch=arm --target-os=darwin --cpu=cortex-a8 \
    --cc=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang \
    --sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk \
    --extra-ldflags=-L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk/usr/lib/system \
    --extra-cflags='-arch armv7' --extra-ldflags='-arch armv7' --extra-cflags=-I/usr/local/include \
    --disable-doc --disable-programs --enable-cross-compile --enable-pic --disable-asm  --disable-armv5te --disable-armv6 --disable-armv6t2 --disable-bzlib \
    --disable-decoders --disable-muxers --disable-demuxers --disable-devices --disable-parsers --disable-encoders --disable-protocols --disable-bsfs \
    --disable-filters --disable-filter=aformat --disable-filter=anull --disable-filter=atrim --disable-filter=format --disable-filter=null --disable-filter=setpts --disable-filter=trim \
    --enable-encoder=flv --enable-decoder=flv --enable-encoder=nellymoser --enable-decoder=nellymoser

# build for armv7
make clean
make && make install


# configure for x86_64 build
./configure --prefix=compiled/x86_64 --arch=x86_64 --target-os=darwin --cpu=x86_64 \
    --cc=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang \
    --sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.0.sdk \
    --extra-ldflags=-L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.0.sdk/usr/lib/system \
    --extra-cflags='-arch x86_64 -mios-simulator-version-min=7.0' --extra-ldflags='-arch x86_64 -mios-simulator-version-min=7.0' --extra-cflags=-I/usr/local/include \
    --disable-doc --disable-programs --enable-cross-compile --enable-pic --disable-asm  --disable-armv5te --disable-armv6 --disable-armv6t2 --disable-bzlib \
    --disable-decoders --disable-muxers --disable-demuxers --disable-devices --disable-parsers --disable-encoders --disable-protocols --disable-bsfs \
    --disable-filters --disable-filter=aformat --disable-filter=anull --disable-filter=atrim --disable-filter=format --disable-filter=null --disable-filter=setpts --disable-filter=trim \
    --enable-encoder=flv --enable-decoder=flv --enable-encoder=nellymoser --enable-decoder=nellymoser

# build for x86_64
make clean
make && make install


# configure for i386 build
./configure --prefix=compiled/i386 --arch=i386 --target-os=darwin --cpu=i386 \
--cc=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang \
--sysroot=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.0.sdk \
--extra-ldflags=-L/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.0.sdk/usr/lib/system \
--extra-cflags='-arch i386 -mios-simulator-version-min=5.0' --extra-ldflags='-arch i386 -mios-simulator-version-min=5.0' --extra-cflags=-I/usr/local/include \
--disable-doc --disable-programs --enable-cross-compile --enable-pic --disable-asm  --disable-armv5te --disable-armv6 --disable-armv6t2 --disable-bzlib \
--disable-decoders --disable-muxers --disable-demuxers --disable-devices --disable-parsers --disable-encoders --disable-protocols --disable-bsfs \
--disable-filters --disable-filter=aformat --disable-filter=anull --disable-filter=atrim --disable-filter=format --disable-filter=null --disable-filter=setpts --disable-filter=trim \
--enable-encoder=flv --enable-decoder=flv --enable-encoder=nellymoser --enable-decoder=nellymoser

# build for i386
make clean
make && make install


# copy lipo
cp /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/lipo ./compiled

# make fat libs
mkdir -p ./compiled/fat/lib

./compiled/lipo -output ./compiled/fat/lib/libavcodec.a  -create \
-arch arm64 ./compiled/arm64/lib/libavcodec.a \
-arch armv7s ./compiled/armv7s/lib/libavcodec.a \
-arch armv7 ./compiled/armv7/lib/libavcodec.a \
-arch x86_64 ./compiled/x86_64/lib/libavcodec.a \
-arch i386 ./compiled/i386/lib/libavcodec.a

./compiled/lipo -output ./compiled/fat/lib/libavdevice.a  -create \
-arch arm64 ./compiled/arm64/lib/libavdevice.a \
-arch armv7s ./compiled/armv7s/lib/libavdevice.a \
-arch armv7 ./compiled/armv7/lib/libavdevice.a \
-arch x86_64 ./compiled/x86_64/lib/libavdevice.a \
-arch i386 ./compiled/i386/lib/libavdevice.a

./compiled/lipo -output ./compiled/fat/lib/libavfilter.a  -create \
-arch arm64 ./compiled/arm64/lib/libavfilter.a \
-arch armv7s ./compiled/armv7s/lib/libavfilter.a \
-arch armv7 ./compiled/armv7/lib/libavfilter.a \
-arch x86_64 ./compiled/x86_64/lib/libavfilter.a \
-arch i386 ./compiled/i386/lib/libavfilter.a

./compiled/lipo -output ./compiled/fat/lib/libavformat.a  -create \
-arch arm64 ./compiled/arm64/lib/libavformat.a \
-arch armv7s ./compiled/armv7s/lib/libavformat.a \
-arch armv7 ./compiled/armv7/lib/libavformat.a \
-arch x86_64 ./compiled/x86_64/lib/libavformat.a \
-arch i386 ./compiled/i386/lib/libavformat.a

./compiled/lipo -output ./compiled/fat/lib/libavutil.a  -create \
-arch arm64 ./compiled/arm64/lib/libavutil.a \
-arch armv7s ./compiled/armv7s/lib/libavutil.a \
-arch armv7 ./compiled/armv7/lib/libavutil.a \
-arch x86_64 ./compiled/x86_64/lib/libavutil.a \
-arch i386 ./compiled/i386/lib/libavutil.a

./compiled/lipo -output ./compiled/fat/lib/libswscale.a  -create \
-arch arm64 ./compiled/arm64/lib/libswscale.a \
-arch armv7s ./compiled/armv7s/lib/libswscale.a \
-arch armv7 ./compiled/armv7/lib/libswscale.a \
-arch x86_64 ./compiled/x86_64/lib/libswscale.a \
-arch i386 ./compiled/i386/lib/libswscale.a

./compiled/lipo -output ./compiled/fat/lib/libavresample.a -create \
-arch arm64 ./compiled/arm64/lib/libavresample.a \
-arch armv7s ./compiled/armv7s/lib/libavresample.a \
-arch armv7 ./compiled/armv7/lib/libavresample.a \
-arch x86_64 ./compiled/x86_64/lib/libavresample.a \
-arch i386 ./compiled/i386/lib/libavresample.a

# copy include to fat
cp -R ./compiled/arm64/include ./compiled/fat/include/

# clean up
make clean

