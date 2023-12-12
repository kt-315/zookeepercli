#!/bin/bash -e
#
# kt315 <skraev@tradingview.com>
#

echo "========= Preparing packing start =========";
PKGNAME="zookeepercli"
VER=$(git describe --long --tags --always --abbrev=10 | sed 's/^[^0-9]//ig')
ARCH=$(dpkg --print-architecture)
RDIR="deb_build/${PKGNAME}_${VER}_${ARCH}"
mkdir -p "${RDIR}/usr/local/bin"
mkdir -p "${RDIR}/DEBIAN"

cp ./bin/${PKGNAME} ${RDIR}/usr/local/bin/

cat <<EOF > ${RDIR}/DEBIAN/control
Package: ${PKGNAME}
Version: ${VER}
Section: universe/net
Priority: optional
Architecture: $(dpkg --print-architecture)
Maintainer: Sergei Kraev <skraev@tradingview.com>
Installed-Size: $(du -s ${RDIR} | cut -f1)
Bugs: https://github.com/openark/zookeepercli
Description: Zookeeper client console
EOF

echo "========= Packing start =========";
dpkg-deb --verbose --build ${RDIR}  ./deb_build/"${PKGNAME}_${VER}_${ARCH}.deb"

echo "========= Done! =========";
