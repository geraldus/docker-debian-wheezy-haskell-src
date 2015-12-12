FROM geraldus/wheezy-haskell-base:latest

MAINTAINER Geraldus <heraldhoi@gmail.com>

# GHC itself
WORKDIR /root/tmp/ghc7103

# First install GHC 7.8.4 from binary distro then build 7.10.3 from source
RUN mkdir /root/tmp/ghc784 \
 && cd /root/tmp/ghc784 \
 && wget http://downloads.haskell.org/~ghc/7.8.4/ghc-7.8.4-x86_64-unknown-linux-deb7.tar.bz2 \
 && echo '20b5731d268613bbf6e977dbb192a3a3b7b78d954c35edbfca4fb36b652e24f7  ghc-7.8.4-x86_64-unknown-linux-deb7.tar.bz2' | sha256sum -c - \
 && tar --strip-components=1 -xjvf ghc-7.8.4-x86_64-unknown-linux-deb7.tar.bz2 \
 && rm ghc-7.8.4-x86_64-unknown-linux-deb7.tar.bz2 \
 && ./configure \
 && make install \
 && rm -fr /usr/src/ghc \
 && rm -fr /root/tmp/ghc784 \
 && cd /root/tmp/ghc7103 \
 && wget http://downloads.haskell.org/~ghc/7.10.3/ghc-7.10.3a-src.tar.bz2 \
 && echo '877899988b64d13a86148f4db29b26d5adddef9207f718b726dc5c202d8efd8e  ghc-7.10.3a-src.tar.bz2' | sha256sum -c - \
 && tar --strip-components=1 -xjvf ghc-7.10.3a-src.tar.bz2 \
 && rm ghc-7.10.3a-src.tar.bz2 \
 && cp mk/build.mk.sample mk/build.mk \
 && ./boot \
 && ./configure \
 && make \
 && make install \
 && rm -fr /usr/src/ghc \
 && rm -rf /usr/local/lib/ghc-7.8.4 \
 && rm /usr/local/bin/ghc-7.8.4 \
       /usr/local/bin/ghci-7.8.4 \
       /usr/local/bin/ghc-pkg-7.8.4 \
       /usr/local/bin/haddock-ghc-7.8.4 \
       /usr/local/bin/runghc-7.8.4 \
 && rm -fr /root/tmp/* \
 && rm -fr /tmp/*

WORKDIR /root

RUN ghc --version

CMD ["ghci"]


# <thomie> Geraldus: don't select BuildFlavour=devel2 for release builds
#
# <thomie> Geraldus: these are release settings:
# https://ghc.haskell.org/trac/ghc/wiki/MakingReleases?version=40#Makingthebinarybuilds
#
# <thomie> Geraldus: either rebuild with `BUILD_PROF_LIBS = YES` in your
# mk/build.mk file, or install from here
# https://launchpad.net/~hvr/+archive/ubuntu/ghc, or turn off profiling in
# your .cabal/config file
#
# <thomie> Geraldus: sorry, not sure if that option exists in ghc-7.10 actually
#
# <thomie> Geraldus: oh, it should be the default, GhcLibWays += p in
# mk/config.mk, so I don't know what's wrong with your build
