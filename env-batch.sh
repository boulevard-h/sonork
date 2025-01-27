#!/bin/bash

sudo apt-get update
sudo apt-get -y install make bison flex libgmp-dev git libmpc-dev python3.10 python3-dev python3-pip libssl-dev libgmp3-dev

wget https://crypto.stanford.edu/pbc/files/pbc-0.5.14.tar.gz
tar -xvf pbc-0.5.14.tar.gz
cd pbc-0.5.14
sudo ./configure
sudo make
sudo make install
cd ..

sudo ldconfig /usr/local/lib

cat <<EOF >~/.profile
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
EOF

source ~/.profile
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
 
git clone https://github.com/JHUISI/charm.git
cd charm
sudo ./configure.sh
sudo make
sudo make install
cd ..

python3 -m pip install --upgrade pip
sudo pip3 install gevent setuptools gevent numpy ecdsa pysocks gmpy2 zfec gipc pycrypto coincurve portalocker pytz ntplib

#git clone -b speed-kronos-sqlite3 https://github.com/hidden-er/kronos.git 
#cd kronos

#Then you should replace hosts.config & start.sh and start to run.
