#! /bin/bash
# Simple AOSP Clang Puller Script
#
# Copyright (c) 2021-2022 Reinazhard <reinazhard@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


export EMOH="/drone/src"
export CLANG_VERSION="clang-r468909"  # https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+/refs/heads/master

# Import clang from Google's repository
import() {
	mkdir ${EMOH}/tmp
	cd ${EMOH}/tmp

	wget --quiet https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/master/${CLANG_VERSION}.tgz
	tar -xf ${CLANG_VERSION}.tgz
	rm -rf ${CLANG_VERSION}.tgz
}

# Strip unneeded packages
strip() {
	cd ${EMOH}/tmp

	find . -type f -exec file {} \; \
		| grep -E "x86|80386" \
		| grep "strip" \
		| grep -v "relocatable" \
		| tr ':' ' ' | awk '{print $1}' | while read file; do
		    ./bin/llvm-strip -s $file
	done

	find . -type f -exec file {} \; \
		| grep "ARM" \
		| grep "aarch64" \
		| grep "strip" \
		| grep -v "relocatable" \
		| tr ':' ' ' | awk '{print $1}' | while read file; do
		    ./bin/llvm-strip -s $file
	done

	find . -type f -exec file {} \; \
		| grep "ARM" \
		| grep "32.bit" \
		| grep "strip" \
		| grep -v "relocatable" \
		| tr ':' ' ' | awk '{print $1}' | while read file; do
		    ./bin/llvm-strip -s $file
	done
}

# Push it to GitLab
push() {
	git clone https://reina:${GL_TOKEN}@gitlab.com/reinazhard/aosp-clang ${EMOH}/push
	rm -rf ${EMOH}/push/*
	cp -rf ${EMOH}/tmp/* ${EMOH}/push/

	cd ${EMOH}/push/
	git add .
	git commit -s --quiet -m "Import AOSP Clang from https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/master/${CLANG_VERSION}"
	git push origin
}

import
strip
push
