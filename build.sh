#!/bin/bash

mkdir deps &> /dev/null
cd deps

#Add necessary extra repos
version=$(lsb_release -a 2>&1)
if [[ $version == *"14.04"* ]] ; then
    wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_7.5-18_amd64.deb
    sudo dpkg -i cuda-repo-ubuntu1404_7.5-18_amd64.deb
    rm cuda-repo-ubuntu1404_7.5-18_amd64.deb
    sudo apt-get update
    sudo apt-get install cuda-7-5
elif [[ $version == *"15.04"* ]] ; then
    wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1504/x86_64/cuda-repo-ubuntu1504_7.5-18_amd64.deb
    sudo dpkg -i cuda-repo-ubuntu1504_7.5-18_amd64.deb
    rm cuda-repo-ubuntu1504_7.5-18_amd64.deb
    sudo apt-get update
    sudo apt-get install cuda-7-5
elif [[ $version == *"16.04"* ]] ; then
    wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
    sudo dpkg -i cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
    rm cuda-repo-ubuntu1604_8.0.44-1_amd64.deb
    sudo add-apt-repository ppa:openjdk-r/ppa 
    sudo apt-get update
    sudo apt-get install cuda-8-0
elif [[ $version == *"18.10"* ]] ; then
    wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1810/x86_64/cuda-repo-ubuntu1810_10.1.168-1_amd64.deb
    sudo dpkg -i cuda-repo-ubuntu1810_10.1.168-1_amd64.deb
    rm cuda-repo-ubuntu1810_10.1.168-1_amd64.deb
    sudo apt update
    sudo apt install cuda
else
    echo "Don't use this on anything except 14.04, 15.04, or 16.04"
    exit
fi

sudo apt-get install -y cmake-qt-gui git build-essential libusb-1.0-0-dev libudev-dev freeglut3-dev libglew-dev libsuitesparse-dev libeigen3-dev zlib1g-dev libjpeg-dev

if [[ $version == *"18.10"* ]] ; then
    sudo apt install -y openjdk-11-jdk
else
    sudo apt-get install -y openjdk-7-jdk
fi

#Installing Pangolin
git clone https://github.com/stevenlovegrove/Pangolin.git
cd Pangolin
mkdir build
cd build
cmake ../ -DAVFORMAT_INCLUDE_DIR="" -DCPP11_NO_BOOST=ON
make -j8
cd ../..

#Up to date OpenNI2
git clone https://github.com/occipital/OpenNI2.git
cd OpenNI2
make -j8
cd ..

#Actually build ElasticFusion
cd ../Core
mkdir build
cd build
cmake ../src
make -j8
cd ../../GPUTest
mkdir build
cd build
cmake ../src
make -j8
cd ../../GUI
mkdir build
cd build
cmake ../src
make -j8
