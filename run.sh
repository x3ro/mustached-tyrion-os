#!/bin/bash -xe

./build.sh
bochs -q <<EOF
c

EOF
