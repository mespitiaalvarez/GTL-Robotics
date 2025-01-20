# This is an auto generated Dockerfile for ros:ros-base
# generated from docker_images_ros2/create_ros_image.Dockerfile.em
FROM ros:jazzy-ros-core-noble

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    python3-colcon-common-extensions \
    python3-colcon-mixin \
    python3-rosdep \
    python3-vcstool \
    curl \
    lsb-release \
    gnupg \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

# bootstrap rosdep
RUN rosdep init && \
  rosdep update --rosdistro $ROS_DISTRO

# setup colcon mixin and metadata
RUN colcon mixin add default \
      https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml && \
    colcon mixin update && \
    colcon metadata add default \
      https://raw.githubusercontent.com/colcon/colcon-metadata-repository/master/index.yaml && \
    colcon metadata update

# install ros2 packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-jazzy-ros-base=0.11.0-1* \
    && rm -rf /var/lib/apt/lists/*

# Get Gazebo Harmonic
RUN curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
  gz-harmonic \
  ros-${ROS_DISTRO}-ros-gz

# Setup Workspace
WORKDIR /root/create3_ws/
RUN mkdir -p src

# Clone Repos
WORKDIR /root/create3_ws/src
RUN git clone https://github.com/iRobotEducation/create3_sim.git 
RUN git clone https://github.com/iRobotEducation/irobot_create_msgs.git 

# Source ROS 2
RUN /bin/bash -c "source /opt/ros/jazzy/setup.bash"

# Rosdep
WORKDIR /root/create3_ws
RUN rosdep install --from-path src -yi


