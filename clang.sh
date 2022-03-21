#! /bin/bash
# Just a simple script for auto push aosp-clang since my network is limited


export EMOH="/drone/src"
export CLANG_VERSION="clang-r450784"  # https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+/refs/heads/master

mkdir ${EMOH}/tmp
cd ${EMOH}/tmp

wget --quiet https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/master/${CLANG_VERSION}.tgz
tar -xf ${CLANG_VERSION}.tgz
rm -rf ${CLANG_VERSION}.tgz

git clone https://reina:${GL_TOKEN}@gitlab.com/reinazhard/aosp-clang ${EMOH}/push
rm -rf ${EMOH}/push/*
cp -rf ${EMOH}/tmp/* ${EMOH}/push/

cd ${EMOH}/push/
git add .
git commit -s --quiet -m "Import AOSP Clang from https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/master/${CLANG_VERSION}"
git push origin
