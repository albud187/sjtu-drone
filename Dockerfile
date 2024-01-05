FROM osrf/ros:humble-desktop

RUN apt-get update \
    && apt-get install -y \
    wget curl unzip \
    lsb-release \
    mesa-utils \
    build-essential \
    && apt-get clean

# Get gazebo binaries
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list \
    && wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add - \
    && apt-get update \
    && apt-get install -y \
    gazebo \
    ros-${ROS_DISTRO}-gazebo-ros-pkgs \
    python3-colcon-common-extensions python3-rosdep --no-install-recommends \
    && apt-get clean
#RUN rosdep init && rosdep update

RUN curl -L https://github.com/osrf/gazebo_models/archive/refs/heads/master.zip -o /tmp/gazebo_models.zip \
    && unzip /tmp/gazebo_models.zip -d /tmp && mkdir -p ~/.gazebo/models/ && mv /tmp/gazebo_models-master/* ~/.gazebo/models/ \
    && rm -r /tmp/gazebo_models.zip


RUN mkdir -p /ros2_ws/src
COPY ./sjtu_drone_description /ros2_ws/src/sjtu_drone_description
COPY ./sjtu_drone_bringup /ros2_ws/src/sjtu_drone_bringup
COPY ./sjtu_drone_control /ros2_ws/src/sjtu_drone_control

#RUN apt-get install ros-humble-tf-transformations

WORKDIR /ros2_ws
RUN /bin/bash -c 'cd /ros2_ws/ \
    && source /opt/ros/${ROS_DISTRO}/setup.bash \
    && rosdep install --from-paths src --ignore-src -r -y \
    && colcon build'

#CMD ["/bin/bash", "-c", "source /opt/ros/${ROS_DISTRO}/setup.bash && source /ros2_ws/install/setup.bash && ros2 launch sjtu_drone_bringup sjtu_drone_bringup_empty_world.launch.py"]
CMD ["/bin/bash", "-c", "source /opt/ros/${ROS_DISTRO}/setup.bash && source /ros2_ws/install/setup.bash && ros2 launch sjtu_drone_bringup sjtu_drone_2x_bringup_empty_world.launch.py"]
#CMD ["/bin/bash", "-c", "source /opt/ros/${ROS_DISTRO}/setup.bash && source /ros2_ws/install/setup.bash"]

# FROM osrf/ros:humble-desktop

# RUN apt update
# RUN apt install nano

# #install stuff
# RUN apt-get update \
#     && apt-get install -y \
#     wget curl unzip \
#     lsb-release \
#     mesa-utils \
#     build-essential \
#     && apt-get clean

# # Install Gazebo
# RUN apt-get update && apt-get install -y \
#     ros-humble-gazebo-ros-pkgs

# RUN curl -L https://github.com/osrf/gazebo_models/archive/refs/heads/master.zip -o /tmp/gazebo_models.zip \
#     && unzip /tmp/gazebo_models.zip -d /tmp && mkdir -p ~/.gazebo/models/ && mv /tmp/gazebo_models-master/* ~/.gazebo/models/ \
#     && rm -r /tmp/gazebo_models.zip

# RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list \
#     && wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add - \
#     && apt-get update \
#     && apt-get install -y \
#     gazebo \
#     ros-${ROS_DISTRO}-gazebo-ros-pkgs \
#     python3-colcon-common-extensions python3-rosdep --no-install-recommends \
#     && apt-get clean

# #RUN /bin/bash -c '. /opt/ros/humble/setup.bash; cd /robots_ws; colcon build --symlink-install'

# # RUN /bin/bash -c 'cd /robots_ws/ \
# #     && source /opt/ros/humble/setup.bash \
# #     && rosdep install --from-paths src --ignore-src -r -y \
# #     && colcon build'

# ENTRYPOINT ["/bin/bash", "-c", "source /opt/ros/humble/setup.bash"]
# # RUN mkdir -p /sjtu_ws/src
# # WORKDIR /sjtu_ws

# # Clean up
# RUN rm -rf /var/lib/apt/lists/*