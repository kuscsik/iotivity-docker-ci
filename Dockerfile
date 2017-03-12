# Latest Ubuntu LTS
FROM ubuntu:12.04
ADD sources.list /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0CFB84AE029DB5C7
RUN apt-get -y update

RUN apt-get install -y \
autotools-dev \
binutils \
blcr-util \
build-essential \
ca-certificates-java \
cmap-adobe-japan1 \
cpp \
cpp-4.6 \
doc-base \
dos2unix \
dpkg-dev \
fakeroot \
fontconfig \
fontconfig-config \
fonts-liberation \
g++ \
g++-4.6 \
gcc \
gcc-4.6 \
gccxml \
gdb \
gettext \
git \
graphviz \
gs-cjk-resource \
gsfonts \
installation-report \
intltool-debian \
java-common \
language-pack-en \
language-pack-en-base \
lib32gcc1 \
lib32stdc++6 \
lib32z1 \
libalgorithm-diff-perl \
libalgorithm-diff-xs-perl \
libalgorithm-merge-perl \
libasyncns0 \
libavahi-client3 \
libavahi-common-data \
libavahi-common3 \
libboost-all-dev \
libbz2-dev \
libc-dev-bin \
libc6-dbg \
libc6-dev \
libc6-i386 \
libcairo2 \
libcdt4 \
libcgraph5 \
libcr0 \
libcroco3 \
libcups2 \
libcupsimage2 \
libdatrie1 \
libdpkg-perl \
liberror-perl \
libexpat1-dev \
libffi-dev \
libflac8 \
libfontconfig1 \
libfontenc1 \
libgd2-xpm \
libgettextpo0 \
libglib2.0-bin \
libglib2.0-data \
libglib2.0-dev \
libgomp1 \
libgraph4 \
libgs9 \
libgs9-common \
libgvc5 \
libgvpr1 \
libibverbs-dev \
libibverbs1 \
libice6 \
libicu-dev \
libicu48 \
libijs-0.35 \
libjasper1 \
libjbig2dec0 \
libjpeg-turbo8 \
libjpeg8 \
libjson0 \
libkpathsea5 \
liblcms2-2 \
liblua5.1-0 \
libmail-sendmail-perl \
libmpc2 \
libmpfr4 \
libnspr4 \
libnss3 \
libnss3-1d \
libnuma1 \
libogg0 \
libopenmpi-dev \
libopenmpi1.3 \
libpango1.0-0 \
libpaper-utils \
libpaper1 \
libpathplan4 \
libpcre3-dev \
libpcrecpp0 \
libpixman-1-0 \
libpoppler19 \
libpulse0 \
libquadmath0 \
libsensors4 \
libsm6 \
libsndfile1 \
libssl-dev \
libssl-doc \
libstdc++6-4.6-dev \
libsys-hostname-long-perl \
libthai-data \
libthai0 \
libtiff4 \
libtorque2 \
libunistring0 \
libuuid-perl \
libvorbis0a \
libvorbisenc2 \
libxaw7 \
libxcb-render0 \
libxcb-shm0 \
libxfont1 \
libxft2 \
libxmu6 \
libxpm4 \
libxrender1 \
libxt6 \
libyaml-tiny-perl \
linux-libc-dev \
make \
mpi-default-bin \
mpi-default-dev \
openjdk-7-jdk \
openjdk-7-jre-headless \
openmpi-bin \
openmpi-checkpoint \
openmpi-common \
pkg-config \
po-debconf \
ps2eps \
python-dev \
python-http-parser \
python2.7-dev \
scons \
sysstat \
traceroute \
ttf-dejavu-core \
ttf-liberation \
tzdata-java \
unzip \
uuid-dev \
valgrind \
xfonts-encodings \
xfonts-utils \
zlib1g-dev

# Dependencies
RUN  apt-get update && apt-get install -yq libstdc++6:i386 zlib1g:i386 libncurses5:i386 ant maven --no-install-recommends
ENV GRADLE_URL http://services.gradle.org/distributions/gradle-2.2.1-all.zip
RUN curl -L ${GRADLE_URL} -o /tmp/gradle-2.2.1-all.zip && unzip /tmp/gradle-2.2.1-all.zip -d /usr/local && rm /tmp/gradle-2.2.1-all.zip
ENV GRADLE_HOME /usr/local/gradle-2.2.1

# Download and untar SDK
#ENV ANDROID_SDK_URL http://dl.google.com/android/android-sdk_r24.2-linux.tgz
#RUN curl -L ${ANDROID_SDK_URL} | tar xz -C /usr/local
#ENV ANDROID_HOME /usr/local/android-sdk-linux

# Install Android SDK components
#ENV ANDROID_SDK_COMPONENTS platform-tools,build-tools-21.1.2,android-21,extra-android-support
#RUN echo y | ${ANDROID_HOME}/tools/android update sdk --no-ui --all --filter "${ANDROID_SDK_COMPONENTS}"

# Path
#ENV PATH $PATH:${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:${GRADLE_HOME}/bin

WORKDIR /usr/local
RUN curl -L -O  http://dl.google.com/android/ndk/android-ndk-r10d-linux-x86_64.bin
RUN chmod a+x android-ndk-r10d-linux-x86_64.bin
RUN ./android-ndk-r10d-linux-x86_64.bin 1> /dev/null 2>&1 && rm android-ndk-r10d-linux-x86_64.bin

ENV ANDROID_NDK /usr/local/android-ndk-r10d

RUN git clone https://github.com/01org/tinycbor.git /usr/local/tinycbor && cd /usr/local/tinycbor && git checkout v0.4

RUN git clone  https://github.com/ARMmbed/mbedtls.git  /usr/local/mbedtls

RUN cd /usr/local/mbedtls && git checkout mbedtls-2.4.0 &>/dev/null

ADD BuildScript /root/BuildScript
RUN chmod +x /root/BuildScript

RUN apt-get update && apt-get install -y libcurl4-openssl-dev \
    libsqlite3-dev autoconf libtool software-properties-common python-software-properties vim


# RUN add-apt-repository ppa:ubuntu-toolchain-r/test && apt-get update && apt-get install -y gcc-5 g++-5

WORKDIR /root

CMD ["/root/BuildScript"]
