# Use Ubuntu 18.04 as the base image
FROM ubuntu:18.04

# Update package lists and install basic dependencies
RUN apt-get update && apt-get install -y \
    make \
    bison \
    flex \
    git \
    libgmp-dev \
    libmpc-dev \
    python3.8 \
    python3-dev \
    python3-pip \
    libssl-dev \
    wget \
    && apt-get clean

# Install PBC library
RUN wget https://crypto.stanford.edu/pbc/files/pbc-0.5.14.tar.gz && \
    tar -xvf pbc-0.5.14.tar.gz && \
    cd pbc-0.5.14 && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf pbc-0.5.14 pbc-0.5.14.tar.gz

# Update library cache
RUN ldconfig /usr/local/lib

# Set Environment Variables
ENV LIBRARY_PATH=/usr/local/lib:$LIBRARY_PATH
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# Clone and install Charm
RUN git clone https://github.com/JHUISI/charm.git && \
    cd charm && \
    ./configure.sh && \
    make && \
    make install && \
    cd .. && \
    rm -rf charm

# Install Python 
RUN python3 -m pip install --upgrade pip && \
    pip3 install gevent setuptools gevent numpy ecdsa pysocks gmpy2 zfec gipc pycrypto coincurve portalocker pytz ntplib

# Clone the kronos repository and set it as the working directory
RUN git clone https://github.com/XYZ-LABb/sonork.git --branch hotstuff /kronos
WORKDIR /kronos