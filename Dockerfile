FROM ros:humble

# Install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    python3-pip \
    libeigen3-dev \
    && rm -rf /var/lib/apt/lists/*

# Create a workspace directory and set permissions
WORKDIR /ros2_ws
RUN mkdir -p /ros2_ws/src && \
    chown -R ros:ros /ros2_ws

# Add any additional ROS2 packages you might need
RUN apt-get update && apt-get install -y \
    ros-humble-rqt* \
    ros-humble-rviz2 \
    python3-rosdep \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-vcstool \
    python3-colcon-common-extensions \
    && rm -rf /var/lib/apt/lists/*

# Fix for rosdep issues
RUN apt-get update && apt-get install -y \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -s /bin/bash ros
RUN echo "ros ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ros
RUN chmod 0440 /etc/sudoers.d/ros

# Switch to the non-root user
USER ros

# Setup rosdep
RUN rosdep init || echo "rosdep already initialized"
RUN rosdep update

# Source ROS2 environment for the non-root user
RUN echo "source /opt/ros/humble/setup.bash" >> /home/ros/.bashrc

# Helper commands
RUN echo "eval '$(register-python-argcomplete3 ros2)' " >> /home/ros/.bashrc
RUN echo "eval '$(register-python-argcomplete3 colcon)' " >> /home/ros/.bashrc
RUN echo "source /usr/share/colcon_cd/function/colcon_cd.sh " >> /home/ros/.bashrc
RUN echo "source /usr/share/colcon_cd/function/colcon_cd-argcomplete.bash" >> /home/ros/.bashrc
RUN echo "export _colcon_cd_root=/opt/ros/humble/" >> /home/ros/.bashrc

# Keep container running
CMD ["bash"] 