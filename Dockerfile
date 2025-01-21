# Creating Dockerfile from base image
# of ROS 2 Jazzy on Ubuntu Noble
FROM ros:jazzy-ros-core-noble

# Install tools and packages
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

# Bootstrap rosdep
RUN rosdep init && \
  rosdep update --rosdistro $ROS_DISTRO

# Setup colcon mixin and metadata
RUN colcon mixin add default \
      https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml && \
    colcon mixin update && \
    colcon metadata add default \
      https://raw.githubusercontent.com/colcon/colcon-metadata-repository/master/index.yaml && \
    colcon metadata update

# Install ROS2 packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-jazzy-ros-base=0.11.0-1* \
    && rm -rf /var/lib/apt/lists/*

# Install Gazebo Harmonic
RUN curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
  gz-harmonic \
  ros-${ROS_DISTRO}-ros-gz

# Setup Workspace Structure
WORKDIR /root/create3_ws/
RUN mkdir -p src

# Clone Repos
WORKDIR /root/create3_ws/src
RUN git clone https://github.com/iRobotEducation/create3_sim.git 
RUN git clone https://github.com/iRobotEducation/irobot_create_msgs.git 
# RUN git clone https://github.com/iRobotEducation/create3_examples.git --branch jazzy


# Install from rosdep
WORKDIR /root/create3_ws
RUN rosdep install --from-path src -yi

# Source ROS 2
RUN /bin/bash -c "source /opt/ros/jazzy/setup.bash"

# Copy the entrypoint script into the container
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default command
CMD ["bash"]



