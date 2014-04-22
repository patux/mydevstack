# Vagrant Devstack Environment w/Proxy support

This environments creates a devstack environment.
Also if you are behind a proxy this environment adds the proper modules to get and configure the environment behind it 

http://devstack.org/

**IMPORTANT NOTES**

  * Once puppet finishes, **The devstack install process is kicked into the background**. You still have to wait for devstack to finish. Instlaler Logs  **/opt/stack/logs/stack.sh.log** and **/tmp/devstack-install.log**
  * Use etc/common-sample.yaml as a guide to create etc/common.yaml to build your environment
  * If you are not behind a proxy do not set them in the yaml file
  * Devstack credentials: admin/password and demo/password

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

Add devstack_setup: complex to etc/common.yaml

    $ vi etc/common.yaml 
    devstack_setup: complex 

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


