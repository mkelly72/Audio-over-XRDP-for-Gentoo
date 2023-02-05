#!/bin/bash

# To build audio drivers for xrdp (Gentoo)

### Download and install dependencies
sudo emerge -u media-sound/pulseaudio dev-vcs/git app-portage/gentoolkit

### Find current pulseaudio version and set variables
LIBPULSEVERSION=$(equery list libpulse | awk '/libpulse/ {print}'| sed 's/media-libs\///')
PULSEAUDIOEBUILD=/var/db/repos/gentoo/media-libs/libpulse/$LIBPULSEVERSION.ebuild
PULSEAUDIOVERSION=$(equery list pulseaudio | awk '/pulseaudio/ {print}' | sed 's/media-sound\///')
BUILDDIR=/var/tmp/portage/media-libs/$LIBPULSEVERSION/
PULSEDIR=$BUILDDIR/work/$PULSEAUDIOVERSION/
FINDARCH=$(uname -m)
if [[ "$FINDARCH" == "aarch64" ]]
    then MYARCH=arm64
    else
        if [[ "$FINDARCH" == "x86_64" ]]
            then MYARCH=amd64
            else
            MYARCH=x86
        fi
fi
PULSECONFIGDIR=$BUILDDIR/work/$PULSEAUDIOVERSION-.$MYARCH/

### Fetch/unpack/build libpulse
sudo ebuild $PULSEAUDIOEBUILD compile

### Access and change to build directory
sudo chmod -R 755 $BUILDDIR
cd $PULSEDIR

### Download module source
sudo git clone https://github.com/neutrinolabs/pulseaudio-module-xrdp.git

### Build module
cd pulseaudio-module-xrdp
sudo ./bootstrap
sudo ./configure PULSE_DIR=$PULSEDIR PULSE_CONFIG_DIR=$PULSECONFIGDIR
sudo make
cd src/.libs
sudo install -t "/usr/lib64/pulseaudio/modules" -D -m 644 *.so

### Restart pulseaudio
if test -f /usr/bin/systemctl; then
	systemctl --user restart pulseaudio
    systemctl --user enable pulseaudio
fi
if test -f /sbin/rc-update; then
    sudo rc-update add pulseaudio default
    sudo rc-service pulseaudio start
fi

sudo rc-update add pulseaudio default
sudo rc-service pulseaudio start


### Clean up
cd ~
sudo rm -rf $BUILDDIR

exit 0
