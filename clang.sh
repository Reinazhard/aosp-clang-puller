#! /bin/bash
# Just a simple script for auto push aosp-clang since my network is limited


export EMOH="/drone/src"
export CLANG_VERSION="clang-r437112"  # https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+/refs/heads/master

git config --global http.version HTTP/1.1

mkdir ${EMOH}/tmp
cd ${EMOH}/tmp

wget --quiet https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/master/${CLANG_VERSION}.tgz
tar -xf ${CLANG_VERSION}.tgz
rm -rf ${CLANG_VERSION}.tgz

git clone https://Reinazhard:${GH_TOKEN}@github.com/pjorektneira/aosp-clang.git ${EMOH}/push
rm -rf ${EMOH}/push/*
cp -rf ${EMOH}/tmp/* ${EMOH}/push/

cd ${EMOH}/push/
git add .
git commit -s --quiet -m "Import AOSP Clang from https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/master/${CLANG_VERSION}"
git lfs migrate import --include="lib64/liblldb.so.14.*git lib64/libclang-cpp.so.14git"
git push origin
