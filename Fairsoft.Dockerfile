ARG BASE_IMAGE=ubuntu:18.04
FROM $BASE_IMAGE

MAINTAINER Maisam M. Dadkan, Email:maisam.m.dadkan@gmail.com
#
# Install dependencies
#

RUN	apt-get update && \
	apt-get install -y cmake cmake-data g++ gcc gfortran \
	debianutils build-essential make patch sed \
	libx11-dev libxft-dev libxext-dev libxpm-dev libxmu-dev \
	libglu1-mesa-dev libgl1-mesa-dev \
	libncurses5-dev curl libcurl4-openssl-dev bzip2 libbz2-dev gzip unzip tar \
	subversion git xutils-dev flex bison lsb-release python-dev python3-dev\
	libc6-dev-i386 libxml2-dev wget libssl-dev libkrb5-dev \
	automake autoconf libtool zlib1g-dev \
	libreadline-dev libsqlite3-dev llvm \
	libncursesw5-dev xz-utils liblzma-dev python-openssl python3-openssl &&\
	apt-get clean && rm -rf /var/lib/apt/lists/*

#
# Steal newer CMake
#
WORKDIR /opt
RUN wget https://github.com/Kitware/CMake/releases/download/v3.16.4/cmake-3.16.4-Linux-x86_64.sh -O cmake.sh && chmod +x cmake.sh && \
    mkdir /opt/cmake-3.16.4 && ./cmake.sh --skip-license --prefix=/opt/cmake-3.16.4 && \
    rm cmake.sh
ENV PATH="/opt/cmake-3.16.4/bin:${PATH}"

#copy modified source code of fairsoft and install it
WORKDIR	/tmp/fairsoft-build
COPY	./fairsoft.conf ./fairsoft.conf
COPY	./FairSoft-jun19p2 ./FairSoft
RUN	cd FairSoft &&  ./configure.sh ../fairsoft.conf && ./make_clean.sh all && rm -rf /tmp/fair*

ENV SIMPATH="/opt/fairsoft_jun19p2"\
    G4INCLDATA="/opt/fairsoft_jun19p2/share/Geant4-10.5.1/data/G4INCL1.0"\
    G4LEVELGAMMADATA="/opt/fairsoft_jun19p2/share/Geant4-10.5.1/data/PhotonEvaporation5.3"\
    G4RADIOACTIVEDATA="/opt/fairsoft_jun19p2/share/Geant4-10.5.1/data/RadioactiveDecay5.3"\
    G4PIIDATA="/opt/fairsoft_jun19p2/share/Geant4-10.5.1/data/G4PII1.3"\
    G4SAIDXSDATA="/opt/fairsoft_jun19p2/share/Geant4-10.5.1/data/G4SAIDDATA2.0"\
    G4ABLADATA="/opt/fairsoft_jun19p2/share/Geant4-10.5.1/data/G4ABLA3.1"\
    G4REALSURFACEDATA="/opt/fairsoft_jun19p2/share/Geant4-10.5.1/data/RealSurface2.1.1"\
    G4NEUTRONHPDATA="/opt/fairsoft_jun19p2/share/Geant4-10.5.1/data/G4NDL4.5"\
    G4PARTICLEXSDATA="/opt/fairsoft_jun19p2/share/Geant4-10.5.1/data/G4PARTICLEXS1.1"\
    G4ENSDFSTATEDATA="/opt/fairsoft_jun19p2/share/Geant4-10.5.1/data/G4ENSDFSTATE2.2"\
    G4LEDATA="/opt/fairsoft_jun19p2/share/Geant4-10.5.1/data/G4EMLOW7.7"

ENV SIMPATH="/opt/fairsoft_jun19p2"\
    PATH="${SIMPATH}/bin:${PATH}"\
    LD_LIBRARY_PATH=$SIMPATH/lib:$SIMPATH/lib/root:$LD_LIBRARY_PATH\
    PYTHONPATH=$SIMPATH/lib/root

# Set the working directory
WORKDIR /home/project

