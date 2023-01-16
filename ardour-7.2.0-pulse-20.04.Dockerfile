# Ardour-7.2.0 with Pulseaudio backend (for a CRD endpoint) based off Ubuntu 20.04

from ubuntu:20.04 as ardour

# Based on the dependencies, butld Ardour proper. In the end create a tar binary bundle.

from xx-by-crdep as ardour

run apt install -y libboost-dev libasound2-dev libglibmm-2.4-dev libsndfile1-dev
run apt install -y libcurl4-gnutls-dev libarchive-dev liblo-dev libtag-extras-dev
run apt install -y vamp-plugin-sdk librubberband-dev libudev-dev libnfft3-dev
run apt install -y libaubio-dev libxml2-dev libusb-1.0-0-dev libreadline-dev
run apt install -y libpangomm-1.4-dev liblrdf0-dev libsamplerate0-dev
run apt install -y libserd-dev libsord-dev libsratom-dev liblilv-dev
run apt install -y libgtkmm-2.4-dev libsuil-dev libcwiid-dev python libpulse-dev

run apt install -y wget curl git

run mkdir /build-ardour
workdir /build-ardour

run git clone https://github.com/Ardour/ardour.git

workdir ardour

run git checkout 7.2

workdir /build-ardour/ardour
run ./waf configure --no-phone-home --with-backend=pulseaudio --optimize --ptformat --cxx11 --luadoc
run ./waf build -j 4
run ./waf install
run apt install -y chrpath rsync unzip
run ln -sf /bin/false /usr/bin/curl
workdir tools/linux_packaging
run ./build --public --strip some
run ./package --public --singlearch

# At this point, the file /build-ardour/ardour/tools/linux_packaging/Ardour-x.y.0-x86_64.tar
# is ready for extraction.

