# Base OS
FROM ubuntu:latest

# Creater
# MAINTAINER EK
# LABEL maintainer="EK <hoge@sample.com>"
LABEL maintainer="EK"

# Environment Variable
ENV USER tester
ENV HOME /home/${USER}
# ENV SHELL /bin/zsh
# ENV TZ Asia/Tokyo

# Overwrite Shell Command
SHELL ["/bin/bash", "-o" , "pipefail", "-c"]
# SHELL ["/bin/zsh", "-o" , "pipefail", "-c"]

# Install sudo and needed components
# RUN apt-get update && apt-get upgrade -y --no-install-recommends
RUN apt-get update && apt-get install -y --no-install-recommends sudo zsh vim git \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Add User Account
RUN useradd -m ${USER}
RUN gpasswd -a ${USER} sudo
RUN echo "${USER}:hogehoge" | chpasswd

# Change User and Specify Working Directory After here
# USER ${USER}
WORKDIR ${HOME}

# zprezto to zsh
RUN git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
RUN setopt EXTENDED_GLOB \
  && for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do ln -s "${rcfile}" "${ZDOTDIR:-$HOME}/.${rcfile:t}"; done

## Change Login Shell (Maybe Not Mean)
RUN chsh -s /bin/zsh

# Copy setup shell script
# COPY ./setup.sh ${HOME}/

# Entry Point
ENTRYPOINT ["/bin/zsh"]