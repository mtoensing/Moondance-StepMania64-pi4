#!/bin/bash
# Moondance StepMania64 installation script by Marc Tönsing

echo "Moondance StepMania64 installation script V1.0"
echo "Latest version is always at https://github.com/mtoensing/Moondance-StepMania64-pi4"

cd

if [ -d "Stepmania64" ]; then
  echo "Directory Stepmania64 already exists!  Exiting... "
  exit 1
fi

if [ -d ".stepmania-5.3" ]; then
  echo "Hidden directory .stepmania-5.3 already exists!  Exiting... "
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

echo "Copying StepMania files..."
cp -r Moondance-StepMania64-pi4/pi/.stepmania-5.3/ /home/pi/
cp -r Moondance-StepMania64-pi4/pi/StepMania64/ /home/pi/
cp Moondance-StepMania64-pi4/pi/StepMania64.desktop /home/pi/Desktop/
echo "Copying StepMania to autostart"
cp Moondance-StepMania64-pi4/pi/StepMania64.desktop /home/pi/.config/autostart/

chmod +x ~/StepMania64/stepmania

./stepmania
