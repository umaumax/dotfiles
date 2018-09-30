#!/usr/bin/env bash

set -e

# FYI: [kinetic/Installation/Ubuntu \- ROS Wiki]( http://wiki.ros.org/kinetic/Installation/Ubuntu )

# ubuntu16.04: kinetic
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt-get update
sudo apt-get install -y ros-kinetic-desktop-full
sudo rosdep init
rosdep update

# echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
# source ~/.bashrc
# # or
# echo "source /opt/ros/kinetic/setup.zsh" >> ~/.zshrc
# source ~/.zshrc

# NOTE: Dependencies for building packages
sudo apt-get install -y python-rosinstall python-rosinstall-generator python-wstool build-essential
