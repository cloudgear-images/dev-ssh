# Development SSH Image

This image can be used as an SSH endpoint to create reversed SSH tunnels to allow Docker container apps to access endpoints outside of their Docker host, e.g. an application running on an OSX machine in development environment.

For details how to use this image, read our blog post on CloudGear.net.

## Run SSH Container

Pass your SSH public key as env variable. The pubic key is added to the user root.

    docker run -d \
      -p 2200:22 \
      --name ssh-tunnel \
      -e SSH_PUBKEY="ssh-rsa AAAA....jzsAN9D" \
      cloudgear/dev-ssh:1.0.0

## Setup Reverese Tunnel

On the machine which should be reachable from other Docker containers, initiate a reverse SSH tunnel:

    ssh -N -R 80:localhost:3000 root@docker-host -p 2200

The option `-R` sets up the reverse tunnel and the parameter `80:localhost:3000` defines the port mapping. The first number defines the port on the SSH container, e.g. in the example port 80. The `localhost:3000` part defines the host and port which can be reached through the tunnel, in this case a Rails application running on an OSX machine.

## Link the SSH Container

On the Docker host, the SSH Container can now be linked to another container which will gain access to it by using the alias name as host and the configured port, in the example port 80.

    docker run -it --link ssh-tunnel:demo ubuntu:latest
    $ curl demo:80

Curl must be installed first when using the Ubuntu image but you get the idea.

With this concept you can connect an application inside a container to any apps outside of the host. This can be used for example when the containerized application needs to connect to an API for sending callbacks.
