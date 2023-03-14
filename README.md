# Desktop Entries

Run `desktop/install.sh` to create the desktop entries for the current user. The desktop entries assume the container name `ros2`.

# Container Name

Per default root base directory name + `_devcontainer` will be the stack name that gets prepended to docker volumes.

The container name can be specified in `docker_compose.yaml` and is `ros2`.

# Run a command inside the container

~~~
docker exec -it ros2 <COMMAND>
~~~
