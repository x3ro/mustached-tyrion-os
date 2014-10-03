#!/bin/bash -x

cd src
nasm boot.asm -f bin -o ../build/boot.bin
cd ../build
dd if=/dev/zero of=boot.img bs=512 count=2880
dd if=boot.bin of=boot.img conv=notrunc
