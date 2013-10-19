#!/bin/sh

# Tools and SDK paths
#export DEVPATH="/Developer4/Platforms/iPhoneOS.platform/Developer"
DEVPATH=/Applications/XCode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer
export SDKPATH="${DEVPATH}/SDKs/iPhoneOS6.0.sdk"
IPHONEOS_DEPLOYMENT_TARGET=4.1

INSTALLDIR=~/Sources/iOS/audio/iOS
DEST=/Users/Samuel/Sources/iOS/audio/iOS

# Tools
export AR="${DEVPATH}/usr/bin/libtool -static -o"
#export CC="${DEVPATH}/usr/bin/clang"
export CC=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang
#export CC="${DEVPATH}/usr/bin/llvm-gcc"

trap exit ERR

# 
#  -DARCH_ARMV6=1 -DCONTROL_OPT=1

CONTROL_OPT=
export CFLAGS="-Os -mno-thumb -isysroot ${SDKPATH} -fvisibility=hidden -miphoneos-version-min=${IPHONEOS_DEPLOYMENT_TARGET} -DARCH_ARMV6=1"
if test -n "$CONTROL_OPT"; then
export CFLAGS+=" -DCONTROL_OPT=1"
fi
export LDFLAGS="-isysroot ${SDKPATH} -miphoneos-version-min=${IPHONEOS_DEPLOYMENT_TARGET}"

echo "Building armv6..."
export ARCH=armv6
export DESTDIR=./iPhoneOS-${ARCH}.sdk

make -f Makefile.iOS -C src install || exit 1
if test -n "$CONTROL_OPT"; then
make -f Makefile.iOS -C tests install || exit 1
fi
make -f Makefile.iOS -C src clean   || exit 1
if test -n "$CONTROL_OPT"; then
make -f Makefile.iOS -C tests clean   || exit 1
fi

echo "Building armv7..."
export ARCH=armv7
export DESTDIR=./iPhoneOS-${ARCH}.sdk

make -f Makefile.iOS -C src install || exit 1
if test -n "$CONTROL_OPT"; then
make -f Makefile.iOS -C tests install || exit 1
fi
make -f Makefile.iOS -C src clean   || exit 1
if test -n "$CONTROL_OPT"; then
make -f Makefile.iOS -C tests clean   || exit 1
fi

#############
# universal lib
echo "Build library..."
mkdir -p ${INSTALLDIR}/lib
pushd src

for libpath in `ls -d ./iPhoneOS-armv6.sdk/usr/local/lib/lib*.a`; do
	libname=`basename ${libpath}`
	lipo -create ./iPhoneOS-armv6.sdk/usr/local/lib/${libname} ./iPhoneOS-armv7.sdk/usr/local/lib/${libname} -output ${INSTALLDIR}/lib/${libname}
done

mkdir -p ${DEST}/include/g729a
cp -R ./iPhoneOS-armv6.sdk/usr/local/include/* ${DEST}/include/

echo "Building done."
echo "Cleaning up..."
rm -rf ./iPhoneOS-armv?.sdk
popd

if test -n "$CONTROL_OPT"; then
echo "Install binaries..."
mkdir -p ${DEST}/bin
pushd tests

cp -R ./iPhoneOS-armv?.sdk/usr/local/bin/* ${DEST}/bin
rm -rf ./iPhoneOS-armv?.sdk
popd
fi

echo "Done."
