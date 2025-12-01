# galfit_docker

# Example build command

docker build --platform=linux/amd64 -t robertdstein/galfit .

# Example command for a mac

docker run -it --rm -e DISPLAY=host.docker.internal:0 -v ~/Data/galfit:/mydata robertdstein/galfit /bin/bash