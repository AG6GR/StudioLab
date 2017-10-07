# Vicon Motion Capture

The performance area of the StudioLab is set up with a [Vicon Motion Capture](https://www.vicon.com/) system. Here are some tips and hints for setting the system up and using it for fun things.

## System components
The motion capture system is made up of these major components:
* Cameras: These are the square cameras with screens mounted around the capture area.
* Network switch: This is the black box in the corner by the PC's.
* PC: The PC in the corner is set up with the Vicon software for configuring the system. The Dell box across the table from it has some tools for working with Motion Capture data, such as Blender and Matlab.
* Calibration wand: This is a black T-shaped wand on the same table as the computers.
* Tracking objects: Things you want to track, labeled with silver reflective markers.

# Getting Started
## Turning on the system
The network switch is usually turned off. To begin, flip the small rocker switch on the front side facing the PC's. You should hear its fan turn on and see some blinking lights. At this point, the motion capture cameras should also activate and display their individual ID numbers.

## Calibration
Log on to the control PC using the OEM account. The open the Vicon Tracker software.

On the calibration tab, there is an option to select Load and load an existing calibration profile. If you have time, it is better to create a fresh calibration. Turn on the calibration wand LED's by flipping the small white switch at the center of the crossbar. Red LED's should light up. Then hit the 'Start Calibration' button on the calibrationt tab. You should see the views of all the active cameras pop up on the main screen. If there are any missing cameras or cameras with excessive noise, you can enable and disable them from the Cameras tab. 

Once that is looking good, go to the capture area and start waving the wand around in big circles. This gives the cameras data to start figuring out where they are around the room. As they get more data, a circle displayed on their screens should start filling up. I'm not sure if there's a "correct" technique to waving the wand, but doing a motion like alternating forehand and backhand tenis swings with the red LED's facing the cameras works well. Once a camera has received enough data, its LED's should turn green. Once all the cameras have been calibrated, the Tracker software will automatically switch to tracking mode.

Before recording data, it is a good idea to reset the coordinate system. Place the wand flat on the black X on the center of the capture area floor. Hit the set origin button under the calibration tab and click on the white dots representing the wand's tracking dots. You should see the cameras flip around to the correct orientations.
