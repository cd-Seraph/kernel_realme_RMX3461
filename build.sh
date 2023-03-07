#!/bin/bash

# Built in Timer
SECONDS=0
TZ='Asia/Manila'
export TZ
DATE=$(date "+%Y-%m-%d")
source ~/.bashrc && source ~/.profile
export LC_ALL=C && export USE_CCACHE=1
export ARCH=arm64
export KBUILD_BUILD_HOST=feather
export KBUILD_BUILD_USER="cd-Seraph"
ZIPNAME=Feather-OSS-KERNEL-RELEASE-"${DATE}".zip

mkdir clang && curl -Lsq "https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/android13-release/clang-r450784d.tar.gz" -o clang.tgz && tar -xzf clang.tgz -C clang

curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -

# Built in Timer
SECONDS=0

[ -d "out" ] && rm -rf out || mkdir -p out

make O=out ARCH=arm64 feather_defconfig

PATH="${PWD}/clang/bin:${PATH}" \
make -j$(nproc --all) O=out \
			ARCH=$ARCH \
			CC=clang HOSTCC=clang \
			CLANG_TRIPLE=aarch64-linux-gnu- \
			CROSS_COMPILE=aarch64-linux-android- \
			CROSS_COMPILE_ARM32=arm-linux-androideabi-
            		CONFIG_NO_ERROR_ON_MISMATCH=y 2>&1 | tee error.log 



git clone --depth=1 https://github.com/cd-Seraph/AnyKernel3.git -b master AnyKernel
cp out/arch/arm64/boot/Image AnyKernel
cd AnyKernel
zip -r9 "../$ZIPNAME" * -x .git README.md *placeholder
cd ..
echo -e "\nCompleted in $((SECONDS / 60)) minute(s) and $((SECONDS % 60)) second(s) !"
