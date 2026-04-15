#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

# Source the main ROS 2 Jazzy setup
source "/opt/ros/jazzy/setup.bash"

# Source the local workspace if it has been built
if [ -f "/home/ros2_dev/husky_industrial_stack/install/setup.bash" ]; then
    source "/home/ros2_dev/husky_industrial_stack/install/setup.bash"
    # Local workspace sourced successfully
fi

exec "$@"