#!/bin/sh

# Tools and SDK paths
export DEVPATH="/Developer4/Platforms/iPhoneOS.platform/Developer"
export SDKPATH="${DEVPATH}/SDKs/iPhoneOS5.0.sdk"
IPHONEOS_DEPLOYMENT_TARGET=4.1

#armv6 or armv7
export ARCH=armv6

export SRCDIR=../src
export INCDIR=../include
export OBJDIR=../build/${ARCH}
export EXEDIR=../bin

# Tools
export AR="${DEVPATH}/usr/bin/libtool -static -o"
export CC="${DEVPATH}/usr/bin/clang"

# 
#  -DARCH_ARMV6=1 -DCONTROL_OPT=1
ICFLAGS="-Os -mno-thumb -isysroot ${SDKPATH} -fvisibility=hidden -miphoneos-version-min=${IPHONEOS_DEPLOYMENT_TARGET} -DARCH_ARMV6=1 -DCONTROL_OPT=1"
ILDFLAGS="-isysroot ${SDKPATH} -miphoneos-version-min=${IPHONEOS_DEPLOYMENT_TARGET}"
#-miphoneos-version-min (iOS) or -mmacosx-version-min (Simulator)


export CFLAGS="-arch ${ARCH} ${ICFLAGS} -I${INCDIR}"
export LDFLAGS="-arch ${ARCH} ${ILDFLAGS}"

mkdir -p ${OBJDIR}

make -f CODER.MAK  || exit 1
make -f DECODER.MAK  || exit 1

###
export ARCH=armv7
export OBJDIR=../build/${ARCH}
export CFLAGS="-arch ${ARCH} ${ICFLAGS} -I${INCDIR}"
export LDFLAGS="-arch ${ARCH} ${ILDFLAGS}"

mkdir -p ${OBJDIR}

make -f CODER.MAK  || exit 1
make -f DECODER.MAK  || exit 1

# for i in *; do mv "$i" "$(echo $i | tr '[:upper:]' '[:lower:]')"; done