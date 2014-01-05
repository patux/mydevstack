# Vagrant Devstack Environment

http://devstack.org/

The devstack install process is kicked into the background.  The standard output of the install is redirected to /opt/stack/logs/stack.sh.log 

You can change the branch to use to build the environment in: puppet/modules/devstack/manifests/nodes.pp 
Ddefault is stable/grizzly


## Instructions

    $ git clone --recursive https://github.com/patux/mydevstack.git
    $ cd mydevstack
    $ vagrant up

**NOTE** If you are behind a proxy create common.yaml

    $ git clone --recursive https://github.com/patux/mydevstack.git
    $ cd mydevstack
    $ cp etc/common-sample.yaml etc/common.yaml  
    $ vi etc/common.yaml
    $ vagrant up 

## Contribute for Openstack

https://wiki.openstack.org/wiki/How_To_Contribute


## Gerrit Workflow 

https://wiki.openstack.org/wiki/Gerrit_Workflow


