# GTL-Robotics-Simulation
This repo contains the instructions for setting up and using a Docker container for simulating the iRobot Create3 Robot in ROS2 Jazzy on Ubuntu Noble.

# Requirements
This environment is created for a class taught as part of MIT's Global Teaching Labs Program. Students have access to laptops running Windows 11/10. There is no accommodation for systems running Linux or MacOS, but you can adapt the repo to your liking.

# Set-up
1. Download Docker Desktop for Windows: https://docs.docker.com/desktop/setup/install/windows-install/. OPEN DOCKER DESKTOP BEFORE BUILDING ANYTHING
2. Download Git for Windows from here: https://git-scm.com/downloads/win
3. Download VcXsrv, a free and open source X server for Windows (Needed for visualizing GUI from container): https://sourceforge.net/projects/vcxsrv/
4. Open a terminal (PowerShell). If you have never used a terminal before... lock-in.
5. Assuming you are not in the home directory, use:
```powershell 
cd ~
```
6. Get a copy of this repo by running:  
```powershell
git clone https://github.com/mespitiaalvarez/GTL-Robotics-Simulation.git
```
7. Navigate inside the repo
```powershell
cd ~/GTL-Robotics-Simulation
```

8. Use the following command to check your IP address:
```powershell
ipconfig
```

9. Edit the entrypoint.sh so that the line:
```powershell
export DISPLAY="${HOST_IP:-host.docker.internal}:0.0
```
is replaced with 
```powershell
export DISPLAY={YOUR IP}
```

10. Run:
```powershell
docker compose up --build
```

Then in another terminal tab

```powershell
docker exec -it create3_container /bin/bash
```

11. Create an X server using XLaunch and make sure it has disabled, disable remote access

12. In the container run:
```bash
source /opt/ros/jazzy/setup.bash
colcon build --symlink-install
```

13. Once built, test with:
```bash
ros2 launch irobot_create_gz_bringup create3_gz.launch.py
```