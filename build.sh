#!/bin/bash

set -e
rm -rf GigaWireVB
git clone https://github.com/sartura/GigaWireVB.git -b vdsl
cd GigaWireVB
sed -i 's/gcc-4.4/gcc/g' Makefile
sed -i 's/SPECIAL       += -O0 -g -fno-strict-aliasing/SPECIAL       += -O1 -g -fno-strict-aliasing/g' Makefile
sed -i 's/SPECIAL       +=/SPECIAL       += -Wno-error /g' Makefile
sed -i 's/TARGET_LIST   := x86 MIPS ARMV7b ARM64 ARMV7/TARGET_LIST   := x86 MIPS ARMV7b ARM64 ARMV7 AMD64/g' Makefile
sed -i 's/MACROS        := -D_X86_=0 -D_MIPS_=1 -D_ARMV7_=2 -D_ARMV7b_=3 -D_ARM64_=4/MACROS        := -D_X86_=0 -D_MIPS_=1 -D_ARMV7_=2 -D_ARMV7b_=3 -D_ARM64_=4 -D_AMD64_=5/g' Makefile
sed -i 's#SYS_INCLUDES  := $(addprefix -I ,$(shell echo | $(CC) -Wp,-v -x c - -fsyntax-only 2>\&1 | grep -e \"^ \"))#SYS_INCLUDES  := $(addprefix -I ,$(shell echo | $(CC) -Wp,-v -x c - -fsyntax-only 2>\&1 | grep -e \"^ \"))'"\n"'else ifeq ($(COMPILER),AMD64)'"\n"'  CC            := gcc'"\n"'  AR            := ar'"\n"'  MACROS        += -D_CONFIG_LOG_=1 -D__BYTE_ORDER__=__ORDER_LITTLE_ENDIAN__ -D_CONFIG_TARGET_=_AMD64_'"\n"'  WARNINGS      += -Wno-address-of-packed-member -Wno-format-truncation -Wno-stringop-truncation'"\n"'  ifeq ($(VECTORBOOST_VALGRIND),yes)'"\n"'    SPECIAL       += -Wno-error -O0 -g -fno-strict-aliasing'"\n"'  else'"\n"'    SPECIAL       += -Wno-error -static'"\n"'    ifeq ($(VECTORBOOST_DEBUG),yes)'"\n"'      SPECIAL     += -Wno-error -O0 -g -fno-strict-aliasing'"\n"'    else'"\n"'      SPECIAL     += -Wno-error -O2 -fno-strict-aliasing'"\n"'    endif'"\n"'  endif'"\n"''"\n"'  SYS_INCLUDES  := $(addprefix -I ,$(shell echo | $(CC) -Wp,-v -x c - -fsyntax-only 2>\&1 | grep -e \"^ \"))#g' Makefile
sed -i 's#@echo \">> Preparing ARM64 release package...\"#@echo \">> Preparing AMD64 release package...\"'"\n"'	COMPILER=AMD64 $(MAKE)  all'"\n"'	COMPILER=AMD64 $(MAKE) -C driver INSTALL_PATH=`pwd`/release/amd64 install'"\n"'	COMPILER=AMD64 $(MAKE) -C engine INSTALL_PATH=`pwd`/release/amd64 install'"\n"'	COMPILER=AMD64 $(MAKE) -C driver clean'"\n"'	COMPILER=AMD64 $(MAKE) -C engine clean'"\n"'	@echo \"\"'"\n"'	@echo \">> Preparing ARM64 release package...\"#g' Makefile
sed -i 's#cd release; rm -rf vectorBoost_src#cd release; tar czvf vectorBoost_amd64.tgz amd64 > /dev/null'"\n"'	cd release; tar czvf vectorBoost_arm64.tgz arm64 > /dev/null'"\n"'	cd release; rm -rf vectorBoost_src'"\n"'	cd release; rm -rf amd64'"\n"'	cd release; rm -rf arm64'"\n"'	cd release; rm -rf armv7'"\n"'	cd release; rm -rf mips#g' Makefile


export ARM64_CROSS=/usr/bin/aarch64-linux-gnu-
export ARM64_SYSROOT=/usr/aarch64-linux-gnu/
export ARMV7b_CROSS=/usr/bin/arm-linux-gnueabihf-
export ARMV7b_SYSROOT=/usr/arm-linux-gnueabihf/

rm -rf driver/bin
rm -rf engine/bin
make release

echo "Your files are in GigawireVB/release"
