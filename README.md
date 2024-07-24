# sjtu_drone


# Requirements

This package is tested with ROS 2 (Ubuntu 22.04) and Gazebo 11.

# Downloading and building
Clone and build container
```
git clone git@github.com:albud187/sjtu-drone.git
git checkout -b dev
cd sjtu-drone
sh dockerbuild.sh
```

build the package
```
sh dockerrun.sh
apt update
source /opt/ros/humble/setup.bash
rosdep install --from-paths src --ignore-src -r -y
colcon build
```

## Drone Topics

### Sensors
The folowing sensors are currently implemented:
- ~/front_camera/image_raw [__sensor_msgs/msg/Image__]
- ~/bottom/image_raw [__sensor_msgs/msg/Image__]
- ~/sonar [__sensor_msgs/msg/Range__]
- ~/imu [__sensor_msgs/msg/Imu__]


### Control 
The following control topics are currently subscribed to:
- ~/cmd_vel [__geometry_msgs/msg/Twist__]: Steers the drone
- ~/land [__std_msgs/msg/Empty__]: Lands the drone
- ~/takeoff [__std_msgs/msg/Empty__]: Starts the drone
- ~/posctrl [__std_msgs/msg/Bool__]: Switch to position control
- ~/dronevel_mode [__std_msgs/msg/Bool__]: Change the drone steering method
- ~/reset [__std_msgs/msg/Empty__]: Resets the drone

### Ground Truth
The following ground truth topics are currently published:
- ~/gt_acc [__geometry_msgs/msg/Twist__]: ground truth acceleration
- ~/gt_pose [__geometry_msgs/msg/Pose__]: ground truth pose
- ~/gt_vel [__geometry_msgs/msg/Twist__]: ground truth velocity


# Run


# PID Params

The parameters of the PID controller that controls the drone and the motion noise can be changed by adapting the file [sjtu_drone.urdf.xacro](sjtu_drone_description/urdf/sjtu_drone.urdf.xacro#L51-L80):

```xml
<plugin name='simple_drone' filename='libplugin_drone.so'>
    <bodyName>base_link</bodyName>
    <rosNamespace>drone</rosNamespace>
    <imuTopic>imu</imuTopic>
    <rollpitchProportionalGain>10.0</rollpitchProportionalGain>
    <rollpitchDifferentialGain>5.0</rollpitchDifferentialGain>
    <rollpitchLimit>0.5</rollpitchLimit>
    <yawProportionalGain>2.0</yawProportionalGain>
    <yawDifferentialGain>1.0</yawDifferentialGain>
    <yawLimit>1.5</yawLimit>
    <velocityXYProportionalGain>5.0</velocityXYProportionalGain>
    <velocityXYDifferentialGain>2.3</velocityXYDifferentialGain>
    <velocityXYLimit>2</velocityXYLimit>
    <velocityZProportionalGain>5.0</velocityZProportionalGain>
    <velocityZIntegralGain>0.0</velocityZIntegralGain>
    <velocityZDifferentialGain>1.0</velocityZDifferentialGain>
    <velocityZLimit>-1</velocityZLimit>
    <positionXYProportionalGain>1.1</positionXYProportionalGain>
    <positionXYDifferentialGain>0.0</positionXYDifferentialGain>
    <positionXYIntegralGain>0.0</positionXYIntegralGain>
    <positionXYLimit>5</positionXYLimit>
    <positionZProportionalGain>1.0</positionZProportionalGain>
    <positionZDifferentialGain>0.2</positionZDifferentialGain>
    <positionZIntegralGain>0.0</positionZIntegralGain>
    <positionZLimit>-1</positionZLimit>
    <maxForce>30</maxForce>
    <motionSmallNoise>0.05</motionSmallNoise>
    <motionDriftNoise>0.03</motionDriftNoise>
    <motionDriftNoiseTime>5.0</motionDriftNoiseTime>
</plugin>
```

# Known Issues
* No ROS communication between docker container and host
* Change of ROS namespace not working automatically for plugin_drone when changed in [spawn_drone.py](./sjtu_drone_bringup/sjtu_drone_bringup/spawn_drone.py)
    * TODO: Change to gazebo_ros::Node::SharedPtr
