# Base OS
FROM ubuntu:18.04

# Creater
# MAINTAINER EK
# LABEL maintainer="EK <hoge@sample.com>"
LABEL maintainer="EK"

# Environment Variable
ENV USER tester
ENV HOME /home/${USER}
# ENV TZ Asia/Tokyo

# Overwrite Shell Command
SHELL ["/bin/bash", "-o" , "pipefail", "-c"]
# SHELL ["/bin/zsh", "-o" , "pipefail", "-c"]

# Install sudo and needed components
# RUN apt-get update && apt-get upgrade -y --no-install-recommends
RUN apt-get update && apt-get install -y --no-install-recommends sudo zsh vim git tmux openssh-server \
    && apt-get clean
    # && rm -rf /var/lib/apt/lists/*

# Add User Account
RUN useradd -m ${USER}
RUN gpasswd -a ${USER} sudo
RUN echo "${USER}:hogehoge" | chpasswd

# Change User and Specify Working Directory After here
WORKDIR ${HOME}

SHELL ["/bin/zsh", "-c"]

# zprezto to zsh
RUN git config --global http.sslVerify false
RUN git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
RUN setopt EXTENDED_GLOB \
    && for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do ln -s "${rcfile}" "${ZDOTDIR:-$HOME}/.${rcfile:t}"; done

## Change Login Shell (Maybe Not Mean)
RUN chsh -s /bin/zsh

# Copy setup shell script
# COPY ./setup.sh ${HOME}/

# Change User
USER ${USER}

# Entry Point
ENTRYPOINT ["/bin/zsh"]
