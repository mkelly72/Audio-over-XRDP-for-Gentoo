# Audio-over-XRDP-for-Gentoo
Simple script to build Pulseaudio driver for audio over XRDP

I use Gentoo on Hyper-V, and as you may know the only way to get proper video and audio over Hyper-V is through RDP. Gentoo by default does not have a driver for audio over XRDP (or XRDP itself for that matter), and the instructions I have seen on the internet to build one are quite complicated. And as you also probably know, whenever dependency packages are upgraded, the drivers they depend on need to be rebuilt, which can happen frequently. So I created a simple script to make the process easier and decided to share it on Github.

I use the "xrdp" and "xorgxrdp" ebuilds from the "ace" overlay, but the "pulseaudio-module-xrdp" ebuild does not work. Hence this script.

I use this script for my own purposes, so as long as it works for me I don't plan on frequently updating it. Keep in mind that my machine is arm64, so that's the only architecture I've tested on, though I have tried to take amd64 and x86 into account. But feel free to use it, copy it, fork it, unfork it, whatever.

Just download the script, make it executable, and run it as the local user, but be prepared to supply a SUDO password.

One of these days I might try to make a proper ebuild, but I haven't tried to make one before so I don't even know if it is within my capability.
