FROM buildpack-deps:jessie-scm

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential \
      g++ \
      libmysql++-dev \
      libbz2-dev \
      libgmp3-dev \
      libboost-all-dev \
 && rm -rf /var/lib/apt/lists/*

ARG BUILDDIR=/srv/build
ARG INSTALLDIR=/srv/app
ARG CONFDIR=/srv/app
ARG PLUGINSDIR=/srv/app

ADD 'OHSystem/ghost/src' "$BUILDDIR"

RUN cd "$BUILDDIR/bncsutil/src/bncsutil" \
 && make -j "$(nproc)" && make install \
 && cd "$BUILDDIR/StormLib/stormlib" \
 && make -j "$(nproc)" && make install \
 && cd "$BUILDDIR" \
 && make -j "$(nproc)" \
 && mkdir -p "$INSTALLDIR" \
 && cp 'ghost++' -t "$INSTALLDIR" \
 && rm -rf "$BUILDDIR"

RUN mkdir -p "$CONFDIR" "$PLUGINSDIR"

ADD 'OHSystem/ghost/config/' "$CONFDIR/"

WORKDIR "$INSTALLDIR"
CMD "./ghost++"
