# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.

FROM phusion/baseimage:0.9.16

MAINTAINER Nicholas Hathaway <nicholas.hathaway@umassmed.edu>

# global env
ENV HOME=/root TERM=xterm

# set proper timezone
RUN echo America/New_York > /etc/timezone && sudo dpkg-reconfigure --frontend noninteractive tzdata

# Install essential for building   
RUN \
  apt-get update && \
  apt-get install -y build-essential && \
  apt-get install -y software-properties-common && \
  apt-get -y upgrade

# install generic stuff for downloading other libraries 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y git cmake wget

# install clang and g++-5 
RUN echo "deb http://llvm.org/apt/"$(lsb_release -sc)"/ llvm-toolchain-"$(lsb_release -sc)"-3.5 main" | sudo tee /etc/apt/sources.list.d/llvm.list && \ 
	echo "deb-src http://llvm.org/apt/"$(lsb_release -sc)"/ llvm-toolchain-"$(lsb_release -sc)"-3.5 main" | sudo tee -a /etc/apt/sources.list.d/llvm.list && \
	echo "deb http://llvm.org/apt/"$(lsb_release -sc)"/ llvm-toolchain-"$(lsb_release -sc)" main" | sudo tee -a /etc/apt/sources.list.d/llvm.list && \
	echo "deb-src http://llvm.org/apt/"$(lsb_release -sc)"/ llvm-toolchain-"$(lsb_release -sc)" main" | sudo tee -a /etc/apt/sources.list.d/llvm.list && \
	sudo add-apt-repository ppa:ubuntu-toolchain-r/test && \
	wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key |sudo apt-key add - && \
	sudo apt-get update && sudo apt-get install -y clang-3.5 libc++-dev g++-5
	
RUN ln -s /usr/bin/clang-3.5 /usr/bin/clang && ln -s /usr/bin/clang++-3.5 /usr/bin/clang++

# install some generic stuff needed by other libraries 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y zlib1g-dev libpango1.0-dev libcurl4-openssl-dev doxygen graphviz libbz2-dev libjpeg-dev libatlas-base-dev gfortran fort77 libreadline6-dev emacs23-nox

#install apache2
RUN apt-get update && \
  apt-get install -y apache2 apache2-utils
  
# add all the files necessary files from the files directory for misc operations
ADD /files/ /

#
# link seek into /usr/bin
#
RUN ln -s /root/SeekDeepHome/SeekDeep/bin/SeekDeep /usr/bin/

#
# Make necessary scripts executable 
#

RUN chmod 755 /etc/rc.local /root/installSeekDeep.sh /root/copyfs.sh

# enable sshd
RUN /bin/rm /etc/service/sshd/down

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]


# public exposed ports
EXPOSE 8000 22
