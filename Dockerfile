FROM ros:humble

# Install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    python3-pip \
    libeigen3-dev \
    && rm -rf /var/lib/apt/lists/*

# Create a workspace directory
WORKDIR /ros2_ws

# Create source directory for labs
RUN mkdir -p /ros2_ws/src

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

# Source ROS2 environment in bashrc
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

# Helper commands
RUN echo "eval "$(register-python-argcomplete3 ros2)" " >> /root/.bashrc
RUN echo "eval "$(register-python-argcomplete3 colcon)"" >> /root/.bashrc
RUN echo "source /usr/share/colcon_cd/function/colcon_cd.sh " >> /root/.bashrc
RUN echo "source /usr/share/colcon_cd/function/colcon_cd-argcomplete.bash" >> /root/.bashrc
RUN echo "export _colcon_cd_root=/opt/ros/humble/" >> /root/.bashrc

RUN rosdep init
RUN rosdep update

# Keep container running
CMD ["bash"] 