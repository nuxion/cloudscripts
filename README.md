# CloudScripts

This is a collections of different scripts used for software and server provisioning in the context of cloud, usually docker, some networking configurations and so forth. 

I used to use ansible in a push strategy approach (from client or bastion to servers), however with the introduction of different HashiCorp tools, this strategy started to be cumbersome. Instead, I would like that each server execute by their self the related scripts using environment knowledge provided by the cloud platform like Metadata server, labels & tags, in a pull strategy approach.

For the time being, this runs over GCE cloud, debian like S.O., and systemd, but it should be easy to adapt for other providers and S.O, besides some scripts are agnostics. Let me know if you are interest in other providers, or tools. 

A terraform sandbox is included for testing purposes. 

Tools used:
- Shell scripts
- Gomplate for templating

## Starting

```
curl -Ls https://raw.githubusercontent.com/nuxion/cloudscripts/main/install.sh | sh
```
or:

```
curl -Ls https://raw.githubusercontent.com/nuxion/cloudscripts/main/install.sh -o install.sh
chmod +x install.sh
sh ./install.sh
```

after installation you can use standalone scripts or the command line:
```
cscli -i nvidia-driver
```
Example:


Installations avalaible could be found in `scripts/commands` dir. 

Output example:
```
nuxion@gce-small-cpu-j0z8dr:~/cloudscripts$ sudo cscli -i nvidia-docker
=> cuda found!
=> docker found!
=> nvidia-docker2 not found!
=> nvidia-docker2 installing... be patient it will take some minutes
....
....
=> nvidia-docker2 installed!
```
Commands allow to call each other as dependencies in a simple way (but with the risk of circular dependencies, usually if a commands needs other commands the ideal will be put they as services instead of commands):

```
cat scripts/commands/nvidia-docker.sh
#!/bin/bash
# docs
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html
source $BASEDIR/commands/nvidia-driver.sh
source $BASEDIR/commands/docker.sh
...
...
```

## Inspirations
- https://www.serf.io/docs/recipes/event-handler-router.html
- https://github.com/void-linux/void-infrastructure
 




