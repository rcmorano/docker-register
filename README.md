This is forked from jwilder/docker-register but modified to working with [Vulcan][vulcan].

docker-register sets up a container running [docker-gen][docker-gen].  docker-gen dynamically generate a
python script when containers are started and stopped.  This generated script registers the running
containers host IP and port in etcd with a TTL.  It works in tandem with [vulcand][vulcan] which
is a dynamic and easilly expandable HTTP reverse proxy.

### Usage

First, you should have an etcd server. If not, you can launch an etcd server like this:

    $ docker run --name etcd -p 4001:4001 -p 7001:7001 -d coreos/etcd

Then you can launch the docker registration container:

    $ docker run -d \
      --name docker-registar \
      -e HOST_IP=172.17.42.1 \
      -e ETCD_HOST=172.17.42.1:4001 \
      -e KEY_PREFIX=/vulcand \
      -v /var/run/docker.sock:/var/run/docker.sock \
      ncarlier/docker-register

**HOST_IP** should refer the public IP of the docker host.

**ETCD_HOST** sould refer the public IP and PORT of etcd host.

**KEY_PREFIX** is the prefix used inside etcd. If you want to use vulcan you have to setup "/vulcand".

Then start any containers you want to be discoverable by adding the DOMAIN_NAME variable.

    $ docker run -d -P -e DOMAIN_NAME=foo.bar.com ...

If you want to use this discovery tool inside a cluster like CoreOS you have to
use '-P' to expose the container port on the public IP of the CorOS node.

If you run the container on multiple hosts, they will be grouped together automatically by Vuclan.
Don't forget to use the parameter "-P" to expose ports on the host interface.

[vulcan]: http://www.vulcanproxy.com
[docker-gen]: https://github.com/jwilder/docker-gen
