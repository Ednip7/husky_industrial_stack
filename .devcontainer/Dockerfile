# Base Image
FROM osrf/ros:jazzy-desktop-full

# Build Arguments
ARG USERNAME=ros2_dev
ARG USER_UID=1000
ARG USER_GID=1000

# Environment Variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# System Dependencies & Repositories
RUN apt-get update && apt-get install -y \
    curl \
    lsb-release \
    gnupg \
    sudo \
    wget \
    tree \
    bash-completion \
    git \
    nano \
    build-essential \
    cmake \
    && mkdir -p -m 755 /etc/apt/keyrings \
    && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null \
    && apt-get update && apt-get install -y \
    gz-harmonic \
    ros-jazzy-ros-gz \
    gh \
    # Clearpath Unified Configuration System packages
    ros-jazzy-clearpath-common \
    ros-jazzy-clearpath-config \
    ros-jazzy-clearpath-simulator \
    ros-jazzy-clearpath-viz \
    && rm -rf /var/lib/apt/lists/*

# User Management
RUN if getent passwd $USER_UID; then userdel -f $(getent passwd $USER_UID | cut -d: -f1); fi && \
    if getent group $USER_GID; then groupdel $(getent group $USER_GID | cut -d: -f1); fi && \
    groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME && \
    echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

RUN echo "source /usr/share/bash-completion/completions/git" >> /home/$USERNAME/.bashrc && \
    echo 'eval "$(gh completion -s bash)"' >> /home/$USERNAME/.bashrc && \
    echo "source /opt/ros/jazzy/setup.bash" >> /home/$USERNAME/.bashrc

# Rosdep Initialization
RUN rm -rf /etc/ros/rosdep/sources.list.d/* && \
    rosdep init && \
    sudo -u $USERNAME rosdep update

# Entrypoint
COPY --chown=$USER_UID:$USER_GID docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Execution Context
WORKDIR /home/$USERNAME/husky_industrial_stack
USER $USERNAME
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]