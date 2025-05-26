FROM ubuntu:20.04 AS build
ARG TARGETARCH
ARG TARGETVARIANT

ENV FZF_VERSION=0.62.0
ENV FZF=fzf-$FZF_VERSION-linux_${TARGETARCH}${TARGETVARIANT}.tar.gz
ENV KUBECTX=kubectx_v0.9.5_linux_${TARGETARCH}${TARGETVARIANT}.tar.gz
RUN mkdir /work /bash-customization
WORKDIR /work

RUN apt update 
RUN apt -y install xz-utils git make gawk

RUN git clone --depth=1 https://github.com/Bash-it/bash-it.git /bash-customization/bash-it
RUN git clone --recursive https://github.com/akinomyoga/ble.sh.git
RUN make -C ble.sh install PREFIX=/bash-customization && \
     mv /bash-customization/share/blesh /bash-customization/ble.sh && \
     rm -r /bash-customization/share

RUN git clone --depth=1 https://github.com/junegunn/fzf.git
RUN mkdir /bash-customization/fzf && cp fzf/shell/* /bash-customization/fzf && rm -rvf fzf
#ADD fzf /bash-customization/fzf
RUN cd /bash-customization/fzf && ln -sf . shell
ADD https://github.com/junegunn/fzf/releases/download/v$FZF_VERSION/$FZF .
#ADD https://github.com/ahmetb/kubectx/releases/download/v0.9.5/kubectx_v0.9.5_linux_${TARGETARCH}${TARGETVARIANT}.tar.gz $WORKDIR

RUN tar -xf $FZF && \
     mkdir /bash-customization/bin && \
     mv fzf /bash-customization/bin 

#RUN tar -xf kubectx_v0.9.5_linux_${TARGETARCH}${TARGETVARIANT}.tar.gz -C /bash-customization/bin kubectx

#ADD .bashrc .shellvars .tmux.conf /bash-customization/
ADD .bashrc .tmux.conf /bash-customization/

RUN ln -sf /bash-customization /usr/local/share/bash-customization
RUN cd /bash-customization/bash-it && ./install.sh -s 
RUN chmod 777 /bash-customization/bash-it/enabled /bash-customization/bash-it
RUN cd / && tar -cvzf /bash-customization.tar.gz /bash-customization



FROM alpine:3.18.4
COPY --from=build /bash-customization /bash-customization
COPY --from=build /bash-customization.tar.gz /
