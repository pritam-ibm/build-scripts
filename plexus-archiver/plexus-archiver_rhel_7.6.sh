# ----------------------------------------------------------------------------
#
# Package			: plexus-archiver
# Version			: 3.7.0, 4.2.2
# Source repo		: https://github.com/codehaus-plexus/plexus-archiver
# Tested on			: RHEL 7.6
# Script License	: Apache License Version 2.0
# Maintainer		: Sarvesh Tamba <sarvesh.tamba@ibm.com>
#
# Disclaimer: This script has been tested in root mode on given
# ==========  platform using the mentioned version of the package.
#             It may not work as expected with newer versions of the
#             package and/or distribution. In such case, please
#             contact "Maintainer" of this script.
#			  
# ----------------------------------------------------------------------------

#!/bin/bash

# install tools and dependent packages
#yum -y update
yum install -y git wget curl unzip nano vim make build-essential dos2unix
#yum install -y gcc ant

# setup java environment
yum install -y java java-devel
which java
ls /usr/lib/jvm/
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-ibm-1.8.0.6.5-1jpp.1.el7.ppc64le
# update the path env. variable 
export PATH=$PATH:$JAVA_HOME/bin

# install maven
MAVEN_VERSION=3.6.3
wget http://mirrors.estointernet.in/apache/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz
ls /usr/local
tar -C /usr/local/ -xzf apache-maven-$MAVEN_VERSION-bin.tar.gz
mv /usr/local/apache-maven-$MAVEN_VERSION /usr/local/maven
ls /usr/local
rm apache-maven-$MAVEN_VERSION-bin.tar.gz
export M2_HOME=/usr/local/maven
# update the path env. variable 
export PATH=$PATH:$M2_HOME/bin

# create folder for saving logs 
mkdir -p /logs

# variables
PKG_NAME="plexus-archiver"
PKG_VERSION=3.7.0
PKG_VERSION_LATEST=4.2.2
LOGS_DIRECTORY=/logs
LOCAL_DIRECTORY=/root
REPOSITORY="https://github.com/codehaus-plexus/plexus-archiver.git"

# export env. variables 
export LC_ALL=en_US.UTF-8

# clone, build and test specified version
cd $LOCAL_DIRECTORY
git clone $REPOSITORY $PKG_NAME-$PKG_VERSION
cd $PKG_NAME-$PKG_VERSION/
git checkout -b $PKG_VERSION tags/$PKG_NAME-$PKG_VERSION
mvn clean install | tee $LOGS_DIRECTORY/$PKG_NAME-$PKG_VERSION.txt

# clone, build and test latest version
cd $LOCAL_DIRECTORY
git clone $REPOSITORY $PKG_NAME-$PKG_VERSION_LATEST
cd $PKG_NAME-$PKG_VERSION_LATEST/
git checkout -b $PKG_VERSION_LATEST tags/$PKG_NAME-$PKG_VERSION_LATEST
mvn clean install | tee $LOGS_DIRECTORY/$PKG_NAME-$PKG_VERSION_LATEST.txt

# clone, build and test master
#cd $LOCAL_DIRECTORY
#git clone $REPOSITORY $PKG_NAME-master
#cd $PKG_NAME-master/
#mvn clean install | tee $LOGS_DIRECTORY/$PKG_NAME.txt
