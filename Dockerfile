FROM osrf/ros:humble-desktop-full
ARG ROS_DISTR=humble

ENV DEBIAN_FRONTEND=noninteractive
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics
ARG USERNAME=ros-user
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ENV ROS_DISTR=$ROS_DISTR

RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    && apt-get install -y \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    mesa-utils \
    mesa-utils-extra \
    python3-pip \
    avahi-daemon \
    avahi-utils \
    libnss-mdns \
    iputils-ping \
    sudo \
    vim \
    wget \
    xmlstarlet \
    ros-${ROS_DISTR}-rqt-tf-tree \
    ros-${ROS_DISTR}-apriltag \
    && pip3 install yapf \
    rope \
    flake8 \
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
RUN echo "source /opt/ros/$ROS_DISTR/setup.bash" >> /home/$USERNAME/.bashrc
USER ${USERNAME}
ENV TERM xterm-256color
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)" -- \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p git \
    -t "" \
    -a 'fpath+=$HOME/.zsh/pure' \
    -a 'autoload -U promptinit; promptinit' \
    -a 'prompt pure' \
    -a "zstyle ':prompt:pure:host' color 119" \
    -a "ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=161'" \
    -a 'export TERM=xterm-256color' \
    -a 'PATH=$PATH:$HOME/.local/bin' \
    -a 'export HISTFILE=/zsh_history/.zsh_history' \
    && mkdir -p "$HOME/.zsh" \
    && git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure" \
    && echo "source /opt/ros/$ROS_DISTR/setup.zsh" >> /home/$USERNAME/.zshrc \
    && echo 'source $HOME/uuv/ros2/install/local_setup.zsh' >> /home/$USERNAME/.zshrc \
    && echo 'eval "$(register-python-argcomplete3 ros2)"' >> /home/$USERNAME/.zshrc \
    && echo 'eval "$(register-python-argcomplete3 colcon)"' >> /home/$USERNAME/.zshrc
USER root
RUN mkdir /zsh_history \
    && touch /zsh_history/.zsh_history \
    && chown -R $USERNAME /zsh_history
USER ${USERNAME}

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
CMD [ "zsh"]

