MediaLibDemos
=============

Media Library for iOS provides the classes and protocols for media live stream publishing and playback, or VOD recording and playback, via RTMP. 
It allows the iOS devices to interact with the media servers: Adobe FMS, Wowza MS, Red5, crtmp, rtmpd.

Media Library for iOS uses the classes and protocols of Communication Library for iOS (see Communication Library for iOS User Guide).

Requirements
The library imposes the following requirements on the iOS applications utilizing it:
1.	iOS Deployment Target - 6.0 or above;
2.	the following frameworks and libraries must be added to the list of libraries linked to the binary:
-	AudioToolbox.framework, AVFoundation.framework, CFNetwork.framework, CoreData.framework, CoreFoundation.framework, CoreGraphics.framework, CoreMedia.framework, CoreVideo.framework, Foundation.framework, Security.framework, libiconv.2.4.0.dylib, libz.dylib;
-	The Midnight Coders static library: CommLibiOS.a;
-	the FFmpeg/Libav static libraries: libavcodec.a, libavdevice.a, libavfilter.a, libavformat.a, libavutil.a, libswscale.a
