# Vagrant Devstack Environment w/Proxy support

This environments creates a devstack environment.
Also if you are behind a proxy this environment adds the proper modules to get and configure the environment behind it 

If you are not behind a proxy just leave the variables as nil

http://devstack.org/

The devstack install process is kicked into the background.  The standard output of the install is redirected to /opt/stack/logs/stack.sh.log and /tmp/devstack-install.log 

You can change the branch to use to build the environment in: puppet/modules/devstack/manifests/nodes.pp 
Ddefault is **master**


## Instructions
### Get the code and prepare the environment
    $ git clone --recursive https://github.com/patux/mydevstack.git
    $ cd mydevstack

**NOTE** If you are behind a proxy create common.yaml and modify to fit your needs

    $ cp etc/common-sample.yaml etc/common.yaml  
    $ vi etc/common.yaml

### Launch the environment

    $ vagrant up 

### Base environment

    $ git checkout master

Enabled services:
  * nova
  * glance
  * neutron
  * cinder
  * keystone
  * horizon
  * tempest

### Complex environment

You will need 8GB at least for your devstack environment

    $ git checkout complex

Enabled services:
  * nova
  * glance
  * neutron
  * cinder
  * keystone
  * horizon
  * tempest
  * swift
  * lbaas
  * fwass
  * vpnaas
  * gre tunnels
  * ceilometer
  * trove

## Contribute for Openstack

https://wiki.openstack.org/wiki/How_To_Contribute


## Gerrit Workflow 

https://wiki.openstack.org/wiki/Gerrit_Workflow


