#!/bin/bash

# Built in Timer
SECONDS=0

function compile() 
{
TZ='Asia/Manila'
export TZ
DATE=$(date "+%Y-%m-%d")
rm -rf AnyKernel
source ~/.bashrc && source ~/.profile
export LC_ALL=C && export USE_CCACHE=1
export ARCH=arm64
export KBUILD_BUILD_HOST=ice
export KBUILD_BUILD_USER="cd-Seraph"
ZIPNAME=Ice-Test-OSS-KERNEL-"${DATE}".zip
kernel="out/arch/arm64/boot/Image"
dtb="out/arch/arm64/boot/dts/vendor/oplus_7325/yupik.dtb"
dtbo="out/arch/arm64/boot/dts/vendor/oplus_7325/yupik-21643-overlay.dtbo"

curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -

git clone --depth=1 https://github.com/kdrag0n/proton-clang clang

[ -d "out" ] && rm -rf out || mkdir -p out

make O=out ARCH=arm64 feather_defconfig

PATH="${PWD}/clang/bin:${PATH}" \
make -j$(nproc --all) O=out \
			ARCH=$ARCH \
			CC="clang" \
			CROSS_COMPILE=aarch64-linux-gnu- \
			CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
           	 	LLVM=1 \
			LD=ld.lld \
			AR=llvm-ar \
			NM=llvm-nm \
			OBJCOPY=llvm-objcopy \
			OBJDUMP=llvm-objdump \
			STRIP=llvm-strip \
            		CONFIG_NO_ERROR_ON_MISMATCH=y 2>&1 | tee error.log 
}

function zupload()
{
if [ -f "$kernel" ] && [ -f "$dtb" ] && [ -f "$dtbo" ]; then
	echo -e "\nKernel compiled succesfully! Zipping up...\n"

      git clone --depth=1 https://github.com/cd-Seraph/AnyKernel3.git -b master AnyKernel
	
	cp $kernel AnyKernel
	cp $dtb AnyKernel/dtb
	python2 scripts/dtc/libfdt/mkdtboimg.py create AnyKernel/dtbo.img --page_size=4096 $dtbo
	cd AnyKernel
	zip -r9 "../$ZIPNAME" * -x .git README.md *placeholder
	cd ..
	echo -e "\nCompleted in $((SECONDS / 60)) minute(s) and $((SECONDS % 60)) second(s) !"
	echo "Zip: $ZIPNAME"
else
	echo -e "\nCompilation failed!"
	exit 1
fi
}

compile
zupload

curl -sL https://git.io/file-transfer | sh
./transfer wet *.zip
./transfer wet error.log
