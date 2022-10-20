# CloudScripts

This is a collections of different scripts used for software and server provisioning in the context of cloud, usually docker, some networking configurations and so forth. 

I used to use ansible in a push strategy approach (from client or bastion to servers), however with the introduction of different [HashiCorp tools](https://terraform.io/), this strategy started to be cumbersome. Instead, I would like that each server execute by their self the related scripts using environment knowledge provided by the cloud platform like Metadata server, labels & tags, etcd servers, in a [pull strategy approach](https://www.michaelwashere.net/post/2020-03-23-config-binding/).

For the time being, this runs over GCE cloud, debian like S.O., and systemd, but it should be easy to adapt for other providers and S.O, besides some scripts are agnostics like docker installation script. Let me know if you are interest in other providers, or tools. 

A terraform sandbox is included for testing purposes. 

Tools used:
- Shell scripts
- Gomplate for templating in services
- Maybe python3 in the future using only the standard library

## Starting

```
curl -Ls https://raw.githubusercontent.com/nuxion/cloudscripts/main/install.sh | bash
```
or if you want to pin a version:

```
https://raw.githubusercontent.com/nuxion/cloudscripts/<version>/install.sh
```

Where `<version>` will match we the tags available in this repo. 

or if you want to check the install code first:

```
curl -Ls https://raw.githubusercontent.com/nuxion/cloudscripts/main/install.sh -o install.sh
chmod +x install.sh
./install.sh
```

:warning: *Note*: If you are using it in a ci/cd workflow, some system requires an `apt-get update` first. 

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

## Stability

It is being used in production for quick provisiong using packer as image builder: mostly for docker and docker-compose. 

I try to follow [semver](https://semver.org/), it's mean cscli will have a Stable API during minor versions, for now it is very simple:

```
cscli -i <pkg_name>
```

Options could be added between minor releases during **0.x.z** releases, but never a new option added, will be deleted without a mayor version change. 

Meanwhile internal structure inside `scripts/` could change, how commands are defined internally could change, but the `command` dir and the way in that "source" import other scripts as dependencies will be maintained through minor releases. 

Finally, the **install.sh** script only downloads the last tag from github and never deletes old installations (usually in /opt/cloudscripts-${VERSION} folder) but it replaces /usr/local/bin/cscli pointing to the new version installed. 

## Concepts

- **commads**: are mostly one shot installer of some dependency needed for running some service, for instance docker, a nvidia-cuda driver. A command could have dependecies between them (that is the case of nvdidia-docker which it has: nvdia-driver and docker as dependecies). This strategy resolve in a quick way the problem but could be error prone and generate circular dependecies because all of this depends on the order that others scripts are imported as sources in the header of a command definition. So, with a simple solution comes a big responsability ;) 

- **services**: ideally, more complex installations like a nginx web server that will require allso more dynamically configurations from others services, and complex initializacions like a db, should come here. They will be using gomplate to render configurations files needed based on the environment and external services like redis/etcd/consul or zookeeper. 

In the future other special folders could be added like secrets and certs. Or special hooks for user creations, dns changes, routes add and so forth, maybe those actions will be performed by a [serf agent](https://www.serf.io). 

## Customizing

I believe that the interface is very simple and easy to respect, so changes shouln't be the norm . 

Custom commands could be added inside the "scripts/commands", the only thing that they need to do is to validate if it's is installed or not, perfom the action required, verify the installation, and execute a `exit 1` if the installation failed for some reason to avoid that other scripts run.

Also all the scripts are using variables and relative paths, base path and variables can be changed in cscli, env.sh and install.sh in a forked project. 


## Inspirations
- https://www.serf.io/docs/recipes/event-handler-router.html
- https://github.com/void-linux/void-infrastructure
- https://www.funtoo.org/Bash_by_Example,_Part_3
- https://www.michaelwashere.net/post/2020-03-23-config-binding/
 




