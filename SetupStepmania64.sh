#!/bin/bash
# Moondance StepMania64 installation script by Marc Tönsing

echo "Moondance StepMania64 installation script V1.0"
echo "Latest version always at https://github.com/mtoensing/Moondance-StepMania64-pi4"

cd

if [ -d "Stepmania64" ]; then
  echo "Directory Stepmania64 already exists!  Exiting... "
  exit 1
fi

echo "Updating packages..."
sudo apt-get update
sudo apt-get upgrade

echo "Installing git..."
sudo apt-get install git

echo "Installing latest libopengl0..."
sudo apt install libopengl0

echo "Cloning repository"
git clone https://github.com/mtoensing/Moondance-StepMania64-pi4.git
