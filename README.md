# docker-ros-uav

## 运行

```bash
docker run -itd \
    --restart unless-stopped \
    --name=ros \
    -v /dev/shm:/dev/shm \
    -v `pwd`/quarotor_feedback_controller:/root/catkin_ws/src/test \
    -p 6080:80 \
    -p 6022:22 \
    --user root \
    --hostname melodic \
    -e PASSWORD=<password for root> \
    skb666/ros-uav:melodic
```
