#!/bin/bash

mkdir -p /root/SeekDeepHome

cd /root/SeekDeepHome && git clone https://github.com/bailey-lab/SeekDeep.git

# download and install dependencies
cd /root/SeekDeepHome/SeekDeep && ./configure.py -CC clang-3.5 -CXX clang++-3.5 && ./setup.py -compfile compfile.mk

#remove tarballs and build directories
#sudo /bin/rm -fr /root/SeekDeepHome/SeekDeep/external/tarballs /root/SeekDeepHome/SeekDeep/external/build  

#make SeekDeep
cd /root/SeekDeepHome/SeekDeep && make -j $(nproc)

