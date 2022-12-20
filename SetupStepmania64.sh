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

if [ -d "Moondance-StepMania64-pi4" ]; then
  echo "Directory Moondance-StepMania64-pi4 already exists!  Exiting... "
  exit 1
fi

echo "Updating packages..."
sudo apt-get update
sudo apt-get -y upgrade

echo "Installing git..."
sudo apt-get install git

echo "Installing latest libopengl0..."
sudo apt-get install libopengl0

echo "Installing latest mesa packages..."
sudo apt-get install libglu1-mesa

echo "Cloning repository"
git clone https://github.com/mtoensing/Moondance-StepMania64-pi4.git

echo "Copying StepMania files..."
cp -r /home/pi/Moondance-StepMania64-pi4/pi/.stepmania-5.3 /home/pi/
cp -r /home/pi/Moondance-StepMania64-pi4/pi/Stepmania64/ /home/pi/
cp /home/pi/Moondance-StepMania64-pi4/pi/StepMania64.desktop /home/pi/Desktop/

echo "creating autostart folder..."
mkdir -p /home/pi/.config/autostart
echo "Copying StepMania to autostart"
cp /home/pi/Moondance-StepMania64-pi4/pi/StepMania64.desktop /home/pi/.config/autostart/

echo "Making files executable"
chmod +x /home/pi/Desktop/StepMania64.desktop
chmod +x /home/pi/.config/autostart/StepMania64.desktop
chmod +x /home/pi/Stepmania64/stepmania

gsettings set org.gnome.mutter check-alive-timeout 60000

cd /home/pi/Stepmania64

./stepmania
