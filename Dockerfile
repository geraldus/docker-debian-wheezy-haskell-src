FROM geraldus/wheezy-haskell-base:latest

MAINTAINER Geraldus <heraldhoi@gmail.com>

RUN apt-get update

# GHC itself
WORKDIR /root/tmp/sources

# Install prerequisites

WORKDIR /root/tmp/sources
RUN wget http://downloads.haskell.org/~ghc/7.8.4/ghc-7.8.4-x86_64-unknown-linux-deb7.tar.bz2 \
  && echo '20b5731d268613bbf6e977dbb192a3a3b7b78d954c35edbfca4fb36b652e24f7  ghc-7.8.4-x86_64-unknown-linux-deb7.tar.bz2' | sha256sum -c - \
  && tar --strip-components=1 -xjvf ghc-7.8.4-x86_64-unknown-linux-deb7.tar.bz2 \
  && rm ghc-7.8.4-x86_64-unknown-linux-deb7.tar.bz2 \
  && ./configure \
  && make install \
  && rm -fr /usr/src/ghc
WORKDIR /

RUN ghc --version

RUN rm -rf /root/tmp/sources/*

WORKDIR /root/tmp/sources

RUN wget http://downloads.haskell.org/~ghc/7.10.3/ghc-7.10.3a-src.tar.bz2
RUN echo '877899988b64d13a86148f4db29b26d5adddef9207f718b726dc5c202d8efd8e  ghc-7.10.3a-src.tar.bz2' | sha256sum -c -
RUN tar --strip-components=1 -xjvf ghc-7.10.3a-src.tar.bz2 \
 && rm ghc-7.10.3a-src.tar.bz2

RUN ./configure
RUN make
# RUN make fasttest
# make -r --no-print-directory -f ghc.mk phase=final fasttest
# make[1]: *** No rule to make target `fasttest'.  Stop.
# make: *** [fasttest] Error 2
# RUN make test
# Step 17 : RUN make test
#  ---> Running in 7fe04ee37aa6
# make -C testsuite/tests CLEANUP=1 OUTPUT_SUMMARY=../../testsuite_summary.txt fast
# make: *** testsuite/tests: No such file or directory.  Stop.
# make: *** [test] Error 2

RUN make install

RUN ghc --version

# # cabal-install
# WORKDIR /root/tmp

# RUN git clone https://github.com/haskell/cabal.git

# WORKDIR cabal
# RUN git checkout tags/cabal-install-v1.22.0.0
# WORKDIR cabal-install
# RUN ./bootstrap.sh

# ENV PATH /root/.cabal/bin:$PATH

# # Updating Cabal library
# RUN cabal update
# RUN cabal install Cabal-1.22.0.0 \
#  && ghc-pkg hide Cabal-1.18.1.5

# RUN cabal --version
# RUN ghc-pkg list Cabal


# RUN for pkg in `ghc-pkg --user list  --simple-output`; \
#       do ghc-pkg unregister --force $pkg; \
#     done

# Cleanup

WORKDIR /

RUN rm -rf /usr/local/lib/ghc-7.8.4
RUN rm /usr/local/bin/ghc-7.8.4 \
       /usr/local/bin/ghci-7.8.4 \
       /usr/local/bin/ghc-pkg-7.8.4 \
       /usr/local/bin/haddock-ghc-7.8.4 \
       /usr/local/bin/runghc-7.8.4

RUN rm -fr /root/tmp/*
RUN rm -fr /tmp/*

RUN rm -rf /var/lib/apt/lists/*

CMD ["ghci"]
