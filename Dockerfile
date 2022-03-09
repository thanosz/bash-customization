FROM ubuntu:20.04 AS build

ENV FZF_VERSION 0.27.2
ENV FZF fzf-$FZF_VERSION-linux_amd64.tar.gz
RUN mkdir /work /bash-customization
WORKDIR /work

RUN apt update 
RUN apt -y install xz-utils git make gawk

RUN git clone --depth=1 https://github.com/Bash-it/bash-it.git /bash-customization/bash-it
RUN git clone --recursive https://github.com/akinomyoga/ble.sh.git
RUN make -C ble.sh install PREFIX=/bash-customization && \
     mv /bash-customization/share/blesh /bash-customization/ble.sh && \
     rm -r /bash-customization/share
ADD fzf /bash-customization/fzf
RUN cd /bash-customization/fzf && ln -sf . shell
ADD https://github.com/junegunn/fzf/releases/download/$FZF_VERSION/$FZF /work
RUN tar -xf $FZF && \
     mkdir /bash-customization/fzf/bin && \
     mv fzf /bash-customization/fzf/bin   
ADD .bashrc .shellvars .tmux.conf /bash-customization
RUN ln -sf /bash-customization /usr/local/share/bash-customization
RUN cd /bash-customization/bash-it && ./install.sh -s 
RUN chmod 777 /bash-customization/bash-it/enabled /bash-customization/bash-it
RUN cd / && tar -cvzf /bash-customization.tar.gz /bash-customization

FROM alpine:3.13.5
COPY --from=build /bash-customization /bash-customization
COPY --from=build /bash-customization.tar.gz /
