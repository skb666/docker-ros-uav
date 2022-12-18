FROM skb666/ubuntu-desktop-lxde-vnc:focal

RUN sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list \
    && sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && sed -i 's/http:/https:/g' /etc/apt/sources.list

RUN sh -c 'echo "deb [signed-by=/usr/share/keyrings/ros.gpg] https://mirrors.ustc.edu.cn/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
    && gpg --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 \
    && gpg --export C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 | tee /usr/share/keyrings/ros.gpg > /dev/null

RUN apt update \
    && apt install -y ros-noetic-desktop-full ros-noetic-mavros ros-noetic-mavros-extras\
    && sh -c 'echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc' \
    && apt autoremove \
    && apt autoclean \
    && rm -rf /var/lib/apt/lists/*

RUN apt update \
    && apt install -y \
        python3-rosdep python3-vcstools \
        python3-rosinstall python3-rosinstall-generator python3-wstool \
        build-essential pkg-config cmake curl wget zip unzip tar \
    && apt autoremove \
    && apt autoclean \
    && rm -rf /var/lib/apt/lists/*

RUN rosdep init && rosdep fix-permissions && rosdep update

RUN wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh -O - | bash

RUN mkdir -p /root/catkin_ws/src
WORKDIR /root/catkin_ws

COPY rootfs /

ENTRYPOINT ["/startup.sh"]
