# [Choice] Ubuntu version (use jammy on local arm64/Apple Silicon): jammy, focal
ARG VARIANT
FROM buildpack-deps:${VARIANT}-curl

# ARG VARIANT
ARG SCHEME
LABEL dev.containers.features="common"
ENV LANG C.UTF-8

# install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends wget libfontconfig git make libfile-fcntllock-perl

# TeXLive
WORKDIR /tmp
RUN wget --no-check-certificate https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
    && zcat < install-tl-unx.tar.gz | tar -xf - \
    && export TLDIR=$( ls -d install-tl-2* ) \
    && perl "./${TLDIR}/install-tl" -scheme="scheme-${SCHEME}" --no-interaction

RUN YEAR=$(ls -d /usr/local/texlive/2* | sed -e 's/.*[/]//g') \
    && echo MANPATH=/usr/local/texlive/$YEAR/texmf-dist/doc/man:$MANPATH >> ~/.profile \
    && echo INFOPATH=/usr/local/texlive/$YEAR/texmf-dist/doc/info:$INFOPATH >> ~/.profile \
    && echo PATH=/usr/local/texlive/$YEAR/bin/x86_64-linux:$PATH >> ~/.profile \
    && . ~/.profile
