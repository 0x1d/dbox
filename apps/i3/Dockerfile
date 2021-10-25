FROM lscr.io/linuxserver/webtop:arch-i3 AS base
COPY opt/ /opt
RUN yes | pacman -Sy $(awk '{print $1}'  /opt/pkglist/shell)
RUN yes | pacman -Sy $(awk '{print $1}'  /opt/pkglist/yak)
RUN yes | pacman -Sy $(awk '{print $1}'  /opt/pkglist/k8s)
