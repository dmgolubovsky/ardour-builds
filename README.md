# ardour-builds

This repository contains Dockerfiles to build Ardour standalone in various versions and configurations.

The build creates a tar file located as follows:
```
/build-ardour/ardour/tools/linux_packaging/Ardour-x.y.0-x86_64.tar
```
where x.y are Ardour version/subversion (e. g. 7.2) and the third digit is expected to be 0.

This file has to be extracted from the image.

The following commands (depending on the Ardour and libs versions) may need to be run on your base image to complete the install.
This may change if a different version/configuration of Ardour is being built, or a different base image/distro is used.

```
run mkdir -p /install-ardour
workdir /install-ardour
copy --from=ardour /build-ardour/ardour/tools/linux_packaging/Ardour-x.y.0-x86_64.tar .
run tar xvf Ardour-x.y.0-x86_64.tar
workdir Ardour-x.y.0-x86_64

# Install some libs that were not picked by bundlers - mainly X11 related.

run apt -y install gtk2-engines-pixbuf libxfixes3 libxinerama1 libxi6 libxrandr2 libxcursor1 libsuil-0-0
run apt -y install libxcomposite1 libxdamage1 liblzo2-2 libkeyutils1 libasound2 libgl1 libusb-1.0-0
run apt -y install libglibmm-2.4-1v5 libsamplerate0 libsndfile1 libfftw3-single3 libvamp-sdk2v5 \
                   libvamp-hostsdk3v5
run apt -y install liblo7 libaubio5 liblilv-0-0 libtag1v5-vanilla libpangomm-1.4-1v5 libcairomm-1.0-1v5
run apt -y install libgtkmm-2.4-1v5 libcurl3-gnutls libarchive13 liblrdf0 librubberband2 libcwiid1

# First time it will fail because one library was not copied properly.

# It will ask questions, say no.

run echo -ne "n\nn\nn\nn\nn\nn\nn\nn\n" | env NOABICHECK=1 ./.stage2.run

# Copy the missing libraries

run cp /usr/lib/x86_64-linux-gnu/gtk-2.0/2.10.0/engines/libpixmap.so /opt/Ardour-x.y.0/lib
run cp /usr/lib/x86_64-linux-gnu/suil-0/libsuil_x11_in_gtk2.so /opt/Ardour-x.y.0/lib
run cp /usr/lib/x86_64-linux-gnu/suil-0/libsuil_qt5_in_gtk2.so /opt/Ardour-x.y.0/lib

# Delete the unpacked bundle

run rm -rf /install-ardour
```

Dockerfiles can be used directly from this repo:

```
https://raw.githubusercontent.com/dmgolubovsky/ardour-builds/main/ardour-7.2.0-pulse-20.04.Dockerfile
```
